/* «Операторы, фильтрация, сортировка и ограничение». */

 -- задание 1
/* Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
 *  Заполните их текущими датой и временем.*/
 
UPDATE users 
SET 
created_at = now(), updated_at = now(); 

SELECT * FROM users;

 -- задание 2
/* Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR 
 * и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, 
 * сохранив введённые ранее значения. */
 
 SELECT * FROM users;

-- добавляем в табл две колонки с нужным типом данных
ALTER TABLE users ADD COLUMN new_created_at DATETIME; 
ALTER TABLE users ADD COLUMN new_updated_at DATETIME;

-- SELECT created_at, STR_TO_DATE(created_at, "%d.%m.%Y %k:%i") FROM users;
-- переносим данные, изменив их формат при помощи ф-ии STR_TO_DATE() в созданные колонки
UPDATE users
SET 
  new_created_at = STR_TO_DATE(created_at, "%d.%m.%Y %k:%i"),
  new_updated_at = STR_TO_DATE(updated_at, "%d.%m.%Y %k:%i");
 
-- удаляем колонки created_at, updated_at
ALTER TABLE users 
    DROP created_at, DROP updated_at, 
    RENAME COLUMN new_created_at TO created_at, RENAME COLUMN new_updated_at TO updated_at; -- переименум 
    
     -- задание 3
 /* В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился 
  * и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, 
  * чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей. */
 
SELECT * FROM storehouses_products;

SELECT * FROM storehouses_products
  ORDER BY CASE WHEN value = 0 THEN 2501 ELSE value END;
  
  
  /* «Операторы, фильтрация, сортировка и ограничение» */
  
  -- задание 1. Подсчитайте средний возраст пользователей в таблице users.
SELECT
  ROUND(AVG((TO_DAYS(NOW()) - TO_DAYS(birthday_at))/365.25)) AS average
FROM
  users;
 
/* задание 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
 * Следует учесть, что необходимы дни недели текущего года, а не года рождения.*/
 
SELECT
    DAYNAME(CONCAT(YEAR(NOW()), '-', SUBSTRING(birthday_at, 6, 10))) AS day ,
    COUNT(*) AS total
FROM
    users
GROUP BY 
    day
ORDER BY
	total DESC;
 
