USE vk2;

/* 1. Пусть задан некоторый пользователь.
Найдите человека, который больше всех общался с нашим пользователем, иначе, кто написал пользователю наибольшее число сообщений. (можете взять пользователя с любым id).
(по желанию: можете найти друга, с которым пользователь больше всего общался) */

-- смотрим кто писал пользователю id=1:
SELECT to_user_id , from_user_id 
FROM messages
WHERE to_user_id = 1;

-- сгруппируем
SELECT count(*), from_user_id 
FROM messages
WHERE to_user_id = 1
GROUP BY from_user_id;

-- видим что больше всех писал id = 2, выведем его имя и фамилию
SELECT CONCAT(first_name, ' ', last_name) AS name 
FROM users WHERE id = 2

-- оформим запрос 
SELECT COUNT(*) AS total_messages, 
       from_user_id AS user_id, 
       (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = messages.from_user_id) AS name 
FROM messages 
WHERE to_user_id = 1
GROUP BY from_user_id
LIMIT 1;  -- покажем только верхнюю строку

-- 2. Подсчитать общее количество лайков на посты, которые получили пользователи младше 18 лет.

-- найдем пользователей младше 18 лет:
SELECT user_id, 
       ROUND((TO_DAYS(NOW()) - TO_DAYS(birthday))/365.25) AS age
FROM profiles
WHERE ((TO_DAYS(NOW()) - TO_DAYS(birthday))/365.25) <18;

 -- найдем id постов этих пользователей
SELECT id 
FROM posts
WHERE user_id IN (SELECT user_id FROM profiles
                   WHERE ((TO_DAYS(NOW()) - TO_DAYS(birthday))/365.25) <18);

-- кол-во лайков на эти посты
SELECT count(*) AS total_likes
FROM posts_likes
WHERE post_id IN (SELECT id FROM posts
                  WHERE user_id IN ( SELECT user_id FROM profiles
                                     WHERE like_type = TRUE AND ((TO_DAYS(NOW()) - TO_DAYS(birthday))/365.25) <18));
                                    

-- 3. Определить, кто больше поставил лайков (всего) - мужчины или женщины?

-- все лайки
SELECT user_id FROM posts_likes 
WHERE like_type = TRUE;

-- найдем их пол
SELECT CASE (gender) 
	   WHEN 'f' THEN 'female'
	   WHEN 'm' THEN 'man'
	   WHEN 'x' THEN 'not defined'
	   END AS gender, 
	   count(gender) AS total 
FROM profiles
WHERE user_id IN (SELECT user_id 
                  FROM posts_likes 
                  WHERE like_type = TRUE) AND 
      gender != 'x'  -- оставим тоько женщин и мужчин          
GROUP BY gender;  -- группируем по полу





