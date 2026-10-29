// ==============================================================================
// CẤU HÌNH KẾT NỐI SUPABASE CHO POLICE REPORT
// ==============================================================================
// Bạn có 3 cách kết nối:
// Cách 1: Điền trực tiếp URL và ANON KEY vào bên dưới, sau đó git push lên Vercel.
// Cách 2: Nhập qua nút "Cấu hình Supabase" trên giao diện web (lưu vào trình duyệt).
// Cách 3: Thêm SUPABASE_URL và SUPABASE_ANON_KEY trong mục Environment Variables trên Vercel.
//
// Lấy thông tin này tại: Supabase Dashboard -> Project Settings -> API
// - Project URL (URL)
// - Project API keys -> anon / public (Anon Key)
// ==============================================================================

var SUPABASE_CONFIG = {
  url: '',      // Ví dụ: 'https://xyzabcdefghijklmno.supabase.co'
  anonKey: ''  // Ví dụ: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
};

if (typeof window !== 'undefined') {
  window.SUPABASE_CONFIG = SUPABASE_CONFIG;
}
if (typeof module !== 'undefined' && module.exports) {
  module.exports = SUPABASE_CONFIG;
}
