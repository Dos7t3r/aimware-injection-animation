---------------------------------------------------------------------------
--  AIMWARE – Injection Intro Animation  
---------------------------------------------------------------------------

-- == 可调常量 =============================================================
local ANIM_DURATION   = 4.5        -- 总时长（含淡出）秒
local FADE_OUT_TIME   = 0.6        -- 淡出时长秒
local MAIN_COLOR      = {227,  6, 19}  -- AIMWARE 红 #E30613
local BG_ALPHA        = 200        -- 背景遮罩透明度 (0‑255)
local TYPE_DELAY      = 0.05       -- 打字间隔秒
local RING_DOTS       = 36         -- 旋转环点数
local RING_RADIUS_PX  = 120        -- 圆环半径（1080p 基准像素）
local LOGO_FONT_PX    = 72         -- “AW” 字号（1080p 基准）
local TYPE_FONT_PX    = 28         -- 底部文字字号（1080p 基准）
---------------------------------------------------------------------------

-- == 初始化 ===============================================================
local start_time   = globals.RealTime()
local finished     = false

-- DPI‑Aware 缩放
local scr_x, scr_y = draw.GetScreenSize()
local scale        = scr_y / 1080        -- 1080p 基准
local center_x, center_y = scr_x * 0.5, scr_y * 0.35

-- 字体一次性创建（避免帧内重建）
local logo_font  = draw.CreateFont("Verdana Bold", math.floor(LOGO_FONT_PX  * scale + 0.5), 1000)
local type_font  = draw.CreateFont("Verdana",      math.floor(TYPE_FONT_PX  * scale + 0.5), 800)

-- 文字常量
local TYPE_TEXT  = "AIMWARE.NET"

-- == 辅助函数 =============================================================
local function filled_rect(x1, y1, x2, y2, r, g, b, a)
    draw.Color(r, g, b, a); draw.FilledRect(x1, y1, x2, y2)
end

-- == 主绘制回调 ============================================================
local function on_draw()
    if finished then return end

    local now   = globals.RealTime()
    local t     = now - start_time

    -- 结束判定
    if t > ANIM_DURATION + FADE_OUT_TIME then
        finished = true
        callbacks.Unregister("Draw", "aw_inject_anim_draw")
        return
    end

    -- Alpha 计算（淡出阶段逐渐减小）
    local alpha_fac = 1.0
    if t > ANIM_DURATION then
        alpha_fac = 1.0 - (t - ANIM_DURATION) / FADE_OUT_TIME
    end
    local alpha = math.floor(255 * alpha_fac + 0.5)

    -----------------------------------------------------------------------
    -- 背景半透明遮罩
    -----------------------------------------------------------------------
    filled_rect(0, 0, scr_x, scr_y, 0, 0, 0, math.floor(BG_ALPHA * alpha_fac))

    -----------------------------------------------------------------------
    -- 旋转环 + 中央 “AW” logo
    -----------------------------------------------------------------------
    local ring_radius = RING_RADIUS_PX * scale
    local dot_size    = 6 * scale
    local rot_speed   = 120               -- 角速度 deg/s
    local current_rot = t * rot_speed

    local r, g, b = MAIN_COLOR[1], MAIN_COLOR[2], MAIN_COLOR[3]
    for i = 0, RING_DOTS - 1 do
        local angle_deg = i * 360 / RING_DOTS + current_rot
        local rad       = math.rad(angle_deg)
        local px = center_x + math.cos(rad) * ring_radius
        local py = center_y + math.sin(rad) * ring_radius
        filled_rect(
            px - dot_size / 2, py - dot_size / 2,
            px + dot_size / 2, py + dot_size / 2,
            r, g, b, alpha
        )
    end

    -- 中心大字 “AW”
    draw.SetFont(logo_font)
    draw.Color(r, g, b, alpha)
    local aw_text = "AW"
    local txt_w, txt_h = draw.GetTextSize(aw_text)
    draw.Text(center_x - txt_w / 2, center_y - txt_h / 2, aw_text)

    -----------------------------------------------------------------------
    -- 底部 typewriter 动画 “AIMWARE.NET”
    -----------------------------------------------------------------------
    local typed_chars = math.max(0, math.min(#TYPE_TEXT,
                        math.floor((t - 0.5) / TYPE_DELAY)))  -- 0.5s 延迟后开始
    local text_show   = TYPE_TEXT:sub(1, typed_chars)

    draw.SetFont(type_font)
    local base_y = scr_y * 0.75
    local tw, th = draw.GetTextSize(text_show)
    filled_rect(center_x - tw/2 - 10, base_y - 5,
                center_x + tw/2 + 10, base_y + th + 5,
                0, 0, 0, math.floor(120 * alpha_fac))        -- 小背景条

    draw.Color(255, 255, 255, alpha)
    draw.Text(center_x - tw / 2, base_y, text_show)
end

callbacks.Register("Draw", "aw_inject_anim_draw", on_draw)

-- == 卸载安全钩 ============================================================
callbacks.Register("Unload", function() finished = true end)
