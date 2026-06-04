# 🛠️ TOOLS & LIBRARIES SUMMARY
> *Danh sách các công cụ "hàng nóng" trong bộ Dotfiles này và tác dụng của chúng.*

## 1. 🚀 Core & Giao diện (Shell & Terminal)

| Tên | Vai trò trong hệ thống | Lệnh thay thế/liên quan |
| :--- | :--- | :--- |
| **Zsh + Oh-My-Zsh** | Shell mặc định, bộ khung quản lý plugin. | `source ~/.zshrc` |
| **Starship** | Dòng nhắc lệnh (Prompt) thông minh, siêu nhanh, hiển thị trạng thái Git/Node/Docker... | Tự động, thay thế `p10k` |
| **GNU Stow** | "Shipper" quản lý symlink. Giúp cài đặt dotfiles từ repo vào Home directory. | `stow -t $HOME <folder>` |
| **Zellij** | Quản lý đa nhiệm Terminal (Multiplexer). Chia màn hình, tab xịn hơn Tmux. | `zl` hoặc `zellij` |
| **Ghostty / Alacritty** | Terminal Emulator. App cửa sổ dòng lệnh siêu tốc (GPU accelerated). | (App chạy ngoài) |

## 2. ⚡ Power Tools (Hàng hiện đại thay thế lệnh cũ)

| Tên | Thay thế cho... | Tác dụng bá đạo | Lệnh tắt (Alias) |
| :--- | :--- | :--- | :--- |
| **Zoxide** | `cd` | Di chuyển thư mục thông minh. Nhớ tần suất truy cập. | `z <tên_folder>` |
| **Eza** | `ls` | Liệt kê file có màu, icon, hỗ trợ Git status. | `ls`, `ll` |
| **Bat** | `cat` | Xem nội dung file có tô màu cú pháp (Syntax highlighting). | `cat` |
| **FZF** | (Search) | Tìm kiếm mờ (Fuzzy Finder). Tìm file, lướt lịch sử lệnh cực nhanh. | `Ctrl+R` (history), `zz` |
| **Tlrc (tldr)** | `man` | Tra cứu cú pháp lệnh nhanh gọn lẹ, ví dụ trực quan thay cho man pages dài dòng. | `tldr <lệnh>` |

## 3. 🔌 Zsh Plugins (Trợ thủ đắc lực)

| Plugin | Tác dụng |
| :--- | :--- |
| **zsh-autosuggestions** | Gợi ý lệnh mờ dựa trên lịch sử đã gõ. Gõ 1 chữ, hiện cả dòng, bấm `→` để chọn. |
| **zsh-syntax-highlighting** | Tô màu lệnh ngay khi đang gõ. Lệnh đúng màu xanh, sai màu đỏ. |
| **zsh-you-should-use** | Nhắc nhở dùng Alias. Gõ `git commit...` nó sẽ bảo "Sao không dùng `gcmsg` cho nhanh?". |

## 4. 🛠️ Dev Tools (Git, Docker, Code)

| Tên | Vai trò | Lệnh tắt |
| :--- | :--- | :--- |
| **Lazygit** | Giao diện đồ họa (TUI) cho Git ngay trong terminal. Xử lý conflict, cherry-pick siêu sướng. | `lg` |
| **Lazydocker** | Quản lý Docker container/image/volume bằng giao diện trực quan. | `ld` |
| **GitHub CLI (gh)** | Tương tác với GitHub (PR, Issue, Repo) từ dòng lệnh. | `ghc` (Create PR), `ghv` (View PR) |
| **Cursor / VSCode** | Code Editor. Được alias sẵn để mở nhanh project. | `c .` (VSCode), `cc .` (Cursor) |

## 5. ⚙️ System & Tiện ích khác

| Tên | Vai trò |
| :--- | :--- |
| **Karabiner** | Remap phím (VD: Chuyển CapsLock thành Hyper Key, map phím cơ). |
| **GnuPG (GPG)** | Mã hóa, ký commit Git (Verified Commit trên GitHub). |
| **SDKMAN** | Quản lý nhiều version Java (JDK) song song. |
| **FVM** | Quản lý các version Flutter/Dart cho từng dự án. |

---
> **Mẹo:** Dùng lệnh `alias` trong terminal để xem tất cả các phím tắt đã được cấu hình sẵn cho mấy món này.
