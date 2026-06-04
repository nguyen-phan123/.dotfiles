# 🛠️ TOOLS & ALIASES QUICK REFERENCE

> [!TIP]
> Bảng tra cứu toàn diện về các công cụ phát triển và phím tắt (aliases) được tích hợp trong bộ Dotfiles. 

---

## 🚀 1. Core Shell & Terminal (Giao diện dòng lệnh)

| Công cụ | Vai trò hệ thống | Phím tắt / Lệnh liên quan |
| :--- | :--- | :--- |
| **Zsh + Oh-My-Zsh** | Shell mặc định và quản lý plugin. | `zz` (tương đương `source ~/.zshrc`) |
| **Starship** | Prompt thông minh hiển thị trạng thái Git/Node/Docker... | Tự động tải |
| **GNU Stow** | Quản lý symlinks cấu hình từ repo vào thư mục `$HOME`. | `stow -t $HOME <package>` |
| **Zellij** | Quản lý đa nhiệm Terminal. Chia màn hình, tab xịn hơn tmux. | `zl` hoặc `zellij` |
| **Ghostty / Alacritty** | Terminal Emulator hỗ trợ tăng tốc đồ họa GPU. | Ứng dụng độc lập |

---

## ⚡ 2. Modern CLI Alternatives (Thay thế lệnh Unix cũ)

| Công cụ | Thay thế | Tính năng nổi bật | Phím tắt (Alias) |
| :--- | :--- | :--- | :--- |
| **Zoxide** | `cd` | Nhảy đến thư mục thông minh dựa trên lịch sử. | `z <tên_thư_mục>` |
| **Eza** | `ls` | Liệt kê file đẹp mắt kèm icon và trạng thái Git. | `ls` (danh sách), `ll` (chi tiết) |
| **Bat** | `cat` | Xem nội dung file kèm tô màu cú pháp (Syntax Highlight).| `cat` |
| **FZF** | Search | Tìm kiếm mờ (Fuzzy Finder) lịch sử lệnh hoặc file. | `Ctrl+R` |
| **Tlrc (tldr)** | `man` | Tra cứu cú pháp lệnh ngắn gọn kèm ví dụ trực quan. | `h <lệnh>` |

---

## 📂 3. Navigation & File System Aliases (Di chuyển nhanh)

| Alias | Lệnh gốc | Tác dụng |
| :--- | :--- | :--- |
| `t` | `tree` | Hiển thị cây thư mục trực quan. |
| `w` | `cd ~/workspace` | Nhảy nhanh vào thư mục Workspace. |
| `p` | `cd ~/personal` | Nhảy nhanh vào thư mục Personal. |
| `cdw` | custom script | Nhảy nhanh vào một project cụ thể trong Workspace qua `fzf`. |
| `cdp` | custom script | Nhảy nhanh vào một project cụ thể trong Personal qua `fzf`. |

---

## 📝 4. Editor Aliases (Trình soạn thảo)

| Alias | Lệnh gốc | Tác dụng |
| :--- | :--- | :--- |
| `c` | `code` | Mở VSCode. |
| `c .` | `code .` | Mở VSCode tại thư mục hiện tại. |
| `ci` | `code-insiders` | Mở VSCode Insiders. |
| `cc` | `cursor` | Mở Cursor AI Editor. |
| `cc .` | `cursor .` | Mở Cursor tại thư mục hiện tại. |
| `lvim` | `lunarvim` | Mở LunarVim. |

---

## 🐙 5. Git & GitHub CLI

| Alias | Lệnh gốc / Loại | Tác dụng |
| :--- | :--- | :--- |
| **`lg`** | `lazygit` | **Giao diện Git TUI cực mạnh trong Terminal (Khuyên dùng).** |
| `gb` | `fzf` script | Tìm và checkout nhanh giữa các local branch. |
| `gbd` | `fzf` script | Tìm và XÓA nhanh branch qua giao diện tìm kiếm mờ. |
| `gt` | `fzf` script | Chọn và checkout nhanh Git tag. |
| `glc` | function | So sánh logs giữa 2 commits lựa chọn ngẫu nhiên. |
| `ghc` | `gh pr create --web` | Tạo Pull Request trực tiếp trên giao diện web GitHub. |
| `ghv` | `gh pr view --web` | Xem Pull Request hiện hành trên web. |
| `ghdb` | `gh dash` | Mở dashboard GitHub quản lý PR/Issue cá nhân. |

---

## 🐳 6. Docker & DevOps

| Alias | Lệnh gốc / Loại | Tác dụng |
| :--- | :--- | :--- |
| **`ld`** | `lazydocker` | **Giao diện quản lý Docker TUI trực quan (Khuyên dùng).** |
| `dcs` | script | Dừng (Stop) toàn bộ các container đang chạy. |
| `dcd` | script | Xóa hoàn toàn (Remove) các containers đã dừng. |
| `tf` | `terraform` | Phím tắt cho Terraform CLI. |
| `tfa`, `tfp`...| `apply / plan` | Lệnh tắt cho Terraform Apply, Plan, Init... |

---

## 📱 7. Flutter & Mobile Development

| Alias | Lệnh gốc | Tác dụng |
| :--- | :--- | :--- |
| `f` | `fvm flutter` | Chạy lệnh Flutter thông qua Flutter Version Manager. |
| `d` | `fvm dart` | Chạy lệnh Dart thông qua FVM. |
| `frun-pos` | Run Flavor | Chạy ứng dụng bản POS Development. |
| `frun-otm` | Run Flavor | Chạy ứng dụng bản OTM Release. |
| `fintl` | `intl_utils` | Tự động sinh file localization. |
| `fbgen` | `build_runner` | Chạy build runner tự động giải quyết conflict sinh code. |

---

## 📦 8. Package Managers (NPM, Yarn, PNPM)

| Alias | Lệnh gốc / Loại | Tác dụng |
| :--- | :--- | :--- |
| `n` | `npm` | Chạy npm package manager. |
| `y` | `yarn` | Chạy yarn package manager. |
| `pn` | `pnpm` | Chạy pnpm package manager. |
| **`s`** | `fzf` script | **Tìm và chạy nhanh các scripts định nghĩa trong `package.json`.** |
| `ns`, `ys` | `npm/yarn run` | Chạy các scripts bằng NPM hoặc Yarn nhanh gọn. |

---

## 🔌 9. Zsh Plugins & Tiện ích hệ thống

*   **zsh-autosuggestions**: Gợi ý lệnh mờ dựa trên lịch sử gõ (bấm phím mũi tên `→` để chọn nhanh).
*   **zsh-syntax-highlighting**: Tô màu cú pháp lệnh trực tiếp khi gõ (Lệnh hợp lệ màu xanh, lệnh lỗi màu đỏ).
*   **zsh-you-should-use**: Nhắc nhở sử dụng alias thay vì gõ lệnh dài.
*   **Karabiner**: Remap phím hệ thống (như chuyển `CapsLock` thành `Hyper Key`).
*   **GnuPG (GPG)**: Ký xác thực commits trên GitHub (**Verified Commit**).
*   **SDKMAN**: Quản lý nhiều phiên bản Java (JDK) song song.

---

> [!IMPORTANT]
> Toàn bộ Aliases được cấu hình và quản lý tại file mã nguồn: [shell/zsh/.zsh_profile](file:///Users/diqit/Documents/GitHub/config/dotfiles/shell/zsh/.zsh_profile)
