# English Steps — MVP

Bản đầu tiên của ứng dụng học tiếng Anh cho trẻ, chạy trên trình duyệt điện thoại và máy tính.

## Có gì trong bản này?
- Flashcard: mặt trước là ảnh/emoji; chạm thẻ để lật; nút loa phát MP3 nếu có URL hoặc dùng giọng đọc của trình duyệt.
- Luyện viết từ và viết lại câu.
- Luyện nghe: phát từ/câu rồi chọn đáp án.
- Luyện nói: phát câu mẫu và ghi âm để nghe lại. Chưa tự động chấm phát âm.
- Hội thoại mẫu theo tình huống ở nhà, bữa ăn, lớp học, cửa hàng.
- Tạo bài học, thêm từ/câu, nhập nhiều từ bằng CSV.
- Xuất bản sao JSON.
- Dữ liệu cục bộ mặc định; có thể bật đồng bộ qua Supabase khi thiết lập.

## Chạy thử ngay (không cần tài khoản)
1. Giải nén thư mục.
2. Mở `index.html` trong trình duyệt hiện đại.
3. Vào **Bài học & nhập bài**: tạo bài học, thêm từ/câu.
4. Dữ liệu bản thử nghiệm lưu trên trình duyệt đang dùng. Hãy bấm **Xuất dữ liệu** để sao lưu.

Một số trình duyệt hạn chế micro khi mở tệp trực tiếp. Để dùng ghi âm, chạy trên HTTPS hoặc localhost.

## Bật đồng bộ trực tuyến (Supabase)
1. Tạo dự án tại https://supabase.com/
2. Mở **SQL Editor** trong dự án, dán toàn bộ `schema.sql`, rồi Run.
3. Vào **Project Settings / API** (tên menu có thể thay đổi), lấy **Project URL** và **anon/public key** hoặc **publishable key**.
   - Không bao giờ dùng `service_role` / secret key trong ứng dụng trình duyệt.
4. Mở ứng dụng, vào **Tổng quan → Thiết lập đồng bộ trực tuyến**, nhập URL và public key, bấm **Kết nối**.
5. Tạo tài khoản bằng email và mật khẩu, sau đó đăng nhập.
6. Nếu Supabase yêu cầu xác nhận email, mở email xác nhận rồi quay lại đăng nhập.
7. Mở ứng dụng trên thiết bị khác, nhập cùng URL/key và đăng nhập cùng tài khoản.

### Lưu ý quan trọng về đồng bộ
- Bản MVP dùng mô hình một người dùng/nhóm gia đình và đồng bộ toàn bộ kho của tài khoản khi đăng nhập.
- Tránh chỉnh sửa cùng lúc trên hai thiết bị trong bản MVP. Bản này chưa có xử lý xung đột dữ liệu nâng cao.
- Nếu tài khoản cloud chưa có dữ liệu, ứng dụng sẽ đẩy dữ liệu cục bộ lên cloud. Nếu cloud đã có dữ liệu, ứng dụng tải dữ liệu cloud xuống thiết bị.
- Hãy xuất JSON trước khi bật đồng bộ lần đầu.
- RLS trong `schema.sql` giới hạn dữ liệu theo tài khoản đã đăng nhập.

## Đưa ứng dụng lên web
Để dùng ổn định trên cả điện thoại và máy tính, nên host thư mục này trên dịch vụ static hosting có HTTPS (ví dụ Netlify, Cloudflare Pages hoặc Vercel).
Vì đây là bản HTML tĩnh, có thể triển khai bằng cách upload `index.html` lên hosting. Giữ `schema.sql` làm tài liệu cấu hình, không cần đưa nó lên web công khai.

## Định dạng CSV
Các cột cần đúng tên:
`lesson_title,word,meaning,emoji,image_url,audio_url,example`

Mỗi dòng là một từ/cụm từ. `lesson_title` giống nhau sẽ được gom vào cùng bài. URL ảnh/MP3 phải là URL truy cập được từ trình duyệt. Tệp CSV nên lưu UTF-8.

## Những gì chưa có trong MVP
- Chưa tự động đọc ảnh/chụp trang sách để trích nội dung.
- Chưa tải ảnh và MP3 lên kho lưu trữ tích hợp; hiện dùng emoji hoặc URL ảnh/âm thanh.
- Chưa tự động chấm phát âm, nhận dạng câu nói hoặc chấm viết tay.
- Chưa có phân quyền nhiều hồ sơ trẻ, lịch ôn lặp lại thông minh, hoặc đồng bộ xung đột nâng cao.
- Chưa phải PWA cài đặt ngoại tuyến hoàn chỉnh.

## Kiến trúc gợi ý cho bản tiếp theo
- Giao diện: HTML/CSS/JavaScript hiện tại, sau này có thể chuyển sang React/Next.js.
- Xác thực + cơ sở dữ liệu: Supabase Auth + Postgres + Row Level Security.
- Tệp media: Supabase Storage (bucket riêng, chính sách theo user).
- Dữ liệu: `lessons`, `words`, `sentences`, tiếp theo bổ sung `activities`, `attempts`, `review_schedule`, `media_assets`.
- Nhập bài hàng ngày: tạo form nhập nhanh hoặc CSV trước; sau đó bổ sung tải ảnh/PDF và luồng trích xuất để phụ huynh kiểm tra trước khi lưu.
