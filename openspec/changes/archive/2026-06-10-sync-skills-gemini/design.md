## Context

Khi người dùng cấu hình các custom agent skills trong thư mục trung tâm `~/.gemini/skills/`, các skills này không được đồng bộ vào các thư mục riêng biệt của từng công cụ khiến các công cụ không hoạt động đồng nhất. Chúng ta cần mở rộng script `shell/zsh/.sync-mcp.js` để thực hiện việc quét và đồng bộ từ `~/.gemini/skills/` sang các thư mục target.

## Goals / Non-Goals

**Goals:**
- Quét các file/symlinks trong thư mục nguồn trung tâm `~/.gemini/skills/`.
- Đồng bộ các skills này vào 3 thư mục đích:
  - `~/.gemini/antigravity-ide/skills/`
  - `~/.gemini/antigravity/skills/`
  - `~/.gemini/config/skills/`
- Nếu skill ở nguồn là symlink, tạo lại symlink trỏ đến cùng một đích thực tế (resolved path) để tránh lồng symlink.
- Dọn dẹp các symlink cũ hoặc bị hỏng trong các thư mục đích.

**Non-Goals:**
- Sao chép trực tiếp nội dung folder (chỉ đồng bộ liên kết symlink).

## Decisions

### 1. Nguồn của Skills: `~/.gemini/skills/`
- **Lý do**: Đây là thư mục trung tâm nơi người dùng quản lý cấu hình các skills của hệ thống.

### 2. Tích hợp trực tiếp vào script `shell/zsh/.sync-mcp.js`
- **Lý do**: Giúp việc đồng bộ diễn ra tự động và trơn tru cùng lúc với MCP khi chạy lệnh `mcpsync`.

## Risks / Trade-offs

- **[Risk]** Xóa nhầm file thực sự do người dùng tạo trực tiếp trong thư mục target.
  - *Mitigation*: Chỉ xóa những file trong thư mục target mà (1) là symlink và (2) không nằm trong danh sách active skills của nguồn hoặc bị hỏng (broken link).
