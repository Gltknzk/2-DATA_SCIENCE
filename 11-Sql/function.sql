-------------------STORED PROCEDURE--------------
---librry_1 alt�nda programmingde 
CREATE PROC sp_sampleproc_1
AS                   -- ba�lamas� bu �ekilde
BEGIN
	SELECT 'HELLO WORLD'

	END;
------�al��t�rma-------------
EXECUTE sp_sampleproc_1

EXEC sp_sampleproc_1
----------------------------------
--de�i�tirece�im
ALTER PROC sp_sampleproc_1
AS                   -- ba�lamas� bu �ekilde
BEGIN
	SELECT 'QUEY COMPLEED' RESULT

	END;              -- biti�i bu �ekilde
--�al��t�rma 
EXEC sp_sampleproc_1
-------------/////////////////--------------------------
--Tablo olu�urduk..
CREATE TABLE ORDER_TBL
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date   tahmini teslimat zaman�
);
INSERT ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 6, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 7, 'Johnson',GETDATE(), GETDATE()+5 )
-------verileri i�ine koyduk
select* from order_tbl

-------------------
CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan delivery date
);
SET NOCOUNT ON
INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
						(2, GETDATE()-2 ),
						(3, GETDATE()-2 ),
						(4, GETDATE() ),
						(5, GETDATE()+2 ),
						(6, GETDATE()+3 ),
						(7, GETDATE()+5 ),
						(8, GETDATE()+5 )


select* from ORDER_DELIVERY
------------------
create proc sp_sumorder  -- 8 di  sonu� prosed�r olu�tu
as
begin
	select count(ORDER_ID) from order_tbl
end;
--execute etme
sp_sumorder  -- g�ncellendik�e bu da de�i�ecek
----------------------
create proc sp_wanted_dayorder (@DAY  DATE)
as
begin

	select count(ORDER_ID) 
	from order_tbl
	where ORDER_DATE = @DAY    --@ parametre demek

end;  -- hangi tarihi istersem onun g�ncel tarihini getir �rnek

select * from order_tbl

exec sp_wanted_dayorder '2021-08-14'
------------------------------------------- --
DECLARE @P1 INT , @P2 INT , @SUM INT -- int olsun dedik
SET @P1 = 5				-- SET  bu �ekilde de olur
SELECT @P2 = 4			-- SELECT bu �ekilde de olur
SELECT @SUM = @P1+@P2
SELECT @SUM   -- �a��rmak istedi�imiz parametreyi bu �ekilde �a��rd�k
-- DE�ER ATAMAK ���N SET VEYA SELECT,
-- PARAMETREY� �A�IRMAK ���N SELECT

-----------------------------------------------
declare @CUST_ID int

select @CUST_ID = 5

SELECT *
FROM order_tbl
where customer_id =@CUST_ID
------parametreli sorguydu yukar�
------------///////////////////////////////////--------------
--3 ten k���kse
--3 e e�itse
--3 ten b�y�kse

DECLARE @CUST_ID INT  --declare ettik

SET @CUST_ID = 3     -- setle atad�k

IF @CUST_ID < 3      --ko�ullu �art sa�lad�k
BEGIN
	SELECT *
	FROM ORDER_TBL
	WHERE	CUSTOMER_ID= @CUST_ID
END
ELSE IF @CUST_ID > 3
BEGIN
	SELECT *
	FROM ORDER_TBL
	WHERE	CUSTOMER_ID= @CUST_ID	
END
ELSE
	PRINT 'CUSTOMER ID EQUAL TO 3'

	------//////////------
-- WHILE  python gibi

DECLARE @NUM_OF_ITER INT = 50, @NCOUNTER INT = 0

WHILE @NUM_OF_ITER >  @NCOUNTER  -- counter 50 den k���kse �al��t�r
BEGIN

	SELECT @NCOUNTER 
	SET @NCOUNTER += 1  -- countera bir ekle her defas�nda @NCOUNTER = @NCOUNTER+1

END

--
-- BEL�RT�LEN �ART SA�LANDI�I S�RECE ��LEME DEVAM EDER.
-- D�KKAT ED�LMES� GEREKEN NOKTA: (���NDE PARAMETRE VAR �SE) BEL�RTT���N�Z PARAMETREN�N B�TECE�� YER� S�YLEMEN�Z GEREK�YOR
	-- YOKSA SONSUZ D�NG�YE G�RECEKT�R.
DECLARE @NUM_OF_ITER INT = 50, @COUNTER INT = 0
WHILE @NUM_OF_ITER > @COUNTER --COUNTER 50'YE GELENE KADAR BEGIN-END KODUNU �ALI�TIRACAK.
BEGIN  -- WHILE �LE DE BEGIN KULLANIYORUM.
	SELECT @COUNTER
	SET @COUNTER += 1 --- D�NG�Y� BU �EK�LDE KONTROL ED�YORUM. �TERASYONU SA�LAYAN SATIR BU SATIR.
END

------------///////////////////////////////////------------------------
---FUNCT�ON
--sclaer value function----------

CREATE FUNCTION fn_uppertext
 (
	@inputtext varchar(max)
 )
 RETURNS VARCHAR(MAX)
 AS
 BEGIN
		return upper(@inputtext)
 END
---------------
 SELECT dbo.fn_uppertext('whatsapp')  --b�y�tt�k
---------------
 SELECT dbo.fn_uppertext(Customer_name)  --tablo de�erlerini uygulad�k
 from ORDER_TBL
 -------------

 ------------///////////////////////////////////------------------------
---FUNCT�ON
--table valued function----------
--begin end kal�b� yoookkkkk----

CREATE FUNCTION fn_order_detail(@DATE DATE)
RETURNS TABLE  -- tablo d�nd�receksin...
AS
	 RETURN SELECT * FROM ORDER_TBL WHERE ORDER_DATE= @DATE
--�a��ral�m
SELECT *
FROM fn_order_detail('2021-08-17')  --fromda �a��r�lacak
------

------------DDL TR�GGERS  AND DML TR�GGERS---------------
