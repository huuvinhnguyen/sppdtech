# =====================================================
# SPPDTECH - Git Aliases Setup
# =====================================================
# Copy các aliases bên dưới vào ~/.gitconfig
# Hoặc chạy: git config --global --edit
# =====================================================

# Đặt thông tin user (THAY ĐỔI CHO PHÙ HỢP)
[user]
    name = Your Name
    email = your-email@sppdtech.com
    initials = XX      # VD: HV cho Hùng Văn, TN cho Trọng Nghĩa

# Aliases
[alias]
    # Status ngắn gọn
    s = status -sb

    # Log đẹp
    l = log --oneline --graph --decorate -10
    ll = log --oneline --graph --decorate -20

    # Staging nhanh
    staged = diff --cached
    staged-name = diff --cached --name-only

    # Unstaged changes
    changes = diff
    changes-name = diff --name-only

    # Sync với remote
    sync = !git fetch origin && git rebase origin/develop

    # Hoàn thành feature (push lên remote)
    done = !git add -A && git commit -m \"$1\" && git push -u origin $(git symbolic-ref --short HEAD)

    # Tạo feature branch nhanh
    # Cách dùng: git feature ten-tinh-nang
    feature = checkout -b feature/${INITIALS:-$USER}/

    # Undo last commit (giữ changes)
    undo = reset --soft HEAD~1

    # Xem branch đang làm việc
    wip = log --oneline HEAD...origin/develop

    # Clean merged branches
    clean-branches = !git branch --merged | grep -v '\\*\\|main\\|develop' | xargs -r git branch -d

    # Tag release nhanh
    release = !git tag -a v$1 -m \"Release version $1\" && git push origin v$1

    # Pull rebase
    up = !git fetch origin && git rebase origin/develop

[pull]
    rebase = false

[push]
    default = current

[rebase]
    autoStash = true

# =====================================================
# CÁCH SỬ DỤNG ALIASES
# =====================================================
#
# 1. Setup (chỉ làm 1 lần):
#    cp git-aliases.md ~/.gitconfig
#    # Sửa tên và initials trong ~/.gitconfig
#
# 2. Commands thường dùng:
#
#    git s                    # Xem status nhanh
#    git l                    # Xem log đẹp
#    git sync                 # Sync code mới nhất
#    git up                   # Pull + rebase
#    git done "feat(header): thêm menu"  # Commit + push
#    git feature ten-tinh-nang            # Tạo branch mới
#    git wip                   # Xem commits chưa push
#    git undo                  # Undo commit cuối
#
# =====================================================
