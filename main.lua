-- Safe Roblox environment check
local ok, game = pcall(function() return game end)
if not ok or not game.GetService then
    return {}
end

local Library = {}
print("V 0.3.0 (Remake)")

local function getSafeParent()
    local parent
    local safe_typeof = typeof or function(obj) return type(obj) end
    local has_gethui, gethui_func = pcall(function() return gethui end)
    if has_gethui and safe_typeof(gethui_func) == "function" then
        local s, res = pcall(gethui_func)
        if s and safe_typeof(res) == "Instance" and (res:IsA("ScreenGui") or res:IsA("Folder") or res:IsA("PlayerGui")) then
            parent = res
        end
    end
    if not parent then
        local s, cg = pcall(function() return game:GetService("CoreGui") end)
        if s and cg then parent = cg end
    end
    if not parent then
        local plr = game:GetService("Players").LocalPlayer
        if plr and plr:FindFirstChildOfClass("PlayerGui") then
            parent = plr.PlayerGui
        end
    end
    if not parent then parent = workspace end
    return parent
end

function Library:CreateWindow(title)
    local accent = Color3.fromRGB(0, 170, 255)
    local bg = Color3.fromRGB(24, 26, 32)
    local fg = Color3.fromRGB(255,255,255)
    local border = Color3.fromRGB(36, 38, 50)
    local tab_bg = Color3.fromRGB(32, 34, 44)
    local tab_sel = accent
    local tab_fg = Color3.fromRGB(200,200,200)
    local btn_bg = Color3.fromRGB(36, 38, 50)
    local btn_hover = accent
    local btn_fg = fg

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LibraryUI_" .. tostring(math.random(100000,999999))
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = getSafeParent()

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = bg
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -260, 0.5, -170)
    Main.Size = UDim2.new(0, 520, 0, 340)
    Main.Active = true
    Main.Visible = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.Parent = Main
    MainCorner.CornerRadius = UDim.new(0, 14)

    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Parent = Main
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageTransparency = 0.6
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10,10,118,118)
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.ZIndex = 0

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Parent = Main
    TitleBar.BackgroundColor3 = tab_bg
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 44)

    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.Parent = TitleBar
    TitleBarCorner.CornerRadius = UDim.new(0, 14)

    local Title = Instance.new("TextLabel")
    Title.Parent = TitleBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.Size = UDim2.new(1, -120, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = fg
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Close/Minimize
    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = TitleBar
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    CloseButton.Position = UDim2.new(1, -38, 0.5, -12)
    CloseButton.Size = UDim2.new(0, 24, 0, 24)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
    CloseButton.TextSize = 16
    CloseButton.AutoButtonColor = true

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Parent = TitleBar
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    MinimizeButton.Position = UDim2.new(1, -70, 0.5, -12)
    MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "—"
    MinimizeButton.TextColor3 = Color3.fromRGB(255,255,255)
    MinimizeButton.TextSize = 16
    MinimizeButton.AutoButtonColor = true

    for _, btn in ipairs({CloseButton, MinimizeButton}) do
        local c = Instance.new("UICorner")
        c.Parent = btn
        c.CornerRadius = UDim.new(1,0)
    end

    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Parent = Main
    TabBar.BackgroundColor3 = tab_bg
    TabBar.BorderSizePixel = 0
    TabBar.Position = UDim2.new(0, 0, 0, 44)
    TabBar.Size = UDim2.new(0, 120, 1, -44)

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabBar
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 8)

    -- Content Area
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Parent = Main
    ContentContainer.BackgroundColor3 = bg
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Position = UDim2.new(0, 120, 0, 44)
    ContentContainer.Size = UDim2.new(1, -120, 1, -44)

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.Parent = ContentContainer
    ContentCorner.CornerRadius = UDim.new(0, 10)

    -- Drag
    local UIS = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Close/Minimize logic
    CloseButton.MouseButton1Click:Connect(function()
        Main:TweenSize(UDim2.new(0,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true, function()
            ScreenGui:Destroy()
        end)
    end)
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            ContentContainer.Visible = false
            TabBar.Visible = false
            Main:TweenSize(UDim2.new(0, 520, 0, 44), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        else
            ContentContainer.Visible = true
            TabBar.Visible = true
            Main:TweenSize(UDim2.new(0, 520, 0, 340), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        end
    end)

    local Window = {}
    Window._tabs = {}
    Window._tabContents = {}

    function Window:CreateTab(name)
        local Tab = Instance.new("TextButton")
        Tab.Name = name
        Tab.Parent = TabBar
        Tab.BackgroundColor3 = btn_bg
        Tab.BorderSizePixel = 0
        Tab.Size = UDim2.new(1, -16, 0, 36)
        Tab.Font = Enum.Font.Gotham
        Tab.Text = name
        Tab.TextColor3 = tab_fg
        Tab.TextSize = 15
        Tab.AutoButtonColor = true

        local TabCorner = Instance.new("UICorner")
        TabCorner.Parent = Tab
        TabCorner.CornerRadius = UDim.new(0, 8)

        local Content = Instance.new("ScrollingFrame")
        Content.Name = name.."Content"
        Content.Parent = ContentContainer
        Content.BackgroundTransparency = 1
        Content.Size = UDim2.new(1, 0, 1, 0)
        Content.Visible = false
        Content.ScrollBarThickness = 4
        Content.ScrollBarImageColor3 = accent
        Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Content.CanvasSize = UDim2.new(0,0,0,0)
        Content.ClipsDescendants = true

        local ContentList = Instance.new("UIListLayout")
        ContentList.Parent = Content
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 12)

        table.insert(Window._tabs, Tab)
        table.insert(Window._tabContents, Content)

        Tab.MouseButton1Click:Connect(function()
            for i, c in ipairs(Window._tabContents) do
                c.Visible = false
                Window._tabs[i].BackgroundColor3 = btn_bg
                Window._tabs[i].TextColor3 = tab_fg
            end
            Content.Visible = true
            Tab.BackgroundColor3 = tab_sel
            Tab.TextColor3 = Color3.fromRGB(255,255,255)
        end)
        if #Window._tabs == 1 then
            Content.Visible = true
            Tab.BackgroundColor3 = tab_sel
            Tab.TextColor3 = Color3.fromRGB(255,255,255)
        end

        local TabFunctions = {}

        function TabFunctions:AddButton(text, description, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text
            Button.Parent = Content
            Button.BackgroundColor3 = btn_bg
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(1, -24, 0, description and 54 or 36)
            Button.Font = Enum.Font.GothamMedium
            Button.Text = text
            Button.TextColor3 = btn_fg
            Button.TextSize = 15
            Button.AutoButtonColor = true

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.Parent = Button
            ButtonCorner.CornerRadius = UDim.new(0, 8)

            Button.MouseEnter:Connect(function()
                Button.BackgroundColor3 = btn_hover
                Button.TextColor3 = Color3.fromRGB(255,255,255)
            end)
            Button.MouseLeave:Connect(function()
                Button.BackgroundColor3 = btn_bg
                Button.TextColor3 = btn_fg
            end)
            Button.MouseButton1Click:Connect(callback)

            if description then
                local Desc = Instance.new("TextLabel")
                Desc.Parent = Button
                Desc.BackgroundTransparency = 1
                Desc.Position = UDim2.new(0, 0, 0, 24)
                Desc.Size = UDim2.new(1, 0, 0, 24)
                Desc.Font = Enum.Font.Gotham
                Desc.Text = description
                Desc.TextColor3 = Color3.fromRGB(180,180,180)
                Desc.TextSize = 12
                Desc.TextXAlignment = Enum.TextXAlignment.Left
            end
            return Button
        end

        function TabFunctions:AddText(text, description)
            local TextFrame = Instance.new("Frame")
            TextFrame.Parent = Content
            TextFrame.BackgroundColor3 = btn_bg
            TextFrame.BorderSizePixel = 0
            TextFrame.Size = UDim2.new(1, -24, 0, description and 54 or 36)

            local TextCorner = Instance.new("UICorner")
            TextCorner.Parent = TextFrame
            TextCorner.CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel")
            Label.Parent = TextFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 8, 0, 0)
            Label.Size = UDim2.new(1, -16, 0, 24)
            Label.Font = Enum.Font.GothamMedium
            Label.Text = text
            Label.TextColor3 = fg
            Label.TextSize = 15
            Label.TextXAlignment = Enum.TextXAlignment.Left

            if description then
                local Desc = Instance.new("TextLabel")
                Desc.Parent = TextFrame
                Desc.BackgroundTransparency = 1
                Desc.Position = UDim2.new(0, 8, 0, 24)
                Desc.Size = UDim2.new(1, -16, 0, 24)
                Desc.Font = Enum.Font.Gotham
                Desc.Text = description
                Desc.TextColor3 = Color3.fromRGB(180,180,180)
                Desc.TextSize = 12
                Desc.TextXAlignment = Enum.TextXAlignment.Left
            end
            return TextFrame
        end

        -- Theme Changer
        function TabFunctions:AddThemeSelector()
            local ThemeFrame = Instance.new("Frame")
            ThemeFrame.Parent = Content
            ThemeFrame.BackgroundColor3 = btn_bg
            ThemeFrame.BorderSizePixel = 0
            ThemeFrame.Size = UDim2.new(1, -24, 0, 54)

            local ThemeCorner = Instance.new("UICorner")
            ThemeCorner.Parent = ThemeFrame
            ThemeCorner.CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel")
            Label.Parent = ThemeFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 8, 0, 0)
            Label.Size = UDim2.new(1, -16, 0, 24)
            Label.Font = Enum.Font.GothamMedium
            Label.Text = "테마 선택"
            Label.TextColor3 = fg
            Label.TextSize = 15
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ThemeDropdown = Instance.new("TextButton")
            ThemeDropdown.Parent = ThemeFrame
            ThemeDropdown.BackgroundColor3 = border
            ThemeDropdown.Position = UDim2.new(0, 8, 0, 28)
            ThemeDropdown.Size = UDim2.new(1, -16, 0, 20)
            ThemeDropdown.Font = Enum.Font.Gotham
            ThemeDropdown.Text = "기본"
            ThemeDropdown.TextColor3 = fg
            ThemeDropdown.TextSize = 13
            ThemeDropdown.AutoButtonColor = true

            local themes = {
            ["기본"] = {
                accent = Color3.fromRGB(0, 170, 255),
                bg = Color3.fromRGB(24, 26, 32),
                fg = Color3.fromRGB(255,255,255),
                border = Color3.fromRGB(36, 38, 50),
                tab_bg = Color3.fromRGB(32, 34, 44),
                tab_sel = Color3.fromRGB(0, 170, 255),
                tab_fg = Color3.fromRGB(200,200,200),
                btn_bg = Color3.fromRGB(36, 38, 50),
                btn_hover = Color3.fromRGB(0, 170, 255),
                btn_fg = Color3.fromRGB(255,255,255),
            },
            ["라이트"] = {
                accent = Color3.fromRGB(0, 120, 255),
                bg = Color3.fromRGB(240, 240, 245),
                fg = Color3.fromRGB(30,30,30),
                border = Color3.fromRGB(200, 200, 210),
                tab_bg = Color3.fromRGB(220, 220, 230),
                tab_sel = Color3.fromRGB(0, 120, 255),
                tab_fg = Color3.fromRGB(60,60,60),
                btn_bg = Color3.fromRGB(230, 230, 240),
                btn_hover = Color3.fromRGB(0, 120, 255),
                btn_fg = Color3.fromRGB(30,30,30),
            },
            ["핑크"] = {
                accent = Color3.fromRGB(255, 80, 180),
                bg = Color3.fromRGB(32, 24, 32),
                fg = Color3.fromRGB(255,255,255),
                border = Color3.fromRGB(50, 36, 50),
                tab_bg = Color3.fromRGB(44, 32, 44),
                tab_sel = Color3.fromRGB(255, 80, 180),
                tab_fg = Color3.fromRGB(200,200,200),
                btn_bg = Color3.fromRGB(50, 36, 50),
                btn_hover = Color3.fromRGB(255, 80, 180),
                btn_fg = Color3.fromRGB(255,255,255),
            }
            }

            local themeNames = {}
            for k in pairs(themes) do table.insert(themeNames, k) end

            local currentTheme = "기본"
            local dropdownOpen = false
            local DropdownFrame

            local function applyTheme(theme)
            accent = theme.accent
            bg = theme.bg
            fg = theme.fg
            border = theme.border
            tab_bg = theme.tab_bg
            tab_sel = theme.tab_sel
            tab_fg = theme.tab_fg
            btn_bg = theme.btn_bg
            btn_hover = theme.btn_hover
            btn_fg = theme.btn_fg

            -- Apply to main UI
            Main.BackgroundColor3 = bg
            ContentContainer.BackgroundColor3 = bg
            TabBar.BackgroundColor3 = tab_bg
            TitleBar.BackgroundColor3 = tab_bg
            for _, tab in ipairs(Window._tabs) do
                tab.BackgroundColor3 = btn_bg
                tab.TextColor3 = tab_fg
            end
            for _, content in ipairs(Window._tabContents) do
                for _, item in ipairs(content:GetChildren()) do
                if item:IsA("Frame") or item:IsA("TextButton") then
                    item.BackgroundColor3 = btn_bg
                end
                end
            end
            Title.TextColor3 = fg
            end

            ThemeDropdown.MouseButton1Click:Connect(function()
            if dropdownOpen then
                if DropdownFrame then DropdownFrame:Destroy() end
                dropdownOpen = false
                return
            end
            dropdownOpen = true
            DropdownFrame = Instance.new("Frame")
            DropdownFrame.Parent = ThemeFrame
            DropdownFrame.BackgroundColor3 = border
            DropdownFrame.Position = UDim2.new(0, 8, 0, 48)
            DropdownFrame.Size = UDim2.new(1, -16, 0, #themeNames*22)
            DropdownFrame.ZIndex = 10

            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.Parent = DropdownFrame
            DropdownCorner.CornerRadius = UDim.new(0, 6)

            for i, name in ipairs(themeNames) do
                local Option = Instance.new("TextButton")
                Option.Parent = DropdownFrame
                Option.BackgroundColor3 = border
                Option.BorderSizePixel = 0
                Option.Position = UDim2.new(0, 0, 0, (i-1)*22)
                Option.Size = UDim2.new(1, 0, 0, 22)
                Option.Font = Enum.Font.Gotham
                Option.Text = name
                Option.TextColor3 = fg
                Option.TextSize = 13
                Option.AutoButtonColor = true
                Option.ZIndex = 11

                Option.MouseButton1Click:Connect(function()
                ThemeDropdown.Text = name
                currentTheme = name
                applyTheme(themes[name])
                DropdownFrame:Destroy()
                dropdownOpen = false
                end)
            end
            end)

            return ThemeFrame
        end

        -- Code Highlighted TextBox (간단한 Lua 하이라이트)
        function TabFunctions:AddCodeBox(text, code)
            local CodeFrame = Instance.new("Frame")
            CodeFrame.Parent = Content
            CodeFrame.BackgroundColor3 = btn_bg
            CodeFrame.BorderSizePixel = 0
            CodeFrame.Size = UDim2.new(1, -24, 0, 120)

            local CodeCorner = Instance.new("UICorner")
            CodeCorner.Parent = CodeFrame
            CodeCorner.CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel")
            Label.Parent = CodeFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 8, 0, 0)
            Label.Size = UDim2.new(1, -16, 0, 24)
            Label.Font = Enum.Font.GothamMedium
            Label.Text = text
            Label.TextColor3 = fg
            Label.TextSize = 15
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Box = Instance.new("TextBox")
            Box.Parent = CodeFrame
            Box.BackgroundColor3 = Color3.fromRGB(30,32,40)
            Box.BorderSizePixel = 0
            Box.Position = UDim2.new(0, 8, 0, 28)
            Box.Size = UDim2.new(1, -16, 0, 80)
            Box.Font = Enum.Font.Code
            Box.Text = code or ""
            Box.TextColor3 = fg
            Box.TextSize = 14
            Box.TextXAlignment = Enum.TextXAlignment.Left
            Box.TextYAlignment = Enum.TextYAlignment.Top
            Box.ClearTextOnFocus = false
            Box.MultiLine = true
            Box.TextEditable = false

            -- Simple Lua syntax highlight (keywords, numbers, comments)
            local keywords = {
            "and","break","do","else","elseif","end","false","for","function","if","in","local","nil","not","or","repeat","return","then","true","until","while"
            }
            local function highlightLua(str)
            -- Color: keyword=blue, number=orange, comment=gray, string=green
            str = str:gsub("(%-%-.-)\n", "<font color=\"#888888\">%1</font>\n")
            str = str:gsub("(%-%-.-)$", "<font color=\"#888888\">%1</font>")
            str = str:gsub("(['\"])(.-)%1", "<font color=\"#6FCF97\">%1%2%1</font>")
            for _, kw in ipairs(keywords) do
                str = str:gsub("(%f[%w_])("..kw..")(%f[^%w_])", "<font color=\"#56CCF2\">%2</font>")
            end
            str = str:gsub("(%d+)", "<font color=\"#F2994A\">%1</font>")
            return str
            end

            local HighlightLabel = Instance.new("TextLabel")
            HighlightLabel.Parent = CodeFrame
            HighlightLabel.BackgroundTransparency = 1
            HighlightLabel.Position = Box.Position
            HighlightLabel.Size = Box.Size
            HighlightLabel.Font = Enum.Font.Code
            HighlightLabel.Text = ""
            HighlightLabel.TextColor3 = fg
            HighlightLabel.TextSize = 14
            HighlightLabel.TextXAlignment = Enum.TextXAlignment.Left
            HighlightLabel.TextYAlignment = Enum.TextYAlignment.Top
            HighlightLabel.RichText = true
            HighlightLabel.ZIndex = Box.ZIndex + 1

            Box:GetPropertyChangedSignal("Text"):Connect(function()
            HighlightLabel.Text = highlightLua(Box.Text)
            end)
            HighlightLabel.Text = highlightLua(Box.Text)

            -- Make HighlightLabel overlay Box
            Box.TextTransparency = 1
            Box.ClearTextOnFocus = false
            Box.TextEditable = false

                return CodeFrame
            end
    
            return TabFunctions
        end
    
        return Window
    end
    
    return Library
end
-- Example usage
--[[
local window = Library:CreateWindow("My Window")
local tab = window:CreateTab("My Tab")
tab:AddButton("Click Me", "This is a button", function()
    print("Button clicked!")
end)
tab:AddText("Hello, World!", "This is a text label.")
tab:AddThemeSelector()
tab:AddCodeBox("Lua Code", "print('Hello, World!')\n-- This is a comment")
tab:AddButton("Close", "Close the window", function()
    window:Destroy()
end)
]]
