-- AIMWARE Intro Simple Version
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

-- 基本配置
local scr_x, scr_y = draw.GetScreenSize()
local scale = scr_y / 1080
local cx = scr_x / 2
local cy = scr_y * 0.45

-- 字体
local logo_font = draw.CreateFont("Consolas", math.floor(26 * scale), 700)
local title_font = draw.CreateFont("Segoe UI", math.floor(42 * scale), 800)
local loading_font = draw.CreateFont("Segoe UI", math.floor(14 * scale), 400)

-- 颜色
local main_r, main_g, main_b = 227, 6, 19
local bg_alpha = 220

-- 粒子
local particles = {}
local particle_count = 25

-- 加载步骤
local loading_steps = {}
loading_steps[1] = {text = "Initializing injection framework", duration = 0.3, progress = 0.05}
loading_steps[2] = {text = "Loading core modules", duration = 0.4, progress = 0.15}
loading_steps[3] = {text = "Scanning target process", duration = 0.6, progress = 0.25}
loading_steps[4] = {text = "Bypassing security checks", duration = 0.8, progress = 0.40}
loading_steps[5] = {text = "Allocating memory regions", duration = 0.5, progress = 0.55}
loading_steps[6] = {text = "Injecting payload", duration = 0.7, progress = 0.75}
loading_steps[7] = {text = "Establishing hooks", duration = 0.4, progress = 0.85}
loading_steps[8] = {text = "Verifying injection integrity", duration = 0.3, progress = 0.95}
loading_steps[9] = {text = "Injection completed successfully", duration = 0.2, progress = 1.0}

-- 状态变量
local current_step = 1
local step_start_time = 0
local total_progress = 0
local current_text = "Initializing injection framework"

-- 初始化粒子
local function initParticles()
    for i = 1, particle_count do
        particles[i] = {}
        particles[i].x = math.random(0, scr_x)
        particles[i].y = math.random(0, scr_y)
        particles[i].vx = (math.random() - 0.5) * 1.5
        particles[i].vy = (math.random() - 0.5) * 1.5
        particles[i].life = math.random() * math.pi * 2
        particles[i].size = math.random() * 2 + 1
    end
end

-- 工具函数
local function lerp(a, b, t)
    return a + (b - a) * t
end

local function easeInOutCubic(t)
    if t < 0.5 then
        return 4 * t * t * t
    else
        return 1 - math.pow(-2 * t + 2, 3) / 2
    end
end

local function easeOutBack(t)
    local c1 = 1.70158
    local c3 = c1 + 1
    return 1 + c3 * math.pow(t - 1, 3) + c1 * math.pow(t - 1, 2)
end

-- 旋转计算
local function rotatePoint(x, y, cx, cy, angle)
    local cos_a = math.cos(math.rad(angle))
    local sin_a = math.sin(math.rad(angle))
    local dx = x - cx
    local dy = y - cy
    return cx + dx * cos_a - dy * sin_a, cy + dx * sin_a + dy * cos_a
end

-- 填充矩形
local function filled(x1, y1, x2, y2, r, g, b, a)
    draw.Color(r, g, b, a)
    draw.FilledRect(x1, y1, x2, y2)
end

-- 辉光文字
local function drawGlow(x, y, text, font, intensity, r, g, b, a)
    draw.SetFont(font)
    
    for i = 1, intensity do
        local offset = i * 1.5
        local glow_alpha = math.floor(a * (0.4 / i))
        
        draw.Color(r, g, b, glow_alpha)
        draw.Text(x + offset, y, text)
        draw.Text(x - offset, y, text)
        draw.Text(x, y + offset, text)
        draw.Text(x, y - offset, text)
        draw.Text(x + offset, y + offset, text)
        draw.Text(x - offset, y - offset, text)
        draw.Text(x + offset, y - offset, text)
        draw.Text(x - offset, y + offset, text)
    end
    
    draw.Color(r, g, b, a)
    draw.Text(x, y, text)
end

-- 更新加载进度
local function updateLoadingProgress(t)
    if current_step > 9 then
        return 1.0, "Complete"
    end
    
    local current_step_data = loading_steps[current_step]
    local step_elapsed = t - step_start_time
    
    if step_elapsed >= current_step_data.duration then
        total_progress = current_step_data.progress
        current_step = current_step + 1
        step_start_time = t
        
        if current_step <= 9 then
            current_text = loading_steps[current_step].text
        end
    else
        local step_progress = step_elapsed / current_step_data.duration
        local prev_progress = 0
        if current_step > 1 then
            prev_progress = loading_steps[current_step - 1].progress
        end
        total_progress = lerp(prev_progress, current_step_data.progress, step_progress)
        current_text = current_step_data.text
    end
    
    return total_progress, current_text
end

-- 主系统
local t0 = globals.RealTime()
local inited = false
local logo_height = 0
local non_empty_lines = {}

callbacks.Register("Draw", "aw_intro_simple", function()
    if not inited then
        initParticles()
        draw.SetFont(logo_font)
        logo_height = #ASCII * select(2, draw.GetTextSize("A")) * 0.7
        
        for i, line in ipairs(ASCII) do
            if line ~= "" then
                table.insert(non_empty_lines, {index = i, content = line})
            end
        end
        
        inited = true
    end
    
    local t = globals.RealTime() - t0
    
    -- 时间设置
    local phase1_duration = 0.8
    local phase2_duration = 2.0
    local phase3_duration = 2.5
    local phase4_duration = 1.0
    local total_duration = phase1_duration + phase2_duration + phase3_duration + phase4_duration
    
    local global_alpha = 1
    if t > total_duration - 0.8 then
        global_alpha = (total_duration - t) / 0.8
    end
    
    if t > total_duration then
        callbacks.Unregister("Draw", "aw_intro_simple")
        return
    end
    
    -- 背景
    local bg_intensity = math.min(1, t / phase1_duration)
    filled(0, 0, scr_x, scr_y, 0, 0, 0, math.floor(bg_alpha * bg_intensity * global_alpha))
    
    -- 粒子
    for i = 1, particle_count do
        local p = particles[i]
        p.x = p.x + p.vx
        p.y = p.y + p.vy
        p.life = p.life + 0.02
        
        if p.x < 0 or p.x > scr_x then p.vx = -p.vx end
        if p.y < 0 or p.y > scr_y then p.vy = -p.vy end
        
        local alpha = math.floor(40 * (math.sin(p.life) * 0.5 + 0.5) * bg_intensity * global_alpha)
        if alpha > 0 then
            filled(p.x - p.size / 2, p.y - p.size / 2, p.x + p.size / 2, p.y + p.size / 2,
                   main_r, main_g, main_b, alpha)
        end
    end
    
    -- 加载进度条
    local progress, progress_text = updateLoadingProgress(t)
    local progress_y = scr_y - 120 * scale
    local progress_width = 400 * scale
    local progress_x = cx - progress_width / 2
    
    filled(progress_x - 2, progress_y - 2, progress_x + progress_width + 2, progress_y + 8,
           30, 30, 30, math.floor(200 * bg_intensity * global_alpha))
    
    filled(progress_x, progress_y, progress_x + progress_width * progress, progress_y + 4,
           main_r, main_g, main_b, math.floor(220 * global_alpha))
    
    draw.SetFont(loading_font)
    draw.Color(200, 200, 200, math.floor(255 * bg_intensity * global_alpha))
    local progress_str = string.format("%.0f%%", progress * 100)
    draw.Text(progress_x + progress_width + 15 * scale, progress_y - 2, progress_str)
    
    draw.Color(180, 180, 180, math.floor(200 * bg_intensity * global_alpha))
    draw.Text(progress_x, progress_y + 20 * scale, progress_text)
    
    -- Phase 1: 淡入
    if t < phase1_duration then
        return
    end
    
    -- Phase 2: 扫描
    local scan_t = t - phase1_duration
    if scan_t < phase2_duration then
        local scan_progress = easeInOutCubic(scan_t / phase2_duration)
        local lines_to_show = math.floor(scan_progress * #non_empty_lines)
        
        draw.SetFont(logo_font)
        
        for i = 1, #non_empty_lines do
            if i <= lines_to_show then
                local line_data = non_empty_lines[i]
                local row = line_data.index
                local line = line_data.content
                local y = cy - logo_height / 2 + (row - 1) * select(2, draw.GetTextSize("A")) * 0.7
                local x = cx - draw.GetTextSize(line) / 2
                
                if i == lines_to_show then
                    drawGlow(x, y, line, logo_font, 3, 255, 255, 255, math.floor(255 * global_alpha))
                else
                    drawGlow(x, y, line, logo_font, 1, main_r, main_g, main_b, math.floor(255 * global_alpha))
                end
            end
        end
        
        return
    end
    
    -- Phase 3: 旋转
    local rotate_t = scan_t - phase2_duration
    if rotate_t < phase3_duration then
        local rotation_progress = easeOutBack(rotate_t / phase3_duration)
        local current_angle = rotation_progress * 360
        
        draw.SetFont(logo_font)
        
        for i = 1, #non_empty_lines do
            local line_data = non_empty_lines[i]
            local row = line_data.index
            local line = line_data.content
            local base_y = cy - logo_height / 2 + (row - 1) * select(2, draw.GetTextSize("A")) * 0.7
            local base_x = cx - draw.GetTextSize(line) / 2
            
            local rot_x, rot_y = rotatePoint(base_x, base_y, cx, cy, current_angle)
            
            local intensity = math.sin(rotate_t * 4) * 0.3 + 0.7
            local r = lerp(main_r, 255, intensity * 0.4)
            local g = lerp(main_g, 100, intensity * 0.4)
            local b = lerp(main_b, 100, intensity * 0.4)
            
            drawGlow(rot_x, rot_y, line, logo_font, math.floor(2 * intensity), r, g, b, math.floor(255 * global_alpha))
        end
        
        -- 文字特效
        local text_progress = math.min(1, rotate_t / (phase3_duration * 0.7))
        if text_progress > 0 then
            local text_y = cy + logo_height / 2 + 60 * scale
            local chars_to_show = math.floor(text_progress * 11)
            local show_text = "AIMWARE.NET"
            if chars_to_show < 11 then
                show_text = string.sub("AIMWARE.NET", 1, chars_to_show)
            end
            
            if string.len(show_text) > 0 then
                draw.SetFont(title_font)
                local tw = draw.GetTextSize(show_text)
                
                local padding = 25 * scale
                filled(cx - tw / 2 - padding, text_y - padding / 2,
                       cx + tw / 2 + padding, text_y + 40 * scale + padding / 2,
                       0, 0, 0, math.floor(180 * text_progress * global_alpha))
                
                draw.Color(main_r, main_g, main_b, math.floor(120 * text_progress * global_alpha))
                draw.OutlinedRect(cx - tw / 2 - padding, text_y - padding / 2,
                                  cx + tw / 2 + padding, text_y + 40 * scale + padding / 2)
                
                local title_intensity = math.sin(rotate_t * 6) * 0.4 + 0.8
                drawGlow(cx - tw / 2, text_y, show_text, title_font, 
                        math.floor(3 * title_intensity), 255, 255, 255, 
                        math.floor(255 * text_progress * global_alpha))
            end
        end
        
        return
    end
    
    -- Phase 4: 完成
    local complete_t = rotate_t - phase3_duration
    local pulse = math.sin(complete_t * 10) * 0.2 + 0.8
    
    draw.SetFont(logo_font)
    for i = 1, #non_empty_lines do
        local line_data = non_empty_lines[i]
        local row = line_data.index
        local line = line_data.content
        local y = cy - logo_height / 2 + (row - 1) * select(2, draw.GetTextSize("A")) * 0.7
        local x = cx - draw.GetTextSize(line) / 2
        
        local r = lerp(main_r, 255, pulse * 0.3)
        local g = lerp(main_g, 255, pulse * 0.3)
        local b = lerp(main_b, 255, pulse * 0.3)
        
        drawGlow(x, y, line, logo_font, math.floor(3 * pulse), r, g, b, math.floor(255 * global_alpha))
    end
    
    local text_y = cy + logo_height / 2 + 60 * scale
    draw.SetFont(title_font)
    local tw = draw.GetTextSize("AIMWARE.NET")
    
    drawGlow(cx - tw / 2, text_y, "AIMWARE.NET", title_font, 
            math.floor(4 * pulse), 255, 255, 255, math.floor(255 * global_alpha))
end)
