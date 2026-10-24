-- Схема SQLite для ARM-OMK.
-- СГЕНЕРИРОВАНО tools/gen_schema.py по фактическим атрибутам MS Access.
-- Имена таблиц/полей не изменены. Маппинг: AutoNumber -> INTEGER PRIMARY KEY
-- AUTOINCREMENT, Long Integer -> INTEGER, TEXT(255)/MEMO -> TEXT.
-- Обязательность (NOT NULL) перенесена из свойства Required Access.

PRAGMA foreign_keys = ON;

-- ===== NameShop =====
CREATE TABLE "NameShop" (
    "ShopID" INTEGER PRIMARY KEY AUTOINCREMENT,
    "ShopName" TEXT,
    "Поле1" TEXT
);

-- ===== NameUchastok =====
CREATE TABLE "NameUchastok" (
    "IDUchastok" INTEGER PRIMARY KEY AUTOINCREMENT,
    "Nameuchastka" TEXT,
    "Поле1" TEXT
);

-- ===== NameProlet =====
CREATE TABLE "NameProlet" (
    "ProletID" INTEGER PRIMARY KEY AUTOINCREMENT,
    "ShopID" INTEGER,
    "Prolet" INTEGER,
    "Prolet_name" TEXT
);

-- ===== IPaddress4 =====
CREATE TABLE "IPaddress4" (
    "IDPC" INTEGER PRIMARY KEY AUTOINCREMENT,
    "Prolet" INTEGER,
    "Oc" INTEGER,
    "Uchastok" TEXT,
    "AgeregatName" TEXT,
    "ConfigLogin" TEXT,
    "IPaddress" TEXT,
    "Shluz" TEXT,
    "MAC" TEXT,
    "KE" TEXT,
    "Telephon" TEXT,
    "Opisanie" TEXT,
    "Monitor" TEXT,
    "Printer" TEXT,
    "UPS" TEXT,
    "Modem" TEXT,
    "CISCO" TEXT
);

-- ===== IPaddress5 =====
CREATE TABLE "IPaddress5" (
    "IDPC" INTEGER PRIMARY KEY AUTOINCREMENT,
    "Oc" INTEGER,
    "Uchastok" TEXT,
    "ConfigLogin" TEXT,
    "IPaddress" TEXT,
    "MAC" TEXT,
    "KE" TEXT,
    "Telephon" TEXT,
    "Opisanie" TEXT,
    "Monitor" TEXT,
    "Printer" TEXT,
    "UPS" TEXT,
    "Modem" TEXT,
    "CISCO" TEXT
);

-- ===== IPaddressAll =====
CREATE TABLE "IPaddressAll" (
    "IDPC" INTEGER PRIMARY KEY AUTOINCREMENT,
    "ShopID" INTEGER,
    "Prolet" INTEGER,
    "Oc" INTEGER,
    "Uchastok" TEXT,
    "AgeregatName" TEXT,
    "ConfigLogin" TEXT,
    "IPaddress" TEXT,
    "Shluz" TEXT,
    "MAC" TEXT,
    "KE" TEXT,
    "Telephon" TEXT,
    "Opisanie" TEXT,
    "Monitor" TEXT,
    "Printer" TEXT,
    "UPS" TEXT,
    "Modem" TEXT,
    "CISCO" TEXT
);

-- ===== IPAddressUch =====
CREATE TABLE "IPAddressUch" (
    "IDPC" INTEGER PRIMARY KEY AUTOINCREMENT,
    "IDUchastok" INTEGER,
    "Kabinet" TEXT,
    "Level" INTEGER,
    "ConfigLogin" TEXT,
    "IPaddress" TEXT,
    "MAC" TEXT,
    "KE" TEXT,
    "Telephon" TEXT,
    "Opisanie" TEXT,
    "Monitor" TEXT,
    "Printer" TEXT,
    "UPS" TEXT,
    "Modem" TEXT,
    "CISCO" TEXT,
    FOREIGN KEY ("IDUchastok") REFERENCES "NameUchastok"("IDUchastok")
);

-- ===== Jarlik =====
CREATE TABLE "Jarlik" (
    "IDJarlik" INTEGER PRIMARY KEY AUTOINCREMENT,
    "LnkNameJarlik" TEXT,
    "NameJarlik" TEXT
);

-- ===== SPR_CAMERA =====
CREATE TABLE "SPR_CAMERA" (
    "IDCAM_NAME" INTEGER PRIMARY KEY AUTOINCREMENT,
    "Camera_Type" TEXT NOT NULL,
    "Camera_Name" TEXT
);

-- ===== SPR_CISCO =====
CREATE TABLE "SPR_CISCO" (
    "ID_CISCO" INTEGER PRIMARY KEY AUTOINCREMENT,
    "IP_CISCO" TEXT,
    "Prolet_CISCO" INTEGER,
    "Oc_CISCO" INTEGER,
    "Location_CISCO" TEXT,
    "Opisanie_CISCO" TEXT
);

-- ===== UserPass =====
CREATE TABLE "UserPass" (
    "UserID" INTEGER PRIMARY KEY AUTOINCREMENT,
    "Login" TEXT,
    "Pass" TEXT
);

-- ===== Video_Camera_all =====
CREATE TABLE "Video_Camera_all" (
    "ID_VID_CAM" INTEGER PRIMARY KEY AUTOINCREMENT,
    "IDCAM_NAME" INTEGER,
    "ID_CISCO" INTEGER,
    "Camera_Type" TEXT,
    "ShopID" INTEGER,
    "Prolet" INTEGER,
    "Oc" INTEGER,
    "Uchastok" TEXT,
    "Camera_number" TEXT,
    "IPaddress" TEXT,
    "Login_password" TEXT,
    "IP_Server_PC" TEXT,
    "upload_img" TEXT,
    "Opisanie" TEXT,
    "Monitor" TEXT,
    "Video_out_lacation_PC" TEXT,
    "CISCO" TEXT,
    "Port_CISCO" TEXT,
    "IP_CAMERA_STREAM" TEXT
);

-- ===== telefon =====
CREATE TABLE "telefon" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "fio" TEXT,
    "telnumber" TEXT
);

-- ===== temp =====
CREATE TABLE "temp" (
    "idt" INTEGER PRIMARY KEY AUTOINCREMENT,
    "t" INTEGER
);

-- ===== users (НОВАЯ: аутентификация и роли) =====
CREATE TABLE users (
    user_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    username      TEXT    NOT NULL UNIQUE,
    password_hash TEXT    NOT NULL,
    role          TEXT    NOT NULL CHECK (role IN ('viewer','editor','admin')),
    is_active     INTEGER NOT NULL DEFAULT 1,
    created_at    TEXT    NOT NULL DEFAULT (datetime('now')),
    last_login    TEXT
);

-- ===== Индексы (соответствуют индексам Access) =====
CREATE INDEX IX_IPaddressAll_ShopID     ON "IPaddressAll"("ShopID");
CREATE INDEX IX_Video_Camera_all_ShopID ON "Video_Camera_all"("ShopID");
CREATE INDEX IX_SPR_CAMERA_IDCAM        ON "SPR_CAMERA"("IDCAM_NAME");
CREATE INDEX IX_NameProlet_ShopID       ON "NameProlet"("ShopID");
CREATE INDEX IX_IPAddressUch_IDUchastok ON "IPAddressUch"("IDUchastok");
CREATE INDEX IX_UserPass_Login          ON "UserPass"("Login");
