# Police Case File

Website hồ sơ sự việc chạy tĩnh, không cần build hoặc cài dependency. Trang chủ là `index.html`; ứng dụng chính ở `police-case-file.html`.

## Chạy thử

Mở `index.html` trong trình duyệt. Tài khoản demo:

- LSPD: `admin` / `admin123` hoặc `officer1` / `police123`
- BCSO: `bcso` / `bcso123`
- SASP: `sasp` / `sasp123`

Logo mặc định của ba sở được lấy từ thư mục `assets/`. Quản trị viên có thể thay logo trong mục **Logo và dấu mộc**.

## Lệnh role-play

Mở **Lệnh bắt giữ / khám xét**, nhập thông tin công dân/đối tượng, địa điểm và căn cứ role-play rồi gửi yêu cầu. Tài khoản quản trị viên (`admin`) của sở phê duyệt; hồ sơ ghi nhận người gửi, người duyệt và thời điểm tương ứng. Chỉ lệnh đã duyệt mới có nút **Tải ảnh PNG**. Ảnh có dấu **ROLEPLAY ONLY · KHÔNG CÓ GIÁ TRỊ PHÁP LÝ** và chỉ dành cho trò chơi; không dùng như giấy tờ hay căn cứ pháp lý ngoài đời.

## Đưa lên GitHub Pages

1. Tạo repository GitHub và tải toàn bộ dự án lên, giữ nguyên thư mục `assets/`.
2. Mở **Settings → Pages**, chọn nhánh chứa mã nguồn và thư mục gốc `/`.
3. Truy cập URL GitHub Pages được cung cấp; `index.html` sẽ mở ứng dụng.

## Đưa lên Vercel

1. Import repository trên Vercel.
2. Chọn **Other** làm framework preset, để trống build command và output directory.
3. Deploy. Không cần cài package hay cấu hình biến môi trường.

## Ảnh, dữ liệu và PDF

Hồ sơ, logo tùy chỉnh và ảnh được lưu trong `localStorage` của trình duyệt đang dùng; thư viện ảnh hiển thị ảnh theo sở và liên kết về hồ sơ gốc. Dữ liệu không được tải lên GitHub/Vercel, không chia sẻ giữa thiết bị hoặc người dùng và có thể bị xóa khi xóa dữ liệu trình duyệt. Đây là bản demo phía trình duyệt, không dùng để lưu thông tin vụ việc thật hoặc thông tin nhạy cảm. Hãy sao lưu dữ liệu trước khi đổi trình duyệt hoặc thiết bị.
Hồ sơ lệnh cũng lưu cục bộ theo cùng cơ chế này; bản deploy tĩnh không có tài khoản an toàn hoặc phê duyệt được xác thực phía máy chủ.

Để tạo PDF, mở hồ sơ rồi chọn **Xuất PDF / In**; trong hộp thoại in của trình duyệt, chọn **Save as PDF / Lưu dưới dạng PDF**.