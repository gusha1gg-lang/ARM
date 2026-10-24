"""Сверка статических страниц CISCO: legacy-разметка vs шаблон (1-в-1).

Сравнивает содержимое блоков ContentPlaceHolderID="head" и
"ContentPlaceHolderID" из CISCO.aspx / CISCO2.aspx с тем, что попало
в app/templates/cisco.html / cisco2.html (без обёртки Jinja-блоков).

Запуск:  python tools/check_cisco_static.py
"""
from __future__ import annotations

import io
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

PAIRS = [
    ("CISCO.aspx", "app/templates/cisco.html"),
    ("CISCO2.aspx", "app/templates/cisco2.html"),
]

CONTENT_RE = re.compile(r"<asp:Content\b[^>]*>(.*?)</asp:Content>", re.S)


def normalize(text: str) -> str:
    """Убрать различия в пробелах по краям строк и обёртку шаблона."""
    lines = [line.rstrip() for line in text.replace("\r\n", "\n").split("\n")]
    return "\n".join(lines).strip()


def main() -> int:
    failed = 0
    for source, target in PAIRS:
        legacy = io.open(os.path.join(ROOT, source), encoding="utf-8-sig").read()
        template = io.open(os.path.join(ROOT, target), encoding="utf-8").read()

        parts = CONTENT_RE.findall(legacy)
        if len(parts) != 2:
            print(f"FAIL {source}: ожидалось 2 блока Content, найдено {len(parts)}")
            failed += 1
            continue
        legacy_head, legacy_body = (normalize(p) for p in parts)

        head = re.search(r"{% block head %}(.*?){% endblock %}", template, re.S)
        body = re.search(r"{% block content %}(.*?){% endblock %}", template, re.S)
        if head is None or body is None:
            print(f"FAIL {target}: не найдены блоки head/content")
            failed += 1
            continue

        tpl_head = normalize(head.group(1))
        tpl_body = normalize(body.group(1))
        # Тело шаблона обёрнуто в <div class="legacy-static">…</div>.
        wrapper = re.fullmatch(r'<div class="legacy-static">\n(.*)\n</div>', tpl_body, re.S)
        tpl_body_inner = normalize(wrapper.group(1)) if wrapper else tpl_body

        for label, old, new in (
            ("head", legacy_head, tpl_head),
            ("content", legacy_body, tpl_body_inner),
        ):
            if old == new:
                print(f"OK   {source} → {target} [{label}]: совпадает ({len(new)} символов)")
            else:
                failed += 1
                print(f"FAIL {source} → {target} [{label}]: различается")
                for index, (a, b) in enumerate(zip(old.split("\n"), new.split("\n")), 1):
                    if a != b:
                        print(f"     строка {index}:\n       legacy:   {a!r}\n       шаблон:   {b!r}")
                        break
                else:
                    print(f"     разное число строк: legacy={old.count(chr(10))}, шаблон={new.count(chr(10))}")

    print()
    print("ИТОГО:", "все страницы совпадают" if not failed else f"расхождений: {failed}")
    return 0 if not failed else 1


if __name__ == "__main__":
    sys.exit(main())
