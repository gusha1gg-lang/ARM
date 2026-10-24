"""Диагностика: где в Access обязательные (required) поля фактически содержат NULL."""
import win32com.client as win32
import pyodbc

mdb = r'C:\ARM-OMK\App_Data\AsutpDB.mdb'
conn_str = rf'Driver={{Microsoft Access Driver (*.mdb, *.accdb)}};DBQ={mdb};'
ac = pyodbc.connect(conn_str)
cur = ac.cursor()

# required-поля из ADOX
ad = win32.Dispatch('ADODB.Connection')
ad.Open(f'Provider=Microsoft.ACE.OLEDB.12.0;Data Source={mdb};')
cat = win32.Dispatch('ADOX.Catalog')
cat.ActiveConnection = ad

required = {}
for t in cat.Tables:
    if t.Name.startswith('MSys'):
        continue
    req = []
    for c in t.Columns:
        if hasattr(c, 'Attributes') and (c.Attributes & 1):  # adColNullable = 1 -> nullable
            pass
        try:
            is_req = bool(c.Properties('Required').Value)
        except Exception:
            is_req = False
        if is_req:
            req.append(c.Name)
    required[t.Name] = req

ad.Close()

lines = []
for table, req_cols in required.items():
    cur.execute(f'SELECT COUNT(*) FROM [{table}]')
    total = cur.fetchone()[0]
    lines.append(f'TABLE {table} (rows={total}) required={req_cols}')
    for col in req_cols:
        cur.execute(f'SELECT COUNT(*) FROM [{table}] WHERE [{col}] IS NULL')
        nulls = cur.fetchone()[0]
        if nulls:
            lines.append(f'  !! {col}: NULL в {nulls} строках')
ac.close()

print('\n'.join(lines))
open('C:/ARM-OMK/docs/null_diagnostic.txt', 'w', encoding='utf-8').write('\n'.join(lines))
