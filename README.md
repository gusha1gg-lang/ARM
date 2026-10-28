# ARM-OMK — справочник ТЭСК ТБД

Локальное веб-приложение для учёта IP-адресов рабочих мест, телефонов,
видеонаблюдения, ярлыков и справочников. Переписано с legacy-сайта
ASP.NET WebForms + C# + MS Access на **Python (Flask) + SQLite** с сохранением
структуры страниц, навигации, названий разделов и данных (1-в-1).

* **Бэкенд:** Flask 3 + Jinja2, без ORM (`sqlite3`).
* **БД:** SQLite (`instance/asutp.db`), схема и данные перенесены из `App_Data/AsutpDB.mdb`.
* **Аутентификация:** сессии Flask, пароли — PBKDF2-SHA256, роли `viewer` / `editor` / `admin`.
* **Журнал действий:** страница **«Логи»** (`/Logs.aspx`) — кто, что и когда сделал;
  на формах редактирования справа от заголовка видно, кто и когда менял запись.
* **Сессии:** сутки с момента входа (не «сутки бездействия»); пароль каждый
  пользователь может сменить сам — шапка → «Сменить пароль» (`/Account.aspx`).
* **Запуск:** локально — `python run.py`; на сервере — `start_server.bat`
  (waitress, слушает локальную сеть). Библиотеки лежат в `vendor/`,
  `pip install` на сервере не нужен.

Статус миграции: **Этапы 0–5 выполнены**, Этап 6 — подготовка к работе на сервере.
Отчёт по страницам — [`docs/04_PAGES.md`](docs/04_PAGES.md), инструкция по
переносу — [`docs/06_DEPLOY.md`](docs/06_DEPLOY.md), состав технологий,
библиотек и кода (для согласования, в т. ч. службой ИБ) —
[`docs/07_STACK.md`](docs/07_STACK.md), журнал изменений —
[`MIGRATION_LOG.md`](MIGRATION_LOG.md).

---

## 1. Требования

| Компонент | Версия | Когда нужен |
|---|---|---|
| Windows | 11 | всегда |
| Python | **3.12 или 3.13, x64** (проверено на 3.13.0 и 3.12.10) | всегда |
| Flask, python-dotenv, waitress | уже в `vendor\` | всегда |
| pyodbc | уже в `vendor\` (5.3.0) | только для миграции из Access и `tools/verify_db.py` |
| драйвер `Microsoft Access Driver (*.mdb, *.accdb)` | — | только для миграции из Access (ставится один раз, см. `docs/06_DEPLOY.md`, п. 4.2) |

> **Про версию Python.** Нужен **3.12 или 3.13, обязательно x64**.
> Бинарные модули в `vendor\`: `markupsafe\_speedups.cp313-win_amd64.pyd`
> (на 3.12 не загрузится и `markupsafe` сам перейдёт на чистый Python —
> работает так же, чуть медленнее) и `pyodbc` — для него в `vendor\` лежат
> сборки под обе версии, нужная подхватывается автоматически.
> Проверено запуском без site-packages на 3.13.0 и 3.12.10.
> Если нужна другая версия Python — на машине с интернетом выполните
> `pip install --target vendor -r requirements.txt` (и `requirements-dev.txt`
> для `pyodbc`) той же версией Python, что стоит на сервере.

## 2. Установка

### На рабочем сервере (без интернета и без pip)

Ничего устанавливать не нужно: библиотеки лежат в папке `vendor\`.
Достаточно скопировать проект целиком (см. [`docs/06_DEPLOY.md`](docs/06_DEPLOY.md)).

### На машине разработчика

```powershell
cd C:\ARM-OMK
python -m venv venv
venv\Scripts\activate
pip install -r requirements-dev.txt
copy .env.example .env
```

В `.env` задайте случайный `SECRET_KEY`:

```powershell
python -c "import secrets; print(secrets.token_hex(32))"
```

Полученную строку впишите в `.env` вместо `change-me-to-random-string`.
Файл `.env` в git не попадает. При запуске `serve.py` ключ создаётся
автоматически, если его нет.

### Перенос данных из Access (один раз)

Миграцию можно выполнить на любом ПК, где разрешён `pip` и установлен драйвер
Access, а затем скопировать готовый файл `instance/asutp.db` на сервер.
Либо выполнить её прямо на сервере — `pyodbc` уже лежит в `vendor\`,
дополнительно нужен только ODBC-драйвер Access
(подробно: [`docs/06_DEPLOY.md`](docs/06_DEPLOY.md), п. 4).

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

> Сверка сравнивает базу с исходным снимком Access. После начала работы на новом
> сайте правки, сделанные через интерфейс, закономерно отличаются от Access —
> у таких таблиц контрольная сумма покажет ❌. Это не ошибка миграции;
> структура, количество строк, ключи и кодировка проверяются отдельно.

## 3. Запуск

### Рабочий режим (сервер, общий доступ)

```powershell
cd C:\ARM-OMK
start_server.bat
```

или напрямую:

```powershell
python serve.py
```

* Работает waitress — постоянный WSGI-сервер (не отладочный).
* Слушает `0.0.0.0:5000` — сайт доступен из локальной сети:
  `http://<IP-сервера>:5000/`.
* Если `.env` нет, он создаётся автоматически вместе со случайным `SECRET_KEY`.
* Остановка — `Ctrl+C`.

### Режим разработки

```powershell
cd C:\ARM-OMK
venv\Scripts\activate
python run.py
```

Откройте <http://127.0.0.1:5000> — приложение перенаправит на `/Login.aspx`.
`run.py` использует `HOST`, `PORT` и `DEBUG` из `.env`; при `DEBUG=1`
сервер сам перезагружается после правок кода.

* Логин администратора — `admin` (перенесён из `UserPass`).
* Пароль — прежний, из старой базы. **Смените его** после первого входа
  (шапка → «Сменить пароль»; администратор может менять пароли и в разделе
  «Пользователи»).
* Порт занят: измените `PORT` в `.env` или завершите процесс, слушающий 5000.

## 4. Настройки (`.env`)

| Переменная | По умолчанию | Назначение |
|---|---|---|
| `SECRET_KEY` | `dev-only-insecure-key` | ключ подписи сессий (`serve.py` заменяет автоматически) |
| `DATABASE_PATH` | `instance/asutp.db` | путь к SQLite относительно корня проекта |
| `UPLOAD_FOLDER` | `uploads` | куда сохраняются картинки камер |
| `HOST` | `127.0.0.1` (`serve.py` — `0.0.0.0`) | адрес прослушивания |
| `PORT` | `5000` | порт |
| `DEBUG` | `0` | `1` — режим разработки, `0` — обычный |
| `LOG_DIR` | `logs` | каталог журнала приложения |

Сессия живёт **сутки с момента входа** (`PERMANENT_SESSION_LIFETIME`,
`SESSION_REFRESH_EACH_REQUEST=False`). Продлить её нельзя: после 24 часов
нужно войти заново, после входа откроется та же страница.

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
| Логи | `/Logs.aspx` | `audit_log` (создаётся автоматически) |

Пункт **«Логи»** в верхнем меню доступен всем вошедшим пользователям: журнал
показывает дату и время, пользователя, роль, действие, раздел и подробности.
Фильтры — по пользователю, разделу, действию и периоду дат.

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
│   ├── account.py            # /Account.aspx — смена своего пароля
│   ├── users.py              # /admin/users/ (только admin)
│   ├── audit.py              # журнал действий /Logs.aspx + audit_log
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
│   ├── test_audit.py         # журнал действий и «последнее изменение» (30)
│   ├── test_prolet_minus.py  # отрицательный «Номер пролета» (-1) (18)
│   ├── test_session_and_account.py  # таймаут сессии и смена пароля (21)
│   ├── backup_db.py          # резервная копия БД (и файлов)
│   ├── backup_db.bat         # то же для планировщика заданий
│   └── gen_static_pages.py   # генератор шаблонов статики
├── docs\                     # 00_AUDIT … 06_DEPLOY, 07_STACK (стек, библиотеки, код)
├── vendor\                   # библиотеки Flask/dotenv/waitress/pyodbc (для сервера без pip)
├── logs\                     # журнал приложения app.log (в git не входит)
├── instance\asutp.db         # рабочая БД (в git не входит)
├── App_Data\AsutpDB.mdb      # исходная база Access (не изменяется)
├── run.py                    # режим разработки: python run.py
├── serve.py                  # рабочий режим: waitress
├── start_server.bat          # запуск сервера двойным щелчком
├── install_autostart.bat     # автозапуск при входе в Windows
├── remove_autostart.bat      # удалить автозапуск
├── requirements.txt          # рабочие зависимости (уже в vendor\)
├── requirements-dev.txt      # зависимости для разработки (pyodbc тоже есть в vendor\)
├── .env.example
├── MIGRATION_LOG.md          # журнал всех изменений по этапам
└── (legacy: *.aspx, *.cs, *.htm, *.files, App_Code\, css\, img\, images\, Slegenie\)
```

Оригинальные файлы legacy-сайта остаются в корне проекта без изменений:
они нужны как источник для проверок и как справочник поведения.

## 8. Проверки и тесты

Все сквозные тесты работают через HTTP и требуют запущенного `python run.py`
на `http://127.0.0.1:5000`. Исключение — `test_session_and_account.py`:
он работает внутри процесса (`test_client`), сервер ему не нужен.

```powershell
python tools/verify_db.py          # сверка БД с Access
python tools/smoke_pages.py        # все страницы → 200
python tools/test_stage5_roles.py  # матрица доступа по ролям
python tools/test_audit.py         # журнал действий и «последнее изменение»
python tools/test_prolet_minus.py  # «Номер пролета» = -1 и «Все равно сохранить»
python tools/test_session_and_account.py  # таймаут сессии и смена пароля
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
| `test_audit.py` (журнал действий) | 30 |
| `test_prolet_minus.py` (пролёт -1) | 18 |
| `test_session_and_account.py` (сессия, пароль) | 21 |
| `smoke_pages.py` (все страницы) | 36 |

Тесты создают временных пользователей (`test_viewer`, `test_editor`) и тестовые
записи, затем удаляют их. Итоговое количество строк в БД не меняется
(контроль — `tools/verify_db.py`, 3 880 = 3 880; строки журнала тестов
`test_audit.py` тоже удаляются).

## 9. База данных и резервные копии

* Рабочая БД: `instance/asutp.db` (в git не входит).
* Режим журнала — **WAL** (`asutp.db-wal` / `-shm` рядом с базой, в git не входят).
  Это позволяет 2–3 пользователям работать одновременно без ошибок
  «database is locked».
* Схема: `scripts/schema.sql` — имена таблиц/полей и типы повторяют Access
  (маппинг типов описан в `docs/02_DB.md`).
* Таблица журнала `audit_log` создаётся приложением при старте
  (`CREATE TABLE IF NOT EXISTS`), в миграции Access её нет.
* Резервная копия (корректна и при включённом WAL):

```powershell
python tools\backup_db.py                # только БД → _backup\db\asutp-ГГГГММДД-ЧЧММСС.db
python tools\backup_db.py --with-files   # + uploads\ и Slegenie\
tools\backup_db.bat                      # то же для планировщика, пишет в _backup\logs\backup.log
```

  Хранятся последние 30 копий (`--keep N` — изменить).
* `scripts/migrate_access_to_sqlite.py` **пересоздаёт** базу из Access:
  изменения, сделанные в приложении, будут потеряны — сначала сделайте копию.
* Расписание бэкапов и перенос на сервер — [`docs/06_DEPLOY.md`](docs/06_DEPLOY.md).

## 10. Безопасность

* Сессия — сутки с момента входа, затем повторный вход. Пароль можно сменить
  самому: шапка → «Сменить пароль» (`/Account.aspx`).
* Отладчик Flask на сервере выключен: `serve.py` принудительно ставит `DEBUG=0`,
  значение по умолчанию — тоже `0`.
* `serve.py` не запускается со значением-заглушкой `SECRET_KEY`: генерирует
  случайный ключ и записывает его в `.env`.
* Пароли — PBKDF2-SHA256; в открытом виде не хранятся.
* Все изменяющие формы защищены CSRF-токеном; запрос без токена → `400`.
* SQL — только параметризованный (`?`), без конкатенации пользовательских строк.
* Проверка прав выполняется на сервере для каждого маршрута, независимо от того,
  видна ли кнопка в интерфейсе.
* `SECRET_KEY` и `.env` не коммитятся; в репозитории только `.env.example`.
* Загружаемые картинки камер: проверка расширения и размера (до 4 МБ, как в оригинале).
* `/health` отдаёт только `{"status": "ok"}` — без пути к БД и количества строк.
* Заголовки `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`.
* Приложение рассчитано на **внутреннюю сеть**: HTTPS, блокировка подбора пароля
  и обратный прокси не настроены (при выходе за пределы сети — обязательны).

### Известное ограничение: `UserPass.Pass`

В legacy-таблице `UserPass` поле `Pass` хранит **пароль администратора
в открытом виде** (перенесено из Access как есть, структура и данные не менялись).
Пароль в `users.password_hash` при этом хранится правильно. Пока БД не выходит
за пределы доверенных машин — риск ограничен; при копировании базы на сетевую
папку или в облако значение `Pass` лучше затереть (см. `docs/06_DEPLOY.md`).

## 11. Документация

| Файл | Содержание |
|---|---|
| [`docs/00_AUDIT.md`](docs/00_AUDIT.md) | аудит legacy-проекта |
| [`docs/01_PLAN.md`](docs/01_PLAN.md) | план миграции, карта страниц, DDL |
| [`docs/02_DB.md`](docs/02_DB.md) | сверка Access ↔ SQLite по таблицам |
| [`docs/03_AUTH.md`](docs/03_AUTH.md) | вход, роли, управление пользователями |
| [`docs/04_PAGES.md`](docs/04_PAGES.md) | отчёты по каждой странице и отклонения |
| [`docs/05_FINAL.md`](docs/05_FINAL.md) | итоговая проверка Этапа 5 |
| [`docs/06_DEPLOY.md`](docs/06_DEPLOY.md) | перенос на сервер, `.env`, автозапуск, бэкапы |
| [`MIGRATION_LOG.md`](MIGRATION_LOG.md) | журнал изменений по этапам |

## 12. Частые проблемы

| Симптом | Причина / решение |
|---|---|
| `no such table: users` | не выполнена миграция: `python scripts/migrate_access_to_sqlite.py` |
| `pyodbc.InterfaceError: Data source name not found` | нет драйвера Access — установите «Microsoft Access Database Engine» (нужен только для миграции) |
| Порт 5000 занят | закройте старый процесс или измените `PORT` в `.env` |
| После правки кода ничего не меняется | `DEBUG=0` — перезапустите `start_server.bat` |
| `ModuleNotFoundError: flask` на сервере | не скопирована папка `vendor\` |
| `ImportError` / ошибка `markupsafe` при старте | версия Python не 3.12/3.13 x64 — см. раздел 1 |
| `ModuleNotFoundError: pyodbc` при миграции | Python не 3.12/3.13 x64 (в `vendor\` лежат сборки только под них) |
| Сайт не открывается с другого ПК | `HOST=0.0.0.0` в `.env` + правило брандмауэра для порта 5000 |
| В `.htm` кракозябры | файлы в windows-1251; их нельзя пересохранять в UTF-8 без изменения `<meta charset>` |
| Забыт пароль администратора | создайте нового admin через `python` + `werkzeug.security.generate_password_hash` или восстановите копию БД |
