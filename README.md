# Police Case File

Website hồ sơ sự việc và quản lý báo cáo cảnh sát (Roleplay LSPD / BCSO / SASP) chạy trên nền web tĩnh kết hợp đám mây **Supabase (PostgreSQL Database)** và triển khai trực tiếp trên **Vercel**.

- Trang chủ: `index.html` (tự chuyển hướng đến `police-case-file.html`)
- Ứng dụng chính: `police-case-file.html`
- Web đã triển khai: [https://policereport-five.vercel.app/police-case-file.html](https://policereport-five.vercel.app/police-case-file.html)
- Hướng dẫn cài đặt Supabase chi tiết: [HUONG_DAN_SUPABASE.md](HUONG_DAN_SUPABASE.md)
- File SQL khởi tạo Database: [supabase_schema.sql](supabase_schema.sql)

---

## 🗄️ Kết Nối Cơ Sở Dữ Liệu Supabase

Hệ thống hỗ trợ lưu trữ toàn bộ:
1. **Tài khoản sĩ quan**: Đăng nhập, cấp bậc, số hiệu badge, phân quyền admin/officer.
2. **Hồ sơ báo cáo vụ việc**: Chi tiết sự việc, nghi phạm, nạn nhân, nhân chứng, phương tiện, tang vật, ảnh hiện trường và chữ ký.
3. **Lệnh bắt giữ / khám xét roleplay**: Đề nghị và duyệt lệnh roleplay trực tiếp qua database.
4. **Cài đặt các sở**: Logo và con dấu riêng của LSPD, BCSO, SASP.

### 3 Bước Nhanh Để Kết Nối Supabase:

1. **Chạy SQL trên Supabase**:
   - Tạo project mới tại [supabase.com](https://supabase.com).
   - Mở tab **SQL Editor**, dán toàn bộ nội dung trong file [supabase_schema.sql](supabase_schema.sql) và bấm **Run**.
2. **Lấy API Keys**:
   - Vào **Project Settings → API** lấy **Project URL** và khóa **anon / public**.
3. **Cấu hình trên web hoặc Vercel**:
   - **Cách 1**: Điền vào `supabase-config.js` rồi git push.
   - **Cách 2**: Thêm biến môi trường `SUPABASE_URL` và `SUPABASE_ANON_KEY` trong mục Settings → Environment Variables trên Vercel.
   - **Cách 3**: Bấm nút **"⚙️ Cấu hình Supabase"** ngay trên giao diện web và dán thông tin vào.

---

## 👮 Tài Khoản Demo Khởi Tạo Sẵn

| Sở | Tên đăng nhập | Mật khẩu | Họ tên | Cấp bậc | Badge | Quyền |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **LSPD** | `admin` | `admin123` | Morgan Hayes | Chief of Police | `0001` | **admin** |
| **LSPD** | `officer1` | `police123` | Daniel Carter | Sergeant | `2041` | officer |
| **BCSO** | `bcso` | `bcso123` | Walter Reed | Sheriff | `S-001` | **admin** |
| **SASP** | `sasp` | `sasp123` | Elena Ruiz | Captain | `C-100` | **admin** |

Logo mặc định của ba sở được lấy từ thư mục `assets/`. Quản trị viên (`admin`) có thể thay logo và con dấu trong mục **Logo và dấu mộc**.

---

## 📜 Lệnh Role-play

Mở **Lệnh bắt giữ / khám xét**, nhập thông tin công dân/đối tượng, địa điểm và căn cứ role-play rồi gửi yêu cầu. Tài khoản quản trị viên (`admin`) của sở phê duyệt; hồ sơ ghi nhận người gửi, người duyệt và thời điểm tương ứng. Chỉ lệnh đã duyệt mới có nút **Tải ảnh PNG**. Ảnh có dấu **ROLEPLAY ONLY · KHÔNG CÓ GIÁ TRỊ PHÁP LÝ** và chỉ dành cho trò chơi.

---

## 🚀 Đưa Lên Vercel & Tự Động Triển Khai

1. Dự án đã được liên kết với repository: [https://github.com/patrickmuoi/policereport](https://github.com/patrickmuoi/policereport)
2. Dự án trên Vercel: [https://vercel.com/bulest/policereport](https://vercel.com/bulest/policereport)
3. Mỗi khi `git push` lên nhánh `main`, Vercel sẽ tự động build và cập nhật trang web trong vài giây!
