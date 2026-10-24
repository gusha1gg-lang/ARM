"""Общие проверки для таблиц IP-адресов.

Дубликаты КЕ/монитора/принтера в оригинале проверялись одинаково
на всех страницах (Addipt4, Addipt5, Addipuch, AddipALL и их Edit-версиях).
"""
from __future__ import annotations

from .db import get_db

# Таблицы, в которых оригинал искал дубликаты.
IP_TABLES = ("IPaddress4", "IPAddressUch", "IPaddress5", "IPaddressAll")


def find_duplicates(field: str, value: str, exclude_id: int | None = None) -> bool:
    """Аналог CustomValidator из legacy-страниц.

    * ``KE`` сравнивается на точное равенство;
    * ``Monitor`` и ``Printer`` — через ``LIKE %значение%``;
    * пустое значение не проверяется (в ASP.NET ``ValidateEmptyText`` выключен).
    """
    value = (value or "").strip()
    if not value:
        return False

    if field == "KE":
        condition = '"KE" = ?'
        param = value
    else:
        condition = f'"{field}" LIKE ?'
        param = f"%{value}%"

    db = get_db()
    for table in IP_TABLES:
        query = f'SELECT 1 FROM "{table}" WHERE {condition}'
        args: list = [param]
        if exclude_id is not None:
            query += ' AND "IDPC" <> ?'
            args.append(exclude_id)
        if db.execute(query, args).fetchone() is not None:
            return True
    return False
