# Аудит проекта (Этап 0)

Дата аудита: 2026-10-24 18:43

## Инвентаризация

- Корневой каталог: C:\ARM-OMK
- Мастер-страница: MainMasterPage.master (+.cs) - навигация по разделам
- Аутентификация: Login.aspx (+.cs) - таблица UserPass(Login, Pass), сессия Session["admin"]="admin"
- БД: App_Data\AsutpDB.mdb (MS Access). Подключение через ODBC DSN AsutpDB (см. web.config)
- Бизнес-логика/DAL: App_Code\*.cs (SPR_Camera_DataAccesseLayer.cs, VideoCameraDataAccesseLayer.cs, SPR_Prolet_DAL.cs, AnalogVideoCameraDAL.cs)
- Статика: css\, images\, img\, uploads\, статические .htm

## Структура БД Access (по pyodbc)
