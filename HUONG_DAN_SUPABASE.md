# Hướng Dẫn Cài Đặt Database Supabase Cho Police Case File

Hệ thống quản lý hồ sơ vụ việc Police Report (Roleplay LSPD / BCSO / SASP) hiện đã hỗ trợ kết nối trực tiếp với **Supabase (PostgreSQL Database)** và tự động đồng bộ hóa lên **Vercel**.

---

## 🚀 Các Bước Cài Đặt Nhanh

### Bước 1: Tạo dự án Supabase mới
1. Truy cập [https://supabase.com](https://supabase.com) và đăng nhập hoặc đăng ký tài khoản (miễn phí).
2. Bấm **"New Project"**.
3. Điền các thông tin:
   - **Name**: `police-report` (hoặc tên bạn thích).
   - **Database Password**: Đặt mật khẩu an toàn và lưu lại.
   - **Region**: Chọn khu vực gần Việt Nam nhất (ví dụ: `Singapore - ap-southeast-1`).
4. Bấm **"Create new project"** và đợi khoảng 1-2 phút để Supabase khởi tạo database.

---

### Bước 2: Chạy File SQL Tạo Database Schema
1. Trong giao diện Supabase Dashboard, nhìn cột menu bên trái và chọn biểu tượng **SQL Editor** (hình `>_`).
2. Bấm **"New query"** (hoặc nút `+`).
3. Mở file [supabase_schema.sql](supabase_schema.sql) trong dự án này, copy toàn bộ nội dung và dán vào ô soạn thảo SQL trên Supabase.
4. Bấm nút **"Run"** (hoặc phím tắt `Ctrl + Enter` / `Cmd + Enter`).
5. Khi thấy thông báo `Success. No rows returned`, toàn bộ các bảng:
   - `departments` (Sở cảnh sát)
   - `officers` (Tài khoản sĩ quan & phân quyền)
   - `cases` (Báo cáo sự việc / Hồ sơ vụ án)
   - `warrants` (Lệnh bắt giữ & khám xét roleplay)
   cùng các chính sách bảo mật RLS và dữ liệu mẫu đã được tạo thành công!

---

### Bước 3: Lấy Thông Tin Kết Nối (API Keys)
1. Ở menu bên trái Supabase, bấm vào biểu tượng bánh răng **Project Settings**.
2. Chọn mục **API** (hoặc Data API).
3. Copy 2 giá trị sau:
   - **Project URL** (dạng `https://xxxxxxxxxxxxxxxx.supabase.co`)
   - **Project API keys** -> copy khóa **`anon` / `public`** (dạng chuỗi token dài bắt đầu bằng `eyJ...`)

---

### Bước 4: Kết Nối Với Website Trên Vercel

Bạn có thể chọn **1 trong 3 cách** dưới đây:

#### Cách 1: Điền vào file `supabase-config.js` (Khuyên dùng để tất cả người dùng đều kết nối tự động)
1. Mở file `supabase-config.js` trong thư mục code.
2. Dán URL và Anon Key vào:
   ```javascript
   window.SUPABASE_CONFIG = {
     url: 'https://xyzabcdefghijklmno.supabase.co',
     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
   };
   ```
3. Lưu file, commit và push lên GitHub. Vercel sẽ tự động deploy bản mới nhất!

#### Cách 2: Cài đặt biến môi trường trên Vercel
1. Vào trang quản lý dự án trên Vercel: [https://vercel.com/bulest/policereport](https://vercel.com/bulest/policereport).
2. Vào **Settings** -> **Environment Variables**.
3. Thêm 2 biến:
   - `SUPABASE_URL`: Dán Project URL của Supabase.
   - `SUPABASE_ANON_KEY`: Dán `anon public key` của Supabase.
4. Bấm **Save** và bấm **Redeploy** trên Vercel.

#### Cách 3: Nhập trực tiếp trên giao diện Web
1. Mở trang web: [https://policereport-five.vercel.app/police-case-file.html](https://policereport-five.vercel.app/police-case-file.html).
2. Bấm vào nút/biểu tượng **"Cấu hình Supabase"** ở góc phải màn hình hoặc trên thanh menu.
3. Dán **Project URL** và **Anon Key**, sau đó bấm **"Lưu & Kết nối"**.
4. Website sẽ tự động kết nối và tải dữ liệu từ Supabase về!

---

## 👥 Danh Sách Tài Khoản Mặc Định Ban Đầu

Sau khi chạy file SQL `supabase_schema.sql`, database đã có sẵn các tài khoản demo sau:

| Sở | Tên đăng nhập | Mật khẩu | Họ tên | Cấp bậc | Số hiệu (Badge) | Quyền |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **LSPD** | `admin` | `admin123` | Morgan Hayes | Chief of Police | `0001` | **admin** |
| **LSPD** | `officer1` | `police123` | Daniel Carter | Sergeant | `2041` | officer |
| **BCSO** | `bcso` | `bcso123` | Walter Reed | Sheriff | `S-001` | **admin** |
| **SASP** | `sasp` | `sasp123` | Elena Ruiz | Captain | `C-100` | **admin** |

> 💡 **Mẹo:**
> - Tài khoản có quyền **admin** có thể: Tạo thêm sĩ quan mới, xóa sĩ quan, chỉnh sửa/xóa hồ sơ báo cáo, phê duyệt lệnh bắt giữ/khám xét, thay đổi logo và dấu mộc của sở.
> - Bạn có thể xem và quản lý trực tiếp tài khoản tại tab **Table Editor** -> chọn bảng **`officers`** trên Supabase.

---

## 🗄️ Cấu Trúc Các Bảng Database Trên Supabase

### 1. Bảng `departments` (Sở cảnh sát)
- `dept` (PK, text): `LSPD`, `BCSO`, `SASP`
- `name` (text): Tên đầy đủ
- `color` (text): Mã màu nhận diện
- `logo` (text): Link hoặc Base64 ảnh logo
- `stamp` (text): Link hoặc Base64 dấu mộc

### 2. Bảng `officers` (Tài khoản sĩ quan)
- `id` (PK, text): ID sĩ quan
- `dept` (FK, text): Mã sở cảnh sát
- `username` (text, UNIQUE): Tên đăng nhập
- `password` (text): Mật khẩu
- `name` (text): Họ và tên
- `rank` (text): Cấp bậc
- `badge` (text): Số hiệu badge
- `role` (text): `admin` hoặc `officer`

### 3. Bảng `cases` (Báo cáo sự việc / Hồ sơ vụ án)
- `id` (PK, text): ID hồ sơ (ví dụ `c1`, `c173...`)
- `dept` (FK, text): Thuộc sở nào
- `no` (text, UNIQUE): Số hồ sơ (ví dụ `LSPD-2026-0001`)
- `title` (text): Tiêu đề sự việc
- `type` (text): Loại tội danh / sự việc
- `status` (text): Tình trạng (Đang bỏ trốn, Đã bắt giữ, Đã đóng...)
- `f` (jsonb): Toàn bộ các thông tin chi tiết sự việc
- `officers` (jsonb): Các sĩ quan liên quan
- `suspects` (jsonb): Danh sách nghi phạm (nhân dạng, đặc điểm, tội danh...)
- `victims` (jsonb): Danh sách nạn nhân & thiệt hại
- `witnesses` (jsonb): Nhân chứng & lời khai
- `vehicles` (jsonb): Phương tiện liên quan & biển số
- `evidence` (jsonb): Tang vật & vật chứng thu giữ
- `photos` (jsonb): Danh sách ảnh chụp hiện trường
- `narr` (text): Nội dung tường thuật chi tiết
- `sig`, `by_name`, `by_rank`, `by_badge`: Chữ ký và thông tin người lập báo cáo

### 4. Bảng `warrants` (Lệnh bắt giữ / khám xét roleplay)
- `id` (PK, text): ID lệnh
- `dept` (FK, text): Mã sở
- `no` (text, UNIQUE): Số lệnh
- `type` (text): `arrest` (bắt giữ) hoặc `search` (khám xét)
- `citizen`, `citizen_id`, `location`, `reason`: Thông tin đối tượng và căn cứ
- `requested_by`, `status`, `approved_by`: Tiến trình duyệt lệnh
