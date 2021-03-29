-- task 2
/* Создайте базу данных example, разместите в ней таблицу users,
 состоящую из двух столбцов, числового id и строкового name */
 DROP DATABASE IF EXISTS example;
 create database example;
 USE example;
 DROP TABLE IF EXISTS users;
 CREATE TABLE users (
 id INT, 
 name char);

-- task 3
 /*Создайте дамп базы данных example из предыдущего задания,
 разверните содержимое дампа в новую базу данных sample.*/
-- Переходим в консоль:
/*
mysqldump example > example.sql --перенаправляем дамп в файл
mysql
CREATE DATABASE sample;  -- создаем базу данных sample
exit
mysql sample < example.sql  -- разворачиваем дамп в базе sample
*/




