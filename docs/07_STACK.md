# 07. Стек: какими технологиями и кодом сделан сайт и БД

Документ фиксирует **весь использованный код и компоненты**: языки, библиотеки
с версиями и лицензиями, структуру кода, устройство базы данных и механизмы
безопасности. Нужен, чтобы можно было показать состав проекта (например,
службе ИБ) без чтения исходников.

Актуально на 2026-10-28. Проверено на Python 3.13.0 и 3.12.10 x64, Windows 11.

---

## 1. Кратко

Сайт — это **одно локальное приложение на Python** (Flask), которое отдаёт
HTML-страницы и работает с **одним файлом базы SQLite**. Внешних сервисов,
облаков, отдельных серверов БД и сборки фронтенда нет: всё запускается одной
командой на самой машине.

| Слой | Технология |
|---|---|
| Серверная логика | Python 3.12 / 3.13 (x64), Flask 3.1.3 |
| Шаблоны страниц | Jinja2 3.1.6 (HTML + серверная подстановка) |
| Стили | CSS (один файл `app/static/css/style.css`, 883 строки) |
| Скрипты в браузере | JavaScript (чистый, без библиотек; ~40 строк в `base.html`) |
| База данных | SQLite 3 (модуль `sqlite3` из стандартной библиотеки Python; локально — 3.45.3) |
| Рабочий HTTP-сервер | waitress 3.0.2 |
| Доступ к Access (только миграция) | pyodbc 5.3.0 + драйвер Microsoft Access |

---

## 2. Языки и их доля в коде

| Язык | Где | Объём |
|---|---|---|
| Python | `app/`, `serve.py`, `run.py` | ~3 700 строк (19 модулей) |
| HTML + Jinja2 | `app/templates/` | 25 шаблонов, ~7 750 строк |
| CSS | `app/static/css/style.css` | 883 строки |
| JavaScript | `app/templates/base.html` (кнопка «Наверх»), атрибуты `onclick="return confirm(...)"` | ~20 строк |
| SQL | `scripts/schema.sql` (DDL) + запросы в коде | 15 таблиц |

Других языков нет: ни C#/ASP.NET (это legacy-версия), ни Node.js, ни PHP.

---

## 3. Библиотеки

Все сторонние библиотеки лежат **внутри проекта** в папке `vendor/`
(5,4 МБ), поэтому на сервере `pip install` не требуется. Скачаны с PyPI как
обычные wheel-пакеты без изменений, ставятся только на `sys.path`
(`app/__init__.py`, первая строка до `import flask`).

| Пакет | Версия | Лицензия | Зачем |
|---|---|---|---|
| Flask | 3.1.3 | BSD-3-Clause | веб-фреймворк: маршруты, сессии, шаблоны |
| Werkzeug | 3.1.9 | BSD-3-Clause | WSGI-утилиты, хеширование паролей (PBKDF2) |
| Jinja2 | 3.1.6 | BSD-3-Clause | шаблонизатор |
| MarkupSafe | 3.0.4 | BSD-3-Clause | экранирование HTML в шаблонах |
| click | 8.5.0 | BSD-3-Clause | зависимость Flask (CLI) |
| itsdangerous | 2.2.0 | BSD-3-Clause | подпись cookie сессии |
| blinker | 1.9.0 | MIT | сигналы Flask |
| python-dotenv | 1.2.4 | BSD-3-Clause | чтение `.env` |
| waitress | 3.0.2 | ZPL 2.1 | многопоточный HTTP-сервер для эксплуатации |
| pyodbc | 5.3.0 | MIT | чтение `AsutpDB.mdb` **только при миграции** |

Тексты лицензий — в `vendor/<пакет>.dist-info/licenses/` (файл `LICENSE.txt`).
Контрольные суммы файлов — в `vendor/<пакет>.dist-info/RECORD`.

Бинарные части (только они зависят от версии Python):

| Файл | Для чего |
|---|---|
| `vendor/markupsafe/_speedups.cp313-win_amd64.pyd` | ускоренное экранирование; на Python 3.12 не загружается, берётся чистый Python |
| `vendor/pyodbc.cp312-win_amd64.pyd` | pyodbc для Python 3.12 |
| `vendor/pyodbc.cp313-win_amd64.pyd` | pyodbc для Python 3.13 |

---

## 4. Стандартная библиотека Python (без установки)

`sqlite3` (БД), `os`, `sys`, `pathlib`, `re`, `datetime`, `time`, `math`,
`hmac`, `hashlib`, `secrets`, `logging`, `logging.handlers`, `functools`,
`json`, `io`, `shutil`, `urllib`, `argparse`, `http`.

Сторонние ORM (SQLAlchemy, Django ORM) **не используются** — только прямые
SQL-запросы через `sqlite3` с параметрами (`?`).

---

## 5. Устройство кода

| Файл | Строк | Назначение |
|---|---|---|
| `serve.py` | 138 | запуск «как на сервере»: waitress, `.env`, `SECRET_KEY`, `DEBUG=0` |
| `run.py` | 8 | запуск для разработки (отладочный сервер Flask) |
| `app/__init__.py` | 178 | сборка приложения, `vendor/` в `sys.path`, WAL, журнал, `/health`, обработчик 500 |
| `app/config.py` | 46 | настройки из `.env`, срок сессии 1 сутки, пути |
| `app/db.py` | 28 | подключение к SQLite (`busy_timeout`, row_factory) |
| `app/security.py` | 124 | вход/сессия, истечение суток, проверка ролей, CSRF |
| `app/auth.py` | 90 | `/Login.aspx`, `/Logout.aspx` |
| `app/account.py` | 64 | `/Account.aspx` — смена своего пароля |
| `app/users.py` | 185 | управление пользователями (только admin) |
| `app/audit.py` | 278 | журнал действий `audit_log`, «Последнее изменение», «Логи» |
| `app/ipaddr4.py` | 407 | «Рабочие места → ТЭСК ТБД» |
| `app/ipaddr5.py` | 269 | «ТЭСЦ 5» |
| `app/ipaddr_uch.py` | 320 | «АБК» |
| `app/ipaddr_all.py` | 376 | «Все цеха» |
| `app/ip_shared.py` | 41 | общая логика этих четырёх разделов |
| `app/jarlik.py` | 165 | «Все ярлыки» + скачивание `.lnk` |
| `app/telefon.py` | 128 | «Телефоны» |
| `app/cisco.py` | 25 | «CISCO» |
| `app/spr.py` | 392 | справочники цехов/камер/CISCO |
| `app/video.py` | 465 | «Видеонаблюдение» (IP и аналог) |
| `app/static_pages.py` | 104 | отдача legacy `.htm` и файлов из `uploads/`, `Slegenie/` |

Служебные (на сервер не копируются): `scripts/` — миграция Access → SQLite,
`tools/` — 15 наборов тестов и сверка БД, `docs/` — эта документация.

---

## 6. База данных

* СУБД: **SQLite 3** (файл, без сервера и без пароля; доступ — правами NTFS).
* Файл: `instance/asutp.db` (~780 КБ), режим **WAL**, `busy_timeout=5000`.
* Схема: `scripts/schema.sql`. Имена таблиц и полей **совпадают с MS Access**.
* Типы: `AutoNumber → INTEGER PRIMARY KEY AUTOINCREMENT`,
  `Long Integer → INTEGER`, `TEXT(n)/MEMO → TEXT`, `DateTime → TEXT`,
  `Yes/No → INTEGER`, `NULL` сохраняется как `NULL`.
* Связи проверяются `PRAGMA foreign_key_check` (`tools/verify_db.py`).

| Таблица | Строк | Полей | Что хранит |
|---|---|---|---|
| `IPAddressUch` | 1733 | 15 | рабочие места АБК |
| `IPaddress4` | 842 | 17 | рабочие места ТЭСК ТБД |
| `IPaddressAll` | 542 | 18 | все цеха |
| `IPaddress5` | 384 | 14 | ТЭСЦ 5 |
| `Video_Camera_all` | 117 | 19 | камеры видеонаблюдения |
| `SPR_CISCO` | 93 | 6 | справочник CISCO |
| `telefon` | 44 | 3 | телефоны |
| `NameProlet` | 33 | 4 | пролёты |
| `NameUchastok` | 29 | 3 | участки |
| `Jarlik` | 27 | 3 | ярлыки |
| `SPR_CAMERA` | 21 | 3 | справочник камер |
| `NameShop` | 12 | 3 | цеха |
| `temp` | 2 | 2 | служебная таблица legacy |
| `UserPass` | 1 | 3 | старый пользователь (перенесён в `users`) |
| `users` | 2 | 7 | пользователи сайта и роли (новая) |
| `audit_log` | — | 10 | журнал действий (создаётся приложением) |

Итого 3 880 строк в 14 legacy-таблицах — столько же, сколько в `AsutpDB.mdb`
(сверка: `docs/02_DB.md`).

---

## 7. Безопасность и разграничение доступа

| Механизм | Реализация |
|---|---|
| Пароли | PBKDF2-SHA256 (`werkzeug.security`), соль на пользователя, в БД только хеш |
| Сессия | подписанная cookie (`itsdangerous`, ключ `SECRET_KEY` из `.env`), 1 сутки с момента входа |
| Роли | `viewer` (просмотр) / `editor` (правка данных) / `admin` (пользователи, роли, всё остальное) |
| Проверка прав | декораторы на каждом маршруте (`app/security.py`) |
| CSRF | скрытое поле `_csrf` во всех POST-формах |
| SQL-инъекции | только параметризованные запросы (`?`), конкатенации значений нет |
| XSS | автоэкранирование Jinja2 (`MarkupSafe`) |
| Журналирование | `logs/app.log` (1 МБ × 5 файлов) + таблица `audit_log` (кто, что, когда) |
| Заголовки | `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy` |
| Внешний доступ | нет: наружу ничего не отправляется, телеметрии и лицензионных серверов нет |

HTTPS, reverse proxy и защита от перебора паролей **не включены** — по
согласованию, сайт работает только в локальной сети.

---

## 8. Что НЕ используется

Django, SQLAlchemy/ORM, Node.js, npm, jQuery, Bootstrap, React/Vue, CDN,
внешние шрифты, Google Analytics/любая телеметрия, MySQL/PostgreSQL,
Docker, IIS, .NET, COM-компоненты в рабочем коде (`win32com` применён только
в служебном генераторе legacy-страниц `tools/gen_static_pages.py`).

Все ссылки `http://…` в шаблонах — это пункты меню на внутренние ресурсы
предприятия (portal.vsw.ru, nms.vsw.ru), а не подключаемые скрипты.

---

## 9. Как проверить состав библиотек

```powershell
# список установленных версий
Get-ChildItem C:\ARM-OMK\vendor -Directory -Filter *.dist-info | Select-Object Name

# лицензии
Get-ChildItem C:\ARM-OMK\vendor -Recurse -Filter LICENSE.txt | Select-Object FullName

# контрольные суммы файлов пакета
Get-Content C:\ARM-OMK\vendor\flask-3.1.3.dist-info\RECORD
```

Скачать те же версии заново (на машине, где разрешён pip):

```powershell
pip download --no-deps -d wheels Flask==3.1.3 Werkzeug==3.1.9 Jinja2==3.1.6 `
  MarkupSafe==3.0.4 click==8.5.0 itsdangerous==2.2.0 blinker==1.9.0 `
  python-dotenv==1.2.4 waitress==3.0.2 pyodbc==5.3.0
```

Сверка с `vendor/` подтверждает, что код библиотек не изменялся.

---

## 10. Обновление библиотек

1. На машине с интернетом: `pip install --target C:\ARM-OMK\vendor --upgrade -r requirements-dev.txt`
   **той же версией Python**, что на сервере (3.12 или 3.13, x64).
2. Скопировать `vendor/` на сервер.
3. Прогнать тесты: `python tools/test_pages.py`, `tools/test_auth.py`,
   `tools/test_stage5_roles.py` и остальные (см. README, раздел 8).
4. Записать изменение версии в `MIGRATION_LOG.md`.

---

## Связанные документы

`docs/00_AUDIT.md` — аудит legacy-сайта, `docs/01_PLAN.md` — план миграции,
`docs/02_DB.md` — сверка БД Access ↔ SQLite, `docs/03_AUTH.md` — роли и
пользователи, `docs/04_PAGES.md` — страницы, `docs/05_FINAL.md` — итоги,
`docs/06_DEPLOY.md` — перенос на сервер, `MIGRATION_LOG.md` — журнал изменений.
