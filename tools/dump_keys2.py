import win32com.client as win32
import os

path = r'C:\ARM-OMK\App_Data\AsutpDB.mdb'
conn = win32.Dispatch('ADODB.Connection')
conn.Open(f'Provider=Microsoft.ACE.OLEDB.12.0;Data Source={path};')
cat = win32.Dispatch('ADOX.Catalog')
cat.ActiveConnection = conn

lines = []
for t in cat.Tables:
    if t.Type == 'TABLE' or t.Type == 'ACCESS TABLE':
        lines.append('TABLE ' + t.Name)
        try:
            for k in t.Keys:
                cols = [c.Name for c in k.Columns]
                lines.append(f'  KEY {k.Name} type={k.Type} cols={cols}')
        except Exception as e:
            lines.append('  KEYERR ' + str(e))
        try:
            for idx in t.Indexes:
                lines.append(f'  IDX {idx.Name} unique={idx.Unique} pk={idx.PrimaryKey} cols={[c.Name for c in idx.Columns]}')
        except Exception as e:
            pass
conn.Close()

open('C:/ARM-OMK/docs/schema_keys2.txt', 'w', encoding='utf-8').write('\n'.join(lines))
print('OK', len(lines))
