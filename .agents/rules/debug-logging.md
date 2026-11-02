# Debug Logging & Path Sanitation Standards

## 1. Path Sanitation Invariant
- **Compact Basename Only**: Khi log file tạm, database snapshot, hoặc cache artifact (ví dụ ObjectBox LMDB snapshot file), **chỉ log compact name (file basename)**.
- **No Absolute Path Leakage**: Không bao giờ in full system path (`/Users/.../Documents/...`) ra console/output logs trừ khi có flag `--verbose` hoặc yêu cầu tường minh từ người dùng.

## 2. Clean-up Invariant
- **Temporary Debug Logs**: Mọi dòng code print / log thêm vào phục vụ kiểm tra trace runtime phải được tự động dọn dẹp (revert/clean) trước khi hoàn tất task hoặc tạo commit.
- **Production Logs**: Chỉ giữ lại các log đạt chuẩn qua logger tập trung (chẳng hạn `AppLogger` hoặc `DPrettyPrinter`) với level phù hợp.
