"""Статические страницы сайта (Этап 4, партия 10).

Перенесено 1-в-1 из legacy-файлов:

  * ``Webnav.aspx``        — «Web Navigator»;
  * ``NastoikaT5.aspx``    — «Настройка Zebra в ТЭСЦ 5» (картинки images/T5*.jpg);
  * ``NastoikaEBS.aspx``   — «Настройка маркировщика EBS-250»;
  * ``Calendar.aspx``      — «Календарь» (большая Excel-таблица).

Плюс готовые ``.htm``-файлы оригинала, которые отдаются как есть:
``NastroykaOPT.htm``, ``birka_akp5.htm``, ``tururushka.htm``,
``Инструкция по перезапуску WinCC.htm`` — вместе с папками ``*.files``.

Серверной логики и обращений к БД в этих файлах нет: ``Page_Load`` пуст,
данные не используются. Поэтому CRUD не добавлялся — только просмотр.
Доступ — после входа, всем ролям (как и было за авторизацией сайта).

``/Nastroyki.aspx`` удалён по требованию пользователя: страница не используется
(в оригинале ссылка на неё в меню была закомментирована, инструкции открываются
из выпадающего меню «Настройки»).
"""
from __future__ import annotations

import re

from flask import Blueprint, abort, render_template, send_from_directory

from .config import BASE_DIR
from .security import login_required

bp = Blueprint("static_pages", __name__)

#: Разрешённые к отдаче .htm-файлы корня проекта (как в оригинале).
HTM_FILES = {
    "NastroykaOPT.htm",
    "birka_akp5.htm",
    "tururushka.htm",
    "Инструкция по перезапуску WinCC.htm",
}

#: Папки ресурсов этих .htm (Word-экспорт: картинки, editdata.mso, filelist.xml).
HTM_ASSET_DIRS = {name[:-4] + ".files" for name in HTM_FILES}

CHARSET_RE = re.compile(rb'charset=["\']?([A-Za-z0-9_\-]+)')


# Шаблоны полностью повторяют legacy-разметку, поэтому переменных у них нет.
@bp.route("/Webnav.aspx")
@login_required
def webnav():
    return render_template("webnav.html")


@bp.route("/NastoikaT5.aspx")
@login_required
def nastoika_t5():
    return render_template("nastoika_t5.html")


@bp.route("/NastoikaEBS.aspx")
@login_required
def nastoika_ebs():
    return render_template("nastoika_ebs.html")


@bp.route("/Calendar.aspx")
@login_required
def calendar():
    return render_template("calendar.html")


@bp.route("/<htm_name>.htm")
@login_required
def htm(htm_name: str):
    """Отдать готовый .htm оригинала (только из белого списка).

    Файлы сохранены в windows-1251 — кодировку берём из их ``<meta charset>``,
    чтобы браузер не показывал кракозябры.
    """
    name = f"{htm_name}.htm"
    if name not in HTM_FILES:
        abort(404)

    path = BASE_DIR / name
    if not path.exists():
        abort(404)

    data = path.read_bytes()
    match = CHARSET_RE.search(data[:4096])
    charset = match.group(1).decode("ascii", "ignore") if match else "windows-1251"

    response = send_from_directory(BASE_DIR, name, mimetype="text/html")
    response.headers["Content-Type"] = f"text/html; charset={charset}"
    return response


@bp.route("/<htm_name>.files/<path:filename>")
@login_required
def htm_assets(htm_name: str, filename: str):
    """Ресурсы .htm-файлов (картинки и служебные файлы Word-экспорта)."""
    directory = f"{htm_name}.files"
    if directory not in HTM_ASSET_DIRS:
        abort(404)
    return send_from_directory(BASE_DIR / directory, filename)
