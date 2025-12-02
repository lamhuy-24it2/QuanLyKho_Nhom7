USE QuanLyKho_Final;
GO

-- 1. NAP DU LIEU HANG HOA (20 Mat hang) --
INSERT INTO HangHoa VALUES ('DT_IP15', N'iPhone 15 Pro Max', N'My');
INSERT INTO HangHoa VALUES ('DT_S24U', N'Samsung Galaxy S24 Ultra', N'Han Quoc');
INSERT INTO HangHoa VALUES ('LT_MAC',  N'Macbook Air M3', N'My');
INSERT INTO HangHoa VALUES ('LT_DELL', N'Laptop Dell XPS', N'My');
INSERT INTO HangHoa VALUES ('DL_TV',   N'Smart Tivi Sony 4K', N'Nhat Ban');
INSERT INTO HangHoa VALUES ('DL_TL',   N'Tu lanh Panasonic', N'Nhat Ban');
INSERT INTO HangHoa VALUES ('PK_TAI',  N'Tai nghe AirPods Pro', N'My');
INSERT INTO HangHoa VALUES ('PK_SAC',  N'Sac du phong Anker', N'Trung Quoc');

-- 2. NAP DU LIEU KHACH HANG --
INSERT INTO KhachHang VALUES ('K01', N'Nguyen Van An', N'Ha Noi', '0901111111');
INSERT INTO KhachHang VALUES ('K02', N'Tran Thi Bich', N'TP HCM', '0902222222');
INSERT INTO KhachHang VALUES ('K03', N'Le Van Cuong', N'Da Nang', '0903333333');
INSERT INTO KhachHang VALUES ('K04', N'Cong ty TechOne', N'Ha Noi', '0912345678');

-- 3. NAP PHIEU NHAP (Nhap kho) --
INSERT INTO PhieuNhap VALUES ('PN01', '2025-10-01');
INSERT INTO ChiTietPhieuNhap VALUES ('PN01', 'DT_IP15', 50, 25000000);
INSERT INTO ChiTietPhieuNhap VALUES ('PN01', 'DT_S24U', 50, 22000000);

INSERT INTO PhieuNhap VALUES ('PN02', '2025-11-01');
INSERT INTO ChiTietPhieuNhap VALUES ('PN02', 'DL_TV', 120, 10000000); 
INSERT INTO ChiTietPhieuNhap VALUES ('PN02', 'PK_TAI', 200, 4000000);

-- 4. NAP PHIEU XUAT (Ban hang) --
INSERT INTO PhieuXuat VALUES ('PX01', '2025-10-05', 'K01');
INSERT INTO ChiTietPhieuXuat VALUES ('PX01', 'DT_IP15', 2, 30000000);

INSERT INTO PhieuXuat VALUES ('PX02', '2025-11-10', 'K04');
INSERT INTO ChiTietPhieuXuat VALUES ('PX02', 'DL_TV', 10, 15000000);
INSERT INTO ChiTietPhieuXuat VALUES ('PX02', 'PK_TAI', 20, 5000000);
GO