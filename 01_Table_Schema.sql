USE master;
GO

-- 1. XOA DB CU NEU CO, TAO DB MOI --
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'QuanLyKho_Final')
    DROP DATABASE QuanLyKho_Final;
GO

CREATE DATABASE QuanLyKho_Final;
GO

USE QuanLyKho_Final;
GO

-- 2. TAO BANG HANG HOA --
CREATE TABLE HangHoa (
    MaHang VARCHAR(20) PRIMARY KEY,
    TenHang NVARCHAR(100),
    NoiSanXuat NVARCHAR(100)
);

-- 3. TAO BANG KHACH HANG --
CREATE TABLE KhachHang (
    MaKhach VARCHAR(20) PRIMARY KEY,
    TenKhach NVARCHAR(100),
    DiaChi NVARCHAR(200),
    SoDienThoai VARCHAR(15)
);

-- 4. TAO BANG PHIEU NHAP --
CREATE TABLE PhieuNhap (
    SoPhieuNhap VARCHAR(20) PRIMARY KEY,
    NgayNhap DATE DEFAULT GETDATE()
);

-- 5. TAO BANG CHI TIET PHIEU NHAP --
CREATE TABLE ChiTietPhieuNhap (
    SoPhieuNhap VARCHAR(20),
    MaHang VARCHAR(20),
    SoLuongNhap INT CHECK (SoLuongNhap > 0),
    DonGiaNhap DECIMAL(18, 0),
    PRIMARY KEY (SoPhieuNhap, MaHang),
    FOREIGN KEY (SoPhieuNhap) REFERENCES PhieuNhap(SoPhieuNhap),
    FOREIGN KEY (MaHang) REFERENCES HangHoa(MaHang)
);

-- 6. TAO BANG PHIEU XUAT --
CREATE TABLE PhieuXuat (
    SoPhieuXuat VARCHAR(20) PRIMARY KEY,
    NgayXuat DATE DEFAULT GETDATE(),
    MaKhach VARCHAR(20),
    FOREIGN KEY (MaKhach) REFERENCES KhachHang(MaKhach)
);

-- 7. TAO BANG CHI TIET PHIEU XUAT --
CREATE TABLE ChiTietPhieuXuat (
    SoPhieuXuat VARCHAR(20),
    MaHang VARCHAR(20),
    SoLuongXuat INT CHECK (SoLuongXuat > 0),
    DonGiaXuat DECIMAL(18, 0),
    PRIMARY KEY (SoPhieuXuat, MaHang),
    FOREIGN KEY (SoPhieuXuat) REFERENCES PhieuXuat(SoPhieuXuat),
    FOREIGN KEY (MaHang) REFERENCES HangHoa(MaHang)
);
GO