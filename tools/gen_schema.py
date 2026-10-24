"""Генерация scripts/schema.sql по фактическим атрибутам Access.

Источник истины:
  * порядок и имена полей — pyodbc (физический порядок);
  * тип/обязательность/автоинкремент — ADOX (Attributes & 1 => допускает NULL).
"""
import win32com.client as win32
import pyodbc

MDB = r'C:\ARM-OMK\App_Data\AsutpDB.mdb'
OUT = r'C:\ARM-OMK\scripts\schema.sql'

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

# ADOX -> метаданные
ad = win32.Dispatch('ADODB.Connection')
ad.Open(f'Provider=Microsoft.ACE.OLEDB.12.0;Data Source={MDB};')
cat = win32.Dispatch('ADOX.Catalog')
cat.ActiveConnection = ad

meta = {}
for t in cat.Tables:
    if t.Name.startswith('MSys'):
        continue
    cols = {}
    for c in t.Columns:
        # ADOX ColumnAttributesEnum: adColFixed = 1, adColNullable = 2
        nullable = bool(c.Attributes & 2)
        autoinc = False
        try:
            autoinc = bool(c.Properties['Autoincrement'].Value)
        except Exception:
            autoinc = False
        cols[c.Name] = {'type': c.Type, 'nullable': nullable, 'autoinc': autoinc}
    meta[t.Name] = cols
ad.Close()

# физический порядок полей
ac = pyodbc.connect(rf'Driver={{Microsoft Access Driver (*.mdb, *.accdb)}};DBQ={MDB};')
cur = ac.cursor()

def sql_type(t):
    if t == 3:
        return 'INTEGER'
    if t in (202, 203):
        return 'TEXT'
    raise ValueError(f'Неподдерживаемый тип Access: {t}')

lines = []
lines.append('-- Схема SQLite для ARM-OMK.')
lines.append('-- СГЕНЕРИРОВАНО tools/gen_schema.py по фактическим атрибутам MS Access.')
lines.append('-- Имена таблиц/полей не изменены. Маппинг: AutoNumber -> INTEGER PRIMARY KEY')
lines.append('-- AUTOINCREMENT, Long Integer -> INTEGER, TEXT(255)/MEMO -> TEXT.')
lines.append('-- Обязательность (NOT NULL) перенесена из свойства Required Access.')
lines.append('')
lines.append('PRAGMA foreign_keys = ON;')
lines.append('')

for table, pk in TABLES:
    cur.execute(f'SELECT * FROM [{table}]')
    physical = [d[0] for d in cur.description]
    lines.append(f'-- ===== {table} =====')
    lines.append(f'CREATE TABLE "{table}" (')
    col_defs = []
    for name in physical:
        m = meta[table][name]
        quoted = f'"{name}"'
        if m['autoinc']:
            col_defs.append(f'    {quoted} INTEGER PRIMARY KEY AUTOINCREMENT')
            continue
        typ = sql_type(m['type'])
        not_null = '' if m['nullable'] else ' NOT NULL'
        col_defs.append(f'    {quoted} {typ}{not_null}')
    # внешний ключ (реальная связь Access)
    if table == 'IPAddressUch':
        col_defs.append('    FOREIGN KEY ("IDUchastok") REFERENCES "NameUchastok"("IDUchastok")')
    lines.append(',\n'.join(col_defs))
    lines.append(');')
    lines.append('')

lines.append('-- ===== users (НОВАЯ: аутентификация и роли) =====')
lines.append('CREATE TABLE users (')
lines.append('    user_id       INTEGER PRIMARY KEY AUTOINCREMENT,')
lines.append('    username      TEXT    NOT NULL UNIQUE,')
lines.append('    password_hash TEXT    NOT NULL,')
lines.append("    role          TEXT    NOT NULL CHECK (role IN ('viewer','editor','admin')),")
lines.append('    is_active     INTEGER NOT NULL DEFAULT 1,')
lines.append("    created_at    TEXT    NOT NULL DEFAULT (datetime('now')),")
lines.append('    last_login    TEXT')
lines.append(');')
lines.append('')

lines.append('-- ===== Индексы (соответствуют индексам Access) =====')
lines.append('CREATE INDEX IX_IPaddressAll_ShopID     ON "IPaddressAll"("ShopID");')
lines.append('CREATE INDEX IX_Video_Camera_all_ShopID ON "Video_Camera_all"("ShopID");')
lines.append('CREATE INDEX IX_SPR_CAMERA_IDCAM        ON "SPR_CAMERA"("IDCAM_NAME");')
lines.append('CREATE INDEX IX_NameProlet_ShopID       ON "NameProlet"("ShopID");')
lines.append('CREATE INDEX IX_IPAddressUch_IDUchastok ON "IPAddressUch"("IDUchastok");')
lines.append('CREATE INDEX IX_UserPass_Login          ON "UserPass"("Login");')
lines.append('')

ac.close()
open(OUT, 'w', encoding='utf-8', newline='\n').write('\n'.join(lines))
print('schema.sql сгенерирован')
