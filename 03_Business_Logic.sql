USE QuanLyKho_Final;
GO

-- 1. TRIGGER: TU DONG KIEM TRA TON KHO (CHAN XUAT AM) --
CREATE TRIGGER trg_CheckTonKho
ON ChiTietPhieuXuat
FOR INSERT
AS
BEGIN
    DECLARE @Ma VARCHAR(20);
    DECLARE @SlXuat INT;
    DECLARE @SlTon INT;

    SELECT @Ma = MaHang, @SlXuat = SoLuongXuat FROM inserted;

    -- Tinh ton kho hien tai = Tong Nhap - Tong Xuat (tru lan dang xuat nay)
    SELECT @SlTon = (
        ISNULL((SELECT SUM(SoLuongNhap) FROM ChiTietPhieuNhap WHERE MaHang = @Ma), 0) - 
        ISNULL((SELECT SUM(SoLuongXuat) FROM ChiTietPhieuXuat WHERE MaHang = @Ma AND SoPhieuXuat NOT IN (SELECT SoPhieuXuat FROM inserted)), 0)
    );

    IF @SlXuat > @SlTon
    BEGIN
        RAISERROR('Loi: So luong xuat vuot qua ton kho hien tai!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- 2. CAC THU TUC BAO CAO (STORED PROCEDURES) --

-- Cau 1: Bao cao ton kho
CREATE PROCEDURE Cau1_TonKho AS
BEGIN
    SELECT h.TenHang, 
        (ISNULL(SUM(n.SoLuongNhap), 0) - ISNULL((SELECT SUM(x.SoLuongXuat) FROM ChiTietPhieuXuat x WHERE x.MaHang = h.MaHang), 0)) AS TonKho
    FROM HangHoa h 
    LEFT JOIN ChiTietPhieuNhap n ON h.MaHang = n.MaHang
    GROUP BY h.MaHang, h.TenHang;
END;
GO

-- Cau 2: Tim kiem hang hoa
CREATE PROCEDURE Cau2_TimKiem @Kw NVARCHAR(50) AS
BEGIN
    SELECT DISTINCT h.* FROM HangHoa h 
    WHERE h.TenHang LIKE '%' + @Kw + '%' OR h.NoiSanXuat LIKE '%' + @Kw + '%';
END;
GO

-- Cau 3: Tim hang xuat theo ngay
CREATE PROCEDURE Cau3_TimXuat @D INT, @M INT, @Y INT AS
BEGIN
    SELECT h.TenHang, px.NgayXuat, c.SoLuongXuat 
    FROM ChiTietPhieuXuat c 
    JOIN PhieuXuat px ON c.SoPhieuXuat = px.SoPhieuXuat 
    JOIN HangHoa h ON c.MaHang = h.MaHang
    WHERE DAY(px.NgayXuat) = @D AND MONTH(px.NgayXuat) = @M AND YEAR(px.NgayXuat) = @Y;
END;
GO

-- Cau 4: Canh bao ton kho lon (> 100)
CREATE PROCEDURE Cau4_TonKhoLon AS
BEGIN
    SELECT h.TenHang, 
        (ISNULL(SUM(n.SoLuongNhap), 0) - ISNULL((SELECT SUM(x.SoLuongXuat) FROM ChiTietPhieuXuat x WHERE x.MaHang = h.MaHang), 0)) AS TonKho
    FROM HangHoa h 
    LEFT JOIN ChiTietPhieuNhap n ON h.MaHang = n.MaHang
    GROUP BY h.MaHang, h.TenHang
    HAVING (ISNULL(SUM(n.SoLuongNhap), 0) - ISNULL((SELECT SUM(x.SoLuongXuat) FROM ChiTietPhieuXuat x WHERE x.MaHang = h.MaHang), 0)) > 100;
END;
GO

-- Cau 5: Bao cao doanh thu
CREATE PROCEDURE Cau5_DoanhThu AS
BEGIN
    SELECT h.TenHang, SUM(c.SoLuongXuat * c.DonGiaXuat) AS TienThuDuoc
    FROM ChiTietPhieuXuat c 
    JOIN HangHoa h ON c.MaHang = h.MaHang
    GROUP BY h.TenHang;
END;
GO

-- Cau 6: Hang nhap/xuat nhieu nhat
CREATE PROCEDURE Cau6_Max AS
BEGIN
    SELECT TOP 1 h.TenHang, SUM(SoLuongNhap) AS SL_Nhap_Max 
    FROM ChiTietPhieuNhap c JOIN HangHoa h ON c.MaHang = h.MaHang 
    GROUP BY h.TenHang ORDER BY SL_Nhap_Max DESC;

    SELECT TOP 1 h.TenHang, SUM(SoLuongXuat) AS SL_Xuat_Max 
    FROM ChiTietPhieuXuat c JOIN HangHoa h ON c.MaHang = h.MaHang 
    GROUP BY h.TenHang ORDER BY SL_Xuat_Max DESC;
END;
GO

-- Cau 7: Hang e (Khong ban duoc trong thang)
CREATE PROCEDURE Cau7_HangE @M INT, @Y INT AS
BEGIN
    SELECT TenHang 
    FROM HangHoa 
    WHERE MaHang NOT IN (
        SELECT DISTINCT MaHang 
        FROM ChiTietPhieuXuat c 
        JOIN PhieuXuat p ON c.SoPhieuXuat = p.SoPhieuXuat 
        WHERE MONTH(p.NgayXuat) = @M AND YEAR(p.NgayXuat) = @Y
    );
END;
GO