"""Сверка статических страниц: legacy-разметка vs шаблон (1-в-1).

Сравнивает блоки ContentPlaceHolderID="head" / "ContentPlaceHolderID" из
Webnav.aspx, NastoikaT5.aspx, NastoikaEBS.aspx, Calendar.aspx
с содержимым шаблонов app/templates/*.html (с учётом замены asp:контролов
на обычный HTML — см. tools/gen_static_pages.py).

Запуск:  python tools/check_static_pages.py
"""
from __future__ import annotations

import io
import os
import re
import sys

from gen_static_pages import PAGES, ROOT, build_template, convert_body, read_legacy_parts


def normalize(text: str) -> str:
    lines = [line.rstrip() for line in text.replace("\r\n", "\n").split("\n")]
    return "\n".join(lines).strip()


def main() -> int:
    failed = 0
    for source, target, title in PAGES:
        head, body = read_legacy_parts(source)
        expected = normalize(build_template(title, head, convert_body(body)))
        actual = normalize(io.open(os.path.join(ROOT, target), encoding="utf-8").read())

        if expected == actual:
            print(f"OK   {source} → {target}: совпадает ({len(actual)} символов)")
            continue

        failed += 1
        print(f"FAIL {source} → {target}: различается")
        for index, (a, b) in enumerate(zip(expected.split("\n"), actual.split("\n")), 1):
            if a != b:
                print(f"     строка {index}:\n       legacy: {a!r}\n       шаблон: {b!r}")
                break
        else:
            print("     разное число строк")

    # Статические .htm-файлы отдаются как есть — проверяем только наличие.
    for name in ("NastroykaOPT.htm", "birka_akp5.htm", "tururushka.htm",
                 "Инструкция по перезапуску WinCC.htm"):
        path = os.path.join(ROOT, name)
        if os.path.exists(path):
            print(f"OK   {name}: файл на месте ({os.path.getsize(path)} байт)")
        else:
            failed += 1
            print(f"FAIL {name}: файл не найден")

    print()
    print("ИТОГО:", "всё совпадает" if not failed else f"расхождений: {failed}")
    return 0 if not failed else 1


if __name__ == "__main__":
    sys.exit(main())
