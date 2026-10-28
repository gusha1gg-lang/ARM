# ARM-OMK — справочник ТЭСК ТБД

Локальное веб-приложение для учёта IP-адресов рабочих мест, телефонов,
видеонаблюдения, ярлыков и справочников. Переписано с legacy-сайта
ASP.NET WebForms + C# + MS Access на **Python (Flask) + SQLite** с сохранением
структуры страниц, навигации, названий разделов и данных (1-в-1).

* **Бэкенд:** Flask 3 + Jinja2, без ORM (`sqlite3`).
* **БД:** SQLite (`instance/asutp.db`), схема и данные перенесены из `App_Data/AsutpDB.mdb`.
* **Аутентификация:** сессии Flask, пароли — PBKDF2-SHA256, роли `viewer` / `editor` / `admin`.
* **Запуск:** только локально, `http://127.0.0.1:5000`.

Статус миграции: **Этапы 0–4 выполнены**, Этап 5 — финальная проверка и документация.
Отчёт по страницам — [`docs/04_PAGES.md`](docs/04_PAGES.md), журнал изменений —
[`MIGRATION_LOG.md`](MIGRATION_LOG.md).

---

## 1. Требования

| Компонент | Версия | Когда нужен |
|---|---|---|
| Windows | 11 | всегда |
| Python | 3.11+ (проверено на 3.13) | всегда |
| Flask, python-dotenv | см. `requirements.txt` | всегда |
| pyodbc + драйвер `Microsoft Access Driver (*.mdb, *.accdb)` | — | только для миграции из Access и `tools/verify_db.py` |

## 2. Установка

```powershell
cd C:\ARM-OMK
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
copy .env.example .env
```

В `.env` задайте случайный `SECRET_KEY`:

```powershell
python -c "import secrets; print(secrets.token_hex(32))"
```

Полученную строку впишите в `.env` вместо `change-me-to-random-string`.
Файл `.env` в git не попадает.

### Перенос данных из Access (один раз)

```powershell
python scripts/migrate_access_to_sqlite.py
python scripts/migrate_legacy_admin.py
```

* Первый скрипт создаёт `instance/asutp.db` по схеме `scripts/schema.sql`
  и переносит все 14 таблиц (3 880 строк).
  **Внимание:** если файл `instance/asutp.db` уже существует, он будет удалён и создан заново.
* Второй скрипт переносит администратора из legacy-таблицы `UserPass` в `users`
  с ролью `admin` (пароль остаётся прежним).
* Скрипт идемпотентен: повторный запуск не создаёт дубликатов.

Проверка переноса:

```powershell
python tools/verify_db.py
```

Ожидаемый результат: `Access=3880, SQLite=3880`, «Внешние ключи: OK», «Кириллица: OK».
Отчёт перезаписывается в `docs/02_DB.md`.

## 3. Запуск

```powershell
cd C:\ARM-OMK
venv\Scripts\activate
python run.py
```

Откройте <http://127.0.0.1:5000> — приложение перенаправит на `/Login.aspx`.

* Логин администратора — `admin` (перенесён из `UserPass`).
* Пароль — прежний, из старой базы. **Смените его** после первого входа
  (шапка → «Пользователи» → «Сменить пароль»).
* Для остановки сервера — `Ctrl+C`.
* Порт занят: измените `PORT` в `.env` или завершите процесс, слушающий 5000.

`run.py` использует `HOST`, `PORT` и `DEBUG` из `.env`. Для обычной работы
рекомендуется `DEBUG=0`; при `DEBUG=1` сервер сам перезагружается после правок кода.

## 4. Настройки (`.env`)

| Переменная | По умолчанию | Назначение |
|---|---|---|
| `SECRET_KEY` | `dev-only-insecure-key` | ключ подписи сессий (обязательно заменить) |
| `DATABASE_PATH` | `instance/asutp.db` | путь к SQLite относительно корня проекта |
| `UPLOAD_FOLDER` | `app/static/uploads` | куда сохраняются картинки камер |
| `HOST` | `127.0.0.1` | адрес прослушивания (только локально) |
| `PORT` | `5000` | порт |
| `DEBUG` | `1` | `1` — режим отладки, `0` — обычный |

## 5. Роли

| Роль | Просмотр | Добавление / правка / удаление | Пользователи |
|---|:---:|:---:|:---:|
| `viewer` | ✅ | ❌ | ❌ |
| `editor` | ✅ | ✅ | ❌ |
| `admin` | ✅ | ✅ | ✅ |

Подробно — [`docs/03_AUTH.md`](docs/03_AUTH.md).

### Как добавить пользователя

1. Войти как `admin`.
2. В шапке нажать **«Пользователи»** (`/admin/users/`).
3. В блоке **«Добавить пользователя»** указать логин, пароль (от 6 символов)
   и роль (`viewer` / `editor` / `admin`), нажать **«Создать»**.
4. Роль меняется выпадающим списком в таблице; там же — «Сменить пароль»,
   «Заблокировать»/«Разблокировать».

Ограничения: нельзя заблокировать себя и нельзя лишить прав последнего
активного администратора.

## 6. Разделы сайта

URL сохранены как в оригинале (`.aspx` / `.htm`).

| Раздел | URL | Таблицы |
|---|---|---|
| Вход | `/Login.aspx`, `/logout` | `users`, `UserPass` (историческая) |
| ТЭСК ТБД | `/main.aspx`, `/Addipt4.aspx`, `/Edit.aspx?id=N`, `/ReportExist.aspx?KE=…` | `IPaddress4`, `NameProlet`, `NameUchastok` |
| ТЭСЦ 5 | `/IpaddrT5.aspx`, `/Addipt5.aspx`, `/Editipt5.aspx?id=N` | `IPaddress5` |
| АБК | `/IPaddrUch.aspx`, `/Addipuch.aspx`, `/EditUch.aspx?id=N` | `IPAddressUch`, `NameUchastok` |
| Все цеха | `/IPaddrALL.aspx`, `/AddipALL.aspx`, `/EditALL.aspx?id=N` | `IPaddressAll`, `NameShop`, `NameProlet` |
| Видеонаблюдение | `/VideoIP.aspx?VideoType=IP\|Analog`, `/VideoAnalog.aspx`, `/VideoIP/upload` | `Video_Camera_all`, `SPR_CISCO`, `SPR_CAMERA`, `NameShop` |
| Телефоны | `/telefon.aspx` | `telefon` |
| Ярлыки | `/JR.aspx`, `/AddJR.aspx`, `/EditJR.aspx?id=N`, `/Slegenie/<файл>` | `Jarlik` + файлы `Slegenie/` |
| CISCO | `/CISCO.aspx`, `/CISCO2.aspx` | статические таблицы |
| Справочники | `/SPR_CISCO.aspx?SPRType=1\|2`, `/spr_shop.aspx` | `SPR_CISCO`, `SPR_CAMERA`, `NameShop` |
| Настройки | `/NastoikaT5.aspx`, `/NastoikaEBS.aspx`, `/NastroykaOPT.htm`, `/birka_akp5.htm`, `/tururushka.htm`, `/Инструкция по перезапуску WinCC.htm` | статические страницы |
| Прочее | `/Webnav.aspx`, `/Calendar.aspx` | статические страницы |
| Пользователи | `/admin/users/` | `users` |

Страницы `/CISCO.aspx`, `/CISCO2.aspx`, `/Webnav.aspx`,
`/NastoikaT5.aspx`, `/NastoikaEBS.aspx`, `/Calendar.aspx` и `.htm`-файлы
не работают с БД: их разметка перенесена без изменений.
Страница `/Nastroyki.aspx` удалена (2026-10-28) — не использовалась; инструкции
открываются из выпадающего меню «Настройки».

## 7. Структура проекта

```text
C:\ARM-OMK\
├── app\                      # новое приложение
│   ├── __init__.py           # фабрика Flask, регистрация модулей, общие маршруты
│   ├── config.py             # конфигурация из .env
│   ├── db.py                 # соединение SQLite на запрос
│   ├── security.py           # g.user, @login_required, @roles_required, CSRF
│   ├── auth.py               # /Login.aspx, /logout
│   ├── users.py              # /admin/users/ (только admin)
│   ├── ipaddr4.py            # ТЭСК ТБД
│   ├── ipaddr5.py            # ТЭСЦ 5
│   ├── ipaddr_uch.py         # АБК
│   ├── ipaddr_all.py         # Все цеха
│   ├── ip_shared.py          # общие проверки IP-полей
│   ├── video.py              # видеонаблюдение + загрузка картинок
│   ├── telefon.py            # телефоны
│   ├── jarlik.py             # ярлыки + файлы Slegenie
│   ├── cisco.py              # CISCO / CISCO2
│   ├── spr.py                # SPR_CISCO / SPR_CAMERA / NameShop
│   ├── static_pages.py       # статические aspx и .htm
│   ├── templates\            # Jinja2-шаблоны (base.html + страницы)
│   └── static\css\style.css  # единый CSS
├── scripts\
│   ├── schema.sql            # DDL SQLite (14 таблиц + users)
│   ├── migrate_access_to_sqlite.py  # Access → SQLite
│   └── migrate_legacy_admin.py      # UserPass → users (admin)
├── tools\                    # проверки и тесты (не входят в приложение)
│   ├── verify_db.py          # сверка Access ↔ SQLite
│   ├── smoke_pages.py        # дым-тест всех страниц
│   ├── check_static_pages.py # сверка статики с legacy 1-в-1
│   ├── check_cisco_static.py # сверка CISCO с legacy 1-в-1
│   ├── test_auth.py          # роли и пользователи (23)
│   ├── test_pages*.py        # по разделам (38–51)
│   ├── test_stage5_roles.py  # матрица «страницы × роли» (173)
│   └── gen_static_pages.py   # генератор шаблонов статики
├── docs\                     # 00_AUDIT, 01_PLAN, 02_DB, 03_AUTH, 04_PAGES, 05_FINAL
├── instance\asutp.db         # рабочая БД (в git не входит)
├── App_Data\AsutpDB.mdb      # исходная база Access (не изменяется)
├── run.py                    # python run.py
├── requirements.txt
├── .env.example
├── MIGRATION_LOG.md          # журнал всех изменений по этапам
└── (legacy: *.aspx, *.cs, *.htm, *.files, App_Code\, css\, img\, images\, Slegenie\)
```

Оригинальные файлы legacy-сайта остаются в корне проекта без изменений:
они нужны как источник для проверок и как справочник поведения.

## 8. Проверки и тесты

Все сквозные тесты работают через HTTP и требуют запущенного `python run.py`
на `http://127.0.0.1:5000`.

```powershell
python tools/verify_db.py          # сверка БД с Access
python tools/smoke_pages.py        # все страницы → 200
python tools/test_stage5_roles.py  # матрица доступа по ролям
python tools/check_static_pages.py # статика 1-в-1 с legacy
python tools/check_cisco_static.py # CISCO 1-в-1 с legacy
```

| Набор | Проверок |
|---|---:|
| `test_pages.py` (ТЭСК ТБД) | 38 |
| `test_pages5.py` (ТЭСЦ 5) | 36 |
| `test_pages_uch.py` (АБК) | 46 |
| `test_pages_all.py` (Все цеха) | 49 |
| `test_pages_video.py` (Видеонаблюдение) | 51 |
| `test_pages_telefon.py` (Телефоны) | 32 |
| `test_pages_cisco.py` (CISCO) | 14 |
| `test_pages_jr.py` (Ярлыки) | 33 |
| `test_pages_spr.py` (Справочники) | 48 |
| `test_pages_static.py` (статика) | 39 |
| `test_auth.py` (роли) | 23 |
| `test_stage5_roles.py` (матрица) | 173 |
| `smoke_pages.py` (все страницы) | 36 |

Тесты создают временных пользователей (`test_viewer`, `test_editor`) и тестовые
записи, затем удаляют их. Итоговое количество строк в БД не меняется
(контроль — `tools/verify_db.py`, 3 880 = 3 880).

## 9. База данных и резервные копии

* Рабочая БД: `instance/asutp.db` (в git не входит).
* Схема: `scripts/schema.sql` — имена таблиц/полей и типы повторяют Access
  (маппинг типов описан в `docs/02_DB.md`).
* Перед экспериментами скопируйте файл:

```powershell
Copy-Item instance\asutp.db "_backup\asutp-$(Get-Date -Format yyyyMMdd-HHmm).db"
```

* `scripts/migrate_access_to_sqlite.py` **пересоздаёт** базу из Access:
  изменения, сделанные в приложении, будут потеряны — сначала сделайте копию.

## 10. Безопасность

* Приложение слушает только `127.0.0.1` (локальное использование).
* Пароли — PBKDF2-SHA256; в открытом виде не хранятся.
* Все изменяющие формы защищены CSRF-токеном; запрос без токена → `400`.
* SQL — только параметризованный (`?`), без конкатенации пользовательских строк.
* Проверка прав выполняется на сервере для каждого маршрута, независимо от того,
  видна ли кнопка в интерфейсе.
* `SECRET_KEY` и `.env` не коммитятся; в репозитории только `.env.example`.
* Загружаемые картинки камер: проверка расширения и размера (до 4 МБ, как в оригинале).

## 11. Документация

| Файл | Содержание |
|---|---|
| [`docs/00_AUDIT.md`](docs/00_AUDIT.md) | аудит legacy-проекта |
| [`docs/01_PLAN.md`](docs/01_PLAN.md) | план миграции, карта страниц, DDL |
| [`docs/02_DB.md`](docs/02_DB.md) | сверка Access ↔ SQLite по таблицам |
| [`docs/03_AUTH.md`](docs/03_AUTH.md) | вход, роли, управление пользователями |
| [`docs/04_PAGES.md`](docs/04_PAGES.md) | отчёты по каждой странице и отклонения |
| [`docs/05_FINAL.md`](docs/05_FINAL.md) | итоговая проверка Этапа 5 |
| [`MIGRATION_LOG.md`](MIGRATION_LOG.md) | журнал изменений по этапам |

## 12. Частые проблемы

| Симптом | Причина / решение |
|---|---|
| `no such table: users` | не выполнена миграция: `python scripts/migrate_access_to_sqlite.py` |
| `pyodbc.InterfaceError: Data source name not found` | нет драйвера Access — установите «Microsoft Access Database Engine» (нужен только для миграции) |
| Порт 5000 занят | закройте старый процесс или измените `PORT` в `.env` |
| После правки кода ничего не меняется | `DEBUG=0` — перезапустите `python run.py` |
| В `.htm` кракозябры | файлы в windows-1251; их нельзя пересохранять в UTF-8 без изменения `<meta charset>` |
| Забыт пароль администратора | создайте нового admin через `python` + `werkzeug.security.generate_password_hash` или восстановите копию БД |
