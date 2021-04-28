USE shoop;

/*1.	Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и 
products в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.*/
-- создадим таблицу logs, тип Archive

DROP TABLE IF EXISTS logs;

CREATE TABLE logs (
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    table_name VARCHAR(20) NOT NULL,
    id_prim_key BIGINT UNSIGNED NOT NULL,
    name_value VARCHAR(45) NOT NULL
    )ENGINE = ARCHIVE;

-- триггер для таблицы users
DROP TRIGGER IF EXISTS log_entry_users;
delimiter //
CREATE TRIGGER log_entry_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name, id_prim_key, name_value)
	VALUES ('users', NEW.id, NEW.name);
END //
delimiter ;

SELECT * FROM users;
SELECT * FROM logs;

-- добавляем пользователя
INSERT INTO users (name, birthday_at)
VALUES ('test_user', '1900-01-01');

SELECT * FROM users;
SELECT * FROM logs;

-- триггер для таблицы catalogs
DROP TRIGGER IF EXISTS log_entry_catalogs;
delimiter //
CREATE TRIGGER log_entry_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name, id_prim_key, name_value)
	VALUES ('catalogs', NEW.id, NEW.name);
END //
delimiter ;

SELECT * FROM catalogs;
SELECT * FROM logs;

-- добавим данные в таблицу
INSERT INTO catalogs (name)
VALUES ('Куллера'),
		('Аксессуары');

SELECT * FROM catalogs;
SELECT * FROM logs;

-- триггер для таблицы products
DROP TRIGGER IF EXISTS log_entry_products;
delimiter //
CREATE TRIGGER log_entry_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name, id_prim_key, name_value)
	VALUES ('products', NEW.id, NEW.name);
END //
delimiter ;

SELECT * FROM products;
SELECT * FROM logs;

-- добавляем данные в таблицу
INSERT INTO products (name, description, price, catalog_id)
VALUES ('MEMORY', 'Оперативная память', 3000.00, 13);

SELECT * FROM products;
SELECT * FROM logs;

    