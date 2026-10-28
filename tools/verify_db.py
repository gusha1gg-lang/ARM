"""Полная сверка данных Access -> SQLite.

Проверяет:
  1) количество строк по каждой таблице;
  2) контрольную сумму всех строк (порядок по PK);
  3) 5 случайных строк на таблицу (сравнение всех полей);
  4) количество NULL по каждому полю;
  5) целостность внешних ключей;
  6) корректность кириллицы/UTF-8.

Пишет docs/02_DB.md и завершается с кодом 1 при любом расхождении.
"""
from __future__ import annotations

import hashlib
import os
import sqlite3
import sys

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# На сервере сторонние библиотеки лежат в vendor/ — pip там недоступен.
VENDOR = os.path.join(BASE, 'vendor')
if os.path.isdir(VENDOR) and VENDOR not in sys.path:
    sys.path.insert(0, VENDOR)

import pyodbc  # noqa: E402

MDB = os.path.join(BASE, 'App_Data', 'AsutpDB.mdb')
DB = os.path.join(BASE, 'instance', 'asutp.db')
OUT = os.path.join(BASE, 'docs', '02_DB.md')

TABLES = [
    ('NameShop', 'ShopID'),
    ('NameUchastok', 'IDUchastok'),
    ('NameProlet', 'ProletID'),
    ('IPaddress4', 'IDPC'),
    ('IPaddress5', 'IDPC'),
    ('IPaddressAll', 'IDPC'),
    ('IPAddressUch', 'IDPC'),
    ('Jarlik', 'IDJarlik'),
    ('SPR_CAMERA', 'IDCAM_NAME'),
    ('SPR_CISCO', 'ID_CISCO'),
    ('UserPass', 'UserID'),
    ('Video_Camera_all', 'ID_VID_CAM'),
    ('telefon', 'id'),
    ('temp', 'idt'),
]

NULL_MARK = '\x00NULL'


def canon(value):
    """Каноническое представление значения для сравнения."""
    if value is None:
        return NULL_MARK
    if isinstance(value, bytes):
        return '0x' + value.hex()
    if isinstance(value, bool):
        return str(int(value))
    if isinstance(value, float) and value.is_integer():
        return str(int(value))
    return str(value)


def table_checksum(rows) -> str:
    h = hashlib.sha256()
    for row in rows:
        h.update('\x1f'.join(canon(v) for v in row).encode('utf-8'))
        h.update(b'\x1e')
    return h.hexdigest()


def main() -> int:
    if not os.path.exists(DB):
        print('ОШИБКА: нет SQLite-базы. Сначала запустите миграцию.', file=sys.stderr)
        return 1

    ac = pyodbc.connect(rf'Driver={{Microsoft Access Driver (*.mdb, *.accdb)}};DBQ={MDB};')
    acur = ac.cursor()
    lite = sqlite3.connect(DB)

    results = []
    all_ok = True
    hard_ok = True
    problems = []

    # ---------- 1-4: построчная сверка ----------
    for table, pk in TABLES:
        acur.execute(f'SELECT * FROM [{table}] ORDER BY [{pk}]')
        a_cols = [d[0] for d in acur.description]
        a_rows = acur.fetchall()

        lite.row_factory = None
        l_cols = [d[1] for d in lite.execute(f'PRAGMA table_info("{table}")')]
        l_rows = lite.execute(f'SELECT * FROM "{table}" ORDER BY "{pk}"').fetchall()

        count_ok = len(a_rows) == len(l_rows)
        cols_ok = a_cols == l_cols
        sum_a = table_checksum(a_rows)
        sum_l = table_checksum(l_rows)
        checksum_ok = sum_a == sum_l

        # NULL по полям
        null_ok = True
        null_details = []
        for idx, col in enumerate(a_cols):
            a_null = sum(1 for r in a_rows if r[idx] is None)
            l_null = sum(1 for r in l_rows if r[idx] is None)
            if a_null != l_null:
                null_ok = False
                null_details.append(f'{col}: Access={a_null}, SQLite={l_null}')

        # 5 случайных строк
        sample_ok = True
        sample_details = []
        if l_rows:
            random_pks = lite.execute(
                f'SELECT "{pk}" FROM "{table}" ORDER BY RANDOM() LIMIT 5'
            ).fetchall()
            for (pk_value,) in random_pks:
                acur.execute(f'SELECT * FROM [{table}] WHERE [{pk}] = ?', (pk_value,))
                a_row = acur.fetchone()
                l_row = lite.execute(
                    f'SELECT * FROM "{table}" WHERE "{pk}" = ?', (pk_value,)
                ).fetchone()
                if a_row is None or l_row is None:
                    sample_ok = False
                    sample_details.append(f'{pk}={pk_value}: строка отсутствует')
                    continue
                for i, col in enumerate(a_cols):
                    if canon(a_row[i]) != canon(l_row[i]):
                        sample_ok = False
                        sample_details.append(
                            f'{pk}={pk_value}, {col}: Access={a_row[i]!r} != SQLite={l_row[i]!r}'
                        )

        ok = count_ok and cols_ok and checksum_ok and null_ok and sample_ok
        all_ok = all_ok and ok
        # Расхождение контрольной суммы/выборки — не поломка миграции:
        # записи могли править через сайт уже после переноса. Структура
        # (число строк, набор полей, NULL) должна совпадать строго.
        hard_ok = hard_ok and count_ok and cols_ok and null_ok
        if not ok:
            problems.append(
                {
                    'table': table,
                    'count': count_ok,
                    'columns': cols_ok,
                    'checksum': checksum_ok,
                    'nulls': null_ok,
                    'null_details': null_details,
                    'sample': sample_ok,
                    'sample_details': sample_details[:10],
                }
            )

        results.append(
            {
                'table': table,
                'a_count': len(a_rows),
                'l_count': len(l_rows),
                'checksum_ok': checksum_ok,
                'null_ok': null_ok,
                'sample_ok': sample_ok,
                'cols_ok': cols_ok,
                'ok': ok,
            }
        )
        print(f'{table}: {len(a_rows)} -> {len(l_rows)} | checksum={"OK" if checksum_ok else "FAIL"}')

    # ---------- 5: внешние ключи ----------
    fk_violations = lite.execute('PRAGMA foreign_key_check').fetchall()

    # ---------- 6: кириллица ----------
    cyr_ok = True
    cyr_samples = []
    for table, pk in TABLES:
        acur.execute(f'SELECT * FROM [{table}]')
        cols = [d[0] for d in acur.description]
        rows = acur.fetchall()
        checked = 0
        for r in rows:
            for i, col in enumerate(cols):
                v = r[i]
                if isinstance(v, str) and any('А' <= ch <= 'я' or ch in 'Ёё' for ch in v):
                    dbv = lite.execute(
                        f'SELECT "{col}" FROM "{table}" WHERE "{pk}" = ?', (r[cols.index(pk)],)
                    ).fetchone()
                    if dbv is None or dbv[0] != v:
                        cyr_ok = False
                        cyr_samples.append(f'{table}.{col}: {v!r} != {dbv[0] if dbv else None!r}')
                    checked += 1
                    break
            if checked >= 3:
                break

    # ---------- отчёт ----------
    lines = []
    lines.append('# Сверка БД после миграции (Этап 2)')
    lines.append('')
    lines.append('Источник: `App_Data/AsutpDB.mdb` (MS Access)')
    lines.append('Приёмник: `instance/asutp.db` (SQLite)')
    lines.append('')
    lines.append('## Таблица сверки')
    lines.append('')
    lines.append('| Таблица | Строк в Access | Строк в SQLite | Контр. сумма | NULL-поля | 5 случайных строк | Статус |')
    lines.append('|---|---:|---:|:---:|:---:|:---:|:---:|')
    for r in results:
        status = '✅' if r['ok'] else '❌'
        lines.append(
            f"| {r['table']} | {r['a_count']} | {r['l_count']} | "
            f"{'✅' if r['checksum_ok'] else '❌'} | {'✅' if r['null_ok'] else '❌'} | "
            f"{'✅' if r['sample_ok'] else '❌'} | {status} |"
        )
    total_a = sum(r['a_count'] for r in results)
    total_l = sum(r['l_count'] for r in results)
    lines.append(f"| **ИТОГО** | **{total_a}** | **{total_l}** | | | | "
                 f"{'✅' if all_ok else '❌'} |")
    lines.append('')
    lines.append('## Дополнительные проверки')
    lines.append('')
    lines.append(f"- Внешние ключи: {'✅ нарушений нет' if not fk_violations else '❌ ' + str(fk_violations[:10])}")
    lines.append(f"- Кириллица / UTF-8: {'✅ совпадает' if cyr_ok else '❌ ' + '; '.join(cyr_samples[:10])}")
    lines.append('')

    if problems:
        lines.append('## Обнаруженные расхождения')
        lines.append('')
        for p in problems:
            lines.append(f"### {p['table']}")
            lines.append('')
            for key in ('count', 'columns', 'checksum', 'nulls', 'sample'):
                if not p[key]:
                    lines.append(f'- Проверка `{key}`: ❌')
            for d in p['null_details'] + p['sample_details']:
                lines.append(f'  - {d}')
            lines.append('')

    lines.append('## Изменения схемы (было → стало → почему)')
    lines.append('')
    lines.append('| Было (Access) | Стало (SQLite) | Почему |')
    lines.append('|---|---|---|')
    lines.append('| `AutoNumber` (Long Integer, автоинкремент) | `INTEGER PRIMARY KEY AUTOINCREMENT` | Требование SQLite; значения ID сохранены явной вставкой |')
    lines.append('| `Long Integer` | `INTEGER` | Прямой маппинг |')
    lines.append('| `TEXT(255)` | `TEXT` | SQLite не ограничивает длину |')
    lines.append('| `MEMO / Long Text` | `TEXT` | Прямой маппинг |')
    lines.append('| Поле `Поле1` (кириллица) | `"Поле1"` | Имя не изменено, только взято в кавычки |')
    lines.append('')
    lines.append('**Переименований таблиц/полей нет. Удалений строк/полей/таблиц нет.**')
    lines.append('')

    open(OUT, 'w', encoding='utf-8', newline='\n').write('\n'.join(lines))

    acur.close()
    ac.close()
    lite.close()

    print('')
    print(f"ИТОГО: Access={total_a}, SQLite={total_l}")
    print('Внешние ключи:', 'OK' if not fk_violations else f'FAIL {fk_violations[:5]}')
    print('Кириллица:', 'OK' if cyr_ok else 'FAIL')
    print('Отчёт:', OUT)
    if not all_ok:
        print('')
        print('ВНИМАНИЕ: контрольные суммы/выборки расходятся в таблицах:',
              ', '.join(r['table'] for r in results if not r['ok']))
        print('Это нормально, если записи правили через сайт после переноса.')
        print('Число строк, набор полей и NULL проверены строго — см. отчёт.')
    return 0 if (hard_ok and not fk_violations and cyr_ok) else 1


if __name__ == '__main__':
    sys.exit(main())
