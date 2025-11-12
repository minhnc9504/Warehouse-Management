# Warehouse Management System

Hệ thống quản lý kho hàng toàn diện được xây dựng bằng Java Servlet và JSP, hỗ trợ quản lý sản phẩm, tồn kho, đơn hàng, nhà cung cấp và nhiều tính năng khác.

## 📋 Mục lục

- [Tính năng](#tính-năng)
- [Công nghệ sử dụng](#công-nghệ-sử-dụng)
- [Yêu cầu hệ thống](#yêu-cầu-hệ-thống)
- [Cài đặt](#cài-đặt)
- [Cấu hình](#cấu-hình)
- [Cấu trúc dự án](#cấu-trúc-dự-án)
- [Sử dụng](#sử-dụng)
- [Vai trò người dùng](#vai-trò-người-dùng)
- [Database](#database)
- [Troubleshooting](#troubleshooting)

## ✨ Tính năng

### Quản lý sản phẩm
- Thêm, sửa, xóa sản phẩm
- Quản lý thuộc tính sản phẩm
- Quản lý đơn vị tính
- Tìm kiếm và lọc sản phẩm

### Quản lý kho hàng
- Quản lý nhiều kho hàng
- Gán quản lý kho cho người dùng
- Theo dõi tồn kho theo từng kho
- Chuyển hàng giữa các kho

### Quản lý tồn kho
- Theo dõi số lượng tồn kho real-time
- Cảnh báo tồn kho thấp
- Điều chỉnh tồn kho (Stock Adjustment)
- Lịch sử giao dịch tồn kho
- Báo cáo kiểm kê (Stock Check Report)

### Quản lý đơn hàng
- **Đơn hàng bán (Sales Order)**: Tạo, quản lý, theo dõi đơn hàng bán
- **Đơn hàng mua (Purchase Order)**: Quản lý đơn hàng mua từ nhà cung cấp
- **Yêu cầu mua hàng (Purchase Request)**: Tạo và phê duyệt yêu cầu mua hàng
- **Yêu cầu báo giá (RFQ - Request for Quotation)**: Quản lý yêu cầu báo giá

### Quản lý nhà cung cấp
- Thêm, sửa, xóa nhà cung cấp
- Đánh giá nhà cung cấp
- Quản lý sản phẩm theo nhà cung cấp

### Quản lý khách hàng
- Quản lý thông tin khách hàng
- Tạo báo giá (Quotation) cho khách hàng

### Mã giảm giá
- Tạo và quản lý mã giảm giá
- Yêu cầu giảm giá đặc biệt
- Theo dõi lịch sử sử dụng mã giảm giá

### Báo cáo và thống kê
- Báo cáo tồn kho
- Báo cáo đơn hàng
- Báo cáo doanh thu
- Lịch sử giao dịch

### Xác thực và phân quyền
- Đăng nhập/Đăng ký
- Đăng nhập bằng Google OAuth
- Phân quyền theo vai trò
- Quản lý người dùng

## 🛠 Công nghệ sử dụng

- **Backend**: Java Servlet (Jakarta EE)
- **Frontend**: JSP, HTML, CSS, JavaScript, Bootstrap
- **Database**: Microsoft SQL Server
- **Build Tool**: Apache Ant
- **Application Server**: Apache Tomcat
- **Libraries**:
  - Gson 2.10.1 (JSON processing)
  - Jakarta Mail 2.0.1 (Email)
  - Lombok 1.18.30 (Code generation)
  - JSTL (JavaServer Pages Standard Tag Library)

## 💻 Yêu cầu hệ thống

- **Java**: JDK 17 hoặc cao hơn
- **Database**: Microsoft SQL Server 2019 hoặc cao hơn
- **Application Server**: Apache Tomcat 10.x
- **IDE**: NetBeans (khuyến nghị) hoặc IntelliJ IDEA / Eclipse
- **OS**: Windows, Linux, hoặc macOS

## 📦 Cài đặt

### 1. Clone repository

```bash
git clone <repository-url>
cd Warehouse-Management
```

### 2. Cài đặt Database

1. Mở Microsoft SQL Server Management Studio (SSMS)
2. Chạy file `ISP392_DTB.sql` để tạo database và các bảng
3. Database sẽ được tạo với tên `ISP392_DTB` (hoặc `Warehouse` tùy theo script)

### 3. Cấu hình Database Connection

Chỉnh sửa file `src/java/dao/DBConnect.java`:

```java
String url = "jdbc:sqlserver://localhost:1433;databaseName=ISP392_DTB";
String username = "sa";  // Thay đổi theo cấu hình của bạn
String password = "admin";  // Thay đổi theo cấu hình của bạn
```

**Lưu ý**: File `DBConnect.java` đã được thêm vào `.gitignore` để bảo mật thông tin đăng nhập.

### 4. Cấu hình Google OAuth (Tùy chọn)

1. Tạo OAuth 2.0 credentials tại [Google Cloud Console](https://console.cloud.google.com/)
2. Thiết lập biến môi trường:

**Windows (PowerShell)**:
```powershell
$env:GOOGLE_CLIENT_ID="your-client-id"
$env:GOOGLE_CLIENT_SECRET="your-client-secret"
```

**Linux/macOS**:
```bash
export GOOGLE_CLIENT_ID="your-client-id"
export GOOGLE_CLIENT_SECRET="your-client-secret"
```

**Hoặc thiết lập vĩnh viễn trong System Environment Variables**

### 5. Build và Deploy

#### Sử dụng NetBeans:
1. Mở project trong NetBeans
2. Clean and Build project (Shift + F11)
3. Deploy lên Tomcat server

#### Sử dụng Ant (Command Line):
```bash
ant clean
ant dist
```

File WAR sẽ được tạo trong thư mục `dist/Warehouse.war`

#### Deploy thủ công:
1. Copy file `dist/Warehouse.war` vào thư mục `webapps` của Tomcat
2. Khởi động Tomcat server
3. Truy cập: `http://localhost:8080/Warehouse`

## ⚙️ Cấu hình

### Biến môi trường

| Biến | Mô tả | Bắt buộc |
|------|-------|----------|
| `GOOGLE_CLIENT_ID` | Google OAuth Client ID | Không (nếu không dùng Google Login) |
| `GOOGLE_CLIENT_SECRET` | Google OAuth Client Secret | Không (nếu không dùng Google Login) |
| `SMTP_FROM_EMAIL` | Email gửi thông báo | Không |
| `SMTP_FROM_PASSWORD` | Mật khẩu email | Không |

### Cấu hình Email (Tùy chọn)

Để gửi email thông báo, cấu hình trong `src/java/utils/NotificationUtil.java`:

```java
String smtpServer = "smtp.gmail.com";
String fromEmail = System.getenv("SMTP_FROM_EMAIL");
String fromPassword = System.getenv("SMTP_FROM_PASSWORD");
```

## 📁 Cấu trúc dự án

```
Warehouse-Management/
├── src/
│   ├── java/
│   │   ├── controller/      # Servlets xử lý request
│   │   ├── dao/             # Data Access Objects
│   │   ├── model/           # Model classes
│   │   ├── utils/           # Utility classes
│   │   ├── exception/       # Custom exceptions
│   │   └── filter/          # Servlet filters
│   └── conf/                # Configuration files
├── web/                     # Web resources (JSP, CSS, JS, images)
│   ├── admin/               # Admin pages
│   ├── manager/             # Manager pages
│   ├── sale/                # Sales staff pages
│   ├── purchase/            # Purchase staff pages
│   ├── staff/               # Warehouse staff pages
│   └── WEB-INF/             # Web configuration
├── lib/                     # External libraries (JAR files)
├── build/                   # Build output
├── dist/                    # Distribution files
├── test/                    # Test files
├── ISP392_DTB.sql           # Database schema
└── README.md                # This file
```

## 🚀 Sử dụng

### Đăng nhập

1. Truy cập: `http://localhost:8080/Warehouse/login`
2. Đăng nhập bằng username/password hoặc Google OAuth
3. Sau khi đăng nhập, bạn sẽ được chuyển đến dashboard tương ứng với vai trò

### Tạo tài khoản Admin đầu tiên

Nếu chưa có tài khoản admin, bạn có thể tạo bằng SQL:

```sql
-- Tạo user admin
INSERT INTO [User] (username, password, first_name, last_name, role_id, status)
VALUES ('admin', 'password', 'Admin', 'User', 1, 'Active');
```

**Lưu ý**: Nên hash password trước khi lưu vào database trong môi trường production.

### Set user thành Admin

```sql
UPDATE [User] 
SET role_id = 1 
WHERE username = 'username';
```

## 👥 Vai trò người dùng

| Role ID | Vai trò | Quyền hạn |
|---------|---------|-----------|
| 1 | Admin | Toàn quyền quản lý hệ thống |
| 2 | Warehouse Manager | Quản lý kho, tồn kho, báo cáo |
| 3 | Sales Staff | Quản lý đơn hàng bán, khách hàng |
| 4 | Warehouse Staff | Quản lý tồn kho, nhập/xuất hàng |
| 5 | Purchase Staff | Quản lý đơn hàng mua, nhà cung cấp |

### Phân quyền chi tiết

- **Admin**: Toàn quyền truy cập tất cả tính năng
- **Warehouse Manager**: Quản lý kho, tồn kho, báo cáo, cảnh báo
- **Sales Staff**: Quản lý đơn hàng bán, khách hàng, báo giá
- **Warehouse Staff**: Xem và cập nhật tồn kho, xử lý nhập/xuất hàng
- **Purchase Staff**: Quản lý đơn hàng mua, nhà cung cấp, RFQ

## 🗄️ Database

### Database Schema

Database chính: `ISP392_DTB` (hoặc `Warehouse`)

### Các bảng chính

- `[User]`: Thông tin người dùng
- `[Role]`: Vai trò người dùng
- `Warehouse`: Thông tin kho hàng
- `Product`: Sản phẩm
- `Inventory`: Tồn kho
- `Sales_Order`: Đơn hàng bán
- `Purchase_Order`: Đơn hàng mua
- `Supplier`: Nhà cung cấp
- `Customer`: Khách hàng
- `Stock_Adjustment`: Điều chỉnh tồn kho
- `Inventory_Transfer`: Chuyển hàng giữa các kho
- Và nhiều bảng khác...

### Câu lệnh SQL hữu ích

**Xem tất cả các bảng:**
```sql
SELECT name FROM sys.tables ORDER BY name;
```

**Xem tất cả users:**
```sql
SELECT u.*, r.role_name 
FROM [User] u 
JOIN Role r ON u.role_id = r.role_id;
```

**Xem tồn kho:**
```sql
SELECT p.product_name, i.quantity, w.warehouse_name
FROM Inventory i
JOIN Product p ON i.product_id = p.product_id
LEFT JOIN Warehouse w ON i.warehouse_id = w.warehouse_id;
```

## 🔧 Troubleshooting

### Lỗi kết nối Database

- Kiểm tra SQL Server đã khởi động chưa
- Kiểm tra thông tin đăng nhập trong `DBConnect.java`
- Kiểm tra database đã được tạo chưa
- Kiểm tra SQL Server đang lắng nghe port 1433

### Lỗi Google OAuth

- Kiểm tra biến môi trường `GOOGLE_CLIENT_ID` và `GOOGLE_CLIENT_SECRET` đã được thiết lập
- Kiểm tra Redirect URI trong Google Cloud Console khớp với URL của ứng dụng
- Xem log trong console để biết chi tiết lỗi

### Lỗi 404 - Page not found

- Kiểm tra URL pattern trong `web.xml`
- Kiểm tra servlet mapping
- Kiểm tra file JSP có tồn tại không

### Lỗi Permission Denied

- Kiểm tra user đã đăng nhập chưa
- Kiểm tra role của user có quyền truy cập tính năng không
- Xem log trong console để biết chi tiết

## 📝 Ghi chú

- File `DBConnect.java` chứa thông tin đăng nhập database, đã được thêm vào `.gitignore` để bảo mật
- Các secret (Google OAuth credentials) không được hardcode trong code, sử dụng biến môi trường
- Nên sử dụng password hashing trong môi trường production
- Database connection string có thể cần điều chỉnh tùy theo môi trường

## 📄 License

Dự án này được phát triển cho mục đích học tập (ISP392 Project).

## 👨‍💻 Tác giả

Nhóm ISP392-G3

---

**Lưu ý**: Đây là dự án học tập. Trong môi trường production, cần thực hiện các biện pháp bảo mật bổ sung như:
- Hash password
- Sử dụng HTTPS
- Validate input
- Xử lý lỗi tốt hơn
- Logging và monitoring

