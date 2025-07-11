-- Aimware Lua API 最终版检测器 (无外部依赖)
local function is_function_available(module, func)
    if type(_G[module]) ~= "table" then return false end
    return type(_G[module][func]) == "function"
end

local function safe_file_exists(path)
    if is_function_available("file", "Exists") then
        return file.Exists(path)
    end
    
    -- 兼容旧版本的文件存在检测
    local found = false
    if is_function_available("file", "Enumerate") then
        file.Enumerate(function(name)
            if name == path then
                found = true
            end
        end)
    end
    return found
end

local function test_api()
    local results = {}
    
    -- 核心模块检测
    local modules = {
        "draw", "entities", "client", "engine",
        "globals", "gui", "file", "callbacks", "http"
    }
    
    for _, mod in ipairs(modules) do
        results[mod] = {}
        if type(_G[mod]) == "table" then
            -- 检测常见函数
            local functions = {
                draw = {"Text", "FilledRect", "GetScreenSize", "CreateTexture", "SetTexture"},
                entities = {"GetLocalPlayer", "GetByIndex", "GetPlayers", "FindByClass"},
                client = {"SetConVar", "GetConVar", "GetLocalPlayerIndex", "Command", "ChatSay"},
                engine = {"GetViewAngles", "SetViewAngles", "GetMapName", "GetServerIP", "ClientCmd"},
                globals = {"RealTime", "CurTime", "FrameTime", "AbsoluteFrameTime"},
                gui = {"Reference", "Groupbox", "Checkbox", "Slider", "GetValue"},
                file = {"Open", "Write", "Read", "Enumerate", "Append"},
                callbacks = {"Register", "Unregister", "GetCallbacks"},
                http = {"Get", "Post", "Fetch"}
            }
            
            for _, func in ipairs(functions[mod] or {}) do
                if is_function_available(mod, func) then
                    table.insert(results[mod], func)
                end
            end
        end
    end
    
    return results
end

-- 显示检测结果
local function display_api_results(results)
    print("\n===== AIMWARE API 检测报告 =====")
    
    -- 获取Aimware版本信息
    local aw_version = "未知"
    if is_function_available("client", "GetVersion") then
        aw_version = client.GetVersion()
    end
    
    print("Aimware版本: " .. aw_version)
    
    for mod, funcs in pairs(results) do
        if #funcs > 0 then
            print("\n[" .. mod .. "] (" .. #funcs .. "):")
            for i, func in ipairs(funcs) do
                print("  " .. i .. ". " .. func)
            end
        end
    end
    
    print("\n===== 报告结束 =====")
end

-- 主执行函数
local function main()
    -- 激活API（如果需要）
    if is_function_available("callbacks", "Register") then
        callbacks.Register("Draw", function()
            -- 空回调仅用于激活API
            return false
        end)
    end
    
    local api_results = test_api()
    display_api_results(api_results)
    
    -- 文件系统检测
    print("\n文件系统检测:")
    print("文件API可用: " .. tostring(is_function_available("file", "Open")))
    
    local test_file = "test_api_detection.txt"
    if is_function_available("file", "Write") then
        file.Write(test_file, "API检测测试文件")
        print("文件写入测试: " .. tostring(safe_file_exists(test_file)))
    end
end

-- 执行检测
main()
