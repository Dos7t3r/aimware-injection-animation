-- AIMWARE Elegant Intro - 优雅版本

-- 基本配置
local scr_x, scr_y = draw.GetScreenSize()
local scale = scr_y / 1080
local cx = scr_x / 2
local cy = scr_y * 0.45

-- 字体
local logo_font = draw.CreateFont("Consolas", math.floor(36 * scale), 800)
local title_font = draw.CreateFont("Segoe UI", math.floor(42 * scale), 800)
local loading_font = draw.CreateFont("Segoe UI", math.floor(14 * scale), 400)

-- 颜色
local main_r, main_g, main_b = 227, 6, 19
local bg_alpha = 240

-- 创建简洁的AIMWARE logo
local logo_lines = {
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

-- 初始化粒子
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

local function easeInOutQuart(t)
    if t < 0.5 then
        return 8 * t * t * t * t
    else
        return 1 - math.pow(-2 * t + 2, 4) / 2
    end
end

-- 填充矩形
local function filled(x1, y1, x2, y2, r, g, b, a)
    draw.Color(r, g, b, a)
    draw.FilledRect(x1, y1, x2, y2)
end

-- 胶囊形状绘制
local function drawCapsule(x, y, width, height, r, g, b, a)
    local radius = height / 2
    
    -- 中间矩形
    filled(x, y, x + width, y + height, r, g, b, a)
    
    -- 左半圆
    for i = 0, radius do
        local circle_alpha = a * (1 - (i / radius) * 0.3)
        filled(x - i, y + i, x - i + 1, y + height - i, r, g, b, math.floor(circle_alpha))
    end
    
    -- 右半圆
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

callbacks.Register("Draw", "aw_elegant_intro", function()
    if not inited then
        initParticles()
        inited = true
    end
    
    local t = globals.RealTime() - t0
    
    -- 重新设计的时间阶段
    local fade_in_duration = 0.8      -- 阶段1：背景淡入
    local logo_appear_duration = 1.5  -- 阶段2：logo出现
    local effects_duration = 3.0      -- 阶段3：特效阶段
    local wait_after_100 = 1.5        -- 等待时间
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
        callbacks.Unregister("Draw", "aw_elegant_intro")
        return
    end
    
    -- 阶段1：背景淡入（纯黑背景）
    local bg_alpha_current = 0
    if t < fade_in_duration then
        bg_alpha_current = easeInOutCubic(t / fade_in_duration) * bg_alpha
    else
        bg_alpha_current = bg_alpha
    end
    
    -- 绘制背景
    filled(0, 0, scr_x, scr_y, 0, 0, 0, math.floor(bg_alpha_current * global_alpha))
    
    -- 只有背景淡入完成后才开始其他效果
    if t < fade_in_duration then
        return
    end
    
    local effects_t = t - fade_in_duration
    
    -- 粒子系统（只在背景淡入后开始）
    local particle_alpha_mult = math.min(1, effects_t / 0.5)  -- 粒子渐入
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
    
    -- 优雅的胶囊形进度条
    local progress, progress_text = updateLoadingProgress(t)
    local progress_y = scr_y - 100 * scale
    local progress_width = 500 * scale
    local progress_height = 8 * scale
    local progress_x = cx - progress_width / 2
    
    -- 进度条背景（胶囊形，很淡的阴影）
    drawCapsule(progress_x - 2, progress_y - 2, progress_width + 4, progress_height + 4,
                15, 15, 15, math.floor(80 * global_alpha))
    
    -- 进度条主体背景
    drawCapsule(progress_x, progress_y, progress_width, progress_height,
                25, 25, 25, math.floor(120 * global_alpha))
    
    -- 进度条填充（带光效的胶囊）
    local progress_fill_width = progress_width * progress
    if progress_fill_width > 0 then
        -- 主填充
        drawCapsule(progress_x, progress_y, progress_fill_width, progress_height,
                    main_r, main_g, main_b, math.floor(200 * global_alpha))
        
        -- 顶部高光
        drawCapsule(progress_x, progress_y, progress_fill_width, progress_height / 3,
                    255, 100, 100, math.floor(100 * global_alpha))
        
        -- 脉冲效果
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
    
    -- 阶段2：Logo出现
    if effects_t < logo_appear_duration then
        local logo_progress = easeInOutCubic(effects_t / logo_appear_duration)
        local logo_alpha = logo_progress * global_alpha
        
        -- 逐行显示logo
        local lines_to_show = math.floor(logo_progress * #logo_lines)
        draw.SetFont(logo_font)
        
        for i = 1, math.min(lines_to_show + 1, #logo_lines) do
            local line = logo_lines[i]
            local line_width = draw.GetTextSize(line)
            local x = cx - line_width / 2
            local y = cy - (#logo_lines * 20 * scale) / 2 + (i - 1) * 20 * scale
            
            if i == lines_to_show + 1 then
                -- 当前行带辉光
                drawGlow(x, y, line, logo_font, 3, 255, 255, 255, math.floor(255 * logo_alpha))
            else
                -- 已完成的行
                drawGlow(x, y, line, logo_font, 1, main_r, main_g, main_b, math.floor(200 * logo_alpha))
            end
        end
        
        return
    end
    
    -- 阶段3：特效阶段
    local special_effects_t = effects_t - logo_appear_duration
    if special_effects_t < effects_duration then
        local effect_progress = special_effects_t / effects_duration
        
        -- 旋转和缩放效果
        local rotation_angle = easeOutBack(effect_progress) * 360
        local scale_pulse = math.sin(special_effects_t * 3) * 0.15 + 1.0
        local color_pulse = math.sin(special_effects_t * 4) * 0.4 + 0.6
        
        draw.SetFont(logo_font)
        
        -- 绘制带特效的logo
        for i, line in ipairs(logo_lines) do
            local line_width = draw.GetTextSize(line)
            local base_x = cx - line_width / 2
            local base_y = cy - (#logo_lines * 20 * scale) / 2 + (i - 1) * 20 * scale
            
            -- 简单的"旋转"效果（通过偏移模拟）
            local offset_x = math.sin(math.rad(rotation_angle + i * 10)) * 2
            local offset_y = math.cos(math.rad(rotation_angle + i * 10)) * 1
            
            local x = base_x + offset_x
            local y = base_y + offset_y
            
            local r = lerp(main_r, 255, color_pulse)
            local g = lerp(main_g, 150, color_pulse)
            local b = lerp(main_b, 150, color_pulse)
            
            drawGlow(x, y, line, logo_font, math.floor(3 * color_pulse), r, g, b, 
                    math.floor(255 * global_alpha))
        end
        
        -- 环形粒子特效
        local ring_particles = 16
        for i = 0, ring_particles - 1 do
            local angle = (i / ring_particles) * 360 + special_effects_t * 60
            local radius = 200 * scale + math.sin(special_effects_t * 2 + i) * 30 * scale
            local px = cx + math.cos(math.rad(angle)) * radius
            local py = cy + math.sin(math.rad(angle)) * radius
            local particle_size = 3 * scale + math.sin(special_effects_t * 4 + i) * 2 * scale
            
            filled(px - particle_size/2, py - particle_size/2, 
                   px + particle_size/2, py + particle_size/2,
                   255, 120, 120, math.floor(120 * global_alpha))
        end
        
        -- 标题文字
        local text_y = cy + (#logo_lines * 20 * scale) / 2 + 60 * scale
        draw.SetFont(title_font)
        local tw = draw.GetTextSize("AIMWARE.NET")
        drawGlow(cx - tw/2, text_y, "AIMWARE.NET", title_font, 
                math.floor(4 * color_pulse), 255, 255, 255, math.floor(255 * global_alpha))
        
        return
    end
    
    -- 静态显示（等待进度条完成）
    local blink_intensity = math.sin(t * 3) * 0.3 + 0.7
    
    draw.SetFont(logo_font)
    for i, line in ipairs(logo_lines) do
        local line_width = draw.GetTextSize(line)
        local x = cx - line_width / 2
        local y = cy - (#logo_lines * 20 * scale) / 2 + (i - 1) * 20 * scale
        
        drawGlow(x, y, line, logo_font, math.floor(2 * blink_intensity), 
                main_r, main_g, main_b, math.floor(200 * blink_intensity * global_alpha))
    end
    
    local text_y = cy + (#logo_lines * 20 * scale) / 2 + 60 * scale
    draw.SetFont(title_font)
    local tw = draw.GetTextSize("AIMWARE.NET")
    drawGlow(cx - tw/2, text_y, "AIMWARE.NET", title_font, 
            math.floor(4 * blink_intensity), 255, 255, 255, math.floor(255 * global_alpha))
end)
