--------------------------------------------------------------------------
-- AIMWARE Intro · 高级版 v9.0 - 优雅现代风格
--------------------------------------------------------------------------

-- 配置区 ---------------------------------------
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


-- 高级配置
local MAIN_COLOR = {227,6,19}      -- 主色调
local ACCENT_COLOR = {255,100,100} -- 强调色
local BG_ALPHA = 220               -- 背景不透明度
local PARTICLES = 50               -- 粒子数量
local SCAN_SPEED = 0.015           -- 更流畅的扫描
local GLOW_INTENSITY = 3           -- 辉光强度

---------------------------------------------------------------------------
-- 高级视觉效果系统
---------------------------------------------------------------------------
local scr_x, scr_y = draw.GetScreenSize()
local scale = scr_y/1080
local cx, cy = scr_x/2, scr_y*0.45

-- 字体系统
local logo_font = draw.CreateFont("Consolas", math.floor(26*scale), 700)
local title_font = draw.CreateFont("Segoe UI", math.floor(42*scale), 800)
local subtitle_font = draw.CreateFont("Segoe UI", math.floor(18*scale), 400)

-- 粒子系统
local particles = {}
local function initParticles()
    for i=1,PARTICLES do
        particles[i] = {
            x = math.random(0, scr_x),
            y = math.random(0, scr_y),
            vx = (math.random()-0.5) * 2,
            vy = (math.random()-0.5) * 2,
            life = math.random(),
            size = math.random() * 3 + 1
        }
    end
end

-- 缓动函数
local function easeInOutCubic(t)
    return t < 0.5 and 4 * t * t * t or 1 - math.pow(-2 * t + 2, 3) / 2
end

local function easeOutElastic(t)
    local c4 = (2 * math.pi) / 3
    return t == 0 and 0 or t == 1 and 1 or math.pow(2, -10 * t) * math.sin((t * 10 - 0.75) * c4) + 1
end

-- 工具函数
local function lerp(a,b,t) return a+(b-a)*t end
local function filled(x1,y1,x2,y2,r,g,b,a)
    draw.Color(r,g,b,a); draw.FilledRect(x1,y1,x2,y2)
end

-- 渐变矩形
local function gradientRect(x1,y1,x2,y2, r1,g1,b1,a1, r2,g2,b2,a2, vertical)
    local steps = 20
    for i=0,steps-1 do
        local t = i/steps
        local r = lerp(r1,r2,t)
        local g = lerp(g1,g2,t)
        local b = lerp(b1,b2,t)
        local a = lerp(a1,a2,t)
        
        if vertical then
            local y = lerp(y1,y2,t)
            local h = (y2-y1)/steps
            filled(x1, y, x2, y+h, r,g,b,a)
        else
            local x = lerp(x1,x2,t)
            local w = (x2-x1)/steps
            filled(x, y1, x+w, y2, r,g,b,a)
        end
    end
end

-- 辉光效果
local function drawGlow(x, y, text, font, intensity, r, g, b, a)
    draw.SetFont(font)
    local tw, th = draw.GetTextSize(text)
    
    -- 多层辉光
    for i=1,intensity do
        local offset = i * 2
        local glow_alpha = math.floor(a * (0.3/i))
        
        -- 8方向辉光
        for dx=-1,1 do
            for dy=-1,1 do
                if dx~=0 or dy~=0 then
                    draw.Color(r,g,b,glow_alpha)
                    draw.Text(x + dx*offset, y + dy*offset, text)
                end
            end
        end
    end
    
    -- 主文字
    draw.Color(r,g,b,a)
    draw.Text(x, y, text)
end

---------------------------------------------------------------------------
-- 主动画系统
---------------------------------------------------------------------------
local t0 = globals.RealTime()
local inited = false
local logo_height, progress_y

callbacks.Register("Draw","aw_intro_premium",function()
    if not inited then
        initParticles()
        draw.SetFont(logo_font)
        logo_height = #ASCII * select(2, draw.GetTextSize("A")) * 0.7
        progress_y = cy + logo_height/2 + 80*scale
        inited = true
    end
    
    local t = globals.RealTime() - t0
    local phase1_duration = 1.5  -- 入场动画
    local phase2_duration = 2.0  -- logo扫描
    local phase3_duration = 1.0  -- 完成效果
    local total_duration = phase1_duration + phase2_duration + phase3_duration
    
    -- 全局透明度
    local global_alpha = 1
    if t > total_duration - 0.8 then
        global_alpha = (total_duration - t) / 0.8
    end
    
    if t > total_duration then
        callbacks.Unregister("Draw","aw_intro_premium")
        return
    end
    
    ---------------------------------------------------------------------
    -- 动态背景
    ---------------------------------------------------------------------
    -- 渐变背景
    gradientRect(0, 0, scr_x, scr_y, 
                 0,0,0,math.floor(BG_ALPHA*global_alpha),
                 10,5,15,math.floor(BG_ALPHA*global_alpha*0.8), true)
    
    -- 更新粒子
    for i,p in ipairs(particles) do
        p.x = p.x + p.vx
        p.y = p.y + p.vy
        p.life = p.life + 0.01
        
        if p.x < 0 or p.x > scr_x then p.vx = -p.vx end
        if p.y < 0 or p.y > scr_y then p.vy = -p.vy end
        
        local alpha = math.floor(50 * math.sin(p.life) * global_alpha)
        if alpha > 0 then
            filled(p.x-p.size/2, p.y-p.size/2, p.x+p.size/2, p.y+p.size/2,
                   MAIN_COLOR[1], MAIN_COLOR[2], MAIN_COLOR[3], alpha)
        end
    end
    
    ---------------------------------------------------------------------
    -- Phase 1: 入场动画
    ---------------------------------------------------------------------
    if t < phase1_duration then
        local progress = easeOutElastic(t / phase1_duration)
        local y_offset = (1 - progress) * 200
        
        -- Logo预览（模糊效果）
        draw.SetFont(logo_font)
        local preview_alpha = math.floor(100 * progress * global_alpha)
        for row, line in ipairs(ASCII) do
            if line ~= "" then
                local y = cy - logo_height/2 + (row-1)*select(2,draw.GetTextSize("A"))*0.7 - y_offset
                local x = cx - draw.GetTextSize(line)/2
                draw.Color(MAIN_COLOR[1], MAIN_COLOR[2], MAIN_COLOR[3], preview_alpha)
                draw.Text(x, y, line)
            end
        end
        
        -- 标题预告
        draw.SetFont(title_font)
        local title_y = progress_y - y_offset
        local title_alpha = math.floor(150 * progress * global_alpha)
        draw.Color(255,255,255, title_alpha)
        local tw = draw.GetTextSize("AIMWARE.NET")
        draw.Text(cx - tw/2, title_y, "AIMWARE.NET")
        
        return
    end
    
    ---------------------------------------------------------------------
    -- Phase 2: 高级Logo扫描
    ---------------------------------------------------------------------
    local scan_t = t - phase1_duration
    if scan_t < phase2_duration then
        local scan_progress = scan_t / phase2_duration
        local current_line = math.floor(scan_progress * #ASCII) + 1
        
        draw.SetFont(logo_font)
        
        for row, line in ipairs(ASCII) do
            if line ~= "" then
                local y = cy - logo_height/2 + (row-1)*select(2,draw.GetTextSize("A"))*0.7
                local x = cx - draw.GetTextSize(line)/2
                
                if row < current_line then
                    -- 已完成的行 - 带辉光
                    drawGlow(x, y, line, logo_font, 2, 
                            MAIN_COLOR[1], MAIN_COLOR[2], MAIN_COLOR[3], 
                            math.floor(255*global_alpha))
                elseif row == current_line then
                    -- 当前扫描行 - 打字机效果
                    local char_progress = (scan_progress * #ASCII) - (current_line - 1)
                    local chars_to_show = math.floor(char_progress * #line)
                    if chars_to_show > 0 then
                        local partial_line = line:sub(1, chars_to_show)
                        drawGlow(x, y, partial_line, logo_font, 3,
                                255, 255, 255, math.floor(255*global_alpha))
                    end
                end
            end
        end
        
        -- 扫描线效果
        local scan_line_y = cy - logo_height/2 + (current_line-1)*select(2,draw.GetTextSize("A"))*0.7
        gradientRect(0, scan_line_y-2, scr_x, scan_line_y+2,
                     0,0,0,0, 255,255,255,math.floor(100*global_alpha), false)
        
        -- 进度条
        local progress_width = 300*scale
        local progress_x = cx - progress_width/2
        filled(progress_x-2, progress_y-2, progress_x+progress_width+2, progress_y+8,
               50,50,50, math.floor(150*global_alpha))
        
        gradientRect(progress_x, progress_y, progress_x + progress_width*scan_progress, progress_y+4,
                     MAIN_COLOR[1], MAIN_COLOR[2], MAIN_COLOR[3], math.floor(200*global_alpha),
                     ACCENT_COLOR[1], ACCENT_COLOR[2], ACCENT_COLOR[3], math.floor(200*global_alpha), false)
        
        return
    end
    
    ---------------------------------------------------------------------
    -- Phase 3: 完成效果
    ---------------------------------------------------------------------
    local complete_t = t - phase1_duration - phase2_duration
    local pulse = math.sin(complete_t * 8) * 0.3 + 0.7
    
    -- 完整Logo带脉冲效果
    draw.SetFont(logo_font)
    for row, line in ipairs(ASCII) do
        if line ~= "" then
            local y = cy - logo_height/2 + (row-1)*select(2,draw.GetTextSize("A"))*0.7
            local x = cx - draw.GetTextSize(line)/2
            
            local r = lerp(MAIN_COLOR[1], 255, pulse*0.3)
            local g = lerp(MAIN_COLOR[2], 255, pulse*0.3)
            local b = lerp(MAIN_COLOR[3], 255, pulse*0.3)
            
            drawGlow(x, y, line, logo_font, math.floor(GLOW_INTENSITY*pulse),
                    r, g, b, math.floor(255*global_alpha))
        end
    end
    
    -- 高级标题效果
    draw.SetFont(title_font)
    local title_glow = math.floor(4 * pulse)
    drawGlow(cx - draw.GetTextSize("AIMWARE.NET")/2, progress_y, "AIMWARE.NET", 
             title_font, title_glow, 255, 255, 255, math.floor(255*global_alpha))
    
    -- 副标题
    draw.SetFont(subtitle_font)
    local subtitle = "One Step Ahead of the Game | Since 2014"
    local sub_alpha = math.floor(180 * pulse * global_alpha)
    draw.Color(150, 150, 150, sub_alpha)
    draw.Text(cx - draw.GetTextSize(subtitle)/2, progress_y + 50*scale, subtitle)
    
    -- 完成进度条
    local progress_width = 300*scale
    local progress_x = cx - progress_width/2
    filled(progress_x-2, progress_y+20-2, progress_x+progress_width+2, progress_y+20+8,
           50,50,50, math.floor(150*global_alpha))
    
    gradientRect(progress_x, progress_y+20, progress_x + progress_width, progress_y+20+4,
                 MAIN_COLOR[1], MAIN_COLOR[2], MAIN_COLOR[3], math.floor(255*pulse*global_alpha),
                 ACCENT_COLOR[1], ACCENT_COLOR[2], ACCENT_COLOR[3], math.floor(255*pulse*global_alpha), false)
end)
