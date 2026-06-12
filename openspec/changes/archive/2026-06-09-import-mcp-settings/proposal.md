## Why

Hiện tại, các MCP (Model Context Protocol) servers được cấu hình trong `~/.gemini/settings.json` của môi trường Gemini Client/Claude Code, nhưng không được tự động đồng bộ sang file cấu hình `mcp_config.json` của `antigravity-ide` (ở thư mục `~/.gemini/antigravity-ide/mcp_config.json`). Việc này yêu cầu cấu hình thủ công lặp đi lặp lại và dễ gây sai lệch/mất mát cài đặt MCP giữa các công cụ trong cùng hệ sinh thái.

## What Changes

- **Thêm tính năng/script tự động đồng bộ cấu hình MCP**: Tạo một Node.js script để đọc `mcpServers` từ `~/.gemini/settings.json`, giải nén/phân tích và merge một cách an toàn vào `~/.gemini/antigravity-ide/mcp_config.json`.
- **Thêm alias hoặc CLI command**: Tạo alias hoặc sub-command (ví dụ: `rtk sync-mcp` hoặc mở rộng từ scripts có sẵn) để chạy script đồng bộ này một cách nhanh chóng.
- **Merge Logic thông minh**:
  - Giữ lại các MCP servers cũ trong `mcp_config.json` nếu không bị trùng tên.
  - Cập nhật các MCP servers trùng tên với thông tin mới nhất từ `~/.gemini/settings.json`.
  - Hỗ trợ biến môi trường (như `PATH`) và các tham số đặc thù.
- **Non-goals**:
  - Không đồng bộ ngược lại từ `antigravity-ide` về `~/.gemini/settings.json` để tránh làm hỏng cấu hình gốc của client.
  - Không tự động chạy nền liên tục (chỉ chạy trigger thủ công hoặc tích hợp vào hook cài đặt/khởi động).

## Capabilities

### New Capabilities
- `import-mcp-settings`: Cung cấp script Node.js và CLI command/alias để đồng bộ cấu hình MCP từ `~/.gemini/settings.json` sang `~/.gemini/antigravity-ide/mcp_config.json`.

### Modified Capabilities
- None

## Impact

- Thư mục `~/.gemini/antigravity-ide/mcp_config.json` sẽ được tự động ghi đè/cập nhật thông qua script.
- Bổ sung script mới vào `scripts/sync-mcp.js` (hoặc tương tự) trong repo `dotfiles`.
- Bổ sung alias vào `shell/zsh/.zsh_profile` (hoặc profile tương ứng).
