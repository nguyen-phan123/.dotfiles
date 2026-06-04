# ⌨️ ALIAS CHEAT SHEET
> *Bảng cửu chương phím tắt cho anh em Coder. Học thuộc lòng hoặc tra cứu nhanh.*

## 1. 📂 Navigation & File System (Đi lại & Quản lý file)

| Alias | Lệnh gốc | Tác dụng |
| :--- | :--- | :--- |
| `z <tên>` | `zoxide` | Nhảy đến thư mục thông minh (VD: `z agent` -> tự vào `agent-kit`). |
| `ls` | `eza --icons --git` | Liệt kê file đẹp, có icon. |
| `ll` | `eza -al --icons --git` | Liệt kê chi tiết (full option). |
| `cat` | `bat` | Xem file nội dung file (có màu). |
| `t` | `tree` | Xem cây thư mục. |
| `w` | `cd ~/workspace` | Về thư mục Workspace. |
| `p` | `cd ~/personal` | Về thư mục Personal. |
| `wui`, `wa`... | (Thư mục cụ thể) | Shortcut vào các dự án cụ thể (Check `.zsh_profile` để sửa). |

## 2. 📝 Editor (Soạn thảo)

| Alias | Lệnh gốc | Tác dụng |
| :--- | :--- | :--- |
| `c` | `code` | Mở VSCode. |
| `c .` | `code .` | Mở VSCode tại thư mục hiện tại. |
| `ci` | `code-insiders` | Mở VSCode Insiders. |
| `cc` | `cursor` | Mở Cursor AI Editor. |
| `cc .` | `cursor .` | Mở Cursor tại thư mục hiện tại. |
| `lvim` | `lunarvim` | Mở LunarVim. |

## 3. 🐙 Git & GitHub (Quản lý mã nguồn)

| Alias | Lệnh gốc | Tác dụng |
| :--- | :--- | :--- |
| **`lg`** | **`lazygit`** | **Git GUI trong Terminal (Siêu mạnh, nên dùng).** |
| `gb` | (fzf script) | Chọn branch để checkout bằng giao diện tìm kiếm. |
| `gbd` | (fzf script) | Chọn branch để XÓA. |
| `gt` | (fzf script) | Chọn tag để checkout. |
| `glc` | (function) | So sánh giữa 2 commit chọn bằng fzf. |
| `ghc` | `gh pr create --web` | Tạo PR trên web GitHub. |
| `ghv` | `gh pr view --web` | Xem PR hiện tại trên web. |
| `ghdb` | `gh dash` | Xem Dashboard GitHub (Issue/PR của mình). |

## 4. 🐳 Docker & DevOps

| Alias | Lệnh gốc | Tác dụng |
| :--- | :--- | :--- |
| **`ld`** | **`lazydocker`** | **Quản lý Docker bằng giao diện (Nên dùng).** |
| `dcs` | (docker stop all) | Stop toàn bộ container đang chạy. |
| `dcd` | (docker rm all) | Xóa toàn bộ container. |
| `tf` | `terraform` | Lệnh Terraform ngắn gọn. |
| `tfa`, `tfp`...| `verify/plan` | Các lệnh Terraform Apply, Plan, Init... |

## 5. 📱 Flutter & Mobile (Migrated)

| Alias | Lệnh gốc | Tác dụng |
| :--- | :--- | :--- |
| `f` | `fvm flutter` | Chạy lệnh Flutter qua FVM. |
| `d` | `fvm dart` | Chạy lệnh Dart qua FVM. |
| `frun-pos` | (Run Flavor) | Chạy app bản POS Dev. |
| `frun-otm` | (Run Flavor) | Chạy app bản OTM Release. |
| `fintl` | (intl_utils) | Generate localization (ngôn ngữ). |
| `fbgen` | (build_runner) | Chạy Build Runner (sinh code). |

## 6. ☕ Java & SDKMan

| Alias | Lệnh gốc | Tác dụng |
| :--- | :--- | :--- |
| `jdk11` | `sdk use java 11...` | Chuyển sang Java 11. |
| `jdk17` | `sdk use java 17...` | Chuyển sang Java 17. |
| `jdk-list` | `sdk list...` | Xem các Java đã cài. |

## 7. 📦 Package Managers (NPM, Yarn...)

| Alias | Lệnh gốc | Tác dụng |
| :--- | :--- | :--- |
| `n` | `npm` | |
| `y` | `yarn` | |
| `pn` | `pnpm` | |
| `s` | (fzf script) | **Chọn script trong `package.json` để chạy (Siêu tiện).** |
| `ns`, `ys` | `npm run`, `yarn run` | Chạy script đã chọn bằng npm/yarn. |

## 8. 🛠️ Tiện ích khác

| Alias | Lệnh gốc | Tác dụng |
| :--- | :--- | :--- |
| `h` | `tldr` | Tra cứu nhanh cú pháp lệnh (ví dụ trực quan thay cho man). |
| `zz` | `source ~/.zshrc` | Reload lại cấu hình Zsh (khi vừa sửa xong). |
| `nocors` | (Chrome flags) | Mở Chrome tắt bảo mật CORS (để test API local). |
| `ytd` | `yt-dlp` | Tải video Youtube. |
| `zl` | `zellij` | Mở Zellij Multiplexer. |

---
> **Lưu ý:** Để sửa hoặc thêm Alias, hãy sửa file: `~/.dotfiles/zsh/.zsh_profile`
