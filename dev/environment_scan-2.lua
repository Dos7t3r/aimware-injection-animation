-- Aimware Lua环境探测器 (增强版)
local function ScanEnvironment()
    local results = {
        global_functions = {},
        loaded_modules = {},
        custom_objects = {}
    }

    -- 扫描全局函数
    for name, value in pairs(_G) do
        local t = type(value)
        if t == "function" then
            table.insert(results.global_functions, name)
        elseif t == "table" then
            table.insert(results.custom_objects, name)
        end
    end

    -- 扫描核心模块（通过尝试访问已知API）
    local core_modules = {
        "draw", "entities", "client", "engine",
        "globals", "gui", "file", "memory",
        "callbacks", "http", "cvar"
    }
    
    for _, mod_name in ipairs(core_modules) do
        local status, mod = pcall(function() return _G[mod_name] end)
        if status and type(mod) == "table" then
            results.loaded_modules[mod_name] = {}
            for fn_name, _ in pairs(mod) do
                table.insert(results.loaded_modules[mod_name], fn_name)
            end
        end
    end

    return results
end

-- 生成报告到控制台
local function PrintReport(data)
    print("===== Aimware Lua环境报告 (增强版) =====")
    
    -- 打印全局函数
    print("\n[全局函数] ("..#data.global_functions.."):")
    for i, func in ipairs(data.global_functions) do
        print(string.format("%3d. %s()", i, func))
    end
    
    -- 打印自定义对象
    if #data.custom_objects > 0 then
        print("\n[自定义对象] ("..#data.custom_objects.."):")
        for i, obj in ipairs(data.custom_objects) do
            print(string.format("%3d. %s", i, obj))
        end
    end
    
    -- 打印核心模块
    print("\n[核心模块]:")
    for mod_name, functions in pairs(data.loaded_modules) do
        print("\n["..mod_name.."] ("..#functions.."):")
        for j, func in ipairs(functions) do
            print(string.format("  %3d. %s", j, func))
        end
    end
    
    print("\n===== 报告结束 =====")
end

-- 主执行函数
local function main()
    -- 尝试访问核心API以激活它们
    pcall(function() return draw.GetScreenSize() end)
    pcall(function() return entities.GetLocalPlayer() end)
    pcall(function() return client.GetLocalPlayerIndex() end)
    
    local env_data = ScanEnvironment()
    PrintReport(env_data)
    
    print("\n✅ 环境扫描完成！")
    print("💡 提示：Aimware的核心API需要在实际使用时才会被激活")
    print("📌 示例：在回调函数中使用 draw.Text 会激活绘图API")
end

-- 执行扫描
main()

-- 示例回调函数（用于激活API）
callbacks.Register("Draw", function()
    -- 这些调用会激活实际的API
    local w, h = draw.GetScreenSize()
    draw.Text(10, 10, "Draw API已激活")
    
    -- 不需要实际执行，只需注册即可
    return false
end)
