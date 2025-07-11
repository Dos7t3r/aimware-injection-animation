-- AIMWARE Enhanced Dual Logo - 增强双层logo效果 v2

-- 基本配置
local scr_x, scr_y = draw.GetScreenSize()
local scale = scr_y / 1080
local cx = scr_x / 2
local cy = scr_y * 0.42

-- 字体
local background_logo_font = draw.CreateFont("Consolas", math.floor(26 * scale), 700)
local main_logo_font = draw.CreateFont("Consolas", math.floor(36 * scale), 800)
local title_font = draw.CreateFont("Segoe UI", math.floor(42 * scale), 800)
local loading_font = draw.CreateFont("Segoe UI", math.floor(14 * scale), 400)

-- 颜色
local main_r, main_g, main_b = 227, 6, 19
local bg_alpha = 220

-- 背景ASCII logo（你的）
local background_ASCII = {
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

-- 主要logo（我的花样字体）
local main_logo_lines = {
    "     ▄▄▄       ██▓ ███▄ ▄███▓ █     █░ ▄▄▄       ██▀███  ▓█████ ",
    "    ▒████▄    ▓██▒▓██▒▀█▀ ██▒▓█░ █ ░█░▒████▄    ▓██ ▒ ██▒▓█   ▀ ",
    "    ▒██  ▀█▄  ▒██▒▓██    ▓██░▒█░ █ ░█ ▒██  ▀█▄  ▓██ ░▄█ ▒▒███   ",
    "    ░██▄▄▄▄██ ░██░▒██    ▒██ ░█░ █ ░█ ░██▄▄▄▄██ ▒██▀▀█▄  ▒▓█  ▄ ",
    "     ▓█   ▓██▒░██░▒██▒   ░██▒░░██▒██▓  ▓█   ▓██▒░██▓ ▒██▒░▒████▒",
    "     ▒▒   ▓▒█░░▓  ░ ▒░   ░  ░░ ▓░▒ ▒   ▒▒   ▓▒█░░ ▒▓ ░▒▓░░░ ▒░ ░",
    "      ▒   ▒▒ ░ ▒ ░░  ░      ░  ▒ ░ ░    ▒   ▒▒ ░  ░▒ ░ ▒░ ░ ░  ░",
    "      ░   ▒    ▒ ░░      ░     ░   ░    ░   ▒     ░░   ░    ░   ",
    "          ░  ░ ░         ░       ░          ░  ░   ░        ░  ░"
}

-- 加载步骤
local loading_steps = {}
loading_steps[1] = {text = "Initializing injection framework", duration = 0.15, progress = 0.05}
loading_steps[2] = {text = "Loading core modules", duration = 0.2, progress = 0.12}
loading_steps[3] = {text = "Scanning target process", duration = 0.4, progress = 0.20}
loading_steps[4] = {text = "Analyzing process memory", duration = 0.25, progress = 0.28}
loading_steps[5] = {text = "Bypassing security checks", duration = 0.5, progress = 0.40}
loading_steps[6] = {text = "Waiting for safe injection window", duration = 0.3, progress = 0.48}
loading_steps[7] = {text = "Allocating memory regions", duration = 0.2, progress = 0.58}
loading_steps[8] = {text = "Preparing payload", duration = 0.15, progress = 0.68}
loading_steps[9] = {text = "Injecting payload", duration = 0.4, progress = 0.80}
loading_steps[10] = {text = "Establishing function hooks", duration = 0.25, progress = 0.88}
loading_steps[11] = {text = "Initializing cheat features", duration = 0.2, progress = 0.94}
loading_steps[12] = {text = "Verifying injection integrity", duration = 0.25, progress = 0.98}
loading_steps[13] = {text = "Injection completed successfully", duration = 0.15, progress = 1.0}

-- 状态变量
local current_step = 1
local step_start_time = 0
local total_progress = 0
local current_text = "Initializing injection framework"
local completion_time = 0

-- 粒子系统
local particles = {}
local particle_count = 25
local background_non_empty_lines = {}

-- 初始化
local function initParticles()
    for i = 1, particle_count do
        particles[i] = {
            x = math.random(0, scr_x),
            y = math.random(0, scr_y),
            vx = (math.random() - 0.5) * 1.5,
            vy = (math.random() - 0.5) * 1.5,
            life = math.random() * math.pi * 2,
            size = math.random() * 2 + 1,
            alpha = math.random() * 0.3 + 0.2
        }
    end
    
    -- 提取背景logo的非空行
    for i, line in ipairs(background_ASCII) do
        if line ~= "" then
            table.insert(background_non_empty_lines, {index = i, content = line})
        end
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

-- 填充矩形
local function filled(x1, y1, x2, y2, r, g, b, a)
    draw.Color(r, g, b, a)
    draw.FilledRect(x1, y1, x2, y2)
end

-- 胶囊形状绘制
local function drawCapsule(x, y, width, height, r, g, b, a)
    local radius = height / 2
    
    filled(x, y, x + width, y + height, r, g, b, a)
    
    for i = 0, radius do
        local circle_alpha = a * (1 - (i / radius) * 0.3)
        filled(x - i, y + i, x - i + 1, y + height - i, r, g, b, math.floor(circle_alpha))
    end
    
    for i = 0, radius do
        local circle_alpha = a * (1 - (i / radius) * 0.3)
        filled(x + width + i, y + i, x + width + i + 1, y + height - i, r, g, b, math.floor(circle_alpha))
    end
end

-- 辉光文字
local function drawGlow(x, y, text, font, intensity, r, g, b, a)
    draw.SetFont(font)
    
    for i = 1, intensity do
        local offset = i * 1.2
        local glow_alpha = math.floor(a * (0.3 / i))
        
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

-- 绘制背景logo（你的ASCII，30%透明度）
local function drawBackgroundLogo(alpha_mult, scan_progress, dimming_factor)
    draw.SetFont(background_logo_font)
    local line_height = select(2, draw.GetTextSize("A")) * 0.7
    local bg_logo_height = #background_ASCII * line_height
    
    -- 设置为30%透明度
    local final_dimming = (dimming_factor or 1.0) * 0.3  -- 30%透明度
    
    if scan_progress then
        -- 扫描模式
        local lines_to_show = math.floor(scan_progress * #background_non_empty_lines)
        
        for i = 1, #background_non_empty_lines do
            if i <= lines_to_show then
                local line_data = background_non_empty_lines[i]
                local row = line_data.index
                local line = line_data.content
                local y = cy - bg_logo_height / 2 + (row - 1) * line_height
                local x = cx - draw.GetTextSize(line) / 2
                
                if i == lines_to_show then
                    -- 当前扫描行（白色高亮，但也是30%透明度）
                    drawGlow(x, y, line, background_logo_font, 2, 255, 255, 255, 
                            math.floor(255 * alpha_mult * final_dimming))
                else
                    -- 已完成的行（红色，30%透明度）
                    drawGlow(x, y, line, background_logo_font, 1, main_r, main_g, main_b, 
                            math.floor(200 * alpha_mult * final_dimming))
                end
            end
        end
    else
        -- 静态显示（30%透明度）
        for i, line in ipairs(background_ASCII) do
            if line ~= "" then
                local y = cy - bg_logo_height / 2 + (i - 1) * line_height
                local x = cx - draw.GetTextSize(line) / 2
                
                drawGlow(x, y, line, background_logo_font, 1, main_r, main_g, main_b, 
                        math.floor(200 * alpha_mult * final_dimming))
            end
        end
    end
end

-- 绘制主logo
local function drawMainLogo(alpha_mult, scan_progress, effect_mode)
    draw.SetFont(main_logo_font)
    local line_height = select(2, draw.GetTextSize("A")) * 0.8
    local main_logo_height = #main_logo_lines * line_height
    
    if scan_progress then
        -- 扫描模式
        local lines_to_show = math.floor(scan_progress * #main_logo_lines)
        
        for i = 1, #main_logo_lines do
            if i <= lines_to_show then
                local line = main_logo_lines[i]
                local y = cy - main_logo_height / 2 + (i - 1) * line_height
                local x = cx - draw.GetTextSize(line) / 2
                
                if i == lines_to_show then
                    -- 当前扫描行
                    drawGlow(x, y, line, main_logo_font, 4, 255, 255, 255, math.floor(255 * alpha_mult))
                else
                    -- 已完成的行
                    drawGlow(x, y, line, main_logo_font, 2, main_r, main_g, main_b, math.floor(220 * alpha_mult))
                end
            end
        end
    elseif effect_mode then
        -- 特效模式
        local color_pulse = effect_mode.color_pulse
        local rotation_angle = effect_mode.rotation_angle
        
        for i, line in ipairs(main_logo_lines) do
            local base_y = cy - main_logo_height / 2 + (i - 1) * line_height
            local base_x = cx - draw.GetTextSize(line) / 2
            
            -- 旋转效果
            local offset_x = math.sin(math.rad(rotation_angle + i * 8)) * 4
            local offset_y = math.cos(math.rad(rotation_angle + i * 8)) * 2
            
            local x = base_x + offset_x
            local y = base_y + offset_y
            
            local r = lerp(main_r, 255, color_pulse * 0.6)
            local g = lerp(main_g, 150, color_pulse * 0.6)
            local b = lerp(main_b, 150, color_pulse * 0.6)
            
            drawGlow(x, y, line, main_logo_font, math.floor(4 * color_pulse), r, g, b, 
                    math.floor(255 * alpha_mult))
        end
    else
        -- 静态显示
        for i, line in ipairs(main_logo_lines) do
            local y = cy - main_logo_height / 2 + (i - 1) * line_height
            local x = cx - draw.GetTextSize(line) / 2
            
            drawGlow(x, y, line, main_logo_font, 2, main_r, main_g, main_b, 
                    math.floor(200 * alpha_mult))
        end
    end
end

-- 更新加载进度
local function updateLoadingProgress(t)
    if current_step > #loading_steps then
        if completion_time == 0 then
            completion_time = t
        end
        return 1.0, "Injection completed successfully"
    end
    
    local current_step_data = loading_steps[current_step]
    local step_elapsed = t - step_start_time
    
    if step_elapsed >= current_step_data.duration then
        total_progress = current_step_data.progress
        current_step = current_step + 1
        step_start_time = t
        
        if current_step <= #loading_steps then
            current_text = loading_steps[current_step].text
        end
    else
        local step_progress = step_elapsed / current_step_data.duration
        step_progress = math.min(1, step_progress)
        
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

callbacks.Register("Draw", "aw_enhanced_dual_logo_v2", function()
    if not inited then
        initParticles()
        inited = true
    end
    
    local t = globals.RealTime() - t0
    
    -- 时间阶段
    local fade_in_duration = 0.8      -- 背景淡入
    local bg_logo_duration = 2.0      -- 背景logo出现（你的）
    local main_logo_duration = 2.0    -- 主logo出现（我的）
    local effects_duration = 3.0      -- 特效阶段
    local wait_after_100 = 3.5        -- 等待时间改为3.5秒
    local fadeout_duration = 0.8      -- 淡出时间
    
    -- 全局透明度控制
    local global_alpha = 1
    local time_since_completion = 0
    
    if completion_time > 0 then
        time_since_completion = t - completion_time
        if time_since_completion > wait_after_100 then
            local fadeout_progress = (time_since_completion - wait_after_100) / fadeout_duration
            global_alpha = math.max(0, 1 - fadeout_progress)
        end
    end
    
    -- 检查是否应该结束
    if completion_time > 0 and time_since_completion > wait_after_100 + fadeout_duration then
        callbacks.Unregister("Draw", "aw_enhanced_dual_logo_v2")
        return
    end
    
    -- 阶段1：背景淡入
    local bg_alpha_current = 0
    if t < fade_in_duration then
        bg_alpha_current = easeInOutCubic(t / fade_in_duration) * bg_alpha
    else
        bg_alpha_current = bg_alpha
    end
    
    filled(0, 0, scr_x, scr_y, 0, 0, 0, math.floor(bg_alpha_current * global_alpha))
    
    if t < fade_in_duration then
        return
    end
    
    local effects_t = t - fade_in_duration
    
    -- 粒子系统
    local particle_alpha_mult = math.min(1, effects_t / 0.5)
    for i = 1, particle_count do
        local p = particles[i]
        p.x = p.x + p.vx
        p.y = p.y + p.vy
        p.life = p.life + 0.015
        
        if p.x < 0 or p.x > scr_x then p.vx = -p.vx end
        if p.y < 0 or p.y > scr_y then p.vy = -p.vy end
        
        local pulse = math.sin(p.life) * 0.5 + 0.5
        local alpha = math.floor(40 * pulse * p.alpha * particle_alpha_mult * global_alpha)
        if alpha > 0 then
            filled(p.x - p.size/2, p.y - p.size/2, p.x + p.size/2, p.y + p.size/2,
                   main_r, main_g, main_b, alpha)
        end
    end
    
    -- 进度条
    local progress, progress_text = updateLoadingProgress(t)
    local progress_y = scr_y - 100 * scale
    local progress_width = 500 * scale
    local progress_height = 8 * scale
    local progress_x = cx - progress_width / 2
    
    drawCapsule(progress_x - 2, progress_y - 2, progress_width + 4, progress_height + 4,
                15, 15, 15, math.floor(60 * global_alpha))
    
    drawCapsule(progress_x, progress_y, progress_width, progress_height,
                25, 25, 25, math.floor(100 * global_alpha))
    
    local progress_fill_width = progress_width * progress
    if progress_fill_width > 0 then
        drawCapsule(progress_x, progress_y, progress_fill_width, progress_height,
                    main_r, main_g, main_b, math.floor(200 * global_alpha))
        
        drawCapsule(progress_x, progress_y, progress_fill_width, progress_height / 3,
                    255, 100, 100, math.floor(100 * global_alpha))
        
        local pulse = math.sin(t * 6) * 0.3 + 0.7
        drawCapsule(progress_x, progress_y, progress_fill_width, progress_height,
                    255, 150, 150, math.floor(60 * pulse * global_alpha))
    end
    
    -- 进度文字
    draw.SetFont(loading_font)
    draw.Color(200, 200, 200, math.floor(255 * global_alpha))
    local progress_str = string.format("%.1f%%", progress * 100)
    local progress_str_width = draw.GetTextSize(progress_str)
    draw.Text(progress_x + progress_width - progress_str_width, progress_y - 25 * scale, progress_str)
    
    draw.Color(160, 160, 160, math.floor(200 * global_alpha))
    draw.Text(progress_x, progress_y - 25 * scale, progress_text)
    
    -- 阶段2：你的ASCII logo出现（30%透明度）
    if effects_t < bg_logo_duration then
        local bg_scan_progress = easeInOutCubic(effects_t / bg_logo_duration)
        drawBackgroundLogo(global_alpha, bg_scan_progress, 	5.0)  -- 30%透明度已在函数内处理
        return
    end
    
    -- 阶段3：我的花样字体出现
    local main_logo_t = effects_t - bg_logo_duration
    if main_logo_t < main_logo_duration then
        -- 绘制你的logo（30%透明度）
        drawBackgroundLogo(global_alpha, nil, 1.0)
        
        -- 绘制扫描中的我的logo
        local main_scan_progress = easeInOutCubic(main_logo_t / main_logo_duration)
        drawMainLogo(global_alpha, main_scan_progress)
        return
    end
    
    -- 阶段4：特效阶段
    local special_effects_t = main_logo_t - main_logo_duration
    if special_effects_t < effects_duration then
        -- 绘制你的logo（30%透明度）
        drawBackgroundLogo(global_alpha, nil, 1.0)
        
        -- 绘制带特效的我的logo
        local effect_progress = special_effects_t / effects_duration
        local rotation_angle = easeOutBack(effect_progress) * 360
        local color_pulse = math.sin(special_effects_t * 4) * 0.4 + 0.6
        
        drawMainLogo(global_alpha, nil, {
            rotation_angle = rotation_angle,
            color_pulse = color_pulse
        })
        
        -- 环形粒子特效
        local ring_particles = 16
        for i = 0, ring_particles - 1 do
            local angle = (i / ring_particles) * 360 + special_effects_t * 60
            local radius = 200 * scale + math.sin(special_effects_t * 2 + i) * 25 * scale
            local px = cx + math.cos(math.rad(angle)) * radius
            local py = cy + math.sin(math.rad(angle)) * radius
            local particle_size = 3 * scale + math.sin(special_effects_t * 4 + i) * 2 * scale
            
            filled(px - particle_size/2, py - particle_size/2, 
                   px + particle_size/2, py + particle_size/2,
                   255, 120, 120, math.floor(120 * global_alpha))
        end
        
        -- AIMWARE.NET标题
        local text_y = cy + 120 * scale
        draw.SetFont(title_font)
        local tw = draw.GetTextSize("AIMWARE.NET")
        drawGlow(cx - tw/2, text_y, "AIMWARE.NET", title_font, 
                math.floor(4 * color_pulse), 255, 255, 255, math.floor(255 * global_alpha))
        
        return
    end
    
    -- 静态显示（等待进度条完成，等待3秒）
    local blink_intensity = math.sin(t * 3) * 0.3 + 0.7
    
    -- 绘制你的logo（30%透明度）
    drawBackgroundLogo(global_alpha * blink_intensity, nil, 1.0)
    
    -- 绘制我的logo（闪烁）
    drawMainLogo(global_alpha * blink_intensity)
    
    -- 标题
    local text_y = cy + 120 * scale
    draw.SetFont(title_font)
    local tw = draw.GetTextSize("AIMWARE.NET")
    drawGlow(cx - tw/2, text_y, "AIMWARE.NET", title_font, 
            math.floor(4 * blink_intensity), 255, 255, 255, math.floor(255 * global_alpha))
end)
