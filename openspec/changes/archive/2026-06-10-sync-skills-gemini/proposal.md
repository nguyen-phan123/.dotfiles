## Why

Hiện tại, khi người dùng cấu hình các custom agent skills trong thư mục trung tâm `~/.gemini/skills/`, các skills này không được tự động đồng bộ/liên kết vào các thư mục skills riêng biệt của từng công cụ:
- Antigravity IDE (`~/.gemini/antigravity-ide/skills/`)
- Antigravity App (`~/.gemini/antigravity/skills/`)
- Antigravity CLI / Gemini Config (`~/.gemini/config/skills/`)

Điều này khiến các công cụ của Gemini/Antigravity không đồng bộ được danh sách skills đang hoạt động.

## What Changes

- **Đồng bộ Skills trung tâm sang các công cụ**: Tạo/cập nhật script để đọc danh sách các skills trong thư mục nguồn `~/.gemini/skills/` và tự động tạo lại các liên kết (symlinks) tương ứng trong thư mục `skills/` của từng công cụ mục tiêu (Antigravity IDE, Antigravity App, và Antigravity CLI).
- **Merge/Prune Logic**: Tự động dọn dẹp các symlink bị broken hoặc các skills không còn tồn tại trong thư mục nguồn `~/.gemini/skills/` khỏi các thư mục đích.
- **Tích hợp vào lệnh `mcpsync`**: Tích hợp phần đồng bộ skills này vào hàm `mcpsync` để đồng bộ cả MCP và Skills chỉ với một lệnh duy nhất.

## Capabilities

### New Capabilities
- `sync-skills-gemini`: Đồng bộ các agent skills từ thư mục nguồn trung tâm `~/.gemini/skills/` sang các thư mục target của Antigravity IDE, Antigravity App, và Antigravity CLI.

### Modified Capabilities
- None

## Impact

- Cập nhật lại script `shell/zsh/.sync-mcp.js`.
- Cập nhật các thư mục skills đích:
  - `~/.gemini/antigravity-ide/skills/`
  - `~/.gemini/antigravity/skills/`
  - `~/.gemini/config/skills/`
