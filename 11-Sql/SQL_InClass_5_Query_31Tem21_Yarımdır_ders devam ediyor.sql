------------- 2021-7-31 DAwSQL Session 5 (Data Functions) --------------------


-- �NCEK� DERS KONUSUNDAN B�R SORU �LE BA�LIYORUZ:

-- List customer who bought both 'Electric Bikes' and 'Comfort Bicycles' and 'Children Bicycles' in the same order.


-- �nce istenen kategorilerden elektric bikes'a bir bakal�m.
select category_id
from production.categories
where category_name = 'Electric Bikes' 

-- category_id products tablosunda oldu�undan join i�in products'a gitmem gerek.
	-- order lara ula�mam gerekti�inden product_id �zerinden order_items'a gitmem gerekecek.
SELECT B.order_id
FROM production.products A, sales.order_items B
WHERE A.product_id = B.product_id
AND   A.category_id = (

					select category_id
					from production.categories
					where category_name = 'Electric Bikes'
					)

INTERSECT

SELECT B.order_id
FROM production.products A, sales.order_items B
WHERE A.product_id = B.product_id
AND   A.category_id = (

					select category_id
					from production.categories
					where category_name = 'Comfort Bicycles'
					)

INTERSECT

SELECT B.order_id
FROM production.products A, sales.order_items B
WHERE A.product_id = B.product_id
AND   A.category_id = (

					select category_id
					from production.categories
					where category_name = 'Children Bicycles'
					)

-- order_id'lere ula�t�m. bizden customerlar� istiyordu. 
	-- yukardaki query sonucunda gelen order_id leri subquery yap�yorum ve bu id leri sipari� veren customerlara ula��yorum

SELECT	A.customer_id, A.first_name, A.last_name
FROM	sales.customers A, sales.orders B
WHERE	A.customer_id = B.customer_id
AND		B.order_id IN (
						SELECT B.order_id
						FROM production.products A, sales.order_items B
						WHERE A.product_id = B.product_id
						AND   A.category_id = (

											select category_id
											from production.categories
											where category_name = 'Electric Bikes'
											)

						INTERSECT

						SELECT B.order_id
						FROM production.products A, sales.order_items B
						WHERE A.product_id = B.product_id
						AND   A.category_id = (

											select category_id
											from production.categories
											where category_name = 'Comfort Bicycles'
											)

						INTERSECT

						SELECT B.order_id
						FROM production.products A, sales.order_items B
						WHERE A.product_id = B.product_id
						AND   A.category_id = (

											select category_id
											from production.categories
											where category_name = 'Children Bicycles'
											)
											)



------------------------		DATE FUNCTIONS		-----------------------

CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset )


SELECT *
FROM t_date_time

-- INSERT VALUES TO THE TABLE

INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES
('12:00:00', '2021-07-17', '2021-07-17', '2021-07-17', '2021-07-17', '2021-07-17')

SELECT * 
FROM t_date_time
-- girilen value lar� s�tunlar�n (tablo olu�turulurken tan�mlanan) date ve datetime tiplerine otomatik olarak �evirdi.


----------------------------------
		-- TIMEFROMPART() FUNCTION

-- The TIMEFROMPARTS() function returns a fully initialized time value. 
	-- It requires five arguments as shown in the following syntax:
		--TIMEFROMPARTS ( hour, minute, seconds, fractions, precision)
		-- EXAMPLE:
		SELECT 
    TIMEFROMPARTS(23, 59, 59, 0, 0) AS Time;
		-- EXAMPLE:
		SELECT 
    TIMEFROMPARTS(06, 30, 15, 5, 2) Time;
	-- sondaki precision'�n 2 verildi�inde nas�l g�z�kt���ne dikkat et.(saniye fraction'u iki basamakl� g�steriyor)
	-- 2 verirsek saniyenin 100 de 1'ine kadar kesinlik sa�lar�z. 3 verirsek 1000 de biri kadar kesinlik sa�lar�z.

-- Bizim �rne�imize d�nersek:
INSERT t_date_time (A_time) VALUES (TIMEFROMPARTS(12,0,0,0,0));
-- saat 12, dakika ve saniye 0 girildi. precision 0 verildi�inde nas�l g�z�kt���ne dikkat et!

SELECT * 
FROM t_date_time

