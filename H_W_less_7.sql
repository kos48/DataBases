USE less_7;

/* Задание 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
   Задание 2. Выведите список товаров products и разделов catalogs, который соответствует товару.
   Задание 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов. */

-- Задание 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

SELECT name FROM users
WHERE id IN (SELECT user_id FROM orders);

-- Задание 2. Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT
  p.name AS products_name,
  c.name AS catalogs_name
FROM
  catalogs AS c RIGHT JOIN  products AS p
ON
  c.id = p.catalog_id;

 

