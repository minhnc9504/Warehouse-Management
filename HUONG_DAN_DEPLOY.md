# 🚀 Hướng dẫn Deploy Hệ thống Warehouse Management lên Website

## 📋 Tổng quan

Dự án của bạn đã được cấu hình sẵn để deploy lên **Railway.app** - một nền tảng PaaS miễn phí cho phép deploy ứng dụng Java web một cách dễ dàng.

## ✅ Đã chuẩn bị sẵn

- ✅ PostgreSQL JDBC driver đã có trong `lib/`
- ✅ File cấu hình Railway (`nixpacks.toml`, `railway.json`, `Procfile`)
- ✅ DatabaseConnection đã được cấu hình để đọc từ environment variables
- ✅ Code đã được push lên GitHub

---

## 🎯 Các bước triển khai

### **Bước 1: Đăng ký tài khoản Railway**

1. Truy cập: **https://railway.app**
2. Click **"Start a New Project"** hoặc **"Login"**
3. Chọn **"Login with GitHub"**
4. Authorize Railway truy cập GitHub repositories của bạn
5. Chọn plan **"Hobby"** (miễn phí, có $5 credit/tháng)

---

### **Bước 2: Tạo Project mới trên Railway**

1. Click nút **"+ New Project"** (góc trên bên phải)
2. Chọn **"Deploy from GitHub repo"**
3. Tìm và chọn repository **"Warehouse-Management"** (hoặc tên repo của bạn)
4. Railway sẽ tự động:
   - Detect đây là Java project
   - Bắt đầu build project
   - Tạo web service

**Lưu ý:** Lần đầu build có thể mất 5-10 phút.

---

### **Bước 3: Thêm PostgreSQL Database**

1. Trong project dashboard, click nút **"+ New"** (bên trái)
2. Chọn **"Database"**
3. Chọn **"Add PostgreSQL"**
4. Railway sẽ tự động:
   - Tạo PostgreSQL database
   - Cung cấp connection string
   - Link với web service

5. Đợi vài giây để database khởi tạo xong (bạn sẽ thấy service màu xanh)

---

### **Bước 4: Kiểm tra Environment Variables**

Railway thường tự động link database với web service, nhưng hãy kiểm tra:

1. Click vào **Web Service** (service đầu tiên - thường có icon Java)
2. Vào tab **"Variables"**
3. Kiểm tra xem đã có các biến sau chưa:
   - `DATABASE_URL` (tự động từ PostgreSQL service)
   - `PGHOST`
   - `PGPORT`
   - `PGDATABASE`
   - `PGUSER`
   - `PGPASSWORD`

**Nếu chưa có**, thêm thủ công:
- Click **"New Variable"**
- Name: `DATABASE_URL`
- Value: `${{Postgres.DATABASE_URL}}` (Railway sẽ tự động thay thế)

---

### **Bước 5: Chạy Database Script**

Bạn cần import database schema vào PostgreSQL trên Railway:

#### **Cách 1: Dùng Railway Dashboard (Dễ nhất - Khuyến nghị)**

1. Vào **PostgreSQL service** (service màu xanh)
2. Click tab **"Data"** hoặc **"Query"**
3. Mở file SQL của bạn (`ISP392_DTB.sql`)
4. **Lưu ý:** Nếu file SQL là MSSQL, bạn cần convert sang PostgreSQL trước:
   - Truy cập: https://www.sqlines.com/online
   - Paste SQL script vào
   - Convert sang PostgreSQL
   - Copy kết quả

5. Paste toàn bộ SQL script vào SQL editor trên Railway
6. Click **"Run"** hoặc **"Execute"**
7. Đợi script chạy xong (có thể mất vài phút nếu script lớn)

#### **Cách 2: Dùng Railway CLI (Nâng cao)**

```bash
# Cài Railway CLI
npm i -g @railway/cli

# Login
railway login

# Link project
railway link

# Connect to database
railway connect postgres

# Sau khi connect, chạy script
psql < ISP392_DTB.sql
```

---

### **Bước 6: Kiểm tra Deployment**

1. Vào **Web Service** → tab **"Deployments"**
2. Xem logs để đảm bảo:
   - Build thành công (không có lỗi)
   - Application đã start
   - Port đã được bind

3. Nếu có lỗi:
   - Click vào deployment để xem chi tiết
   - Kiểm tra logs để tìm nguyên nhân
   - Xem phần Troubleshooting bên dưới

---

### **Bước 7: Lấy URL và Test**

1. Vào **Web Service** → tab **"Settings"**
2. Scroll xuống phần **"Domains"**
3. Railway tự tạo domain: `your-app-name.up.railway.app`
4. Click vào domain để mở trong browser
5. Test các chức năng:
   - Đăng nhập
   - Các trang admin/manager/staff
   - Kết nối database

---

### **Bước 8: Cấu hình Google OAuth (Nếu có sử dụng)**

Nếu ứng dụng của bạn có chức năng đăng nhập bằng Google:

1. Vào **Google Cloud Console**: https://console.cloud.google.com
2. Vào **APIs & Services** → **Credentials**
3. Chọn OAuth 2.0 Client ID của bạn
4. Thêm **Authorized redirect URIs**:
   ```
   https://your-app-name.up.railway.app/auth/google/callback
   ```
5. Quay lại Railway → **Web Service** → **Variables**
6. Thêm các biến:
   - `GOOGLE_CLIENT_ID` = (client ID của bạn)
   - `GOOGLE_CLIENT_SECRET` = (client secret của bạn)
7. Railway sẽ tự động restart service

---

## 🔍 Troubleshooting (Xử lý lỗi)

### **Lỗi: "Build failed"**

**Nguyên nhân có thể:**
- File `nixpacks.toml` sai format
- Ant không tìm thấy
- Thiếu dependencies

**Cách xử lý:**
1. Xem logs chi tiết trong tab "Deployments"
2. Kiểm tra file `nixpacks.toml` có đúng format không
3. Thử build local: `ant war` để kiểm tra

---

### **Lỗi: "Database connection failed"**

**Nguyên nhân có thể:**
- Environment variables chưa được set
- Database chưa được link với web service
- Database credentials sai

**Cách xử lý:**
1. Kiểm tra tab "Variables" trong web service
2. Đảm bảo PostgreSQL service đã được link
3. Xem logs để biết lỗi cụ thể
4. Thử test connection bằng cách chạy `DatabaseConnection.main()` trong logs

---

### **Lỗi: "ClassNotFoundException: org.postgresql.Driver"**

**Nguyên nhân:**
- PostgreSQL JDBC driver không có trong WAR file

**Cách xử lý:**
1. Đảm bảo `postgresql-42.7.7.jar` có trong thư mục `lib/`
2. Rebuild và redeploy:
   ```bash
   git add lib/postgresql-42.7.7.jar
   git commit -m "Add PostgreSQL driver"
   git push
   ```

---

### **App không chạy sau khi deploy**

**Nguyên nhân có thể:**
- WAR file không được tạo đúng
- Port không được bind
- Start command sai

**Cách xử lý:**
1. Kiểm tra logs trong Railway dashboard
2. Đảm bảo WAR file được tạo: `dist/Warehouse.war`
3. Kiểm tra start command trong `nixpacks.toml`
4. Railway tự động set PORT, không cần config thêm

---

### **Database script lỗi**

**Nguyên nhân:**
- SQL syntax không đúng với PostgreSQL
- Chưa convert từ MSSQL sang PostgreSQL

**Cách xử lý:**
1. Sử dụng tool convert: https://www.sqlines.com/online
2. Chạy từng phần script nếu script quá dài
3. Kiểm tra syntax PostgreSQL

---

## ✅ Checklist cuối cùng

Trước khi hoàn tất, đảm bảo:

- [ ] Đã push code lên GitHub
- [ ] Đã tạo Railway project và link GitHub repo
- [ ] Đã thêm PostgreSQL database
- [ ] Đã kiểm tra environment variables
- [ ] Đã chạy database script thành công
- [ ] Đã test app trên Railway domain
- [ ] Đã cấu hình Google OAuth (nếu cần)
- [ ] App chạy ổn định, không có lỗi

---

## 📞 Cần hỗ trợ?

- **Railway Docs**: https://docs.railway.app
- **Railway Discord**: https://discord.gg/railway
- **Xem logs**: Vào Railway dashboard → Web Service → Deployments → Click vào deployment để xem logs chi tiết

---

## 🎉 Hoàn thành!

Sau khi hoàn tất các bước trên, hệ thống của bạn sẽ:
- ✅ Chạy 24/7 trên Railway
- ✅ Tự động deploy khi push code mới lên GitHub
- ✅ Có domain riêng: `your-app-name.up.railway.app`
- ✅ Database PostgreSQL được quản lý tự động
- ✅ Có thể scale khi cần

**Chúc bạn deploy thành công! 🚀**

