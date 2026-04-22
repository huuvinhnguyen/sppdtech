# SPPDTECH Workflow - Team 2 người

## 1. Git Workflow

### 1.1 Branching Strategy (Đơn giản)

```
main          ← Nhánh production (chỉ merge khi test OK)
    ↑
feature/*     ← Nhánh tính năng
hotfix/*      ← Nhánh sửa lỗi khẩn cấp
```

**Quy tắc đặt tên branch:**

| Loại | Format | Ví dụ |
|------|--------|-------|
| Tính năng | `feature/HV-ten-tinh-nang` | `feature/HV-them-trang-gioi-thieu` |
| Sửa lỗi | `hotfix/HV-ten-loi` | `hotfix/HV-sua-loi-slider` |
| Chore | `chore/HV-ten-cong-viec` | `chore/HV-update-blocksy-2.1.40` |

### 1.2 Commit Message Convention

```
<type>(<scope>): <mô tả ngắn>

[body]

[footer]
```

**Types:**

| Type | Mục đích |
|------|----------|
| `feat` | Tính năng mới |
| `fix` | Sửa lỗi |
| `docs` | Chỉ thay đổi documentation |
| `style` | Format code, không thay đổi logic |
| `refactor` | Tái cấu trúc code |
| `perf` | Cải thiện performance |
| `test` | Thêm/sửa tests |
| `chore` | Công việc bảo trì, dependencies |

**Ví dụ:**

```bash
# Tốt
git commit -m "feat(header): thêm menu mobile responsive"
git commit -m "fix(slider): sửa lỗi không hiển thị ảnh trên Safari"
git commit -m "chore: cập nhật Blocksy theme lên 2.1.40"

# Không tốt
git commit -m "update code"
git commit -m "fix bug"
git commit -m "thêm cái này cái kia"
```

### 1.3 Git Operations Flow

#### Bắt đầu tính năng mới:

```bash
# Luôn bắt đầu từ main mới nhất
git checkout main
git pull origin main

# Tạo branch mới (thay HV bằng initials của bạn)
git checkout -b feature/HV-them-trang-gioi-thieu
```

#### Trong quá trình làm:

```bash
# Thường xuyên sync với main (rebase)
git fetch origin
git rebase origin/main

# Commit thay đổi (commit nhỏ, commit thường xuyên)
git add .
git commit -m "feat(about): tạo template trang giới thiệu"
```

#### Hoàn thành tính năng:

```bash
# 1. Rebase lần cuối để đảm bảo code mới nhất
git fetch origin
git rebase origin/main

# 2. Push branch lên remote
git push -u origin feature/HV-them-trang-gioi-thieu

# 3. Tạo Pull Request (PR) qua GitHub
#    GitHub → Pull Requests → New Pull Request → base: main
```

#### Deploy lên Production (sau khi test OK):

```bash
# 1. GitHub: Squash merge PR vào main

# 2. Hostinger: Pull main
ssh -p 65002 u200682234@185.187.241.39
cd ~/domains/sppdtech.com/public_html
git pull origin main

# 3. Xóa branch đã merge
git branch -d feature/HV-them-trang-gioi-thieu
git push origin --delete feature/HV-them-trang-gioi-thieu
```

### 1.4 Pull Request (PR) Process

**Review checklist trước khi tạo PR:**

- [ ] Code đã được test local
- [ ] Không có conflict với develop
- [ ] Đã chạy `npm run build` thành công
- [ ] Commit messages tuân thủ convention
- [ ] Mô tả PR rõ ràng

**PR Template:**

```markdown
## Mô tả
[Mô tả ngắn gọn tính năng/thay đổi]

## Loại thay đổi
- [ ] Tính năng mới
- [ ] Sửa lỗi
- [ ] Refactor
- [ ] Cập nhật giao diện

## Checklist
- [ ] Đã test trên local
- [ ] Không ảnh hưởng tính năng khác
- [ ] Đã cập nhật docs nếu cần

## Screenshots (nếu có thay đổi UI)
[Ảnh chụp màn hình]
```

### 1.5 Merge Strategy

```
feature/*  →  main   (Squash merge - gom commits lại)
hotfix/*   →  main   (Squash merge - fix nhanh)
```

**Quy tắc:**
- **Squash merge** cho feature/hotfix → main
- **KHÔNG BAO GIỜ** push trực tiếp lên main
- **LUÔN LUÔN** test trên production trước khi merge

### 1.6 Emergency Hotfix Process

```bash
# 1. Tạo hotfix branch từ main
git checkout main
git pull origin main
git checkout -b hotfix/HV-sua-loi-slider-crash

# 2. Fix nhanh
git commit -m "fix(slider): ngăn crash khi ảnh null"

# 3. Test nhanh trên local

# 4. Push và test trên production
git push -u origin hotfix/HV-sua-loi-slider-crash

# 5. SSH Hostinger test
ssh -p 65002 u200682234@185.187.241.39
cd ~/domains/sppdtech.com/public_html
git checkout hotfix/HV-sua-loi-slider-crash
git pull origin hotfix/HV-sua-loi-slider-crash

# 6. OK → GitHub squash merge → pull main
```

---

## 2. Development Environment

### 2.1 Cài đặt Local

```bash
# Clone repo
git clone git@github.com:huuvinhnguyen/sppdtech.git

# Di chuyển vào thư mục
cd sppdtech

# Cài đặt dependencies
npm install

# Development mode (watch + live reload)
npm run dev

# Production build
npm run build
```

### 2.2 WordPress Local Development

Đề xuất sử dụng **Local by Flywheel** hoặc **Docker** để chạy WordPress local:

```
# Cấu trúc thư mục đề xuất
sppdtech-local/
├── wp-content/
│   ├── themes/
│   │   └── blocksy/      ← Clone repo vào đây
│   └── plugins/
│       └── vnf-slideshow/ ← Custom plugin
├── database/
└── conf/
```

### 2.3 Development Rules

**Frontend (Blocksy Theme):**

- Chỉnh sửa files trong `wp-content/themes/blocksy/static/sass/`
- Không sửa trực tiếp files trong `static/bundle/` (sẽ bị ghi đè khi build)
- Sử dụng CSS variables từ `theme.json`

**Custom Plugin (`vnf-slideshow`):**

- Tất cả PHP files trong `wp-content/plugins/vnf-slideshow/`
- Theo WordPress plugin coding standards

---

## 3. Deployment & Testing Workflow

### 3.1 Kiến trúc môi trường

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           TEAM 2 NGƯỜI                                  │
│                                                                         │
│   ┌──────────────┐     ┌──────────────┐     ┌──────────────────────┐ │
│   │   Dev A      │     │   Dev B      │     │   GitHub              │ │
│   │   (Local)    │────▶│   (Local)    │────▶│   Pull Request        │ │
│   └──────────────┘     └──────────────┘     └──────────────────────┘ │
│          │                                         │                   │
│          │                    ┌────────────────────┘                   │
│          │                    │                                        │
│          ▼                    ▼                                        │
│   ┌─────────────────────────────────────────────────────────────┐      │
│   │                 HOSTINGER (Production)                       │      │
│   │                                                             │      │
│   │   /domains/sppdtech.com/public_html/                        │      │
│   │   ├── main           ← Nhánh sạch, production-ready         │      │
│   │   └── feature/*     ← Test trực tiếp tại đây               │      │
│   │                                                             │      │
│   │   SSH: ssh -p 65002 u200682234@185.187.241.39               │      │
│   │   Panel: https://hpanel.hostinger.com/                      │      │
│   │                                                             │      │
│   └─────────────────────────────────────────────────────────────┘      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.2 QUY TRÌNH CHÍNH (Test Direct Production)

```
┌─────────────────────────────────────────────────────────────────────┐
│  BƯỚC 1: Dev A làm feature trên Local                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  # Checkout từ main và tạo branch mới                              │
│  git checkout main                                                  │
│  git pull origin main                                               │
│  git checkout -b feature/HV-them-trang-about                        │
│                                                                     │
│  # Làm việc và commit                                              │
│  git add .                                                          │
│  git commit -m "feat(about): tạo trang giới thiệu"                  │
│                                                                     │
│  # Push lên GitHub                                                 │
│  git push -u origin feature/HV-them-trang-about                     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│  BƯỚC 2: Dev A/B tạo Pull Request trên GitHub                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  # GitHub → Pull Requests → New Pull Request                        │
│  # base: main ← compare: feature/HV-them-trang-about               │
│  # Điền mô tả, assign reviewer                                      │
│                                                                     │
│  ⚠️ CHƯA merge - chờ test trên production                          │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│  BƯỚC 3: SSH Hostinger → Switch sang branch mới → Test Production   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  # SSH vào server                                                  │
│  ssh -p 65002 u200682234@185.187.241.39                            │
│                                                                     │
│  # Di chuyển đến thư mục website                                   │
│  cd ~/domains/sppdtech.com/public_html                              │
│                                                                     │
│  # Switch sang branch cần test                                      │
│  git fetch origin                                                  │
│  git checkout feature/HV-them-trang-about                          │
│  git pull origin feature/HV-them-trang-about                      │
│                                                                     │
│  # Test trên sppdtech.com                                          │
│  # - Homepage                                                       │
│  # - Trang mới                                                      │
│  # - Forms, navigation, responsive                                  │
│  # - Test trên mobile thật                                         │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┴───────────────┐
              │                               │
              ▼                               ▼
    ┌─────────────────────┐       ┌─────────────────────┐
    │  ✅ KHÔNG CÓ LỖI    │       │  ❌ CÓ LỖI         │
    └─────────────────────┘       └─────────────────────┘
              │                               │
              ▼                               ▼
┌─────────────────────────────┐   ┌─────────────────────────────────────┐
│  BƯỚC 4A: Release          │   │  BƯỚC 4B: Fix & Retest              │
├─────────────────────────────┤   ├─────────────────────────────────────┤
│                             │   │                                     │
│  4A.1 GitHub: Merge PR     │   │  4B.1 Quay lại local                │
│     Squash and merge       │   │     git checkout feature/HV-them-trang-about │
│                             │   │                                     │
│  4A.2 Hostinger: Switch    │   │  4B.2 Fix lỗi                       │
│     về main                │   │     git add .                      │
│     cd ~/domains/sppdtech.com/public_html │   │     git commit -m "fix(about): sửa layout"        │
│     git checkout main       │   │                                     │
│     git pull origin main   │   │  4B.3 Push lên GitHub                │
│                             │   │     git push origin feature/HV-them-trang-about  │
│  4A.3 Clear LiteSpeed      │   │                                     │
│     Cache                  │   │  4B.4 Quay lại BƯỚC 3               │
│     hPanel → Cache → Purge │   │     SSH Hostinger → pull branch mới │
│                             │   │     Test lại trên production        │
│  ✅ HOÀN THÀNH!            │   │                                     │
│                             │   │  Lặp lại cho đến khi không có lỗi  │
└─────────────────────────────┘   └─────────────────────────────────────┘
```

### 3.3 Chi tiết từng Bước

#### Bước 1: Setup & Commit (Dev A)

```bash
# 1. Đảm bảo main mới nhất
git checkout main
git pull origin main

# 2. Tạo branch mới (thay HV bằng initials của bạn)
git checkout -b feature/HV-them-trang-about

# 3. Làm feature và commit
git add .
git commit -m "feat(about): tạo template trang giới thiệu"
git commit -m "style(about): thêm CSS responsive"

# 4. Push lên remote
git push -u origin feature/HV-them-trang-about
```

#### Bước 2: Tạo Pull Request

```
GitHub → Pull Requests → New Pull Request

Base: main
Compare: feature/HV-them-trang-about

Điền:
- Title: feat(about): thêm trang giới thiệu
- Description: (dùng PR template)
- Reviewer: [Dev B]
```

#### Bước 3: Test trên Production

```bash
# SSH vào Hostinger
ssh -p 65002 u200682234@185.187.241.39

# Di chuyển đến website
cd ~/domains/sppdtech.com/public_html

# Kiểm tra branch hiện tại
git branch

# Fetch tất cả branches mới
git fetch origin

# Switch sang branch cần test
git checkout feature/HV-them-trang-about
git pull origin feature/HV-them-trang-about

# Clear LiteSpeed cache (tùy chọn)
# hPanel → LiteSpeed Cache → Purge All

# Test trên trình duyệt: https://sppdtech.com
```

#### Bước 4A: Release (không lỗi)

```bash
# Trên GitHub:
# 1. Review PR → Approve
# 2. Squash and merge

# Trên Hostinger:
cd ~/domains/sppdtech.com/public_html

# Switch về main
git checkout main
git pull origin main

# Clear cache
# hPanel → LiteSpeed Cache → Purge All

# ✅ Website đã update!
```

#### Bước 4B: Fix & Retest (có lỗi)

```bash
# Quay lại máy local
git checkout feature/HV-them-trang-about

# Fix lỗi
git add .
git commit -m "fix(about): sửa lỗi padding trên mobile"

# Push lên GitHub
git push origin feature/HV-them-trang-about

# Quay lại Hostinger test lại
ssh -p 65002 u200682234@185.187.241.39
cd ~/domains/sppdtech.com/public_html
git pull origin feature/HV-them-trang-about

# Test lại → Lặp cho đến khi OK
```

### 3.4 Backup & Rollback

**Backup trước khi test:**

```bash
# Trên Hostinger - Backup nhanh
cd ~/domains/sppdtech.com
cp -r public_html public_html.backup.$(date +%Y%m%d_%H%M%S)

# Xem các backup
ls -la | grep backup
```

**Rollback nếu cần:**

```bash
# Trên Hostinger
cd ~/domains/sppdtech.com

# Xem các commit gần đây
git log --oneline -5

# Rollback về commit trước (nếu cần)
git reset --hard HEAD~1
git push --force origin main

# Hoặc khôi phục từ backup
rm -rf public_html
mv public_html.backup.DATE public_html
```

### 3.5 Git Aliases cho workflow nhanh

```bash
# Thêm vào ~/.gitconfig

[alias]
    # Bắt đầu feature nhanh
    start = checkout main && git pull origin main && git checkout -b feature/HV-

    # Test trên production (sau khi push)
    test-prod = !echo "ssh -p 65002 u200682234@185.187.241.39" && echo "cd ~/domains/sppdtech.com/public_html && git pull origin $(git symbolic-ref --short HEAD)"

    # Hoàn thành feature (merge và release)
    done = checkout main && git merge --squash HEAD && git push origin main && echo "Ready to deploy on Hostinger"
```

---

## 4. Task Management

### 4.1 Quy trình làm việc

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   BACKLOG   │───▶│  IN PROGRESS │───▶│   REVIEW    │───▶│    DONE     │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

**Trạng thái task:**

| Trạng thái | Ý nghĩa |
|------------|---------|
| Backlog | Chưa bắt đầu, ưu tiên thấp |
| Ready | Sẵn sàng bắt đầu, đã clarified |
| In Progress | Đang làm |
| Review | Đang chờ review |
| Done | Hoàn thành |

### 4.2 Daily Standup (15 phút)

Mỗi ngày, cả team check-in:

**Mỗi người trả lời:**
1. Hôm qua đã làm gì?
2. Hôm nay sẽ làm gì?
3. Có blocker gì không?

### 4.3 Weekly Planning (30 phút - Thứ 2)

- Review sprint trước
- Plan sprint mới (2 tuần)
- Gán tasks cho từng người

---

## 5. Communication

### 5.1 Channels

| Kênh | Mục đích |
|------|----------|
| GitHub Issues | Task tracking, bug reports |
| Pull Requests | Code review |
| Discord/Slack | Chat nhanh |
| Meeting | Thảo luận phức tạp |

### 5.2 Notification Rules

**GitHub:**
- Assignee khi có PR cần review
- Mention khi cần feedback

**Chat:**
- `@all` chỉ khi thông báo quan trọng toàn team
- Reply thread để tránh loãng

---

## 6. Code Quality

### 6.1 PHP Standards

Sử dụng **WordPress Coding Standards**:

```bash
# Cài đặt
composer global require wp-coding-standards/wpcs

# Chạy check
phpcs --standard=WordPress wp-content/plugins/vnf-slideshow/
```

### 6.2 JavaScript

- ES6+ syntax
- ESLint với WordPress config

### 6.3 Pre-commit Hook

Thiết lập pre-commit để tự động:

```bash
# Cài husky
npm install husky --save-dev

# Cài lint-staged
npm install lint-staged --save-dev
```

---

## 7. Checklist cho mỗi tính năng

### Trước khi bắt đầu:
- [ ] Đã tạo branch từ `develop`
- [ ] Đã ghi ticket vào task board
- [ ] Đã hiểu rõ yêu cầu

### Trong quá trình:
- [ ] Commit nhỏ, commit thường xuyên
- [ ] Mỗi commit nên test được

### Trước khi submit PR:
- [ ] Test trên local
- [ ] `npm run build` thành công
- [ ] Rebase với `develop`
- [ ] Không có console errors
- [ ] Responsive trên mobile

### Sau khi merge:
- [ ] Xóa branch đã merge
- [ ] Update task status
- [ ] Thông báo cho team

---

## 8. Troubleshooting

### Git Conflict

```bash
# Khi có conflict khi rebase
git rebase origin/develop

# Sau khi resolve conflict
git add .
git rebase --continue

# Nếu muốn hủy rebase
git rebase --abort
```

### Reset local changes

```bash
# Hủy thay đổi chưa commit
git checkout -- .

# Reset về commit cuối
git reset --hard HEAD
```

---

## Phụ lục: GitHub Actions CI/CD (Tương lai)

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main, develop]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install & Build
        run: |
          npm ci
          npm run build

      - name: Deploy to Staging
        if: github.ref == 'refs/heads/develop'
        run: echo "Deploy to staging"

      - name: Deploy to Production
        if: github.ref == 'refs/heads/main'
        run: echo "Deploy to production"
```
