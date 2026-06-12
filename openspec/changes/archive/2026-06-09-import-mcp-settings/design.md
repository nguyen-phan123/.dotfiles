## Context

Các Model Context Protocol (MCP) servers được thiết lập bởi người dùng hoặc hệ thống trong file `~/.gemini/settings.json`. Tuy nhiên, `antigravity-ide` sử dụng một file cấu hình riêng biệt tại `~/.gemini/antigravity-ide/mcp_config.json`. Việc đồng bộ thủ công tốn thời gian và dễ gây lỗi. Chúng ta cần thiết kế một script tự động chạy bằng Node.js để giải quyết vấn đề này.

## Goals / Non-Goals

**Goals:**
- Tạo script `scripts/sync-mcp.js` để đọc và ghi các MCP servers.
- Hỗ trợ merge cấu hình, bảo toàn các server đã có ở cả hai nơi.
- Khai báo một alias `sync-mcp` trong `shell/zsh/.zsh_profile`.

**Non-Goals:**
- Tự động chạy ngầm (background daemon/watchdog).
- Đồng bộ các cài đặt khác ngoài `mcpServers` (ví dụ: preferredEditor, vimMode, model...).

## Decisions

### 1. Ngôn ngữ của Script: Node.js (JavaScript)
- **Phương án thay thế**: Shell script (bash) kết hợp `jq`.
- **Lý do chọn Node.js**: Hệ thống đã cài đặt sẵn Node.js và pnpm. Node.js xử lý JSON tốt hơn, an toàn hơn và không phụ thuộc vào việc client có cài đặt `jq` hay không. Đồng thời dễ dàng format JSON đẹp mắt (2 spaces) để tránh trailing commas.

### 2. File lưu trữ alias: `shell/zsh/.zsh_profile`
- **Lý do**: File này là nơi chứa các custom alias và profile configuration của Zsh trong dotfiles (sau đó sẽ được stow vào `$HOME`).

## Risks / Trade-offs

- **[Risk]** Ghi đè nhầm các custom settings quan trọng trong `mcp_config.json`.
  - *Mitigation*: Script sẽ đọc cả hai file trước, thực hiện deep merge đối với key `mcpServers` và lưu lại bản backup (ví dụ: `mcp_config.json.bak`) trước khi ghi đè file thật.
