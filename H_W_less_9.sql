/*Практическое задание по теме “Транзакции, переменные, представления”*/

/* Задание 1:	В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
 * Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции. */

START TRANSACTION;

INSERT INTO sample.users SELECT * FROM shop.users 
WHERE id = 1;

COMMIT;

SELECT * FROM sample.users;
SELECT * FROM shop.users;

/*2.	Создайте представление, которое выводит название name товарной позиции из таблицы products и 
 * соответствующее название каталога name из таблицы catalogs. */

USE shop;
-- таблица для представления:
-- SELECT prod.id AS prod_id, prod.name, cat.name
-- FROM products AS prod
-- LEFT JOIN catalogs AS cat 
-- ON prod.catalog_id = cat.id;

CREATE OR REPLACE VIEW name_prod_catalog(prod_id, prod_name, cat_name) AS
SELECT prod.id AS prod_id, prod.name, cat.name
FROM products AS prod
LEFT JOIN catalogs AS cat 
ON prod.catalog_id = cat.id;

SELECT * FROM name_prod_catalog;

/* Практическое задание по теме “Администрирование MySQL” (эта тема изучается по вашему желанию) */

/* Задание 1.	Создайте двух пользователей которые имеют доступ к базе данных shop. 
 * Первому пользователю shop_read должны быть доступны только запросы на чтение данных, 
 * второму пользователю shop — любые операции в пределах базы данных shop. */

-- первый пользователь
DROP USER IF EXISTS 'shop'@'localhost';
CREATE USER 'shop'@'localhost' IDENTIFIED WITH sha256_password BY '123456';
GRANT ALL ON shop.* TO 'shop'@'localhost';
GRANT GRANT OPTION ON shop.* TO 'shop'@'localhost';


-- второй пользователь
DROP USER IF EXISTS 'shop'@'localhost';
CREATE USER 'shop'@'localhost' IDENTIFIED WITH sha256_password BY '123456';
GRANT ALL ON shop.* TO 'shop'@'localhost';
GRANT GRANT OPTION ON shop.* TO 'shop'@'localhost';

/* Практическое задание по теме “Хранимые процедуры и функции, триггеры" */

/* Задание 1.	Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
 * С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
 * с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
 * с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи". */
use shop ;
delimiter //

DROP FUNCTION IF EXISTS hello //
CREATE FUNCTION hello ()
RETURNS TINYTEXT DETERMINISTIC
BEGIN
	DECLARE this_time tinytext;
	SET this_time = time(NOW());
	CASE
		WHEN this_time BETWEEN '06:00:00' AND '12:00:01' THEN RETURN "Доброе утро";
		WHEN this_time BETWEEN '12:00:00' AND '18:00:00' THEN RETURN "Добрый день";
		WHEN this_time BETWEEN '18:00:01' AND '23:59:59' THEN RETURN "Добрый вечер";
		WHEN this_time BETWEEN '00:00:00' AND '05:59:59' THEN RETURN "Доброй ночи";
	END CASE;
END//
 
SELECT hello()//

/* задание 2.   В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
 * Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
 * Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
 * При попытке присвоить полям NULL-значение необходимо отменить операцию. */

drop trigger if exists my_trigger_les_9//
CREATE TRIGGER my_trigger_les_9 BEFORE INSERT ON products
FOR EACH ROW BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Нельзя чтобы оба поля(name, description) были NULL';
	END IF;
END//


