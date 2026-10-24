# Аудит проекта (Этап 0)

Дата аудита: 2025-10-24

## 1. Инвентаризация файлов

**Корневой каталог:** `C:\ARM-OMK`

Ключевые файлы:
- **Мастер-страница:** `MainMasterPage.master`, `MainMasterPage.master.cs` - единый шаблон, навигация по сайту
- **Авторизация:** `Login.aspx`, `Login.aspx.cs` - вход по таблице `UserPass`, при успешной авторизации в сессии проставляется `Session["admin"] = "admin"`
- **Конфигурация:** `web.config` (ASP.NET 2.0/3.5, подключение через ODBC DSN `AsutpDB` к `App_Data\AsutpDB.mdb`)
- **БД:** `App_Data\AsutpDB.mdb` (MS Access)
- **Бизнес-логика/DAL:** `App_Code\*.cs` (`SPR_Camera_DataAccesseLayer.cs`, `VideoCameraDataAccesseLayer.cs`, `SPR_Prolet_DAL.cs`, `AnalogVideoCameraDAL.cs`)
- **Статика:** `css\`, `images\`, `img\`, `uploads\`

## 2. Структура страниц

Основные страницы (по навигации и файлам):
- `main.aspx` - ТЭСК ТБД (основной справочник АРМ)
- `IpaddrT5.aspx` - ТЭСЦ 5
- `IPaddrUch.aspx` - АБК
- `IPaddrALL.aspx` - Все цеха
- `JR.aspx` - Все ярлыки
- `telefon.aspx` - Телефоны
- `CISCO.aspx`, `CISCO2.aspx` - Справочники CISCO
- `SPR_CISCO.aspx` - Справочник камер/CISCO (используется с параметром `SPRType`)
- `spr_shop.aspx` - Справочник цехов
- `Webnav.aspx` - Web Navigator
- `VideoIP.aspx`, `VideoAnalog.aspx` - Видеонаблюдение
- `ReportExist.aspx` - Поиск КЕ
- Страницы добавления/редактирования: `Add*.aspx`, `Edit*.aspx`
- Настройки/инструкции: `Nastroyka*.aspx`, `Nastoika*.aspx`, `*.htm`

## 3. Структура БД Access

| Таблица | Кол-во строк | Поля |
|---|---|---|
| `IPAddressUch` | 1733 | IDPC, IDUchastok, Kabinet, Level, ConfigLogin, IPaddress, MAC, KE, Telephon, Opisanie, Monitor, Printer, UPS, Modem, CISCO |
| `IPaddress4` | 842 | IDPC, Prolet, Oc, Uchastok, AgeregatName, ConfigLogin, IPaddress, Shluz, MAC, KE, Telephon, Opisanie, Monitor, Printer, UPS, Modem, CISCO |
| `IPaddress5` | 384 | IDPC, Oc, Uchastok, ConfigLogin, IPaddress, MAC, KE, Telephon, Opisanie, Monitor, Printer, UPS, Modem, CISCO |
| `IPaddressAll` | 542 | IDPC, ShopID, Prolet, Oc, Uchastok, AgeregatName, ConfigLogin, IPaddress, Shluz, MAC, KE, Telephon, Opisanie, Monitor, Printer, UPS, Modem, CISCO |
| `Jarlik` | 27 | IDJarlik, LnkNameJarlik, NameJarlik |
| `NameProlet` | 33 | ProletID, ShopID, Prolet, Prolet_name |
| `NameShop` | 12 | ShopID, ShopName, ??? |
| `NameUchastok` | 29 | IDUchastok, Nameuchastka, ??? |
| `SPR_CAMERA` | 21 | IDCAM_NAME, Camera_Type, Camera_Name |
| `SPR_CISCO` | 93 | ID_CISCO, IP_CISCO, Prolet_CISCO, Oc_CISCO, Location_CISCO, Opisanie_CISCO |
| `UserPass` | 1 | UserID, Login, Pass |
| `Video_Camera_all` | 117 | ID_VID_CAM, IDCAM_NAME, ID_CISCO, Camera_Type, ShopID, Prolet, Oc, Uchastok, Camera_number, IPaddress, Login_password, IP_Server_PC, upload_img, Opisanie, Monitor, Video_out_lacation_PC, CISCO, Port_CISCO, IP_CAMERA_STREAM |
| `telefon` | 44 | id, fio, telnumber |
| `temp` | 2 | idt, t |

## 4. Точки привязки к Access

- `web.config` - `connectionStrings` с ODBC к `AsutpDB`
- `Login.aspx.cs` - прямой ODBC-запрос к `UserPass` для авторизации
- `main.aspx.cs` - прямые ODBC-запросы к `IPaddress4`, фильтрация по пролётам, вывод таблицей
- Прочие `.aspx.cs` страницы - работают через ODBC к соответствующим таблицам
- `App_Code/*.cs` - DAL-классы для работы со справочниками/камер

## 5. Текущая аутентификация

- Модель: простая сессия
- Проверка: `SELECT UserID FROM UserPass WHERE Login=... AND Pass=...`
- При успехе: `Session["admin"] = "admin"`
- При неуспехе: сессия обнуляется
- Доступ к редактированию/справочникам частично ограничен проверкой `Session["admin"] == "admin"`

## 6. Рекомендация по стеку (для миграции)

- **Backend:** Flask (проще для поэтапного переноса WebForms-логики, меньше "магии", предсказуемее для миграции)
- **БД:** SQLite - **строго 1-в-1** копирование структуры и данных из MS Access (без переименований/удалений/нормализации). Только технически необходимый маппинг типов с фиксацией в `MIGRATION_LOG.md`
- **Аутентификация:** Flask-сессии + хеширование паролей (werkzeug/PBKDF2)
- **Роли:** `viewer` / `editor` / `admin` (RBAC). Существующего пользователя из `UserPass` мигрировать в `users` с ролью `admin`
- **Фронтенд:** сохранить структуру страниц, навигацию и расположение блоков. Визуально аккуратно улучшить CSS при необходимости с фиксацией отклонений

## Статус Этапа 0
**Выполнен.** Ожидаю подтверждения для перехода к **Этапу 1. План миграции и архитектура**.
