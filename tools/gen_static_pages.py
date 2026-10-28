"""Генерация шаблонов для статических legacy-страниц (Этап 4, партия 10).

Содержимое блоков Content переносится в шаблоны без изменений разметки.
Единственное преобразование — замена серверных контролов на обычный HTML
(без ASP.NET они не работают):
  * ``asp:HyperLink NavigateUrl="~/X"`` → ``<a href="/X">``;
  * ``asp:Label Text="X"`` → ``<span>X</span>``.

Запуск:  python tools/gen_static_pages.py
Проверка совпадения:  python tools/check_static_pages.py
"""
from __future__ import annotations

import io
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

CONTENT_RE = re.compile(r"<asp:Content\b[^>]*>(.*?)</asp:Content>", re.S)

HYPERLINK_RE = re.compile(
    r'<asp:HyperLink\b([^>]*)>(.*?)</asp:HyperLink>', re.S
)
# asp:Label встречается в двух видах: <asp:Label ... /> и <asp:Label ...></asp:Label>.
LABEL_RE = re.compile(r'<asp:Label\b([^>]*?)(?:/>|>.*?</asp:Label>)', re.S)


def _attr(attrs: str, name: str) -> str | None:
    match = re.search(rf'\b{name}="([^"]*)"', attrs)
    return match.group(1) if match else None


def _style_from(attrs: str) -> str:
    """Перенос Font-Names/Font-Size в CSS (как их отдавал ASP.NET)."""
    parts = []
    font_names = _attr(attrs, "Font-Names")
    font_size = _attr(attrs, "Font-Size")
    if font_names:
        parts.append(f"font-family:{font_names}")
    if font_size:
        parts.append(f"font-size:{font_size.lower()}")
    return f' style="{"; ".join(parts)}"' if parts else ""


def convert_body(body: str) -> str:
    """Заменить серверные контролы, не работающие без ASP.NET."""

    def hyperlink(match: re.Match) -> str:
        attrs, text = match.group(1), match.group(2).strip()
        url = _attr(attrs, "NavigateUrl") or "#"
        if url.startswith("~/"):
            url = "/" + url[2:]
        target = _attr(attrs, "Target")
        target_attr = f' target="{target}"' if target else ""
        return f'<a href="{url}"{target_attr}{_style_from(attrs)}>{text}</a>'

    def label(match: re.Match) -> str:
        attrs = match.group(1)
        text = _attr(attrs, "Text") or ""
        return f"<span{_style_from(attrs)}>{text}</span>"

    body = HYPERLINK_RE.sub(hyperlink, body)
    return LABEL_RE.sub(label, body)


PAGES = [
    ("Webnav.aspx", "app/templates/webnav.html", "Web Navigator"),
    ("NastoikaT5.aspx", "app/templates/nastoika_t5.html", "Настройка Zebra в ТЭСЦ 5"),
    ("NastoikaEBS.aspx", "app/templates/nastoika_ebs.html",
     "Настройка маркировщика EBS-250"),
    ("Calendar.aspx", "app/templates/calendar.html", "Календарь"),
]


def read_legacy_parts(source: str) -> tuple[str, str]:
    text = io.open(os.path.join(ROOT, source), encoding="utf-8-sig").read()
    parts = CONTENT_RE.findall(text)
    if len(parts) != 2:
        raise SystemExit(f"FAIL {source}: блоков Content — {len(parts)}")
    return tuple(part.strip() for part in parts)  # type: ignore[return-value]


def build_template(title: str, head: str, body: str) -> str:
    return (
        '{% extends "base.html" %}\n'
        f"{{% block title %}}{title} — Справочник ТЭСК ТБД{{% endblock %}}\n"
        "\n"
        "{% block head %}\n"
        f"{head}\n"
        "{% endblock %}\n"
        "\n"
        "{% block content %}\n"
        '<div class="legacy-static">\n'
        f"{body}\n"
        "</div>\n"
        "{% endblock %}\n"
    )


def main() -> int:
    for source, target, title in PAGES:
        head, body = read_legacy_parts(source)
        out = build_template(title, head, convert_body(body))
        with io.open(os.path.join(ROOT, target), "w", encoding="utf-8", newline="\n") as h:
            h.write(out)
        print(f"OK   {source} → {target} ({len(out)} символов)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
