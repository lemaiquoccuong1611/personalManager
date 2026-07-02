/*
 * Cấu hình Supabase cho Flow.
 *
 * Điền URL + anon key của project Supabase vào đây (xem README.md, mục "Bước 1").
 * - Nếu để trống (như mặc định) → app chạy ở chế độ OFFLINE (lưu localStorage như cũ),
 *   không cần đăng nhập. Dùng để xem UI ngay.
 * - Khi đã điền → app bật đăng nhập magic link + đồng bộ dữ liệu qua nhiều thiết bị.
 *
 * Lưu ý: anon key là khoá CÔNG KHAI, an toàn khi để trong file này và đẩy lên git.
 * Dữ liệu được bảo vệ bằng Row Level Security (RLS) ở phía Supabase.
 */
window.FLOW_CONFIG = {
  SUPABASE_URL: "",
  SUPABASE_ANON_KEY: ""
};
