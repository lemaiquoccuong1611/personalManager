# Flow — Quản lý lịch làm việc cá nhân (PWA)

Web app 1 file (React UMD + Babel, **không cần build**) với đồng bộ dữ liệu qua **Supabase**
(đăng nhập bằng **magic link**) và cài được như app trên điện thoại (**PWA / HTTPS**).

| File | Vai trò |
|------|---------|
| `index.html` | Toàn bộ ứng dụng (UI + logic + đồng bộ Supabase) |
| `config.js` | Nơi điền `SUPABASE_URL` + `SUPABASE_ANON_KEY` |
| `supabase-schema.sql` | Tạo bảng `tasks / notes / goals` + Row Level Security |
| `manifest.json`, `service-worker.js`, `icon-*.png` | Phần PWA (cài lên máy, chạy offline) |

> **Chế độ offline mặc định:** khi `config.js` còn trống, app chạy hoàn toàn bằng
> `localStorage` (không cần đăng nhập) — mở `index.html` là dùng được ngay để xem UI.
> Khi điền Supabase vào `config.js` → app bật đăng nhập + đồng bộ nhiều thiết bị.

---

## Bước 1 — Tạo Supabase project & lấy URL + anon key

1. Vào <https://supabase.com/dashboard> → **New project**.
   - **Name:** `flow` (tuỳ ý) · **Database Password:** đặt mật khẩu mạnh (lưu lại) · **Region:** chọn `Southeast Asia (Singapore)` cho gần VN.
   - Bấm **Create new project**, đợi ~1–2 phút cho project khởi tạo xong.
2. Vào **Project Settings** (bánh răng) → **API**. Copy 2 giá trị:
   - **Project URL** → dạng `https://xxxxxxxx.supabase.co`
   - **Project API keys → `anon` `public`** → chuỗi dài bắt đầu bằng `eyJ...`
   > `anon` key là khoá **công khai**, an toàn để đặt trong `config.js` và đẩy lên git.
   > **Tuyệt đối KHÔNG** dùng `service_role` key ở frontend.
3. Mở `config.js` và dán vào:
   ```js
   window.FLOW_CONFIG = {
     SUPABASE_URL: "https://xxxxxxxx.supabase.co",
     SUPABASE_ANON_KEY: "eyJhbGciOi....(anon public key)"
   };
   ```

## Bước 2 — Tạo bảng dữ liệu (chạy SQL)

1. Trong Supabase: **SQL Editor** → **New query**.
2. Mở file `supabase-schema.sql`, copy **toàn bộ** nội dung, dán vào rồi bấm **Run**.
3. Kiểm tra **Table Editor** → phải thấy 3 bảng: `tasks`, `notes`, `goals`.
   (Script đã tự bật Row Level Security để mỗi người chỉ thấy dữ liệu của chính mình.)

## Bước 3 — Cấu hình đăng nhập (email + mật khẩu)

1. **Authentication → Providers → Email**: bật **Enable Email provider**.
2. **TẮT "Confirm email"** (cùng trang Email provider): gạt **Confirm email → OFF**.
   > Tắt bước này để **tạo tài khoản là đăng nhập được ngay**, không phải mở email xác nhận.
   > Nhờ vậy có thể dùng email bất kỳ đúng định dạng (vd `cuong@flow.app`) mà không cần hộp thư thật.
3. (Không bắt buộc với email+mật khẩu) **Authentication → URL Configuration → Site URL**: đặt bằng URL web thật sau khi deploy — dùng cho các email hệ thống (đặt lại mật khẩu…).

## Bước 4 — Chạy thử ở máy (localhost)

Vì có Service Worker + magic link, cần chạy qua HTTP (không mở trực tiếp `file://`):

```bash
# Trong thư mục dự án, chọn 1 trong 2:
python -m http.server 8000
# hoặc:  npx serve -l 8000
```
Mở <http://localhost:8000> → nhập email → mở hộp thư, bấm magic link → vào app.
Thử thêm/sửa/xoá task; đăng nhập cùng email ở máy/điện thoại khác để thấy **đồng bộ**.

---

## Bước 5 — Đưa code lên GitHub

```bash
git add -A
git commit -m "feat: Flow PWA + Supabase sync"
# Tạo repo trên github.com (Private), rồi:
git remote add origin https://github.com/<user>/<repo>.git
git branch -M main
git push -u origin main
```
(Đã có sẵn commit đầu tiên — xem phần cuối README.)

## Bước 6 — Deploy lên Netlify (HTTPS + PWA)

1. Vào <https://app.netlify.com> → **Sign up** bằng **GitHub**.
2. **Add new site → Import an existing project → GitHub** → chọn repo vừa push.
3. Build settings để **trống** (đây là site tĩnh, không có bước build):
   - **Build command:** để trống
   - **Publish directory:** `.` (thư mục gốc)
4. **Deploy site**. Netlify cấp URL dạng `https://<random>.netlify.app` (có HTTPS sẵn).
   - Có thể đổi tên ở **Site configuration → Change site name**.
5. **Quay lại Bước 3**: dán đúng URL Netlify này vào **Site URL** + **Redirect URLs** của Supabase.
6. Mở URL trên điện thoại → trình duyệt hiện **"Thêm vào màn hình chính"** → cài như app.

> Mỗi lần `git push` lên `main`, Netlify tự động deploy lại. Nhớ **commit `config.js`**
> đã điền key để bản deploy có cấu hình Supabase.

---

## Gợi ý & lưu ý

- **Người dùng mới** khi đăng nhập lần đầu sẽ thấy danh sách trống (dữ liệu mẫu chỉ dùng ở chế độ offline). Cứ bấm **Thêm việc** để tạo dữ liệu thật — sẽ được lưu lên cloud.
- **Theme sáng/tối** và **phút Pomodoro hôm nay** lưu theo từng thiết bị (localStorage), không đồng bộ — đúng ý đồ thiết kế.
- Sau khi đổi `config.js`, Service Worker có thể giữ bản cũ. Cách làm mới: DevTools → Application → Service Workers → **Unregister**, rồi tải lại; hoặc bản deploy đã tăng cache lên `flow-app-cache-v2` nên sẽ tự cập nhật.
- **Bảo mật:** dữ liệu được bảo vệ bằng RLS ở Supabase; chỉ `anon` key nằm ở client. Không đưa `service_role` key vào bất kỳ file frontend nào.
