-- ==============================================================================
-- HỆ THỐNG CƠ SỞ DỮ LIỆU POLICE CASE FILE (SUPABASE POSTGRESQL)
-- Website: Police Report & Case File Management (LSPD / BCSO / SASP)
-- Hướng dẫn: Copy toàn bộ nội dung file này và chạy trong Supabase SQL Editor.
-- ==============================================================================

-- 1. BẢNG PHÒNG BAN / SỞ CẢNH SÁT (DEPARTMENTS)
CREATE TABLE IF NOT EXISTS public.departments (
    dept TEXT PRIMARY KEY,                       -- Mã sở: LSPD, BCSO, SASP
    name TEXT NOT NULL,                          -- Tên đầy đủ của sở
    color TEXT DEFAULT '#1c3d7a',               -- Màu nhận diện thương hiệu
    logo TEXT DEFAULT '',                        -- Logo (URL hoặc base64)
    stamp TEXT DEFAULT '',                       -- Dấu mộc (URL hoặc base64)
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

COMMENT ON TABLE public.departments IS 'Danh sách các sở cảnh sát và thiết lập nhận diện';

-- 2. BẢNG TÀI KHOẢN SĨ QUAN / CẢNH SÁT (OFFICERS)
CREATE TABLE IF NOT EXISTS public.officers (
    id TEXT PRIMARY KEY,                         -- ID sĩ quan (ví dụ: o1, o2, o173...)
    dept TEXT NOT NULL REFERENCES public.departments(dept) ON UPDATE CASCADE ON DELETE CASCADE,
    username TEXT NOT NULL UNIQUE,               -- Tên đăng nhập
    password TEXT NOT NULL,                      -- Mật khẩu
    name TEXT NOT NULL,                          -- Họ và tên sĩ quan
    rank TEXT DEFAULT '',                        -- Cấp bậc (Chief of Police, Sergeant, Captain...)
    badge TEXT DEFAULT '',                       -- Số hiệu / Badge number
    role TEXT DEFAULT 'officer' CHECK (role IN ('admin', 'officer')), -- Phân quyền
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

COMMENT ON TABLE public.officers IS 'Tài khoản sĩ quan, phân quyền đăng nhập hệ thống';

-- 3. BẢNG HỒ SƠ BÁO CÁO VỤ VIỆC (CASES)
CREATE TABLE IF NOT EXISTS public.cases (
    id TEXT PRIMARY KEY,                         -- Mã định danh hồ sơ (ví dụ: c1, c173...)
    dept TEXT NOT NULL REFERENCES public.departments(dept) ON UPDATE CASCADE ON DELETE CASCADE,
    no TEXT NOT NULL UNIQUE,                     -- Số hồ sơ (Case No, ví dụ: LSPD-2026-0001)
    title TEXT DEFAULT '',                       -- Tiêu đề vụ việc
    type TEXT DEFAULT '',                        -- Loại tội danh / sự việc
    status TEXT DEFAULT '',                      -- Trạng thái xử lý (Đã bắt giữ, Nghi phạm bỏ trốn...)
    f JSONB DEFAULT '{}'::jsonb NOT NULL,        -- Toàn bộ thông tin sự việc chi tiết (JSON)
    officers JSONB DEFAULT '[]'::jsonb NOT NULL, -- Danh sách sĩ quan tham gia
    suspects JSONB DEFAULT '[]'::jsonb NOT NULL, -- Danh sách nghi phạm
    victims JSONB DEFAULT '[]'::jsonb NOT NULL,  -- Danh sách nạn nhân
    witnesses JSONB DEFAULT '[]'::jsonb NOT NULL,-- Danh sách nhân chứng
    vehicles JSONB DEFAULT '[]'::jsonb NOT NULL, -- Danh sách phương tiện liên quan
    evidence JSONB DEFAULT '[]'::jsonb NOT NULL, -- Danh sách vật chứng / tang vật
    photos JSONB DEFAULT '[]'::jsonb NOT NULL,   -- Danh sách ảnh hiện trường (base64 / URL & chú thích)
    narr TEXT DEFAULT '',                        -- Tường thuật chi tiết sự việc (HTML)
    lh TEXT DEFAULT '1.5',                       -- Khoảng cách dòng tường thuật
    sig TEXT DEFAULT '',                         -- Chữ ký sĩ quan
    by_name TEXT DEFAULT '',                     -- Họ tên người lập
    by_rank TEXT DEFAULT '',                     -- Cấp bậc người lập
    by_badge TEXT DEFAULT '',                    -- Số hiệu người lập
    created TEXT DEFAULT '',                     -- Thời gian lập hồ sơ dạng chuỗi ISO
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

COMMENT ON TABLE public.cases IS 'Lưu trữ toàn bộ hồ sơ báo cáo sự việc của cảnh sát';

-- 4. BẢNG LỆNH BẮT GIỮ / KHÁM XÉT ROLEPLAY (WARRANTS)
CREATE TABLE IF NOT EXISTS public.warrants (
    id TEXT PRIMARY KEY,                         -- ID lệnh (ví dụ: w1, w173...)
    dept TEXT NOT NULL REFERENCES public.departments(dept) ON UPDATE CASCADE ON DELETE CASCADE,
    no TEXT NOT NULL UNIQUE,                     -- Mã lệnh (ví dụ: LSPD-W-2026-0001)
    type TEXT NOT NULL CHECK (type IN ('arrest', 'search')), -- Loại: arrest (bắt giữ) hoặc search (khám xét)
    citizen TEXT DEFAULT '',                     -- Họ tên đối tượng / công dân
    dob TEXT DEFAULT '',                         -- Ngày sinh
    citizen_id TEXT DEFAULT '',                  -- Số ID / CCCD / Giấy tờ
    citizen_address TEXT DEFAULT '',             -- Địa chỉ thường trú
    location TEXT DEFAULT '',                    -- Địa điểm áp dụng lệnh
    case_no TEXT DEFAULT '',                     -- Mã hồ sơ liên quan (nếu có)
    reason TEXT DEFAULT '',                      -- Căn cứ / nội dung đề nghị lệnh
    items TEXT DEFAULT '',                       -- Tài sản / tang vật cần tìm kiếm (đối với lệnh khám xét)
    requested_by TEXT DEFAULT '',                -- Sĩ quan đề nghị
    requested_rank TEXT DEFAULT '',              -- Cấp bậc người đề nghị
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')), -- Trạng thái duyệt
    approved_by TEXT DEFAULT '',                 -- Sĩ quan phê duyệt
    approved_rank TEXT DEFAULT '',               -- Cấp bậc người phê duyệt
    approved_at TEXT DEFAULT '',                 -- Thời điểm phê duyệt
    created_at TEXT DEFAULT '',                  -- Thời điểm tạo
    updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

COMMENT ON TABLE public.warrants IS 'Lệnh bắt giữ và khám xét phục vụ Roleplay';

-- ==============================================================================
-- TẠO CHỈ MỤC (INDEXES) ĐỂ TĂNG TỐC ĐỘ TRUY VẤN
-- ==============================================================================
CREATE INDEX IF NOT EXISTS idx_officers_dept ON public.officers(dept);
CREATE INDEX IF NOT EXISTS idx_officers_username ON public.officers(username);
CREATE INDEX IF NOT EXISTS idx_cases_dept ON public.cases(dept);
CREATE INDEX IF NOT EXISTS idx_cases_no ON public.cases(no);
CREATE INDEX IF NOT EXISTS idx_cases_status ON public.cases(status);
CREATE INDEX IF NOT EXISTS idx_cases_created_at ON public.cases(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_warrants_dept ON public.warrants(dept);
CREATE INDEX IF NOT EXISTS idx_warrants_status ON public.warrants(status);

-- ==============================================================================
-- BẬT ROW LEVEL SECURITY (RLS) VÀ CẤP QUYỀN TRUY CẬP CHO WEB CLIENT (ANON ROLE)
-- ==============================================================================
ALTER TABLE public.departments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.officers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cases ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.warrants ENABLE ROW LEVEL SECURITY;

-- 1. Quyền trên bảng departments
DROP POLICY IF EXISTS "departments_anon_select" ON public.departments;
DROP POLICY IF EXISTS "departments_anon_insert" ON public.departments;
DROP POLICY IF EXISTS "departments_anon_update" ON public.departments;
DROP POLICY IF EXISTS "departments_anon_delete" ON public.departments;

CREATE POLICY "departments_anon_select" ON public.departments FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "departments_anon_insert" ON public.departments FOR INSERT TO anon, authenticated WITH CHECK (true);
CREATE POLICY "departments_anon_update" ON public.departments FOR UPDATE TO anon, authenticated USING (true);
CREATE POLICY "departments_anon_delete" ON public.departments FOR DELETE TO anon, authenticated USING (true);

-- 2. Quyền trên bảng officers (lưu tài khoản)
DROP POLICY IF EXISTS "officers_anon_select" ON public.officers;
DROP POLICY IF EXISTS "officers_anon_insert" ON public.officers;
DROP POLICY IF EXISTS "officers_anon_update" ON public.officers;
DROP POLICY IF EXISTS "officers_anon_delete" ON public.officers;

CREATE POLICY "officers_anon_select" ON public.officers FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "officers_anon_insert" ON public.officers FOR INSERT TO anon, authenticated WITH CHECK (true);
CREATE POLICY "officers_anon_update" ON public.officers FOR UPDATE TO anon, authenticated USING (true);
CREATE POLICY "officers_anon_delete" ON public.officers FOR DELETE TO anon, authenticated USING (true);

-- 3. Quyền trên bảng cases (lưu hồ sơ vụ việc)
DROP POLICY IF EXISTS "cases_anon_select" ON public.cases;
DROP POLICY IF EXISTS "cases_anon_insert" ON public.cases;
DROP POLICY IF EXISTS "cases_anon_update" ON public.cases;
DROP POLICY IF EXISTS "cases_anon_delete" ON public.cases;

CREATE POLICY "cases_anon_select" ON public.cases FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "cases_anon_insert" ON public.cases FOR INSERT TO anon, authenticated WITH CHECK (true);
CREATE POLICY "cases_anon_update" ON public.cases FOR UPDATE TO anon, authenticated USING (true);
CREATE POLICY "cases_anon_delete" ON public.cases FOR DELETE TO anon, authenticated USING (true);

-- 4. Quyền trên bảng warrants (lưu lệnh)
DROP POLICY IF EXISTS "warrants_anon_select" ON public.warrants;
DROP POLICY IF EXISTS "warrants_anon_insert" ON public.warrants;
DROP POLICY IF EXISTS "warrants_anon_update" ON public.warrants;
DROP POLICY IF EXISTS "warrants_anon_delete" ON public.warrants;

CREATE POLICY "warrants_anon_select" ON public.warrants FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "warrants_anon_insert" ON public.warrants FOR INSERT TO anon, authenticated WITH CHECK (true);
CREATE POLICY "warrants_anon_update" ON public.warrants FOR UPDATE TO anon, authenticated USING (true);
CREATE POLICY "warrants_anon_delete" ON public.warrants FOR DELETE TO anon, authenticated USING (true);

-- ==============================================================================
-- DỮ LIỆU KHỞI TẠO MẪU (SEED DATA)
-- ==============================================================================

-- 1. Thêm 3 sở cảnh sát mặc định
INSERT INTO public.departments (dept, name, color)
VALUES 
    ('LSPD', 'Los Santos Police Department', '#1c3d7a'),
    ('BCSO', 'Blaine County Sheriff’s Office', '#8a6a1f'),
    ('SASP', 'San Andreas State Police', '#1b5e3f')
ON CONFLICT (dept) DO UPDATE 
SET name = EXCLUDED.name, color = EXCLUDED.color;

-- 2. Thêm các tài khoản sĩ quan mẫu ban đầu
INSERT INTO public.officers (id, dept, username, password, name, rank, badge, role)
VALUES 
    ('o1', 'LSPD', 'admin', 'admin123', 'Morgan Hayes', 'Chief of Police', '0001', 'admin'),
    ('o2', 'LSPD', 'officer1', 'police123', 'Daniel Carter', 'Sergeant', '2041', 'officer'),
    ('o3', 'BCSO', 'bcso', 'bcso123', 'Walter Reed', 'Sheriff', 'S-001', 'admin'),
    ('o4', 'SASP', 'sasp', 'sasp123', 'Elena Ruiz', 'Captain', 'C-100', 'admin')
ON CONFLICT (username) DO NOTHING;

-- 3. Thêm hồ sơ mẫu ban đầu
INSERT INTO public.cases (
    id, dept, no, title, type, status, 
    f, officers, suspects, victims, witnesses, vehicles, evidence, photos,
    narr, lh, sig, by_name, by_rank, by_badge, created
)
VALUES (
    'c1',
    'LSPD',
    'LSPD-2026-0001',
    'Cướp có vũ trang tại cửa hàng tiện lợi',
    'Cướp',
    'Nghi phạm đang bỏ trốn',
    '{
      "title": "Cướp có vũ trang tại cửa hàng tiện lợi",
      "type": "Cướp",
      "pri": "Cao",
      "status": "Nghi phạm đang bỏ trốn",
      "occurred": "2026-10-27T22:15",
      "reported": "2026-10-27T22:17",
      "arrived": "2026-10-27T22:24",
      "cleared": "",
      "loc": "24 Vinewood Blvd",
      "area": "Beat 4",
      "premises": "Cơ sở kinh doanh",
      "weather": "Trời quang, ban đêm, có đèn đường",
      "rp": "Anna Lee",
      "rpPhone": "555-0142",
      "source": "Cuộc gọi 911",
      "force": "Không",
      "inj": "Không",
      "cam": "Có",
      "callNo": "CAD-88213",
      "follow": "Xem lại camera và dò hỏi khu vực xung quanh.",
      "closed": ""
    }'::jsonb,
    '[{"name": "Daniel Carter", "rank": "Sergeant", "badge": "2041", "callsign": "2-Adam-14", "role": "Sĩ quan lập báo cáo"}]'::jsonb,
    '[{"name": "Nam giới, chưa rõ danh tính", "gender": "Nam", "height": "1m80", "clothing": "Áo hoodie đen, quần jeans tối màu", "weapon": "Súng ngắn", "status": "Đang bỏ trốn", "charges": "Cướp có vũ trang"}]'::jsonb,
    '[{"name": "Anna Lee", "gender": "Nữ", "injury": "Không", "loss": "840 USD tiền mặt"}]'::jsonb,
    '[]'::jsonb,
    '[]'::jsonb,
    '[]'::jsonb,
    '[]'::jsonb,
    '<p>Lúc 22:15, đơn vị tiếp nhận báo cáo về vụ cướp đang diễn ra. <b>Nghi phạm đã bỏ chạy bộ về hướng bắc.</b></p>',
    '1.5',
    'Daniel Carter',
    'Daniel Carter',
    'Sergeant',
    '2041',
    '2026-10-27T23:40:00.000Z'
)
ON CONFLICT (id) DO NOTHING;

