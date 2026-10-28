"""Раздел «Телефоны»: /telefon.aspx.

Логика перенесена 1-в-1 из legacy-файлов telefon.aspx, telefon.aspx.cs:
  * список ФИО / Телефон (GridView1) — для просмотра;
  * добавление (DetailsView1), изменение и удаление (GridView2) — для админа.

Отличия (осознанные, см. MIGRATION_LOG.md):
  * добавление/изменение/удаление доступны editor и admin (в оригинале — admin);
  * параметризованный SQL, CSRF, подтверждение удаления;
  * POST → redirect (PRG).
"""
from __future__ import annotations

from flask import Blueprint, abort, flash, g, redirect, render_template, request, url_for

from .audit import log_action
from .db import get_db
from .security import login_required, validate_csrf

bp = Blueprint("telefon", __name__)

SORT_COLUMNS = {"fio", "telnumber"}


def _rows(sort: str | None, direction: str) -> list:
    sql = 'SELECT "id", "fio", "telnumber" FROM "telefon"'
    if sort in SORT_COLUMNS:
        # В оригинале включена сортировка по клику на заголовок (AllowSorting).
        sql += f' ORDER BY "{sort}" {"DESC" if direction == "desc" else "ASC"}'
    return get_db().execute(sql).fetchall()


def _sort_state() -> tuple[str | None, str]:
    sort = request.args.get("sort")
    if sort not in SORT_COLUMNS:
        sort = None
    direction = "desc" if request.args.get("dir") == "desc" else "asc"
    return sort, direction


def _redirect_back(sort: str | None, direction: str):
    args = {}
    if sort:
        args["sort"] = sort
        args["dir"] = direction
    return redirect(url_for("telefon.main", **args))


@bp.route("/telefon.aspx", methods=("GET", "POST"))
@login_required
def main():
    sort, direction = _sort_state()
    can_edit = g.user is not None and g.user["role"] in ("editor", "admin")

    if request.method == "POST":
        if not can_edit:
            abort(403)
        validate_csrf()
        action = request.form.get("action")
        db = get_db()

        if action == "add":
            fio = (request.form.get("fio") or "").strip()
            telnumber = (request.form.get("telnumber") or "").strip()
            cursor = db.execute(
                'INSERT INTO "telefon" ("fio", "telnumber") VALUES (?, ?)',
                (fio, telnumber),
            )
            db.commit()
            log_action("create", "telefon", cursor.lastrowid,
                       f"{fio or '—'}: {telnumber or '—'}")
            flash("Запись добавлена.", "success")
            return _redirect_back(sort, direction)

        row_id = request.form.get("id", "")
        try:
            row_id = int(row_id)
        except (TypeError, ValueError):
            abort(400)

        if action == "delete":
            old = db.execute(
                'SELECT "fio", "telnumber" FROM "telefon" WHERE "id" = ?', (row_id,)
            ).fetchone()
            db.execute('DELETE FROM "telefon" WHERE "id" = ?', (row_id,))
            db.commit()
            log_action(
                "delete", "telefon", row_id,
                f"{old['fio'] or '—'}: {old['telnumber'] or '—'}" if old else None,
            )
            flash(f"Запись №{row_id} удалена.", "success")
            return _redirect_back(sort, direction)

        if action == "update":
            fio = (request.form.get("fio") or "").strip()
            telnumber = (request.form.get("telnumber") or "").strip()
            db.execute(
                'UPDATE "telefon" SET "fio" = ?, "telnumber" = ? WHERE "id" = ?',
                (fio, telnumber, row_id),
            )
            db.commit()
            log_action("update", "telefon", row_id, f"{fio or '—'}: {telnumber or '—'}")
            flash("Изменения сохранены.", "success")
            return _redirect_back(sort, direction)

        abort(400)

    rows = _rows(sort, direction)

    edit_id = None
    edit_row = None
    try:
        edit_id = int(request.args.get("edit", ""))
    except (TypeError, ValueError):
        edit_id = None
    if edit_id is not None and can_edit:
        edit_row = next((r for r in rows if r["id"] == edit_id), None)

    return render_template(
        "telefon.html",
        rows=rows,
        can_edit=can_edit,
        edit_id=edit_id,
        edit_row=edit_row,
        sort=sort,
        direction=direction,
        total=len(rows),
    )
