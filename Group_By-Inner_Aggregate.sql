-- QUANLYBANHANG---
USE QuanlyBanHang
-- PHAN3---
-- CAU30-
SELECT MASP, TENSP
FROM SANPHAM INNER JOIN
(
SELECT DISTINCT GIA
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'
ORDER BY GIA DESC
LIMIT 3
) AS SP3 ON SANPHAM.GIA = SP3.GIA 

-- CAU31
SELECT TOP 3 *   
FROM KHACHHANG
ORDER BY DOANHSO DESC -- -SAI, CACH NAY CHI SAP THEO TEN
-- NHUNG KHONG CO RANK --

SELECT TOP 3 *, RANK() OVER (ORDER BY DOANHSO DESC) AS DS_RANK
FROM KHACHHANG

SELECT*
FROM KHACHHANG
ORDER BY DOANHSO DESC
LIMIT 3
-- CAU32
SELECT COUNT(MASP)
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc';

-- CAU33
SELECT NUOCSX, COUNT(MASP) AS TONGSP
FROM SANPHAM
GROUP BY NUOCSX

-- CAU34
-- GROUP by cai gi thi select cai do + cac ham gom nhom(COUNT, AVG, SUM, MAX, MIN).
SELECT NUOCSX , MAX(GIA) AS GIACAONHAT, MIN(GIA) AS GIATHAPNHAT, AVG(GIA) AS GIATB
FROM SANPHAM
GROUP BY NUOCSX
 -- CAU35: TINH DOANH THU BAN HANG MOI NGAY
SELECT NGHD, SUM(TRIGIA) AS DOANHTHU FROM HOADON
GROUP BY NGHD
ORDER BY (NGHD) ASC

-- CAU36
SELECT MASP, COUNT(CTHD.SOHD) AS SLSP10
FROM CTHD INNER JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
WHERE NGHD BETWEEN '2006-10-10' AND '2006-10-31' -- MONTH = 10 YEAR = 2006
GROUP BY MASP

-- CAU37
SELECT MONTH(NGHD) AS THANG, COUNT(TRIGIA) AS DOANHTHU
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY THANG
ORDER BY THANG ASC
-- CAU38
SELECT SOHD, COUNT(MASP) AS SLSP
FROM CTHD
GROUP BY SOHD
HAVING COUNT(MASP) > 4
-- CAU39
SELECT SOHD, COUNT(DISTINCT CTHD.MASP) AS SLVN
FROM CTHD INNER JOIN SANPHAM ON CTHD.MASP = SANPHAM.MASP
WHERE NUOCSX = 'Viet Nam'
GROUP BY SOHD
HAVING SLVN >3
-- CAU40
SELECT KHACHHANG.MAKH, HOTEN
FROM KHACHHANG INNER JOIN 
(SELECT MAKH
FROM HOADON
GROUP BY MAKH
HAVING COUNT(SOHD) >= (
SELECT MAX(SLHD) FROM (
SELECT MAKH, COUNT(SOHD) AS SLHD 
FROM HOADON
GROUP BY MAKH) AS T
))AS TB ON KHACHHANG.MAKH = TB.MAKH
-- CAU41
SELECT THANG
FROM (
SELECT MONTH(NGHD) AS THANG, COUNT(TRIGIA) AS DOANHTHU
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)
ORDER BY MONTH(NGHD) ASC
) AS T3 
WHERE DOANHTHU = (SELECT MAX(DOANHTHU) FROM (
	SELECT COUNT(TRIGIA) AS DOANHTHU
	FROM HOADON
	WHERE YEAR(NGHD) = 2006
	GROUP BY MONTH(NGHD)
	ORDER BY MONTH(NGHD) ASC
	) AS T4
)
-- CAU42
SELECT SANPHAM.MASP, TENSP
FROM SANPHAM INNER JOIN 
(SELECT MASP
FROM 
	(SELECT MASP, SUM(SL) AS SLSP
	FROM CTHD
	WHERE SOHD IN (SELECT SOHD
	FROM HOADON
	WHERE YEAR(NGHD) = 2006)
	GROUP BY MASP) AS T
WHERE SLSP = (SELECT MIN(SLSP)FROM(SELECT MASP, SUM(SL) AS SLSP
	FROM CTHD
	WHERE SOHD IN (SELECT SOHD
	FROM HOADON
	WHERE YEAR(NGHD) = 2006)
	GROUP BY MASP) AS T2)
) AS T3 ON SANPHAM.MASP = T3.MASP
-- CAU43

SELECT MASP, TENSP
FROM SANPHAM AS SP1 WHERE GIA = (
SELECT MAX(GIA) FROM SANPHAM AS SP2
WHERE SP1.NUOCSX = SP2.NUOCSX 
GROUP BY NUOCSX 
)
-- C2
SELECT MASP, TENSP, NUOCSX
FROM SANPHAM AS T1
WHERE GIA >= (SELECT MAX(GIA) FROM SANPHAM WHERE T1.NUOCSX = NUOCSX)
ORDER BY NUOCSX ASC

-- CAU44
/*
SELECT DISTINCT NUOCSX
FROM SANPHAM AS T1
WHERE NUOCSX IN
(SELECT NUOCSX, COUNT(MASP) AS SLSP
FROM SANPHAM
GROUP BY NUOCSX
HAVING SLSP >=3)
AND GIA != ()
*/
SELECT DISTINCT NUOCSX
FROM SANPHAM
WHERE NUOCSX IN(
	SELECT NUOCSX
	FROM SANPHAM
	GROUP BY NUOCSX
	HAVING COUNT(DISTINCT GIA) >=3
)
-- CAU45
SELECT*
FROM KHACHHANG RIGHT JOIN
(SELECT HOADON.MAKH, COUNT(SOHD) AS SLMH
FROM HOADON RIGHT JOIN
(SELECT MAKH
FROM KHACHHANG
ORDER BY DOANHSO DESC
LIMIT 10) AS T ON T.MAKH = HOADON.MAKH
GROUP BY MAKH
ORDER BY SLMH DESC
LIMIT 1)AS T1 ON T1.MAKH = KHACHHANG.MAKH



