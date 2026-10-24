# Журнал миграции ARM-OMK

Формат записи: дата — этап — что сделано — отклонения/риски.

---

## 2025-10-24 — Подготовка

- Инициализирован git-репозиторий, привязан `origin` → `https://github.com/gusha1gg-lang/ARM.git` (ветка `main`).
- Первый коммит: снимок legacy-проекта (361 файл).
- Создан `AGENTS.md` с правилами работы (правила из `Promt.md` + обязательная синхронизация с GitHub после каждого изменения).
- Добавлен `.gitignore` (bin/obj, `__pycache__`, `.env`, `*.ldb` и т.п.).

---

## Этап 0 — Аудит (2025-10-24)

- Просканирована директория `C:\ARM-OMK`: 40+ `.aspx`, `.cs`, `.master`, `App_Code\*.cs`, `web.config`, `App_Data\AsutpDB.mdb`, статика.
- Инвентаризация страниц, навигации, аутентификации.
- Прочитана структура БД Access (14 пользовательских таблиц, ~3 758 строк).
- Определены точки привязки к Access (ODBC DSN `AsutpDB`, прямые запросы в code-behind).
- Создан `docs/00_AUDIT.md`.

**Отклонений от оригинала нет** (аудит без изменений).

Артефакты: `docs/00_AUDIT.md`, `docs/audit_raw.json`.

---

## Этап 1 — План миграции и архитектура (2025-10-24)

- Выбран стек: **Flask + Jinja2 + SQLite** (обоснование в `docs/01_PLAN.md`, раздел 1).
- Спроектирована структура проекта (`app/`, `scripts/`, `instance/`, `docs/`, `tools/`).
- Составлена карта страниц «старый URL → новый маршрут» с ролями (`docs/01_PLAN.md`, раздел 3).
- Спроектирована схема аутентификации и RBAC: `viewer` / `editor` / `admin`, новая таблица `users`; легаси `UserPass` сохраняется без изменений.
- Получены точные типы полей Access через ADOX (`docs/schema_types.txt`) и первичные ключи/индексы (`docs/schema_keys2.txt`).
- Составлен DDL SQLite 1-в-1 (`docs/01_PLAN.md`, раздел 5): 14 легаси-таблиц + `users` + индексы + реальный FK `IPAddressUch.IDUchastok → NameUchastok.IDUchastok`.
- Определена стратегия миграции данных (pyodbc → sqlite3, явная вставка ID, сброс `sqlite_sequence`) и порядок работ.

### Вынужденные изменения схемы (зафиксировано)

| Было (Access) | Стало (SQLite) | Почему |
|---|---|---|
| `AutoNumber` (Long Integer, автоинкремент) | `INTEGER PRIMARY KEY AUTOINCREMENT` | Технически необходимо для SQLite; ID сохраняются при переносе |
| `Long Integer` NOT NULL | `INTEGER NOT NULL` | Прямой маппинг |
| `TEXT(255)` | `TEXT` | SQLite не требует ограничения длины |
| `MEMO / Long Text` | `TEXT` | Прямой маппинг |
| Имя поля `Поле1` (кириллица) | `"Поле1"` (в кавычках) | Сохранение имени без переименования |

**Переименований таблиц/полей нет. Удалений строк/полей/таблиц нет. «Нормализация» не выполнялась.**

Артефакты: `docs/01_PLAN.md`, `docs/access_schema.json`, `docs/schema_types.txt`, `docs/schema_keys2.txt`.

**Ожидает подтверждения пользователя для перехода к Этапу 2.**

---

## Этап 2 — Каркас проекта и БД (2025-10-24)

### Создан каркас
- `requirements.txt` (Flask, python-dotenv, pyodbc), `.env.example`.
- `app/config.py` — конфиг из `.env`; `app/db.py` — подключение к SQLite; `app/__init__.py` — фабрика приложения + `/health`.
- `run.py` — точка входа.
- Каталоги: `app/routes`, `app/templates`, `app/static`, `scripts`, `tools`, `instance`.
- Резервная копия БД: `_backup/2025-10-24/AsutpDB.mdb` (1 740 800 байт).

### Схема
- `scripts/schema.sql` сгенерирован `tools/gen_schema.py` по фактическим метаданным Access (ADOX + pyodbc).
- 14 легаси-таблиц + новая `users` + 6 индексов + FK `IPAddressUch.IDUchastok → NameUchastok.IDUchastok`.
- Все неключевые поля — nullable, как в Access (свойство `Required` не задано).

### Диагностированная проблема и решение
| Проблема | Причина | Решение |
|---|---|---|
| `NOT NULL constraint failed: SPR_CISCO.Prolet_CISCO` при первой миграции | Неверная трактовка `ADOX Column.Attributes`: `adColNullable = 2` (бит 1), а не 1 | Генератор исправлен: `nullable = bool(attrs & 2)`; DDL перегенерирован |
| `ON CONFLICT` не работает для `sqlite_sequence` | У системной таблицы нет уникального ограничения | Заменено на `DELETE` + `INSERT` |

**Данные не пострадали:** обе ошибки возникали до/после загрузки данных, итоговая миграция выполнена с нуля.

### Миграция данных
- `scripts/migrate_access_to_sqlite.py`: pyodbc → sqlite3, параметризованные вставки, явное сохранение ID, `NULL` сохраняется, сброс `sqlite_sequence`.
- Перенесено **3 880 строк** из 14 таблиц.

### Сверка (`tools/verify_db.py` → `docs/02_DB.md`)
| Проверка | Результат |
|---|---|
| Количество строк (14 таблиц) | ✅ 3880 = 3880 |
| Контрольные суммы (SHA-256 всех строк по PK) | ✅ все совпали |
| 5 случайных строк на таблицу (все поля) | ✅ совпали |
| Количество NULL по каждому полю | ✅ совпало |
| Внешние ключи (`PRAGMA foreign_key_check`) | ✅ нарушений нет |
| Кириллица / UTF-8 | ✅ совпадает |
| Имена и порядок полей | ✅ совпадают |

### Самопроверка запуска
`python run.py` → `GET /health` → `status: ok`, все 14 таблиц + `users` с ожидаемыми количествами.

**Отклонений от оригинала нет. Блокеров нет.**

Артефакты: `scripts/schema.sql`, `scripts/migrate_access_to_sqlite.py`, `tools/gen_schema.py`, `tools/verify_db.py`, `docs/02_DB.md`, `docs/null_diagnostic.txt`.

## Этап 3 — Аутентификация, пользователи, роли (2025-10-24)

### Реализовано
- `app/security.py` — загрузка пользователя в `g.user`, декораторы `login_required`, `roles_required`, `min_role`, CSRF.
- `app/auth.py` — `GET/POST /Login.aspx` (URL сохранён), `POST /logout`. Сообщение об ошибке дословно из оригинала. Защита от open redirect.
- `app/users.py` — `/admin/users/` управление пользователями/ролями (только `admin`).
- `scripts/migrate_legacy_admin.py` — перенос `UserPass` → `users` (роль `admin`), хеш PBKDF2-SHA256, идемпотентен.
- Шаблоны и CSS: `login.html`, `base.html`, `index.html`, `users.html`, `error.html`, `app/static/css/style.css`.

### Роли
| Действие | viewer | editor | admin |
|---|---|---|---|
| Просмотр | ✅ | ✅ | ✅ |
| Редактирование/добавление/удаление (Этап 4) | ❌ | ✅ | ✅ |
| Управление пользователями (`/admin/users`) | ❌ | ❌ | ✅ |

### Миграция легаси-пользователя
`admin` / `11111111` из `UserPass` перенесён в `users` с ролью `admin` (пароль прежний). Рекомендуется сменить пароль.

### Самопроверка
`tools/test_auth.py` — **23/23** пройдено:
- редирект/403, CSRF 400, неверный пароль — оригинальное сообщение без утечек;
- вход/выход, блокировка, смена ролей, запрет самоблокировки и снятия прав у последнего админа;
- защита от дубликатов и слабых паролей.

**Отклонений нет.** `UserPass` не изменён. Новая логика изолирована в `users`.

Артефакты: `app/security.py`, `app/auth.py`, `app/users.py`, `scripts/migrate_legacy_admin.py`, `app/templates/*`, `app/static/css/style.css`, `tools/test_auth.py`, `docs/03_AUTH.md`.

**Этап 3 завершён, подтверждение получено.**

---

## Этап 4 — Перенос страниц, партия 1: раздел «ТЭСК ТБД» (2025-10-24)

### Перенесено
| Старый URL | Маршрут | Исходник | Таблицы |
|---|---|---|---|
| `/main.aspx` | `/main.aspx` | `main.aspx.cs` | `IPaddress4` |
| `/Addipt4.aspx` | `/Addipt4.aspx` | `Addipt4.aspx.cs` | `IPaddress4` (INSERT) |
| `/Edit.aspx?id=N` | `/Edit.aspx?id=N` | `Edit.aspx.cs` | `IPaddress4` (UPDATE/DELETE) |
| `/ReportExist.aspx?KE=…` | `/ReportExist.aspx?KE=…` | `ReportExist.aspx.cs` | `IPaddress4`, `IPAddressUch`, `IPaddress5`, `NameUchastok` |

Модуль: `app/ipaddr4.py`. Шаблоны: `main.html`, `ipaddr4_form.html`, `report.html`.

### Сохранено 1-в-1
- Список пролётов (9 значений) и их подписи; сортировка `Prolet, Oc, Uchastok, AgeregatName`.
- Групповые строки «Пролет №: N» (`#20B2AA`) и участка (`#C1CDC1`); чередование строк `#e6e6fa`/`#e0ffff`.
- 13 колонок таблицы, порядок и подсказки; всплывающая подсказка CISCO с `Opisanie`.
- Все 16 полей формы, их подписи и порядок; многострочное «Описание».
- Валидаторы Prolet/Oc и предупреждения о дубликатах `KE`/`Monitor`/`Printer` с текстом оригинала.
- Кнопка «Все равно сохранить» при срабатывании проверок.
- URL и переходы: после сохранения/удаления — `/main.aspx`, поиск — `/ReportExist.aspx?KE=…`.

### Восстановлена навигация
`MainMasterPage.master` → `app/templates/base.html`: баннер `img/KPK.jpg` и меню
(Рабочие места, Все ярлыки, Настройки, CISCO, Телефоны, Web Navigator, Видеонаблюдение)
с теми же названиями, вложенностью и порядком. Оригинальные `img/` и `css/` отдаются как есть
(маршруты `/img/...`, `/css/...`), файлы не копировались и не изменялись.

### Отклонения (осознанные, обоснованы)
| № | Отклонение | Причина |
|---|---|---|
| 1 | «Добавить» и редактирование доступны `editor` и `admin` (в оригинале — только админ) | Требование ролей Этапа 3 |
| 2 | Параметризованный SQL вместо конкатенации | Безопасность |
| 3 | CSRF-токены в формах | Безопасность |
| 4 | Подтверждение удаления (`confirm`) | Защита от случайного удаления |
| 5 | При «Все равно сохранить» нечисловые Prolet/Oc отклоняются | В оригинале — ошибка ODBC |
| 6 | CSS-классы вместо inline-стилей ASP.NET, меню на CSS | Адаптивность; цвета и структура сохранены |

### Самопроверка
`tools/test_pages.py` — **38/38**: права viewer/editor/admin, CSRF, валидация, добавление,
фильтр по пролёту, редактирование, дубликаты, принудительное сохранение, поиск КЕ, удаление, 404.
Количество строк `IPaddress4` после тестов — **842** (совпадает с миграцией).

Артефакты: `app/ipaddr4.py`, `app/templates/main.html`, `app/templates/ipaddr4_form.html`,
`app/templates/report.html`, `app/templates/base.html`, `app/static/css/style.css`,
`tools/test_pages.py`, `docs/04_PAGES.md`.

**Ожидает подтверждения пользователя перед следующей партией страниц.**
