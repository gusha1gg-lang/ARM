# План миграции и архитектура (Этап 1)

Дата: 2025-10-24
Основание: `docs/00_AUDIT.md`, `docs/access_schema.json`, `docs/schema_types.txt`, `docs/schema_keys2.txt`

---

## 1. Обоснование выбора фреймворка

**Выбран Flask.**

| Критерий | Flask | FastAPI |
|---|---|---|
| Порог входа / объём кода | Минимальный: маршрут = функция | Выше: нужны Pydantic-модели, async, аннотации |
| Соответствие WebForms-логике | Прямое: серверный рендеринг HTML + формы POST | Заточен под JSON API, HTML-рендер вторичен |
| Шаблоны | Jinja2 «из коробки» (наследование, как MasterPage) | Требует подключения отдельно |
| Сессии/куки | Встроенные, просто | Нужен middleware/зависимости |
| Стабильность для слабой модели | Проще удержать контекст, меньше неявной магии | Больше слоёв, выше риск ошибок |
| Производительность | Достаточно (локальный сайт, 1–5 пользователей) | Избыточна |

**Вывод:** Flask + Jinja2 + SQLite. Серверный рендеринг максимально близок к текущему ASP.NET WebForms, что упрощает перенос 1-в-1 и снижает риск отклонений в поведении.

**Дополнительно:**
- `werkzeug.security` — PBKDF2-хеширование паролей.
- `Flask-Session` не нужен: стандартные cookie-сессии Flask.
- CSRF — `Flask-WTF` (только CSRF-защита форм).
- Доступ к SQLite — стандартный модуль `sqlite3` (без ORM, чтобы SQL был прозрачным и совпадал с оригиналом).

---

## 2. Структура проекта

Оригинальные файлы в корне `C:\ARM-OMK` **не удаляются и не изменяются** (они в git). Новый код — в папке `app/`.

```text
C:\ARM-OMK\
├── AGENTS.md                   # правила работы
├── Promt.md                    # исходное задание
├── MIGRATION_LOG.md            # журнал изменений по этапам
├── README.md                   # инструкция запуска
├── _backup\                    # резервные копии (с датой)
│   └── 2025-10-24\AsutpDB.mdb
├── docs\
│   ├── 00_AUDIT.md
│   ├── 01_PLAN.md
│   ├── 02_DB.md
│   ├── 03_AUTH.md
│   ├── 04_PAGES.md
│   └── access_schema.json, schema_types.txt, schema_keys2.txt
├── tools\                      # вспомогательные скрипты аудита/сверки
│   ├── dump_schema.py
│   ├── dump_keys2.py
│   ├── dump_types.py
│   └── verify_db.py
├── scripts\
│   ├── schema.sql              # DDL SQLite (1-в-1)
│   └── migrate_access_to_sqlite.py
├── instance\
│   └── asutp.db                # рабочая БД SQLite (создаётся миграцией)
├── app\
│   ├── __init__.py             # фабрика приложения, конфиг, регистрация blueprint'ов
│   ├── config.py               # настройки (SECRET_KEY, пути) из .env
│   ├── db.py                   # подключение к SQLite, row_factory
│   ├── auth.py                 # blueprint авторизации + RBAC-декораторы
│   ├── users.py                # blueprint управления пользователями (admin)
│   ├── helpers.py              # общие функции (paging, форматирование)
│   ├── routes\
│   │   ├── pages.py            # все страницы справочников
│   │   ├── ipaddr.py           # main / IpaddrT5 / IPaddrUch / IPaddrALL
│   │   ├── jarlik.py           # JR / AddJR / EditJR
│   │   ├── telefon.py
│   │   ├── spr.py              # SPR_CISCO / SPR_CAMERA / NameShop
│   │   ├── video.py            # VideoIP / VideoAnalog
│   │   └── report.py           # ReportExist
│   ├── templates\
│   │   ├── base.html           # аналог MainMasterPage.master (навигация 1-в-1)
│   │   ├── login.html
│   │   ├── main.html
│   │   ├── ipaddr5.html
│   │   ├── ipaddr_uch.html
│   │   ├── ipaddr_all.html
│   │   ├── jarlik.html
│   │   ├── telefon.html
│   │   ├── spr_cisco.html
│   │   ├── spr_camera.html
│   │   ├── spr_shop.html
│   │   ├── video.html
│   │   ├── report.html
│   │   ├── page_static.html
│   │   └── users.html
│   └── static\                 # css/js/изображения (копия/адаптация текущих)
│       ├── css\
│       ├── img\
│       └── uploads\            # загрузки камер
├── requirements.txt
├── .env.example
├── run.py                      # точка входа (python run.py)
└── (legacy-файлы в корне: *.aspx, *.cs, App_Code\, App_Data\, css\, img\, images\, uploads\, *.htm)
```

**Сохранение оригиналов:** перед миграцией БД копия `App_Data\AsutpDB.mdb` → `_backup\2025-10-24\`. Оригинальный `.mdb` остаётся в `App_Data\`.

---

## 3. Карта страниц (старая → новая)

URL сохраняются максимально близко к оригиналу (включая `.aspx`), чтобы навигация и закладки не ломались.

| Старый URL | Новый маршрут Flask | Шаблон | Таблицы | Роли |
|---|---|---|---|---|
| `/Login.aspx` | `/Login.aspx`, `/logout` | `login.html` | `UserPass`, `users` | все |
| `/main.aspx` | `/main.aspx` | `main.html` | `IPaddress4` | view: viewer, editor, admin |
| `/Addipt4.aspx` | `/Addipt4.aspx` | форма | `IPaddress4` (INSERT) | editor, admin |
| `/Edit.aspx?id=N` | `/Edit.aspx?id=N` | форма | `IPaddress4` (UPDATE/DELETE) | editor, admin |
| `/IpaddrT5.aspx` | `/IpaddrT5.aspx` | `ipaddr5.html` | `IPaddress5` | все (чтение) |
| `/Addipt5.aspx` | `/Addipt5.aspx` | форма | `IPaddress5` | editor, admin |
| `/Editipt5.aspx?id=N` | `/Editipt5.aspx?id=N` | форма | `IPaddress5` | editor, admin |
| `/IPaddrUch.aspx` | `/IPaddrUch.aspx` | `ipaddr_uch.html` | `IPAddressUch`, `NameUchastok` | все |
| `/Addipuch.aspx` | `/Addipuch.aspx` | форма | `IPAddressUch` | editor, admin |
| `/EditUch.aspx?id=N` | `/EditUch.aspx?id=N` | форма | `IPAddressUch` | editor, admin |
| `/IPaddrALL.aspx` | `/IPaddrALL.aspx` | `ipaddr_all.html` | `IPaddressAll`, `NameShop`, `NameProlet` | все |
| `/AddipALL.aspx` | `/AddipALL.aspx` | форма | `IPaddressAll` | editor, admin |
| `/EditALL.aspx?id=N` | `/EditALL.aspx?id=N` | форма | `IPaddressAll` | editor, admin |
| `/JR.aspx` | `/JR.aspx` | `jarlik.html` | `Jarlik` | все |
| `/AddJR.aspx` | `/AddJR.aspx` | форма | `Jarlik` | editor, admin |
| `/EditJR.aspx?id=N` | `/EditJR.aspx?id=N` | форма | `Jarlik` | editor, admin |
| `/telefon.aspx` | `/telefon.aspx` | `telefon.html` | `telefon` | чтение: все; CRUD: editor, admin |
| `/CISCO.aspx` | `/CISCO.aspx` | `page_static.html` | — (стат. таблица шкафов) | все |
| `/CISCO2.aspx` | `/CISCO2.aspx` | `page_static.html` | — (стат. таблица узлов) | все |
| `/SPR_CISCO.aspx?SPRType=1` | `/SPR_CISCO.aspx?SPRType=1` | `spr_cisco.html` | `SPR_CISCO` | чтение: все; CRUD: editor, admin |
| `/SPR_CISCO.aspx?SPRType=2` | `/SPR_CISCO.aspx?SPRType=2` | `spr_camera.html` | `SPR_CAMERA` | чтение: все; CRUD: editor, admin |
| `/spr_shop.aspx` | `/spr_shop.aspx` | `spr_shop.html` | `NameShop`, `NameProlet`, `NameUchastok` | чтение: все; CRUD: editor, admin |
| `/VideoIP.aspx?VideoType=IP` | `/VideoIP.aspx?VideoType=IP` | `video.html` | `Video_Camera_all` (IP), `SPR_CAMERA`, `SPR_CISCO`, `NameShop`, `NameProlet` | чтение: все; CRUD+upload: editor, admin |
| `/VideoIP.aspx?VideoType=Analog` | `/VideoIP.aspx?VideoType=Analog` | `video.html` | те же, `Camera_Type='Analog'` | то же |
| `/VideoAnalog.aspx` | `/VideoAnalog.aspx` | редирект на `/VideoIP.aspx?VideoType=Analog` | — | все |
| `/ReportExist.aspx?KE=...` | `/ReportExist.aspx?KE=...` | `report.html` | `IPaddress4`, `IPAddressUch`, `IPaddress5`, `IPaddressAll` | все |
| `/Webnav.aspx` | `/Webnav.aspx` | `page_static.html` | — | все |
| `/Nastroyki.aspx` | `/Nastroyki.aspx` | `page_static.html` | — | все |
| `/NastoikaT5.aspx` | `/NastoikaT5.aspx` | `page_static.html` | — | все |
| `/NastoikaEBS.aspx` | `/NastoikaEBS.aspx` | `page_static.html` | — | все |
| `/Calendar.aspx` | `/Calendar.aspx` | `page_static.html` | — (стат. HTML из Word) | все |
| `/NastroykaOPT.htm`, `/birka_akp5.htm`, `/tururushka.htm`, `/Инструкция по перезапуску WinCC.htm` | `/<имя>.htm` (раздача как статика) | — | — | все |
| `temp.aspx`, `temp1.aspx`, `test.html`, `NastoikaEBS_test.aspx` | **не переносятся** (отладочные, нет в навигации) | — | `temp` | — |
| — | `/admin/users` | `users.html` | `users` | только admin |

**Статус:** таблица `temp` всё равно мигрируется в SQLite 1-в-1 (данные неприкосновенны), но страниц для неё нет.

---

## 4. Схема аутентификации и ролей

### Модель
- Сессия Flask (подписанная cookie), `session['user_id']`, `session['username']`, `session['role']`.
- Пароли — PBKDF2 (`werkzeug.security.generate_password_hash`), в БД только хеш.
- Легаси-таблица `UserPass` **сохраняется без изменений** (исторические данные). Аутентификация идёт по новой таблице `users`.
- Миграция: запись из `UserPass` (1 пользователь) → `users` с ролью `admin`; исходный пароль хешируется (первый вход — тем же паролем).

### Роли и права

| Действие | viewer | editor | admin |
|---|:---:|:---:|:---:|
| Просмотр всех справочников | ✅ | ✅ | ✅ |
| Поиск / отчёты | ✅ | ✅ | ✅ |
| Добавление/редактирование/удаление записей | ❌ | ✅ | ✅ |
| Загрузка изображений камер | ❌ | ✅ | ✅ |
| Управление пользователями (`/admin/users`) | ❌ | ❌ | ✅ |
| Назначение ролей | ❌ | ❌ | ✅ |

### Реализация
Декораторы в `app/auth.py`:
- `@login_required` — требует авторизации, иначе редирект на `/Login.aspx?next=...`.
- `@roles_required('editor','admin')` — проверка роли, иначе `403`.
- В шаблонах: `current_user.role` управляет видимостью кнопок (аналог `Button1.Visible`).

### Таблица `users` (новая, не затрагивает легаси)

```xml
<file path="scripts/schema.sql (фрагмент)">
CREATE TABLE users (
    user_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    username      TEXT    NOT NULL UNIQUE,
    password_hash TEXT    NOT NULL,
    role          TEXT    NOT NULL CHECK (role IN ('viewer','editor','admin')),
    is_active     INTEGER NOT NULL DEFAULT 1,
    created_at    TEXT    NOT NULL DEFAULT (datetime('now')),
    last_login    TEXT
);
</file>
```

---

## 5. Схема SQLite (DDL) — 1-в-1 со структурой Access

### Маппинг типов Access → SQLite

| Access | SQLite | Комментарий |
|---|---|---|
| `AutoNumber` (Long Integer, `autoincrement=True`) | `INTEGER PRIMARY KEY AUTOINCREMENT` | ID сохраняются при переносе |
| `Long Integer` (`type=3`, required) | `INTEGER NOT NULL` | Обязательные числовые |
| `Long Integer` (`type=3`, nullable) | `INTEGER` | |
| `TEXT(255)` (`type=202`) | `TEXT` | Ограничение 255 в SQLite не нужно |
| `MEMO / Long Text` (`type=203`) | `TEXT` | |
| `Yes/No` | `INTEGER` | В данной БД отсутствуют |
| `DateTime` | `TEXT` (ISO-8601) | В данной БД отсутствуют |

**Имена таблиц и полей не меняются.** Кириллические поля `Поле1` сохраняются как есть.

### DDL

```xml
<file path="scripts/schema.sql">
PRAGMA foreign_keys = ON;

-- ===== 1. IPaddress4 (ТЭСК ТБД) =====
CREATE TABLE IPaddress4 (
    IDPC          INTEGER PRIMARY KEY AUTOINCREMENT,
    Prolet        INTEGER NOT NULL,
    Oc            INTEGER NOT NULL,
    Uchastok      TEXT,
    AgeregatName  TEXT,
    ConfigLogin   TEXT,
    IPaddress     TEXT,
    Shluz         TEXT,
    MAC           TEXT,
    KE            TEXT,
    Telephon      TEXT,
    Opisanie      TEXT,
    Monitor       TEXT,
    Printer       TEXT,
    UPS           TEXT,
    Modem         TEXT,
    CISCO         TEXT
);

-- ===== 2. IPaddress5 (ТЭСЦ 5) =====
CREATE TABLE IPaddress5 (
    IDPC          INTEGER PRIMARY KEY AUTOINCREMENT,
    Oc            INTEGER NOT NULL,
    Uchastok      TEXT,
    ConfigLogin   TEXT,
    IPaddress     TEXT,
    MAC           TEXT,
    KE            TEXT,
    Telephon      TEXT,
    Opisanie      TEXT,
    Monitor       TEXT,
    Printer       TEXT,
    UPS           TEXT,
    Modem         TEXT,
    CISCO         TEXT
);

-- ===== 3. IPaddressAll (все цеха) =====
CREATE TABLE IPaddressAll (
    IDPC          INTEGER PRIMARY KEY AUTOINCREMENT,
    ShopID        INTEGER NOT NULL,
    Prolet        INTEGER NOT NULL,
    Oc            INTEGER NOT NULL,
    Uchastok      TEXT,
    AgeregatName  TEXT,
    ConfigLogin   TEXT,
    IPaddress     TEXT,
    Shluz         TEXT,
    MAC           TEXT,
    KE            TEXT,
    Telephon      TEXT,
    Opisanie      TEXT,
    Monitor       TEXT,
    Printer       TEXT,
    UPS           TEXT,
    Modem         TEXT,
    CISCO         TEXT
);

-- ===== 4. IPAddressUch (АБК) =====
CREATE TABLE IPAddressUch (
    IDPC          INTEGER PRIMARY KEY AUTOINCREMENT,
    IDUchastok    INTEGER NOT NULL,
    Kabinet       TEXT,
    Level         INTEGER NOT NULL,
    ConfigLogin   TEXT,
    IPaddress     TEXT,
    MAC           TEXT,
    KE            TEXT,
    Telephon      TEXT,
    Opisanie      TEXT,
    Monitor       TEXT,
    Printer       TEXT,
    UPS           TEXT,
    Modem         TEXT,
    CISCO         TEXT,
    FOREIGN KEY (IDUchastok) REFERENCES NameUchastok(IDUchastok)
);

-- ===== 5. Jarlik (ярлыки) =====
CREATE TABLE Jarlik (
    IDJarlik      INTEGER PRIMARY KEY AUTOINCREMENT,
    LnkNameJarlik TEXT,
    NameJarlik    TEXT
);

-- ===== 6. NameProlet (пролёты) =====
CREATE TABLE NameProlet (
    ProletID      INTEGER PRIMARY KEY AUTOINCREMENT,
    ShopID        INTEGER NOT NULL,
    Prolet        INTEGER NOT NULL,
    Prolet_name   TEXT
);

-- ===== 7. NameShop (цеха) =====
CREATE TABLE NameShop (
    ShopID        INTEGER PRIMARY KEY AUTOINCREMENT,
    ShopName      TEXT,
    "Поле1"       TEXT
);

-- ===== 8. NameUchastok (участки) =====
CREATE TABLE NameUchastok (
    IDUchastok    INTEGER PRIMARY KEY AUTOINCREMENT,
    Nameuchastka  TEXT,
    "Поле1"       TEXT
);

-- ===== 9. SPR_CAMERA (справочник камер) =====
CREATE TABLE SPR_CAMERA (
    IDCAM_NAME    INTEGER PRIMARY KEY AUTOINCREMENT,
    Camera_Type   TEXT,
    Camera_Name   TEXT
);

-- ===== 10. SPR_CISCO (справочник CISCO) =====
CREATE TABLE SPR_CISCO (
    ID_CISCO      INTEGER PRIMARY KEY AUTOINCREMENT,
    IP_CISCO      TEXT,
    Prolet_CISCO  INTEGER NOT NULL,
    Oc_CISCO      INTEGER NOT NULL,
    Location_CISCO TEXT,
    Opisanie_CISCO TEXT
);

-- ===== 11. UserPass (легаси-аутентификация, без изменений) =====
CREATE TABLE UserPass (
    UserID        INTEGER PRIMARY KEY AUTOINCREMENT,
    Login         TEXT,
    Pass          TEXT
);

-- ===== 12. Video_Camera_all (видеокамеры) =====
CREATE TABLE Video_Camera_all (
    ID_VID_CAM    INTEGER PRIMARY KEY AUTOINCREMENT,
    IDCAM_NAME    INTEGER NOT NULL,
    ID_CISCO      INTEGER NOT NULL,
    Camera_Type   TEXT,
    ShopID        INTEGER NOT NULL,
    Prolet        INTEGER NOT NULL,
    Oc            INTEGER NOT NULL,
    Uchastok      TEXT,
    Camera_number TEXT,
    IPaddress     TEXT,
    Login_password TEXT,
    IP_Server_PC  TEXT,
    upload_img    TEXT,
    Opisanie      TEXT,
    Monitor       TEXT,
    Video_out_lacation_PC TEXT,
    CISCO         TEXT,
    Port_CISCO    TEXT,
    IP_CAMERA_STREAM TEXT
);

-- ===== 13. telefon =====
CREATE TABLE telefon (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    fio           TEXT,
    telnumber     TEXT
);

-- ===== 14. temp (отладочная, переносится 1-в-1) =====
CREATE TABLE temp (
    idt           INTEGER PRIMARY KEY AUTOINCREMENT,
    t             INTEGER NOT NULL
);

-- ===== 15. users (НОВАЯ, для аутентификации и ролей) =====
CREATE TABLE users (
    user_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    username      TEXT    NOT NULL UNIQUE,
    password_hash TEXT    NOT NULL,
    role          TEXT    NOT NULL CHECK (role IN ('viewer','editor','admin')),
    is_active     INTEGER NOT NULL DEFAULT 1,
    created_at    TEXT    NOT NULL DEFAULT (datetime('now')),
    last_login    TEXT
);

-- ===== 16. Индексы (соответствуют индексам Access) =====
CREATE INDEX IX_IPaddressAll_ShopID       ON IPaddressAll(ShopID);
CREATE INDEX IX_Video_Camera_all_ShopID   ON Video_Camera_all(ShopID);
CREATE INDEX IX_SPR_CAMERA_IDCAM          ON SPR_CAMERA(IDCAM_NAME);
CREATE INDEX IX_NameProlet_ShopID         ON NameProlet(ShopID);
CREATE INDEX IX_IPAddressUch_IDUchastok   ON IPAddressUch(IDUchastok);
CREATE INDEX IX_UserPass_Login            ON UserPass(Login);
</file>
```

### Связи: было / стало
| Access | SQLite | Статус |
|---|---|---|
| `IPAddressUch.IDUchastok` → `NameUchastok.IDUchastok` (реальная связь) | `FOREIGN KEY` | сохранено |
| Индекс `IPaddressAll.ShopID` | `INDEX` | сохранено |
| Индекс `Video_Camera_all.ShopID` | `INDEX` | сохранено |
| Индекс `SPR_CAMERA.IDCAM_NAME` | `INDEX` | сохранено |
| Индекс `NameProlet.ProletID` (unique) | PK `ProletID` | сохранено |
| Прочие связи в Access не объявлены | — | не добавляем (структура 1-в-1) |

---

## 6. Стратегия миграции данных Access → SQLite

**Инструмент:** `pyodbc` (драйвер `Microsoft Access Driver (*.mdb, *.accdb)`) + стандартный `sqlite3`. Без pandas — чтобы контролировать типы и NULL.

**Алгоритм `scripts/migrate_access_to_sqlite.py`:**
1. Проверить наличие `App_Data\AsutpDB.mdb`; создать резервную копию в `_backup\<дата>\`.
2. Создать `instance\asutp.db` и выполнить `scripts\schema.sql`.
3. Для каждой таблицы (14 таблиц):
   - `SELECT * FROM [Table]` — все строки.
   - `INSERT INTO Table (все поля, включая PK) VALUES (...)` — **явная вставка ID**, чтобы сохранить значения AutoNumber.
   - Параметризованные запросы (без конкатенации) для сохранности кириллицы/спецсимволов.
   - `NULL` переносится как `NULL`.
4. После переноса — сброс `sqlite_sequence` на максимальные ID, чтобы новые записи не конфликтовали.
5. Мигрировать пользователя из `UserPass` в `users` (роль `admin`, пароль — хеш PBKDF2 от исходного).
6. Записать в `docs/02_DB.md` отчёт сверки.

**Важно:** `temp` и `UserPass` переносятся тоже (данные неприкосновенны).

---

## 7. Порядок работ (Этапы 2–5)

| Шаг | Содержание | Результат |
|---|---|---|
| **2.1** | Резервная копия `.mdb`, структура `app/`, `requirements.txt`, `.env.example`, `run.py` | каркас запускается |
| **2.2** | `scripts/schema.sql` + скрипт миграции | `instance/asutp.db` |
| **2.3** | Сверка: количество строк, контрольные суммы, 5 случайных строк/таблицу, FK, кодировка | `docs/02_DB.md` |
| **3.1** | `users`, `auth.py`, логин/логаут, декораторы RBAC | вход работает |
| **3.2** | `/admin/users` (создание, роли, сброс пароля) | `docs/03_AUTH.md` |
| **4.1** | `base.html` (навигация 1-в-1) + `Login.aspx` + `main.aspx` | 1-я страница |
| **4.2** | `IpaddrT5.aspx`, `IPaddrUch.aspx` + формы | 2-я группа |
| **4.3** | `IPaddrALL.aspx` + формы | |
| **4.4** | `JR.aspx` + формы | |
| **4.5** | `telefon.aspx` | |
| **4.6** | `SPR_CISCO.aspx?SPRType=1/2`, `spr_shop.aspx` | |
| **4.7** | `VideoIP.aspx?VideoType=IP/Analog` + загрузка файлов | |
| **4.8** | `ReportExist.aspx` | |
| **4.9** | Статические (`CISCO`, `CISCO2`, `Webnav`, `Nastroyki`, `Nastoika*`, `Calendar`, `.htm`) | |
| **5.1** | Прогон под 3 ролями, финальная сверка БД, `README.md`, `MIGRATION_LOG.md` | финал |

---

## 8. Риски и решения

| Риск | Решение |
|---|---|
| Потеря AutoNumber-значений | Явная вставка ID + сброс `sqlite_sequence` |
| Кириллица / `Поле1` | Параметризованные запросы, `utf-8`, имена в кавычках |
| SQL-инъекции в оригинале (конкатенация) | В новом коде — только параметризованные запросы (функционально идентично) |
| `Oc`/`Prolet` бывают пустыми в оригинале | В Access они `required`, поэтому `NOT NULL`; при миграции — контроль, расхождение = блокер |
| Огромные статические страницы (CISCO, Calendar) | Переносятся как статические шаблоны без изменения разметки |
| Отладочные страницы (`temp`, `test`) | Не переносятся как страницы; таблица `temp` мигрируется |

---

## 9. Что НЕ меняется

- Имена таблиц, полей, типов (кроме технического маппинга выше).
- Данные: ни одна строка/поле не удаляется.
- Навигация, названия разделов, расположение блоков.
- URL страниц (по возможности 1-в-1).
- Логика CRUD и фильтров.

**Визуальные улучшения** (современный CSS, адаптивность) — только после переноса логики, каждое изменение фиксируется в `MIGRATION_LOG.md`.

---

## Статус Этапа 1
**Выполнен.** Ожидаю подтверждения для перехода к **Этапу 2. Каркас проекта и БД**.
