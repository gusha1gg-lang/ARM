import pyodbc, json

conn_str = r'Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=C:\ARM-OMK\App_Data\AsutpDB.mdb;'
conn = pyodbc.connect(conn_str)
cur = conn.cursor()

out = {}
tables = []
for r in cur.tables(tableType='TABLE'):
    if not r.table_name.startswith('MSys'):
        tables.append(r.table_name)

for t in sorted(tables):
    cols = []
    cur.execute(f'SELECT * FROM [{t}]')
    for d in cur.description:
        name, type_code = d[0], d[1]
        cols.append({'name': name, 'type_code': str(type_code)})
    # indexes / primary key via ODBC
    idx = []
    try:
        for row in cur.statistics(t):
            idx.append({'index': row.index_name, 'non_unique': row.non_unique, 'column': row.column_name, 'ordinal': row.ordinal_position})
    except Exception as e:
        idx.append({'error': str(e)})
    cur.execute(f'SELECT COUNT(*) FROM [{t}]')
    cnt = cur.fetchone()[0]
    out[t] = {'columns': cols, 'count': cnt, 'stats': idx}

conn.close()
with open('C:/ARM-OMK/docs/access_schema.json', 'w', encoding='utf-8') as f:
    json.dump(out, f, ensure_ascii=False, indent=2)
print('OK', len(out))
