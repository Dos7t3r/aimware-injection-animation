-- AIMWARE Lua API 浏览器脚本（增强版）
-- Remember to check ur AIMWARE console
-- 版本：1.1

-- 定义函数列表
local api_functions = {
    ["全局函数"] = {
        {name = "Effect()", desc = "创建特效"},
        {name = "RGBMenu()", desc = "创建 RGB 菜单"},
        {name = "Draw_Indicator()", desc = "绘制指示器"},
        {name = "GetV()", desc = "获取值"},
        {name = "SetV()", desc = "设置值"},
        {name = "GRef()", desc = "获取引用"},
        {name = "DrawC()", desc = "绘制圆形"},
        {name = "DrawL()", desc = "绘制线条"},
        {name = "DrawF()", desc = "绘制填充形状"},
        {name = "DrawCF()", desc = "绘制填充圆形"},
        {name = "DrawT()", desc = "绘制文本"},
        {name = "DrawTS()", desc = "绘制带阴影的文本"},
        {name = "LuaLoader()", desc = "加载 Lua 脚本"},
        {name = "RGB_Window()", desc = "创建 RGB 窗口"},
        {name = "Indicator_Window()", desc = "创建指示器窗口"},
        {name = "assert()", desc = "断言函数"},
        {name = "type()", desc = "获取变量类型"},
        {name = "next()", desc = "获取下一个元素"},
        {name = "pairs()", desc = "遍历表"},
        {name = "ipairs()", desc = "遍历数组"},
        {name = "getmetatable()", desc = "获取元表"},
        {name = "setmetatable()", desc = "设置元表"},
        {name = "getfenv()", desc = "获取函数环境"},
        {name = "setfenv()", desc = "设置函数环境"},
        {name = "rawget()", desc = "原始获取表值"},
        {name = "rawset()", desc = "原始设置表值"},
        {name = "rawequal()", desc = "原始比较"},
        {name = "unpack()", desc = "解包参数"},
        {name = "select()", desc = "选择参数"},
        {name = "tonumber()", desc = "转换为数字"},
        {name = "tostring()", desc = "转换为字符串"},
        {name = "error()", desc = "抛出错误"},
        {name = "pcall()", desc = "保护调用"},
        {name = "xpcall()", desc = "扩展保护调用"},
        {name = "load()", desc = "加载函数"},
        {name = "loadstring()", desc = "加载字符串"},
        {name = "gcinfo()", desc = "获取垃圾回收信息"},
        {name = "collectgarbage()", desc = "执行垃圾回收"},
        {name = "newproxy()", desc = "创建代理对象"}
    },
    ["自定义对象"] = {
        {name = "add", desc = "添加操作"},
        {name = "coroutine", desc = "协程操作"},
        {name = "ffi", desc = "外部函数接口"},
        {name = "math", desc = "数学库"},
        {name = "debug", desc = "调试库"},
        {name = "bit", desc = "位操作库"},
        {name = "_G", desc = "全局环境"},
        {name = "string", desc = "字符串库"},
        {name = "table", desc = "表操作库"}
    },
    ["http"] = {
        {name = "Get", desc = "发送 HTTP GET 请求"}
    },
    ["gui"] = {
        {name = "Reference", desc = "获取 GUI 元素的引用"},
        {name = "Groupbox", desc = "创建一个新的组框"},
        {name = "Checkbox", desc = "创建一个复选框"},
        {name = "Slider", desc = "创建一个滑动条"},
        {name = "GetValue", desc = "获取 GUI 元素的值"}
    },
    ["client"] = {
        {name = "SetConVar", desc = "设置控制台变量的值"},
        {name = "GetConVar", desc = "获取控制台变量的值"},
        {name = "GetLocalPlayerIndex", desc = "获取本地玩家的索引"},
        {name = "Command", desc = "执行控制台命令"},
        {name = "ChatSay", desc = "发送聊天消息"}
    },
    ["engine"] = {
        {name = "GetViewAngles", desc = "获取当前视角角度"},
        {name = "SetViewAngles", desc = "设置视角角度"},
        {name = "GetMapName", desc = "获取当前地图名称"},
        {name = "GetServerIP", desc = "获取服务器 IP 地址"}
    },
    ["globals"] = {
        {name = "RealTime", desc = "获取真实时间"},
        {name = "CurTime", desc = "获取当前时间"},
        {name = "FrameTime", desc = "获取每帧时间"},
        {name = "AbsoluteFrameTime", desc = "获取绝对帧时间"}
    },
    ["entities"] = {
        {name = "GetLocalPlayer", desc = "获取本地玩家实体"},
        {name = "GetByIndex", desc = "通过索引获取实体"},
        {name = "FindByClass", desc = "通过类名查找实体"}
    },
    ["callbacks"] = {
        {name = "Register", desc = "注册回调函数"},
        {name = "Unregister", desc = "取消注册回调函数"}
    },
    ["draw"] = {
        {name = "Text", desc = "绘制文本"},
        {name = "FilledRect", desc = "绘制填充矩形"},
        {name = "GetScreenSize", desc = "获取屏幕尺寸"},
        {name = "CreateTexture", desc = "创建纹理"},
        {name = "SetTexture", desc = "设置当前纹理"}
    },
    ["file"] = {
        {name = "Open", desc = "打开文件"},
        {name = "Write", desc = "写入文件"},
        {name = "Read", desc = "读取文件"},
        {name = "Enumerate", desc = "枚举文件"}
    }
}

-- 创建菜单项
local tab = gui.Tab(gui.Reference("Settings"), "api_browser_tab", "API 浏览器")
local group = gui.Groupbox(tab, "模块选择", 16, 16, 296, 400)

-- 获取模块名称列表
local module_names = {}
for k, _ in pairs(api_functions) do
    table.insert(module_names, k)
end

local module_selector = gui.Combobox(group, "api_browser_module", "选择模块", unpack(module_names))
local display_button = gui.Button(group, "显示函数列表", function()
    local selected_index = module_selector:GetValue() + 1
    local selected_module = module_names[selected_index]
    if selected_module and api_functions[selected_module] then
        print("\n=== [" .. selected_module .. "] 模块函数列表 ===")
        for _, func in ipairs(api_functions[selected_module]) do
            print("• " .. func.name .. " - " .. func.desc)
        end
    else
        print("未找到所选模块的函数列表。")
    end
end)
