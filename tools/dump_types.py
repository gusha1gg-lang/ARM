import win32com.client as win32

path = r'C:\ARM-OMK\App_Data\AsutpDB.mdb'
conn = win32.Dispatch('ADODB.Connection')
conn.Open(f'Provider=Microsoft.ACE.OLEDB.12.0;Data Source={path};')
cat = win32.Dispatch('ADOX.Catalog')
cat.ActiveConnection = conn

# ADOX DataTypeEnum mapping (common)
TYPES = {
    0: 'Empty', 2: 'SmallInt', 3: 'Integer', 4: 'Single', 5: 'Double',
    6: 'Currency', 7: 'Date', 8: 'BSTR', 9: 'IDispatch', 10: 'Error',
    11: 'Boolean', 12: 'Variant', 13: 'IUnknown', 14: 'Decimal',
    16: 'TinyInt', 17: 'UnsignedTinyInt', 18: 'UnsignedSmallInt',
    19: 'UnsignedInt', 20: 'BigInt', 21: 'UnsignedBigInt',
    64: 'Filetime', 72: 'Guid', 128: 'Binary', 129: 'Char',
    130: 'WChar', 131: 'Numeric', 133: 'DBDate', 134: 'DBTime',
    135: 'DBTimeStamp', 136: 'Chapter', 138: 'PropVariant',
    139: 'VarNumeric', 200: 'VarChar', 201: 'LongVarChar',
    202: 'VarWChar', 203: 'LongVarWChar', 204: 'Binary',
    205: 'LongBinary', 206: 'PropVariant', 
}

# Access-specific type codes via Column.Type
ACCESS_TYPES = {
    2: 'SMALLINT(Byte?)', 3: 'INTEGER(Long Integer)', 4: 'SINGLE',
    5: 'DOUBLE', 6: 'CURRENCY', 7: 'DATETIME', 11: 'BIT(Yes/No)',
    17: 'BYTE', 72: 'GUID', 128: 'BINARY', 130: 'TEXT(nvarchar)',
    202: 'TEXT(255)', 203: 'MEMO(Long Text)',
}

lines = []
for t in cat.Tables:
    if t.Name.startswith('MSys'):
        continue
    lines.append(f'TABLE {t.Name}')
    for c in t.Columns:
        props = {}
        for p in c.Properties:
            try:
                props[p.Name] = p.Value
            except Exception:
                pass
        autonum = props.get('Autoincrement', False)
        nullable = props.get('Nullable', None)
        size = props.get('Size', None)
        lines.append(
            f'  {c.Name} | type={c.Type} ({ACCESS_TYPES.get(c.Type, "?")})'
            f' | size={size} | required={c.Attributes & 1 if hasattr(c,"Attributes") else "?"}'
            f' | nullable={nullable} | autoincrement={autonum}'
        )
    lines.append('')

conn.Close()
open('C:/ARM-OMK/docs/schema_types.txt', 'w', encoding='utf-8').write('\n'.join(lines))
print('OK')
