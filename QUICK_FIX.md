# ⚡ Hướng dẫn nhanh xử lý Secret Issue

## ✅ Đã sửa code

Tôi đã sửa 2 file để đọc từ environment variables:
- ✅ `GoogleCallbackServlet.java` 
- ✅ `GoogleLoginServlet.java`

## 🚀 Các bước tiếp theo (Làm ngay)

### Bước 1: Commit code đã sửa

```bash
git add src/java/controller/authentication/GoogleCallbackServlet.java
git add src/java/controller/authentication/GoogleLoginServlet.java
git commit -m "Remove hardcoded Google OAuth credentials - use environment variables"
```

### Bước 2: Xử lý Secret đã bị commit

**Option A: Bypass và push (Nhanh, nhưng secret vẫn còn trong history)**

1. Trong GitHub Desktop, click **"Bypass"** cho cả 2 secrets
2. Click **"Ok"**
3. Push sẽ thành công

⚠️ **Lưu ý:** Secret vẫn còn trong Git history, cần xóa sau.

**Option B: Xóa khỏi history trước (An toàn hơn)**

```bash
# Xóa file khỏi history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch src/java/controller/authentication/GoogleCallbackServlet.java" \
  --prune-empty --tag-name-filter cat -- --all

# Force push
git push origin --force --all
```

Sau đó commit code mới (đã sửa).

### Bước 3: Thu hồi Secret cũ trên Google Cloud Console

1. Truy cập: https://console.cloud.google.com
2. **APIs & Services** → **Credentials**
3. Tìm OAuth 2.0 Client ID
4. **XÓA Client Secret cũ** hoặc tạo mới
5. Lưu Client ID và Secret mới

### Bước 4: Cấu hình Environment Variables

#### Trên Railway (khi deploy):
- `GOOGLE_CLIENT_ID` = (Client ID mới)
- `GOOGLE_CLIENT_SECRET` = (Client Secret mới)

#### Local development:
Set trong system environment variables hoặc IDE run configuration.

## 📝 Checklist

- [ ] Đã commit code mới (không có secret hardcode)
- [ ] Đã xử lý secret trong Git history (Bypass hoặc xóa)
- [ ] Đã thu hồi secret cũ trên Google Cloud Console
- [ ] Đã tạo Client ID/Secret mới
- [ ] Đã cấu hình environment variables (Railway/local)

## ⚠️ Quan trọng

1. **Secret cũ đã bị lộ** → Phải thu hồi ngay trên Google Cloud Console
2. **Git history** → Nếu repo public, secret đã bị lộ, cần xóa khỏi history
3. **Local dev** → Code vẫn có fallback cho local, nhưng không commit secret

---

**Bây giờ bạn có thể push code lên GitHub!** 🎉

