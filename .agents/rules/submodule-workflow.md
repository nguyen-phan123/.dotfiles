# Git Submodule & Branch Alignment Standards

## 1. Branch Verification
- Trước khi thực hiện thay đổi hoặc commit trong các submodule packages (ví dụ `packages/diqit-sync-engine-phj`), luôn chạy `git status` và `git branch --show-current` bên trong submodule để xác nhận branch làm việc.
- Tránh commit ở trạng thái `detached HEAD`.

## 2. Branch Carry & Jira Ticket Traceability
- Nếu có uncommitted changes cần mang sang feature/fix branch tương ứng:
  1. Kiểm tra branch đích (ví dụ `fix/PSV-xxx`).
  2. Mang thay đổi theo (`git stash` / `git checkout <branch>` / `git stash pop`).
  3. Commit với prefix Jira ticket bắt buộc: `PSV-xxx: <type>(<scope>): <message>`.

## 3. Parent Repository Pointer Sync
- Sau khi commit trong submodule, quay về root repository và xác nhận cập nhật git submodule pointer commit (`git add <submodule-path>` & commit tương ứng).
