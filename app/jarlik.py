"""Раздел «Ярлыки»: /JR.aspx, /AddJR.aspx, /EditJR.aspx?id=N.

Логика перенесена 1-в-1 из legacy-файлов JR.aspx(.cs), AddJR.aspx(.cs),
EditJR.aspx(.cs): таблица Jarlik (IDJarlik, LnkNameJarlik, NameJarlik),
файлы ярлыков лежат в каталоге Slegenie/ и скачиваются по ссылке.

Отличия (осознанные, см. MIGRATION_LOG.md):
  * добавление/изменение/удаление доступны editor и admin
    (в оригинале — только admin по Session["admin"]);
  * параметризованный SQL, CSRF-токены, проверка существования записи;
  * POST → redirect (PRG).
"""
from __future__ import annotations

from flask import (
    Blueprint,
    abort,
    flash,
    g,
    redirect,
    render_template,
    request,
    send_from_directory,
    url_for,
)
from werkzeug.security import safe_join

from .config import BASE_DIR
from .db import get_db
from .security import login_required, validate_csrf

bp = Blueprint("jarlik", __name__)

# Каталог файлов ярлыков оригинала (ссылки вида Slegenie/<файл>).
SLEGENIE_DIR = BASE_DIR / "Slegenie"


def _can_edit() -> bool:
    return g.user is not None and g.user["role"] in ("editor", "admin")


def _rows() -> list:
    # Оригинал: "select * from Jarlik" без ORDER BY.
    return get_db().execute(
        'SELECT "IDJarlik", "LnkNameJarlik", "NameJarlik" FROM "Jarlik"'
    ).fetchall()


def _row(row_id: int):
    return get_db().execute(
        'SELECT "IDJarlik", "LnkNameJarlik", "NameJarlik" FROM "Jarlik" '
        'WHERE "IDJarlik" = ?',
        (row_id,),
    ).fetchone()


def _require_editor() -> None:
    if g.user is None:
        abort(401)
    if not _can_edit():
        abort(403)


def _int_arg(value: str | None) -> int | None:
    try:
        return int(str(value).strip())
    except (TypeError, ValueError):
        return None


@bp.route("/Slegenie/<path:filename>")
@login_required
def download(filename):
    """Скачивание файла ярлыка (.lnk / .url / .cer) из каталога Slegenie."""
    if safe_join(str(SLEGENIE_DIR), filename) is None:
        abort(404)
    return send_from_directory(SLEGENIE_DIR, filename, as_attachment=True)


@bp.route("/JR.aspx")
@login_required
def main():
    return render_template(
        "jarlik.html",
        rows=_rows(),
        can_edit=_can_edit(),
        total=len(_rows()),
    )


@bp.route("/AddJR.aspx", methods=("GET", "POST"))
@login_required
def add():
    _require_editor()

    if request.method == "POST":
        validate_csrf()
        # Оригинал: INSERT INTO Jarlik ([NameJarlik],[LnkNameJarlik]) VALUES (?,?)
        db = get_db()
        db.execute(
            'INSERT INTO "Jarlik" ("NameJarlik", "LnkNameJarlik") VALUES (?, ?)',
            (
                (request.form.get("NameJarlik") or "").strip(),
                (request.form.get("LnkNameJarlik") or "").strip(),
            ),
        )
        db.commit()
        flash("Ярлык добавлен.", "success")
        return redirect(url_for("jarlik.main"))

    # Как в оригинале: SetFocus(TextBox10) — фокус в первое поле.
    return render_template("jarlik_form.html", mode="add", row=None, row_id=None)


@bp.route("/EditJR.aspx", methods=("GET", "POST"))
@login_required
def edit():
    _require_editor()

    row_id = _int_arg(request.args.get("id"))
    if row_id is None:
        abort(404)
    row = _row(row_id)
    if row is None:
        abort(404)

    if request.method == "POST":
        validate_csrf()
        action = request.form.get("action")
        db = get_db()

        if action == "delete":
            db.execute('DELETE FROM "Jarlik" WHERE "IDJarlik" = ?', (row_id,))
            db.commit()
            flash(f"Ярлык №{row_id} удалён.", "success")
            return redirect(url_for("jarlik.main"))

        if action == "update":
            db.execute(
                'UPDATE "Jarlik" SET "NameJarlik" = ?, "LnkNameJarlik" = ? '
                'WHERE "IDJarlik" = ?',
                (
                    (request.form.get("NameJarlik") or "").strip(),
                    (request.form.get("LnkNameJarlik") or "").strip(),
                    row_id,
                ),
            )
            db.commit()
            flash("Изменения сохранены.", "success")
            return redirect(url_for("jarlik.main"))

        abort(400)

    return render_template("jarlik_form.html", mode="edit", row=row, row_id=row_id)
