# SPPDTECH - Quick Start Guide

## 🚀 QUICK START (5 phút)

### Workflow: Test Direct Production

```
Local → Push branch → GitHub PR → SSH Hostinger Test → Merge → Release
```

### Chi tiết từng bước

#### 1️⃣ Bắt đầu feature mới

```bash
# Clone repo (lần đầu)
git clone git@github.com:huuvinhnguyen/sppdtech.git
cd sppdtech

# Tạo branch mới (thay HV bằng initials của bạn)
git checkout -b feature/HV-them-trang-about

# Làm feature và commit
git add .
git commit -m "feat(about): tạo trang giới thiệu"

# Push lên GitHub
git push -u origin feature/HV-them-trang-about
```

#### 2️⃣ Tạo Pull Request

```
GitHub → Pull Requests → New Pull Request
base: main
compare: feature/HV-them-trang-about
```

#### 3️⃣ Test trên Production

```bash
# SSH vào Hostinger
ssh -p 65002 u200682234@185.187.241.39

# Di chuyển đến website
cd ~/domains/sppdtech.com/public_html

# Switch sang branch cần test
git fetch origin
git checkout feature/HV-them-trang-about
git pull origin feature/HV-them-trang-about

# Test trên: https://sppdtech.com
```

#### 4️⃣ Release (nếu OK) HOẶC Fix (nếu lỗi)

**Nếu KHÔNG lỗi:**
```bash
# GitHub: Squash and merge PR
# Hostinger: Switch về main
git checkout main
git pull origin main
```

**Nếu CÓ lỗi:**
```bash
# Quay lại local → fix → push
git checkout feature/HV-them-trang-about
git commit -m "fix(about): sửa lỗi"
git push origin feature/HV-them-trang-about

# Quay lại Hostinger → pull → test lại
git pull origin feature/HV-them-trang-about
```

---

## 📁 Cấu trúc thư mục

```
wp-content/themes/blocksy/
├── static/sass/     ← Sửa SCSS ở đây
├── static/bundle/  ← Generated (KHÔNG sửa)
├── inc/             ← PHP logic
└── functions.php    ← Theme functions
```

---

## 🎯 Naming Conventions

| Loại | Format | Ví dụ |
|------|--------|-------|
| Branch | `feature/HV-ten` | `feature/HV-them-trang-about` |
| Commit | `feat(scope): mô tả` | `feat(header): thêm mega menu` |

---

## 🔧 Commands thường dùng

```bash
# Sync code mới nhất
git fetch origin && git rebase origin/main

# Xem branch hiện tại
git branch

# Xem status
git status

# Undo thay đổi
git checkout -- .
```

---

## ⚠️ Lưu ý Quan Trọng

1. **KHÔNG sửa file trong `static/bundle/`** - Sẽ bị ghi đè khi build
2. **LUÔN test trên production** trước khi merge vào main
3. **Backup nếu cần:**
   ```bash
   cp -r public_html public_html.backup.$(date +%Y%m%d)
   ```

---

## 🆘 Troubleshooting

### Lỗi git conflict
```bash
git rebase --abort  # Hủy rebase
```

### Lỗi build
```bash
rm -rf node_modules package-lock.json
npm install
npm run build
```

### Rollback production
```bash
cd ~/domains/sppdtech.com
git checkout main
git pull origin main
```

---

## 📞 Thông tin Server

- **SSH:** `ssh -p 65002 u200682234@185.187.241.39`
- **Panel:** https://hpanel.hostinger.com/
- **Website:** https://sppdtech.com
- **Repo:** https://github.com/huuvinhnguyen/sppdtech
