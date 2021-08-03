--STR�NG FUNCT�ONS

SELECT LEN(123456) as uzunluk

--SELECT LENGTH('Clarusway')

SELECT LEN ('Clarusway')

SELECT LEN ('Clarusway  ')

SELECT CHARINDEX('c','character') -- case sensitive de�il

SELECT CHARINDEX('C','character',2)  -- nerden itibaren

SELECT CHARINDEX('Ct','character')  -- ct yi buldu c nin yerini getirdi

-- patindex

SELECT PATINDEX('R','CHARACTER')  --R yok

SELECT PATINDEX('%R%','CHARACTER')  --R den �nce sonra character var 4. gelir

SELECT PATINDEX('%R','CHARACTER')   --R den �nce var sonra character yok

SELECT PATINDEX('%r','CHARACTER')   --r den �nce var sonra character 

SELECT PATINDEX('%A____','CHARACTER') -- A dan sonra 4 karakter var
-- a dan �nce ka� karakter oldu�u �nemli de�il


SELECT left('CHARACTER',3) -- soldan 3 tane al


SELECT left('  CHARACTER',3) -- soldan 3 tane al bo�luklar� da sayar


SELECT right('CHARACTER',3) -- sa�dan 3 tane al


SELECT right('CHARACTER ',3) -- sa�dan 3 tane al bo�lukta say�l�r


SELECT substring('CHARACTER',3,5) -- 3.karakterden itibaren 5 karakter al

SELECT substring('123456789',3,5) -- 3.karakterden itibaren 5 karakter al

SELECT substring('CHARACTER',0,5) -- 0 dan al�r eksik kal�r 

SELECT SUBSTR('Clarusway', 1, 3)

SELECT SUBSTR('Clarusway', -6, 2)

SELECT lower('CHARACTER')

SELECT upper('CHARACter')

select value  -- commonda b�ld� altalta yazd�rd�
from string_split('john,Sarah,Jack',',')

select value  -- / b�ld� altalta yazd�rd�
from string_split('john/Sarah/Jack','/')


select value  -- // bo�luk ald� arada de�er var zannetti
from string_split('john//Sarah//Jack','/')

SELECT upper(left('character',1))+right('character',8)

SELECT upper(left('character',1))+right('character', len ('character')-1)
-- sa�dan itibaren 8 tane getir len den 1 eksik


SELECT TRIM('  CHARACTER  '); -- sa�dan solada siler

SELECT TRIM('  CHARA   CTER  '); -- i�erdekiler hari�

SELECT LTRIM('  CHARACTER  '); -- soldan siler

SELECT RTRIM('      CHARACTER       '); -- sa�dan siler


SELECT REPLACE(' CHARACTER', 'RAC','') -- rac silindi

SELECT REPLACE(' CHARACTER', 'RAC','/') -- rac yerine / koyduk

SELECT str(1234.573,6,2) -- nokta dahil 6 karakter geldi . dan sonra 2 tane al
-- noktadan sonra 2 tane dedik ama toplamda 6 ya ula�t�, yuvarlad�


SELECT str(1234.573,7,1)-- 7 karakter ama noktadan sonra 1 tane deyinde ba�ta bo�luk al�r.

--JACK_10

SELECT 'JACK' +'_'+ '10'

SELECT 'JACK' +'_'+ 10 -- olamd� str int olmad�

SELECT 'JACK' +'_'+str(10,2) --oldu str str oldu

--CAST de�r d�n��t�r�r
SELECT cast(123456 as char(10)) -- 10 karakterlik yer olu�turdu

SELECT cast(123456 as char) -- char type na d�n��t�

SELECT cast(123456 as varchar()) -- varchar type ka� de�er varsa o dakar de�er ay�rd�.......

SELECT cast(123456 as varchar())+' CHRIS' -

SELECT cast(getdate() as date)  -- cast t�r d�n���m�

--CONVERT de�er d�n��t�r�r

SELECT CONVERT(FLOAT,30.30) -- floata �evir


--COALESCE

SELECT COALESCE(null,null,'jack','NACK',null)-- buldu�u null olmayan ilk de�er
-- sut�nlara tek tek bakar

--null�f

SELECT NULLIF('jack','jack')-- iki de�er e�itse null gelir
SELECT NULLIF('jack','Jackjon')-- iki de�er e�it de�ilse ilki gelir

SELECT first_name
from sales.customers


SELECT count(NULLIF(first_name,'Debra')) --debra y� null yapt�k
FROM sales.customers

SELECT count(*)  -- 1 tane dbra var 1445 de�er
FROM sales.customers

--round
SELECT ROUND(123654.21155,2) -- . dan sonra 2 rakkam yuvarlad�

SELECT ROUND(123654.21155,2,0) -- . dan sonra 2 rakkam 3. default 0 d�r.

SELECT ROUND(123654.21155,1,0) -- . dan sonra 1 rakkam 2. default

SELECT ROUND(123654.21155,1,1) -- . 1 rakkam 1 de koysak almaz 0 olur.


SELECT email
FROM sales.customers

SELECT patindex('%yahoo%',email)AS email_yahoo,email 
FROM sales.customers
-------------------------------------
---yahoo kullana ka� ki�i---
SELECT sum(case when patindex('%yahoo%',email)>0 --index varsa 
            then 1 else 0 end) as sum_of_domain
FROM sales.customers  --toplamda 305 tane sayd� 0 dan b�y�kse

SELECT count(*)
from sales.customers
where email like('%yahoo%')
-----------------------------------------
----email s�tununun de�erlerinde bulunan nokta karakterinden �nceki ifadeleri getiriniz.
--write a query that returns the characters before the '.' character in the email column.


select LEFT(email,CHARINDEX('.',email)-1) from sales.customers
------
select substring(email,1,charindex('.',email)-1),email
from sales.customers
--------------------------------------------------
--Add a new column to the customers table that contains the customers' contact information.
--If the phone is available, the phone information will be printed, if not, the email information will be printed.


select *,coalesce(phone,email)as contact
from sales.customers
---
alter table sales.customers 
add contact_info varchar
update set contact_info = (
select 
	case when phone = Null then email
	else phone
	end as contact
from sales.customers)

---

select *, 
(case when phone is null then email
	else phone
	end) as contact 
from sales.customers

-----------------
--Write a query that returns streets. The third character of the streets is numerical.

SELECT street --hepsini geitrdi
FROM sales.customers

SELECT SUBSTRING(street,1,3) -- ba�tan ba�la 3 karakter al
FROM sales.customers


SELECT SUBSTRING(street,3,1) -- 3 ten ba�la 1 karakter al
FROM sales.customers
WHERE SUBSTRING(street,3,1) LIKE '[0-9]' -- benzerlerini getir
------

SELECT SUBSTRING(street,3,1) -- 3 ten ba�la 1 karakter al
FROM sales.customers
WHERE SUBSTRING(street,3,1) NOT LIKE '[^0-9]' -- 2 olumsuz
--*
SELECT SUBSTRING(street,3,1) -- 3 ten ba�la 1 karakter al
FROM sales.customers
WHERE ISNUMERIC (SUBSTRING(street,3,1))=1 -- isnumeric
-----------------------------------------------------------
--In the street column, clear the string characters that 
--were accidentally added to the end of the initial numeric 
--expression.

-- finding the string char  at the end the of street number 
select street,right(left(street,CHARINDEX(' ',street)-1),1)
from sales.customers
where isnumeric (right(left(street,CHARINDEX(' ',street)-1),1)) = 0

-- final solution
select street,  (case when isnumeric (right(left(street,CHARINDEX(' ',street)-1),1)) = 0 
					then replace(street,(right(left(street,CHARINDEX(' ',street)-1),1)),'')
					else street end) new_column
from sales.customers

------2.way---------------------
C8207-Zehra  8:49 PM
SELECT street,LEFT(street,CHARINDEX(' ',street)-2)+' '+RIGHT(street,LEN(street)-CHARINDEX(' ',street)+1) as new_street
FROM sales.customers
WHERE ISNUMERIC(LEFT(street,CHARINDEX(' ',street)-1))=0
--------------------------------------------------------------------------
SELECT LTRIM('  Reinvent Yourself') AS ltr

SELECT LTRIM('@@@clar@usway@@@@', '@') AS ltr;

SELECT REPLACE('REIMVEMT','M','N');

SELECT REPLACE('I do it my way.','do','did') AS song_name;

SELECT INSTR('Reinvent yourself', 'yourself') AS start_position;

SELECT 'Way' || ' to ' || 'Reinvent ' || 'Yourself' AS motto;-- mysql de zann�mca





