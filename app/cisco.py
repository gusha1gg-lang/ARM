"""Раздел CISCO: /CISCO.aspx (шкафы) и /CISCO2.aspx (узлы ВМЗ).

Обе страницы в оригинале — статические HTML-таблицы (экспорт из Excel),
без обращений к БД и без серверной логики (CISCO.aspx.cs / CISCO2.aspx.cs пусты).
Разметка перенесена 1-в-1 в шаблоны cisco.html / cisco2.html.
"""
from __future__ import annotations

from flask import Blueprint, render_template

from .security import login_required

bp = Blueprint("cisco", __name__)


@bp.route("/CISCO.aspx")
@login_required
def cabinets():
    return render_template("cisco.html")


@bp.route("/CISCO2.aspx")
@login_required
def nodes():
    return render_template("cisco2.html")
