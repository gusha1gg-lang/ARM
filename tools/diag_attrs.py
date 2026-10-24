import win32com.client as win32

mdb = r'C:\ARM-OMK\App_Data\AsutpDB.mdb'
ad = win32.Dispatch('ADODB.Connection')
ad.Open(f'Provider=Microsoft.ACE.OLEDB.12.0;Data Source={mdb};')
cat = win32.Dispatch('ADOX.Catalog')
cat.ActiveConnection = ad

lines = []
for t in cat.Tables:
    if t.Name != 'SPR_CISCO' and t.Name != 'IPaddress4':
        continue
    lines.append('TABLE ' + t.Name)
    for c in t.Columns:
        attrs = c.Attributes
        req = None
        try:
            req = c.Properties['Required'].Value
        except Exception as e:
            req = f'err:{e}'
        sized = None
        try:
            sized = c.Properties['Size'].Value
        except Exception:
            pass
        lines.append(f'  {c.Name}: Attributes={attrs} (bit0_nullable={attrs & 1}) Required={req} Size={sized}')
ad.Close()
print('\n'.join(lines))
