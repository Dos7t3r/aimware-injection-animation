--------------------------------------------------------------------------
-- AIMWARE Intro · ASCII LOGO + 扫描 + 环 + 打字辉光   v8.1  (优化版)
--------------------------------------------------------------------------

-- 可调区 ---------------------------------------
-- 1) ASCII LOGO（已做 1:1 等宽，行间空行以撑高）
local ASCII = {
    "                                                            .:.                                     ",
    "",
    "                                          .::----------::. :=++=-:.                                 ",
    "",
    "                                     .--=++++++++++++++++++++++++++=-                               ",
    "",
    "                                 .:=++++++++++++++++++++++++++++++++:                               ",
    "",
    "                               :=++++++++==-::.........-++++++++++++:                               ",
    "",
    "                             -=++++++=-:.             .=++++++++++++++-.                            ",
    "",
    "                      .:.  :=++++++-.                -++++++++++++++=+++-                           ",
    "",
    "                     .=++==+++++=:         .::--=====++++++++++++.:=+++++=.                         ",
    "",
    "                    .=++++++++++=..     :-=+++++++++++++++++++++.   -++++++:                        ",
    "",
    "                   .=++++++++++++++==:-++++++++++++++++++++++++:     .=+++++-                       ",
    "",
    "                   -=++++++++++++++++++++++==-:...-++++++++++++-.      =+++++:                      ",
    "",
    "                     :+++++++++++++++++++++:      :++++++++++++++:      =+++++.                     ",
    "",
    "                     -+++++++++++++++++++++=:     :+=+++++=-++++++.     :+++++=                     ",
    "",
    "                     +++++=.-=+++++++++++++++-    .++++=:.  :+++++=      =+++++.                    ",
    "",
    "                    :+++++-   .:=+++++++++++++=.  .+-:       -+++++:     :+++++:                    ",
    "",
    "                    :+++++:     -+++++====------             .+++++=     .+++++-                    ",
    "",
    "                    :+++++:     -+++++:             --------==+++++=     .+++++-                    ",
    "",
    "                    :+++++-     :+++++-       .-=.  .=+++++++++++++=:.   :+++++:                    ",
    "",
    "                     +++++=      =+++++:   :-=+++:    -+++++++++++++++=:.=+++++.                    ",
    "",
    "                     -+++++-     .++++++--=++++=+:     :++++++++++++++++++++++=                     ",
    "",
    "                      ++++++.     .=+++++++++++++-      :+++++++++++++++++++++-                     ",
    "",
    "                      :++++++.     .-++++++++++++= ..::==++++++++++++++++++++++=-                   ",
    "",
    "                       :++++++:     .++++++++++++++++++++++++=-==+++++++++++++++:                   ",
    "",
    "                        :++++++-.  .=+++++++++++++++++++++=:.    .:-+++++++++++.                    ",
    "",
    "                         .=++++++-.=+++++++++++======--:.         :=+++++++++=.                     ",
    "",
    "                           -++++++++++++++++++=                .-=++++++-  .:.                      ",
    "",
    "                            .-++++++++++++++=:             .:-=+++++++-.                            ",
    "",
    "                               :=+++++++++++=:........::-==++++++++=-.                              ",
    "",
    "                               .++++++++++++++++++++++++++++++++=-.                                 ",
    "",
    "                               -=++++++++++++++++++++++++++==-:.                                    ",
    "",
    "                                 .:-=+++:..::---====----:..                                          ",
    "",
    "                                     .:.                                                            ",
    "",
}

-- 2) 颜色、速度配置
local MAIN = {227,6,19}        -- 已扫颜色（红）
local NOW  = {255,255,255}     -- 正在扫颜色（白）
local BG_ALPHA   = 200         -- 背景遮罩（增加不透明度）
local LINE_DELAY = 0.02        -- 每行扫描速度
local HOLD_TIME  = 3.0         -- LOGO 完成后停留
local DOTS       = 12          -- 环点数（增加点数让环更明显）
local DOT_SIZE   = 4           -- 像素（增加点大小）
local ROT_SPEED  = 15          -- deg/s（加快旋转）
local TYPE_TEXT  = "AIMWARE.NET"
local TYPE_DELAY = 0.08        -- 打字机速度（稍快一点）

---------------------------------------------------------------------------
-- ↓ 优化后的布局参数 ↓ 
---------------------------------------------------------------------------
local scr_x, scr_y = draw.GetScreenSize()
local scale   = scr_y/1080
local font    = draw.CreateFont("Consolas", math.floor(28*scale+0.5), 700)  -- 稍小字体，加粗
local type_ft = draw.CreateFont("Segoe UI", math.floor(36*scale+0.5), 800)  -- 更大更粗的底部字体

local t0 = globals.RealTime()

-- LOGO 行数、宽度
local total_lines, logo_width = 0, 0
for _,l in ipairs(ASCII) do
    total_lines = total_lines + 1
    if #l > logo_width then logo_width = #l end
end

-- 优化后的屏幕布局：更居中，更紧凑
local cx, cy = scr_x/2, scr_y*0.45  -- 稍微下移

-- 初始化标志
local inited  = false
local line_h, logo_h, y0, ring_radius

-- 工具函数
local function lerp(a,b,t) return a+(b-a)*t end
local function filled(x1,y1,x2,y2,r,g,b,a)
    draw.Color(r,g,b,a); draw.FilledRect(x1,y1,x2,y2)
end

---------------------------------------------------------------------------
-- Draw 回调：主逻辑
---------------------------------------------------------------------------
callbacks.Register("Draw","aw_intro_v8",function()
    ---------------------------------------------------------------------
    -- 一次性初始化
    ---------------------------------------------------------------------
    if not inited then
        draw.SetFont(font)
        line_h     = select(2, draw.GetTextSize("A"))
        logo_h     = total_lines * line_h * 0.8  -- 压缩行高，让logo更紧凑
        y0         = cy - logo_h/2
        -- 环半径稍小，让整体更集中
        ring_radius= (logo_width * (7*scale)) * 0.45
        inited     = true
    end

    ---------------------------------------------------------------------
    -- 时间轴 & Alpha 曲线
    ---------------------------------------------------------------------
    local t   = globals.RealTime() - t0
    local ttl_logo = total_lines*LINE_DELAY + HOLD_TIME
    local ttl_all  = ttl_logo + 0.8  -- 稍长的淡出时间
    local aF = (t<0.5) and t/0.5 
              or (t>ttl_all-0.8 and (ttl_all-t)/0.8) 
              or 1
    local a255 = math.floor(255*aF+0.5)

    -- 结束：注销回调
    if t > ttl_all then
        callbacks.Unregister("Draw","aw_intro_v8")
        return
    end

    -- 背景半透明幕布
    filled(0,0,scr_x,scr_y, 0,0,0, math.floor(BG_ALPHA*aF))

    ---------------------------------------------------------------------
    -- LOGO 扫描（压缩行间距）
    ---------------------------------------------------------------------
    local current_line = math.floor(t / LINE_DELAY) + 1
    draw.SetFont(font)
    
    for row,line in ipairs(ASCII) do
        if line ~= "" then
            local y = y0 + (row-1)*line_h*0.8  -- 压缩行间距
            local x = cx - draw.GetTextSize(line)/2
            local r,g,b = unpack(row < current_line and MAIN or NOW)
            draw.Color(r,g,b,a255)
            
            if row == current_line then
                -- 正在扫描的行
                local chars = math.min(#line,
                              math.floor((t%LINE_DELAY)/LINE_DELAY * #line))
                if chars>0 then
                    draw.Text(x,y,line:sub(1,chars))
                end
            elseif row < current_line then
                -- 已扫描完
                draw.Text(x,y,line)
            end
        end
    end

    ---------------------------------------------------------------------
    -- 旋转环（更明显）
    ---------------------------------------------------------------------
    local rot = t * ROT_SPEED
    local sz  = DOT_SIZE*scale
    for i=0,DOTS-1 do
        local ang = math.rad(i*360/DOTS + rot)
        local px  = cx + math.cos(ang)*ring_radius
        local py  = cy + math.sin(ang)*ring_radius
        
        -- 添加发光效果
        for glow=1,3 do
            local glow_sz = sz + glow*2
            local glow_alpha = math.floor(a255 * (0.3/glow))
            filled(px-glow_sz/2, py-glow_sz/2, px+glow_sz/2, py+glow_sz/2,
                   MAIN[1],MAIN[2],MAIN[3], glow_alpha)
        end
        
        -- 主点
        filled(px-sz/2, py-sz/2, px+sz/2, py+sz/2,
               MAIN[1],MAIN[2],MAIN[3], a255)
    end

    ---------------------------------------------------------------------
    -- AIMWARE.NET 打字机 + 增强显示
    ---------------------------------------------------------------------
    draw.SetFont(type_ft)
    local text_y = cy + logo_h/2 + 40*scale  -- 相对logo底部定位
    local typed  = math.min(#TYPE_TEXT, math.floor(t/TYPE_DELAY))
    local show   = TYPE_TEXT:sub(1,typed)
    local tw,th  = draw.GetTextSize(show)
    
    -- 增强的背景框
    local padding = 20*scale
    filled(cx-tw/2-padding, text_y-padding/2,
           cx+tw/2+padding, text_y+th+padding/2,
           0,0,0, math.floor(180*aF))
    
    -- 边框效果
    draw.Color(MAIN[1],MAIN[2],MAIN[3], math.floor(100*aF))
    draw.OutlinedRect(cx-tw/2-padding, text_y-padding/2,
                      cx+tw/2+padding, text_y+th+padding/2)
    
    -- 主文字
    draw.Color(255,255,255,a255)
    draw.Text(cx - tw/2, text_y, show)
    
    -- 辉光效果：全部打完后的闪烁
    if typed == #TYPE_TEXT then
        local glow_t = (t - #TYPE_TEXT*TYPE_DELAY)
        if glow_t < 2 then  -- 延长辉光时间
            local gfac = math.sin(glow_t*math.pi*2) * 0.5 + 0.5  -- 持续闪烁
            local r = lerp(255, MAIN[1], gfac)
            local g = lerp(255, MAIN[2], gfac)
            local b = lerp(255, MAIN[3], gfac)
            
            -- 文字辉光
            for i=1,2 do
                draw.Color(r,g,b, math.floor(a255*gfac*0.8))
                draw.Text(cx - tw/2 + i, text_y, TYPE_TEXT)
                draw.Text(cx - tw/2 - i, text_y, TYPE_TEXT)
                draw.Text(cx - tw/2, text_y + i, TYPE_TEXT)
                draw.Text(cx - tw/2, text_y - i, TYPE_TEXT)
            end
            
            draw.Color(r,g,b,a255)
            draw.Text(cx - tw/2, text_y, TYPE_TEXT)
        end
    end
end)
