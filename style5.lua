-- AIMWARE Image Intro Version
-- 尝试使用图片替代ASCII
-- 该版本存在Bug,无法载入图片，只会显示ASCII

-- 基本配置
local scr_x, scr_y = draw.GetScreenSize()
local scale = scr_y / 1080
local cx = scr_x / 2
local cy = scr_y * 0.45

-- 字体
local title_font = draw.CreateFont("Segoe UI", math.floor(42 * scale), 800)
local loading_font = draw.CreateFont("Segoe UI", math.floor(14 * scale), 400)

-- 颜色
local main_r, main_g, main_b = 227, 6, 19
local bg_alpha = 220

-- 图片相关
local logo_texture = nil
local logo_size = 256 * scale  -- 缩放后的logo大小
local image_url = "https://ooo.0x0.ooo/2025/07/10/OYxSvc.png"

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
local image_loaded = false

-- 粒子系统
local particles = {}
local particle_count = 30

-- 初始化粒子
local function initParticles()
    for i = 1, particle_count do
        particles[i] = {
            x = math.random(0, scr_x),
            y = math.random(0, scr_y),
            vx = (math.random() - 0.5) * 2,
            vy = (math.random() - 0.5) * 2,
            life = math.random() * math.pi * 2,
            size = math.random() * 3 + 1,
            alpha = math.random() * 0.5 + 0.3
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

-- 尝试加载图片的函数（多种可能的API）
local function tryLoadImage()
    if image_loaded then return true end
    
    -- 方法1: 尝试 draw.CreateTexture
    if draw.CreateTexture then
        logo_texture = draw.CreateTexture(image_url)
        if logo_texture then
            image_loaded = true
            return true
        end
    end
    
    -- 方法2: 尝试 draw.LoadImage
    if draw.LoadImage then
        logo_texture = draw.LoadImage(image_url)
        if logo_texture then
            image_loaded = true
            return true
        end
    end
    
    -- 方法3: 尝试 surface.CreateFont 相关的纹理API
    if surface and surface.CreateTexture then
        logo_texture = surface.CreateTexture(image_url)
        if logo_texture then
            image_loaded = true
            return true
        end
    end
    
    return false
end

-- 绘制旋转图片的函数
local function drawRotatedImage(x, y, size, angle, alpha)
    if not logo_texture or not image_loaded then return false end
    
    -- 方法1: 如果支持 draw.TexturedRect 带旋转
    if draw.TexturedRect then
        draw.Color(255, 255, 255, math.floor(255 * alpha))
        -- 尝试不同的参数组合
        local success = pcall(function()
            draw.TexturedRect(logo_texture, x - size/2, y - size/2, x + size/2, y + size/2, angle)
        end)
        if success then return true end
        
        -- 如果不支持旋转参数，尝试基本版本
        success = pcall(function()
            draw.TexturedRect(logo_texture, x - size/2, y - size/2, x + size/2, y + size/2)
        end)
        if success then return true end
    end
    
    -- 方法2: 如果支持 surface.DrawTexturedRect
    if surface and surface.DrawTexturedRect then
        surface.SetDrawColor(255, 255, 255, math.floor(255 * alpha))
        surface.SetTexture(logo_texture)
        local success = pcall(function()
            surface.DrawTexturedRectRotated(x, y, size, size, angle)
        end)
        if success then return true end
        
        success = pcall(function()
            surface.DrawTexturedRect(x - size/2, y - size/2, size, size)
        end)
        if success then return true end
    end
    
    return false
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

callbacks.Register("Draw", "aw_image_intro", function()
    if not inited then
        initParticles()
        -- 尝试加载图片
        tryLoadImage()
        inited = true
    end
    
    local t = globals.RealTime() - t0
    
    -- 时间设置
    local phase1_duration = 1.0   -- 淡入
    local phase2_duration = 3.0   -- 旋转 + 特效
    local phase3_duration = 1.0   -- 淡出过渡
    local wait_after_100 = 1.0
    local fadeout_duration = 0.8
    
    -- 计算总时间
    local loading_complete_time = 0
    for i = 1, #loading_steps do
        loading_complete_time = loading_complete_time + loading_steps[i].duration
    end
    
    local total_duration = math.max(
        phase1_duration + phase2_duration + phase3_duration,
        loading_complete_time + wait_after_100
    ) + fadeout_duration
    
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
        input.KeyPress(45)
        callbacks.Unregister("Draw", "aw_image_intro")
        return
    end
    
    -- 背景渐变
    local bg_intensity = math.min(1, t / phase1_duration)
    for i = 0, 20 do
        local y = (scr_y / 20) * i
        local alpha_factor = 1 - (i / 20) * 0.3
        filled(0, y, scr_x, y + scr_y/20, 
               math.floor(5 * alpha_factor), 
               math.floor(5 * alpha_factor), 
               math.floor(15 * alpha_factor), 
               math.floor(bg_alpha * bg_intensity * global_alpha * alpha_factor))
    end
    
    -- 动态粒子系统
    for i = 1, particle_count do
        local p = particles[i]
        p.x = p.x + p.vx
        p.y = p.y + p.vy
        p.life = p.life + 0.02
        
        if p.x < 0 or p.x > scr_x then p.vx = -p.vx end
        if p.y < 0 or p.y > scr_y then p.vy = -p.vy end
        
        local pulse = math.sin(p.life) * 0.5 + 0.5
        local alpha = math.floor(60 * pulse * p.alpha * bg_intensity * global_alpha)
        if alpha > 0 then
            filled(p.x - p.size/2, p.y - p.size/2, p.x + p.size/2, p.y + p.size/2,
                   main_r, main_g, main_b, alpha)
        end
    end
    
    -- 加载进度条（增强版）
    local progress, progress_text = updateLoadingProgress(t)
    local progress_y = scr_y - 120 * scale
    local progress_width = 600 * scale
    local progress_x = cx - progress_width / 2
    
    -- 进度条背景（带渐变）
    for i = 0, 10 do
        local offset = i * 2
        local alpha = math.floor((200 - i * 15) * bg_intensity * global_alpha)
        filled(progress_x - 3 - offset, progress_y - 3 - offset, 
               progress_x + progress_width + 3 + offset, progress_y + 10 + offset,
               10, 10, 10, alpha)
    end
    
    -- 进度条填充（带光效）
    local progress_fill_width = progress_width * progress
    for i = 0, math.floor(progress_fill_width / 5) do
        local seg_x = progress_x + i * 5
        local seg_progress = i * 5 / progress_width
        local intensity = 1 - seg_progress * 0.4
        local pulse = math.sin(t * 8 + seg_progress * 10) * 0.2 + 0.8
        
        local r = math.floor(main_r * intensity * pulse)
        local g = math.floor(main_g * intensity * pulse)
        local b = math.floor(main_b * intensity * pulse)
        
        filled(seg_x, progress_y, seg_x + 5, progress_y + 6,
               r, g, b, math.floor(240 * global_alpha))
    end
    
    -- 进度文字
    draw.SetFont(loading_font)
    draw.Color(220, 220, 220, math.floor(255 * bg_intensity * global_alpha))
    local progress_str = string.format("%.1f%%", progress * 100)
    draw.Text(progress_x + progress_width + 20 * scale, progress_y, progress_str)
    
    draw.Color(180, 180, 180, math.floor(220 * bg_intensity * global_alpha))
    draw.Text(progress_x, progress_y + 25 * scale, progress_text)
    
    -- Phase 1: 淡入
    if t < phase1_duration then
        local fade_progress = easeInOutCubic(t / phase1_duration)
        local logo_alpha = fade_progress * global_alpha
        
        -- 尝试绘制图片
        local image_drawn = false
        if tryLoadImage() then
            image_drawn = drawRotatedImage(cx, cy, logo_size, 0, logo_alpha)
        end
        
        -- 如果图片加载失败，显示提示信息
        if not image_drawn then
            draw.SetFont(title_font)
            local fallback_text = "AIMWARE"
            local tw = draw.GetTextSize(fallback_text)
            drawGlow(cx - tw/2, cy - 20*scale, fallback_text, title_font, 3, 
                    main_r, main_g, main_b, math.floor(255 * logo_alpha))
            
            draw.SetFont(loading_font)
            local error_text = "Image loading not supported"
            local ew = draw.GetTextSize(error_text)
            draw.Color(150, 150, 150, math.floor(200 * logo_alpha))
            draw.Text(cx - ew/2, cy + 30*scale, error_text)
        end
        
        return
    end
    
    -- Phase 2: 旋转 + 特效
    local rotate_t = t - phase1_duration
    if rotate_t < phase2_duration then
        local rotation_progress = easeOutBack(rotate_t / phase2_duration)
        local current_angle = rotation_progress * 720  -- 旋转两圈
        
        -- 缩放效果
        local scale_pulse = math.sin(rotate_t * 4) * 0.2 + 1.0
        local current_size = logo_size * scale_pulse
        
        -- 颜色脉冲
        local color_pulse = math.sin(rotate_t * 6) * 0.3 + 0.7
        
        -- 尝试绘制旋转图片
        local image_drawn = false
        if image_loaded then
            image_drawn = drawRotatedImage(cx, cy, current_size, current_angle, global_alpha)
        end
        
        if not image_drawn then
            -- 备用显示
            draw.SetFont(title_font)
            local fallback_text = "AIMWARE"
            local tw = draw.GetTextSize(fallback_text)
            local r = lerp(main_r, 255, color_pulse)
            local g = lerp(main_g, 150, color_pulse)
            local b = lerp(main_b, 150, color_pulse)
            drawGlow(cx - tw/2, cy - 20*scale, fallback_text, title_font, 
                    math.floor(4 * color_pulse), r, g, b, math.floor(255 * global_alpha))
        end
        
        -- 环形粒子特效
        local ring_particles = 12
        for i = 0, ring_particles - 1 do
            local angle = (i / ring_particles) * 360 + rotate_t * 50
            local radius = 150 * scale + math.sin(rotate_t * 3 + i) * 20 * scale
            local px = cx + math.cos(math.rad(angle)) * radius
            local py = cy + math.sin(math.rad(angle)) * radius
            local particle_size = 4 * scale + math.sin(rotate_t * 5 + i) * 2 * scale
            
            filled(px - particle_size/2, py - particle_size/2, 
                   px + particle_size/2, py + particle_size/2,
                   255, 100, 100, math.floor(150 * global_alpha))
        end
        
        -- 标题文字
        local text_y = cy + logo_size/2 + 80 * scale
        draw.SetFont(title_font)
        local tw = draw.GetTextSize("AIMWARE.NET")
        drawGlow(cx - tw/2, text_y, "AIMWARE.NET", title_font, 
                math.floor(4 * color_pulse), 255, 255, 255, math.floor(255 * global_alpha))
        
        return
    end
    
    -- Phase 3: 淡出过渡
    local fadeout_t = rotate_t - phase2_duration
    if fadeout_t < phase3_duration then
        local fade_progress = 1 - easeInOutCubic(fadeout_t / phase3_duration)
        local logo_alpha = fade_progress * global_alpha
        
        -- 静态显示
        local image_drawn = false
        if image_loaded then
            image_drawn = drawRotatedImage(cx, cy, logo_size, 0, logo_alpha)
        end
        
        if not image_drawn then
            draw.SetFont(title_font)
            local fallback_text = "AIMWARE"
            local tw = draw.GetTextSize(fallback_text)
            drawGlow(cx - tw/2, cy - 20*scale, fallback_text, title_font, 3, 
                    main_r, main_g, main_b, math.floor(255 * logo_alpha))
        end
        
        local text_y = cy + logo_size/2 + 80 * scale
        draw.SetFont(title_font)
        local tw = draw.GetTextSize("AIMWARE.NET")
        drawGlow(cx - tw/2, text_y, "AIMWARE.NET", title_font, 3, 
                255, 255, 255, math.floor(255 * logo_alpha))
        
        return
    end
    
    -- 等待进度条完成
    local blink_intensity = math.sin(t * 4) * 0.2 + 0.8
    
    local image_drawn = false
    if image_loaded then
        image_drawn = drawRotatedImage(cx, cy, logo_size, 0, global_alpha * blink_intensity)
    end
    
    if not image_drawn then
        draw.SetFont(title_font)
        local fallback_text = "AIMWARE"
        local tw = draw.GetTextSize(fallback_text)
        drawGlow(cx - tw/2, cy - 20*scale, fallback_text, title_font, 
                math.floor(3 * blink_intensity), main_r, main_g, main_b, 
                math.floor(255 * global_alpha))
    end
    
    local text_y = cy + logo_size/2 + 80 * scale
    draw.SetFont(title_font)
    local tw = draw.GetTextSize("AIMWARE.NET")
    drawGlow(cx - tw/2, text_y, "AIMWARE.NET", title_font, 
            math.floor(4 * blink_intensity), 255, 255, 255, math.floor(255 * global_alpha))
end)
