DROP DATABASE IF EXISTS arcade_mania_datas;

CREATE DATABASE IF NOT EXISTS arcade_mania_datas
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_hungarian_ci;

USE arcade_mania_datas;

-- ------------------------------------------------------
-- users tábla
-- ------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id            CHAR(36)       NOT NULL,     -- GUID (C# Guid)
    user_name     VARCHAR(100)   NOT NULL,
    password_hash CHAR(255)      NOT NULL,     -- Visszafejthető titkosított jelszó
    role          VARCHAR(20)    NOT NULL DEFAULT 'User', -- 'User' vagy 'Admin'
    PRIMARY KEY (id),
    UNIQUE KEY uq_users_user_name (user_name),
    KEY idx_users_role (role)
);

-- ------------------------------------------------------
-- games tábla (GUID azonosítóval)
-- ------------------------------------------------------
CREATE TABLE IF NOT EXISTS games (
    id    CHAR(36)      NOT NULL, -- GUID
    name  VARCHAR(100)  NOT NULL,
    PRIMARY KEY (id)
);

-- ------------------------------------------------------
-- user_high_scores kapcsolótábla
-- ------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_high_scores (
    user_id    CHAR(36)        NOT NULL,  -- GUID → users.id
    game_id    CHAR(36)        NOT NULL,  -- GUID → games.id
    high_score INT UNSIGNED    NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id, game_id),
    CONSTRAINT fk_user_high_scores_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_user_high_scores_game
        FOREIGN KEY (game_id) REFERENCES games(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- Játékok (fix játék ID-k, ne változtassuk meg őket, fontos hogy ezek az ID-k legyenek)
INSERT INTO games (id, name)
VALUES
('dd4c7870-d2a4-11f0-906c-fc5cee8cf808', 'Fighter'),
('dd4c8625-d2a4-11f0-906c-fc5cee8cf808', 'Memory'),
('dd4c8740-d2a4-11f0-906c-fc5cee8cf808', 'Snake');

-- User hozzáadása admin szerepkörrel, felhasználónév: "admin", jelszó: "admin"
INSERT INTO users (id, user_name, password_hash, role)
VALUES
('dd744019-41ef-46ab-9795-9fe5ce9266bc', 'admin', '/RQwb12wid86pG2YeLlU8Q==', 'Admin');

-- A felhasználóhoz tartozó adatok, amit adott esetben a rendszer magától hozna létre
INSERT INTO user_high_scores (user_id, game_id, high_score)
VALUES
('dd744019-41ef-46ab-9795-9fe5ce9266bc', 'dd4c7870-d2a4-11f0-906c-fc5cee8cf808', 0),
('dd744019-41ef-46ab-9795-9fe5ce9266bc', 'dd4c8625-d2a4-11f0-906c-fc5cee8cf808', 0),
('dd744019-41ef-46ab-9795-9fe5ce9266bc', 'dd4c8740-d2a4-11f0-906c-fc5cee8cf808', 0);


-- Role frissítése ha szükséges
-- UPDATE users
-- SET role = "Admin" -- vagy "User"
-- WHERE user_name = '<user neve>';


-- ------------------------------------------------------
-- Példa adatok
-- ------------------------------------------------------

-- Felhasználók
-- INSERT INTO users (id, user_name, password_hash, role)
-- VALUES
-- (UUID(), 'Player1', '<aes_encrypted_password>', 'User'),
-- (UUID(), 'Admin1',  '<aes_encrypted_password>', 'Admin');

-- High score-ok
-- INSERT INTO user_high_scores (user_id, game_id, high_score)
-- VALUES
-- ('<Player1_GUID>', '<Snake_GUID>', 1200);
