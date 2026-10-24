import pyodbc, json

conn_str = r'Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=C:\ARM-OMK\App_Data\AsutpDB.mdb;'
conn = pyodbc.connect(conn_str)
cur = conn.cursor()

lines = []
tables = [r.table_name for r in cur.tables(tableType='TABLE') if not r.table_name.startswith('MSys')]

for t in sorted(tables):
    cur.execute(f'SELECT * FROM [{t}]')
    names = [d[0] for d in cur.description]
    lines.append(f'TABLE {t}')
    for n in names:
        if not n.isascii():
            lines.append(f'  NONASCII_COLUMN: {n!r} = {n}')
    # primary keys
    try:
        pks = []
        for row in cur.primaryKeys(t):
            pks.append((row.column_name, row.key_seq))
        lines.append(f'  PK: {pks}')
    except Exception as e:
        lines.append(f'  PK_ERROR: {e}')
    # foreign keys
    try:
        fks = []
        for row in cur.foreignKeys(t):
            fks.append((row.fk_column_name, row.pk_table_name, row.pk_column_name))
        if fks:
            lines.append(f'  FK: {fks}')
    except Exception as e:
        pass

conn.close()
open('C:/ARM-OMK/docs/schema_keys.txt', 'w', encoding='utf-8').write('\n'.join(lines))
print('OK')
