# 🔒 Hướng dẫn xử lý Secret bị phát hiện trên GitHub

## ✅ Đã sửa code

Tôi đã sửa 2 file để đọc Google OAuth credentials từ environment variables:
- `GoogleCallbackServlet.java` - Đã sửa
- `GoogleLoginServlet.java` - Đã sửa

## ⚠️ QUAN TRỌNG: Secret đã bị commit vào Git history

Vì secret đã được commit trước đó, bạn cần:

### Bước 1: Thu hồi Secret cũ trên Google Cloud Console

1. Truy cập: https://console.cloud.google.com
2. Vào **APIs & Services** → **Credentials**
3. Tìm OAuth 2.0 Client ID của bạn
4. **XÓA Client Secret cũ** (hoặc tạo Client ID/Secret mới)
5. Lưu Client ID và Secret mới để dùng sau

### Bước 2: Xóa secret khỏi Git history

Có 2 cách:

#### Cách 1: Sử dụng git filter-branch (Đơn giản)

```bash
# Xóa file chứa secret khỏi toàn bộ history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch src/java/controller/authentication/GoogleCallbackServlet.java" \
  --prune-empty --tag-name-filter cat -- --all

# Force push (CẢNH BÁO: Sẽ rewrite history)
git push origin --force --all
```

#### Cách 2: Sử dụng BFG Repo-Cleaner (Khuyến nghị)

1. Tải BFG: https://rtyley.github.io/bfg-repo-cleaner/
2. Chạy:
```bash
java -jar bfg.jar --replace-text passwords.txt src/java/controller/authentication/GoogleCallbackServlet.java
git reflog expire --expire=now --all
git gc --prune=now --aggressive
git push origin --force --all
```

#### Cách 3: Tạo repository mới (Dễ nhất, nhưng mất history)

```bash
# Tạo branch mới không có secret
git checkout --orphan clean-main
git add .
git commit -m "Remove secrets from code"
git branch -D main
git branch -m main
git push -f origin main
```

### Bước 3: Commit code mới (đã sửa)

```bash
# Add các file đã sửa
git add src/java/controller/authentication/GoogleCallbackServlet.java
git add src/java/controller/authentication/GoogleLoginServlet.java

# Commit
git commit -m "Remove hardcoded Google OAuth credentials - use environment variables"

# Push
git push origin main
```

### Bước 4: Cấu hình Environment Variables

#### Trên Railway (khi deploy):

1. Vào **Web Service** → **Variables**
2. Thêm:
   - `GOOGLE_CLIENT_ID` = (Client ID mới của bạn)
   - `GOOGLE_CLIENT_SECRET` = (Client Secret mới của bạn)

#### Local development:

Tạo file `.env` (không commit vào Git):

```bash
GOOGLE_CLIENT_ID=your-client-id-here
GOOGLE_CLIENT_SECRET=your-client-secret-here
```

Hoặc set trong IDE/System environment variables.

### Bước 5: Cập nhật .gitignore

Đảm bảo `.gitignore` có:
```
.env
*.env
src/java/dao/DBConnect.java
```

## 🎯 Checklist

- [ ] Đã thu hồi secret cũ trên Google Cloud Console
- [ ] Đã tạo Client ID/Secret mới
- [ ] Đã xóa secret khỏi Git history (chọn 1 trong 3 cách trên)
- [ ] Đã commit code mới (không có secret)
- [ ] Đã push lên GitHub
- [ ] Đã cấu hình environment variables trên Railway
- [ ] Đã test app hoạt động với env vars

## ⚠️ Lưu ý

1. **Secret cũ đã bị lộ** - Phải thu hồi ngay trên Google Cloud Console
2. **Git history** - Nếu repo là public, secret đã bị lộ, cần xóa khỏi history
3. **Force push** - Sẽ ảnh hưởng đến người khác nếu có collaborator
4. **Local development** - Vẫn có thể dùng hardcode fallback cho local (nhưng không commit)

## 📚 Tài liệu tham khảo

- GitHub Secret Scanning: https://docs.github.com/en/code-security/secret-scanning
- BFG Repo-Cleaner: https://rtyley.github.io/bfg-repo-cleaner/
- Git filter-branch: https://git-scm.com/docs/git-filter-branch

