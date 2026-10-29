// ==============================================================================
// CẤU HÌNH KẾT NỐI SUPABASE CHO POLICE REPORT
// ==============================================================================
// Để bảo mật dự án và không làm lộ API Key trên GitHub:
// - Bạn có thể cấu hình trực tiếp qua nút "Cấu hình Supabase" trên giao diện Web (lưu vào trình duyệt của bạn).
// - Hoặc thêm SUPABASE_URL và SUPABASE_ANON_KEY trong mục Settings -> Environment Variables trên Vercel.
// ==============================================================================

var SUPABASE_CONFIG = {
  url: '',
  anonKey: ''
};

if (typeof window !== 'undefined') {
  window.SUPABASE_CONFIG = SUPABASE_CONFIG;
}
if (typeof module !== 'undefined' && module.exports) {
  module.exports = SUPABASE_CONFIG;
}
