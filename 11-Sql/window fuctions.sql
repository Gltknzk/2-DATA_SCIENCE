select *
from orde
------SUM �LE
TOPLA()

SUM() toplama i�levini hepimiz biliyoruz. Belirtilen grup (�ehir, eyalet, 
�lke vb. gibi) veya grup belirtilmemi�se t�m tablo i�in belirtilen alan�n
toplam�n� yapar. Normal SUM() toplama i�levinin ve pencere SUM() toplama 
i�levinin ��kt�s�n�n ne olaca��n� g�rece�iz.

A�a��daki, normal bir SUM() toplama i�levi �rne�idir. Her �ehir i�in sipari�
tutar�n� toplar.

Sonu� k�mesinden, normal bir toplama i�levinin birden �ok sat�r� tek bir 
��kt� sat�r�nda grupland�rd���n� ve bu da tek tek sat�rlar�n kimliklerini 
kaybetmesine neden oldu�unu g�rebilirsiniz.

SELECT city, sum(order_amount) as total_prd_amount
from orde
group by city

-------W�NDOW �LE
Bu, pencere toplama i�levlerinde ger�ekle�mez. Sat�rlar kimliklerini korur 
ve ayr�ca her sat�r i�in toplu bir de�er g�sterir. A�a��daki �rnekte sorgu 
ayn� �eyi yap�yor, yani her �ehir i�in verileri topluyor ve her biri i�in 
toplam sipari� tutar�n�n toplam�n� g�steriyor. Ancak, sorgu art�k toplam 
sipari� miktar� i�in ba�ka bir s�tun ekler, b�ylece her sat�r kendi kimli�ini
korur. Grand_total olarak i�aretlenen s�tun, a�a��daki �rnekteki yeni 
s�tundur.

SELECT order_id, order_date, customer_name, city, order_amount
,SUM(order_amount) 
OVER(PARTITION BY city) as grand_total -- topla �ehirlere g�re grupla
FROM [dbo].[Orde]

---AVG----

AVG veya Ortalama, bir Pencere i�leviyle tam olarak ayn� �ekilde �al���r.
A�a��daki sorgu size her bir �ehir ve her ay i�in ortalama sipari� miktar�n� 
verecektir 
(her ne kadar basit olmas� i�in verileri yaln�zca bir ayda kulland�k).
B�l�m listesinde birden fazla alan belirterek birden fazla ortalama 
belirtiyoruz.
Ayr�ca a�a��daki sorguda g�sterildi�i gibi MONTH(order_date) gibi listelerdeki
ifadeleri de kullanabilece�inizi belirtmekte fayda var. 
 
SELECT order_id, order_date, customer_name, city, order_amount
 ,AVG(order_amount) OVER(PARTITION BY city, MONTH(order_date)) as   average_order_amount 
FROM [dbo].[Orde]


---MIN()---------------
MIN toplama i�levi, belirtilen bir grup veya grup belirtilmemi�se t�m tablo i�in minimum 
de�eri bulur.
�rne�in, a�a��daki sorguyu kullanaca��m�z her �ehir i�in en k���k sipari�i (minimum sipari�)
ar�yoruz.

SELECT order_id, order_date, customer_name, city, order_amount
 ,MIN(order_amount) OVER(PARTITION BY city) as minimum_order_amount 
FROM [dbo].[Orde]
------------------------------------
MAX()her �ehir i�in en b�y�k sipari�i (maksimum sipari� miktar�n�) bulal�m.


SELECT order_id, order_date, customer_name, city, order_amount
 ,MAX(order_amount) OVER(PARTITION BY city) as maximum_order_amount 
FROM [dbo].[Orde] 
-------------------------
---COUNT ()--------------
COUNT() i�levi kay�tlar�/sat�rlar� sayar.

DISTINCT ��esinin COUNT() i�leviyle desteklenmedi�ini, ancak normal COUNT() i�levi i�in 
desteklendi�ini unutmay�n. DISTINCT, belirtilen bir alan�n farkl� de�erlerini bulman�za yard�mc� 
olur.

�rne�in Nisan 2017 de ka� m��terinin sipari� verdi�ini g�rmek istiyorsak, t�m m��terileri 
do�rudan sayamay�z. Ayn� m��terinin ayn� ayda birden fazla sipari� vermesi m�mk�nd�r.

COUNT(customer_name) kopyalar� sayaca�� i�in size yanl�� bir sonu� verecektir. 
Oysa COUNT(DISTINCT m��teri_ad�) her benzersiz m��teriyi yaln�zca bir kez sayd��� i�in size 
do�ru sonucu verecektir.

Normal COUNT() i�levi i�in ge�erlidir:
---------
SELECT city,COUNT(DISTINCT customer_name) number_of_customers
FROM [dbo].[Orde] 
GROUP BY city
--------------
--yanl��----
SELECT order_id, order_date, customer_name, city, order_amount
 ,COUNT(DISTINCT customer_name) OVER(PARTITION BY city) as number_of_customers
FROM [dbo].[Orde] 
------do�ru---------
SELECT order_id, order_date, customer_name, city, order_amount
 ,COUNT(order_id) OVER(PARTITION BY city) as total_orders
FROM [dbo].[Orde]
 
 --------
S�ralama Penceresi ��levleri
Pencere toplama i�levlerinin belirli bir alan�n de�erini toplamas� gibi, RANKING i�levleri de 
belirtilen bir alan�n de�erlerini s�ralayacak ve s�ralamalar�na g�re kategorilere ay�racakt�r.

SIRALAMA i�levlerinin en yayg�n kullan�m�, belirli bir de�ere g�re en �stteki (N) kay�tlar� 
bulmakt�r. �rne�in, En y�ksek �cretli 10 �al��an, �lk 10 s�radaki ��renci, En b�y�k 50 sipari� vb.

A�a��dakiler desteklenen SIRALAMA i�levleridir:

RANK(), DENSE_RANK(), ROW_NUMBER(), NTILE()


RANK() i�levi, �rne�in maa�, sipari� tutar� vb. gibi belirli bir de�ere dayal� olarak her 
kayda benzersiz bir s�ralama vermek i�in kullan�l�r.

�ki kay�t ayn� de�ere sahipse, RANK() i�levi bir sonraki s�ray� atlayarak her iki kayda da 
ayn� s�ray� atayacakt�r. Bunun anlam� � e�er 2. seviyede iki �zde� de�er varsa, her iki kayda 
da ayn� 2. dereceyi atayacak ve sonra 3. s�ray� atlayacak ve 4. s�ray� bir sonraki kayda 
atayacakt�r.

1-2-3-3-5 oldu
SELECT order_date,order_id,customer_name,city,
rank() over(order by order_amount desc) as rank
from orde

SELECT order_id,order_date,customer_name,city, 
RANK() OVER(ORDER BY order_amount DESC) [Rank]
FROM [dbo].[Orde]
 
 ----
DENSE_RANK() i�levi, herhangi bir s�ra atlamamas� d���nda RANK() i�leviyle ayn�d�r. 
Bunun anlam�, iki �zde� kay�t bulunursa, DENSE_RANK() her iki kayda ayn� s�ray� atayacakt�r, 
ancak atlamadan sonraki s�ray� atlamayacakt�r.

1-2-3-3-4 oldu
SELECT order_id,order_date,customer_name,city, order_amount,
DENSE_RANK() OVER(ORDER BY order_amount DESC) [Rank]
FROM [dbo].[Orde]
 -----
--PARTITION BY olmadan ROW_ NUMBER()

SELECT order_id,order_date,customer_name,city, order_amount,
ROW_NUMBER() OVER(ORDER BY order_id) [row_number]
FROM [dbo].[Orde]

--PARTITION BY ile ROW_NUMBER()
 
SELECT order_id,order_date,customer_name,city, order_amount,
ROW_NUMBER() OVER(PARTITION BY city ORDER BY order_amount DESC) [row_number]
FROM [dbo].[Orde]
--B�lmeyi �ehir �zerinde yapt���m�z� unutmay�n. Bu, her �ehir i�in s�ra numaras�n�n s�f�rland��� 
--ve b�ylece tekrar 1 den yeniden ba�lad��� anlam�na gelir. Ancak, s�ralar�n s�ras� sipari� miktar�na
--g�re belirlenir, b�ylece herhangi bir �ehir i�in en b�y�k sipari� tutar� ilk sat�r olur ve b�ylece
--sat�r numaras� 1 olarak atan�r.
---------
NTILE() �ok yararl� bir pencere i�levidir. Belirli bir sat�r�n hangi y�zdelik dilime 
(veya �eyre�e veya ba�ka bir alt b�l�me) d��t���n� belirlemenize yard�mc� olur.

Bu, 100 sat�r�n�z varsa ve belirli bir de�er alan�na g�re 4 �eyrek olu�turmak istiyorsan�z, 
bunu kolayca yapabilir ve her bir �eyre�e ka� sat�r d��t���n� g�rebilirsiniz.

Bir �rnek g�relim. A�a��daki sorguda sipari� miktar�na g�re d�rt �eyrek olu�turmak istedi�imizi 
belirtmi�tik. Ard�ndan, her bir �eyre�e ka� sipari�in d��t���n� g�rmek isteriz.
 
SELECT order_id,order_date,customer_name,city, order_amount,
NTILE(4) OVER(ORDER BY order_amount) [row_number]
FROM [dbo].[Orde]
---
--Value window functions are used to find first, last, previous and next values. 
The functions that can be used are LAG(), LEAD(), FIRST_VALUE(), LAST_VALUE()

LAG() and LEAD()


Bu a�a��daki bir giri� makalesi oldu�undan, bunlar�n nas�l kullan�laca��n� g�stermek i�in 
�ok basit bir �rne�e bak�yoruz.

LAG i�levi, herhangi bir SQL birle�imi kullanmadan ayn� sonu� k�mesindeki �nceki sat�rdaki 
verilere eri�meyi sa�lar. A�a��daki �rnekte, �nceki sipari� tarihini buldu�umuz LAG fonksiyonunu
kullanarak g�rebilirsiniz.

LAG() i�levini kullanarak �nceki sipari� tarihini bulmak i�in komut dosyas�:
 
SELECT order_id,customer_name,city, order_amount,order_date,
 --in below line, 1 indicates check for previous row of the current row
 LAG(order_date,3) OVER(ORDER BY order_date) prev_order_date
FROM [dbo].[Orde]
-----
LEAD i�levi, herhangi bir SQL birle�tirmesi kullanmadan ayn� sonu� k�mesindeki bir sonraki 
sat�rdaki verilere eri�meyi sa�lar. A�a��daki �rnekte g�rebilirsiniz, leadfonksiyonunu 
kullanarak sonraki sipari� tarihini bulduk.

LEAD() i�levini kullanarak bir sonraki sipari� tarihini bulmak i�in komut dosyas�:

SELECT order_id,customer_name,city, order_amount,order_date,
 --in below line, 1 indicates check for next row of the current row
 LEAD(order_date,1) OVER(ORDER BY order_date) next_order_date
FROM [dbo].[Orde]

--FIRST_VALUE() ve LAST_VALUE()

Bu i�levler, PARTITION BY belirtilmemi�se, bir b�l�m veya t�m tablo i�indeki ilk ve son kayd� 
belirlemenize yard�mc� olur .

Mevcut veri k�memizden her �ehrin ilk ve son s�ras�n� bulal�m. Not ORDER BY yan t�mcesi FIRST_VALUE
() ve LAST_VALUE() i�levleri i�in zorunludur

 
SELECT order_id,order_date,customer_name,city, order_amount,
FIRST_VALUE(order_date) OVER(PARTITION BY city ORDER BY city) first_order_date,
LAST_VALUE(order_date) OVER(PARTITION BY city ORDER BY city) last_order_date
FROM [dbo].[Orde]
























