-- Safe Roblox environment check
local ok, game = pcall(function() return game end)
if not ok or not game or not game.GetService then
    return {}
end

local Library = {}
print("V 0.3.1 UI Remake")

-- Helper to get a safe parent for GUIs (for loadstring compatibility)
local function getSafeParent()
    local parent
    local safe_typeof = typeof or function(obj)
        return type(obj)
    end
    local has_gethui, gethui_func = pcall(function() return gethui end)
    if has_gethui and safe_typeof(gethui_func) == "function" then
        local s, res = pcall(gethui_func)
        if s and safe_typeof(res) == "Instance" and (res:IsA("ScreenGui") or res:IsA("Folder") or res:IsA("PlayerGui")) then
            parent = res
        end
    end
    if not parent then
        local s, cg = pcall(function() return game:GetService("CoreGui") end)
        if s and cg then
            parent = cg
        end
    end
    if not parent then
        local plr = game:GetService("Players").LocalPlayer
        if plr and plr:FindFirstChildOfClass("PlayerGui") then
            parent = plr.PlayerGui
        end
    end
    if not parent then
        parent = workspace
    end
    return parent
end

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LibraryUI_" .. tostring(math.random(100000,999999))
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.Parent = getSafeParent()

    -- BACKDROP (삭제됨)
    -- local Backdrop = Instance.new("Frame")
    -- Backdrop.Name = "Backdrop"
    -- Backdrop.Parent = ScreenGui
    -- Backdrop.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
    -- Backdrop.BackgroundTransparency = 0.1
    -- Backdrop.Size = UDim2.new(1, 0, 1, 0)
    -- Backdrop.Position = UDim2.new(0, 0, 0, 0)
    -- Backdrop.ZIndex = 0

    -- MAIN WINDOW
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(28, 32, 44)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -320, 0.5, -210)
    Main.Size = UDim2.new(0, 640, 0, 420)
    Main.Active = true
    Main.Visible = false
    Main.ZIndex = 2

    local MainCorner = Instance.new("UICorner")
    MainCorner.Parent = Main
    MainCorner.CornerRadius = UDim.new(0, 18)

    -- SHADOW
    local Shadow = Instance.new("ImageLabel")
    Shadow.Parent = Main
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageTransparency = 0.6
    Shadow.Size = UDim2.new(1, 36, 1, 36)
    Shadow.Position = UDim2.new(0, -18, 0, -18)
    Shadow.ZIndex = 1

    -- HEADER
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = Main
    Header.BackgroundColor3 = Color3.fromRGB(38, 44, 60)
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 54)
    Header.ZIndex = 3

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.Parent = Header
    HeaderCorner.CornerRadius = UDim.new(0, 18)

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Header
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 24, 0, 0)
    Title.Size = UDim2.new(1, -120, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 4

    -- CLOSE & MINIMIZE BUTTONS
    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = Header
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -48, 0.5, -16)
    CloseButton.Size = UDim2.new(0, 32, 0, 32)
    CloseButton.Image = "rbxassetid://6031094678"
    CloseButton.ImageColor3 = Color3.fromRGB(255, 80, 80)
    CloseButton.ZIndex = 5

    local MinimizeButton = Instance.new("ImageButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = Header
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -88, 0.5, -16)
    MinimizeButton.Size = UDim2.new(0, 32, 0, 32)
    MinimizeButton.Image = "rbxassetid://6031094677"
    MinimizeButton.ImageColor3 = Color3.fromRGB(255, 200, 50)
    MinimizeButton.ZIndex = 5

    -- TAB BAR
    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.Parent = Main
    TabBar.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
    TabBar.BorderSizePixel = 0
    TabBar.Position = UDim2.new(0, 0, 0, 54)
    TabBar.Size = UDim2.new(1, 0, 0, 44)
    TabBar.ZIndex = 3

    local TabBarCorner = Instance.new("UICorner")
    TabBarCorner.Parent = TabBar
    TabBarCorner.CornerRadius = UDim.new(0, 12)

    local TabList = Instance.new("Frame")
    TabList.Name = "TabList"
    TabList.Parent = TabBar
    TabList.BackgroundTransparency = 1
    TabList.Position = UDim2.new(0, 16, 0, 0)
    TabList.Size = UDim2.new(1, -32, 1, 0)
    TabList.ZIndex = 4

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabList
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 12)
    TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    -- CONTENT CONTAINER
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = Main
    ContentContainer.BackgroundColor3 = Color3.fromRGB(34, 38, 52)
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Position = UDim2.new(0, 0, 0, 98)
    ContentContainer.Size = UDim2.new(1, 0, 1, -98)
    ContentContainer.ZIndex = 3

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.Parent = ContentContainer
    ContentCorner.CornerRadius = UDim.new(0, 12)

    -- INTRO ANIMATION
    local TweenService = game:GetService("TweenService")
    local function showIntro()
        Main.Visible = true
        Main.BackgroundTransparency = 1
        Main.Position = UDim2.new(0.5, -320, 0.5, -260)
        Main.Size = UDim2.new(0, 640, 0, 0)
        TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0,
            Position = UDim2.new(0.5, -320, 0.5, -210),
            Size = UDim2.new(0, 640, 0, 420)
        }):Play()
    end
    task.spawn(function()
        task.wait(0.2)
        showIntro()
    end)

    -- DRAGGABLE HEADER
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- CLOSE BUTTON
    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.4)
        ScreenGui:Destroy()
    end)

    -- MINIMIZE BUTTON
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = UDim2.new(0, 320, 0, 54)
            }):Play()
            ContentContainer.Visible = false
            TabBar.Visible = false
        else
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = UDim2.new(0, 640, 0, 420)
            }):Play()
            ContentContainer.Visible = true
            TabBar.Visible = true
        end
    end)

    -- WINDOW OBJECT
    local Window = {}
    Window._tabs = {}
    Window._tabContents = {}

    function Window:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = name
        TabBtn.Parent = TabList
        TabBtn.BackgroundColor3 = Color3.fromRGB(38, 44, 60)
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(0, 120, 1, -8)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(200, 220, 255)
        TabBtn.TextSize = 16
        TabBtn.AutoButtonColor = false
        TabBtn.ZIndex = 5

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.Parent = TabBtn
        TabBtnCorner.CornerRadius = UDim.new(0, 8)

        local Content = Instance.new("ScrollingFrame")
        Content.Name = name.."Content"
        Content.Parent = ContentContainer
        Content.BackgroundTransparency = 1
        Content.Size = UDim2.new(1, 0, 1, 0)
        Content.Visible = false
        Content.ScrollBarThickness = 6
        Content.ScrollBarImageColor3 = Color3.fromRGB(60, 120, 255)
        Content.ZIndex = 6
        Content.AutomaticCanvasSize = Enum.AutomaticSize.Y

        local ContentList = Instance.new("UIListLayout")
        ContentList.Parent = Content
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 16)

        table.insert(Window._tabs, TabBtn)
        table.insert(Window._tabContents, Content)

        -- Tab switching
        TabBtn.MouseButton1Click:Connect(function()
            for i, c in ipairs(Window._tabContents) do
                c.Visible = false
                Window._tabs[i].BackgroundColor3 = Color3.fromRGB(38, 44, 60)
                Window._tabs[i].TextColor3 = Color3.fromRGB(200, 220, 255)
            end
            Content.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
            TabBtn.TextColor3 = Color3.fromRGB(255,255,255)
        end)
        if #Window._tabs == 1 then
            Content.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
            TabBtn.TextColor3 = Color3.fromRGB(255,255,255)
        end

        local TabFunctions = {}

        -- BUTTON
        function TabFunctions:AddButton(text, description, callback)
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = text
            ButtonFrame.Parent = Content
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(48, 54, 74)
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Size = UDim2.new(1, -32, 0, description and 64 or 44)
            ButtonFrame.Position = UDim2.new(0, 16, 0, 0)
            ButtonFrame.ZIndex = 7

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.Parent = ButtonFrame
            ButtonCorner.CornerRadius = UDim.new(0, 8)

            local Btn = Instance.new("TextButton")
            Btn.Parent = ButtonFrame
            Btn.BackgroundTransparency = 1
            Btn.Size = UDim2.new(1, 0, 0, 36)
            Btn.Position = UDim2.new(0, 0, 0, 0)
            Btn.Font = Enum.Font.GothamBold
            Btn.Text = text
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.TextSize = 16
            Btn.ZIndex = 8
            Btn.AutoButtonColor = true

            if description then
                local Desc = Instance.new("TextLabel")
                Desc.Parent = ButtonFrame
                Desc.BackgroundTransparency = 1
                Desc.Position = UDim2.new(0, 0, 0, 36)
                Desc.Size = UDim2.new(1, 0, 0, 24)
                Desc.Font = Enum.Font.Gotham
                Desc.Text = description
                Desc.TextColor3 = Color3.fromRGB(180, 200, 220)
                Desc.TextSize = 13
                Desc.TextXAlignment = Enum.TextXAlignment.Left
                Desc.ZIndex = 8
            end

            Btn.MouseButton1Click:Connect(callback)
            return ButtonFrame
        end

        -- TEXT
        function TabFunctions:AddText(text, description)
            local TextFrame = Instance.new("Frame")
            TextFrame.Name = text
            TextFrame.Parent = Content
            TextFrame.BackgroundColor3 = Color3.fromRGB(48, 54, 74)
            TextFrame.BorderSizePixel = 0
            TextFrame.Size = UDim2.new(1, -32, 0, description and 64 or 44)
            TextFrame.Position = UDim2.new(0, 16, 0, 0)
            TextFrame.ZIndex = 7

            local TextCorner = Instance.new("UICorner")
            TextCorner.Parent = TextFrame
            TextCorner.CornerRadius = UDim.new(0, 8)

            local Txt = Instance.new("TextLabel")
            Txt.Parent = TextFrame
            Txt.BackgroundTransparency = 1
            Txt.Size = UDim2.new(1, 0, 0, 36)
            Txt.Position = UDim2.new(0, 0, 0, 0)
            Txt.Font = Enum.Font.GothamBold
            Txt.Text = text
            Txt.TextColor3 = Color3.fromRGB(255, 255, 255)
            Txt.TextSize = 16
            Txt.TextXAlignment = Enum.TextXAlignment.Left
            Txt.ZIndex = 8

            if description then
                local Desc = Instance.new("TextLabel")
                Desc.Parent = TextFrame
                Desc.BackgroundTransparency = 1
                Desc.Position = UDim2.new(0, 0, 0, 36)
                Desc.Size = UDim2.new(1, 0, 0, 24)
                Desc.Font = Enum.Font.Gotham
                Desc.Text = description
                Desc.TextColor3 = Color3.fromRGB(180, 200, 220)
                Desc.TextSize = 13
                Desc.TextXAlignment = Enum.TextXAlignment.Left
                Desc.ZIndex = 8
            end

            return TextFrame
        end

        -- SLIDER
        function TabFunctions:AddSlider(text, description, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = text
            SliderFrame.Parent = Content
            SliderFrame.BackgroundColor3 = Color3.fromRGB(48, 54, 74)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Size = UDim2.new(1, -32, 0, description and 72 or 52)
            SliderFrame.Position = UDim2.new(0, 16, 0, 0)
            SliderFrame.ZIndex = 7

            local SliderCorner = Instance.new("UICorner")
            SliderCorner.Parent = SliderFrame
            SliderCorner.CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel")
            Label.Parent = SliderFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 0, 0, 0)
            Label.Size = UDim2.new(1, -60, 0, 28)
            Label.Font = Enum.Font.GothamBold
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 15
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 8

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = SliderFrame
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(1, -60, 0, 0)
            ValueLabel.Size = UDim2.new(0, 60, 0, 28)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = Color3.fromRGB(60, 120, 255)
            ValueLabel.TextSize = 15
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.ZIndex = 8

            if description then
                local Desc = Instance.new("TextLabel")
                Desc.Parent = SliderFrame
                Desc.BackgroundTransparency = 1
                Desc.Position = UDim2.new(0, 0, 0, 28)
                Desc.Size = UDim2.new(1, 0, 0, 20)
                Desc.Font = Enum.Font.Gotham
                Desc.Text = description
                Desc.TextColor3 = Color3.fromRGB(180, 200, 220)
                Desc.TextSize = 13
                Desc.TextXAlignment = Enum.TextXAlignment.Left
                Desc.ZIndex = 8
            end

            local Bar = Instance.new("Frame")
            Bar.Parent = SliderFrame
            Bar.BackgroundColor3 = Color3.fromRGB(38, 44, 60)
            Bar.BorderSizePixel = 0
            Bar.Position = UDim2.new(0, 0, 1, -18)
            Bar.Size = UDim2.new(1, 0, 0, 8)
            Bar.ZIndex = 8

            local BarCorner = Instance.new("UICorner")
            BarCorner.Parent = Bar
            BarCorner.CornerRadius = UDim.new(0, 4)

            local Fill = Instance.new("Frame")
            Fill.Parent = Bar
            Fill.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
            Fill.BorderSizePixel = 0
            Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            Fill.ZIndex = 9

            local FillCorner = Instance.new("UICorner")
            FillCorner.Parent = Fill
            FillCorner.CornerRadius = UDim.new(0, 4)

            local dragging = false
            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation()
                    local rel = mousePos.X - Bar.AbsolutePosition.X
                    local pct = math.clamp(rel / Bar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + ((max-min)*pct)+0.5)
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    ValueLabel.Text = tostring(value)
                    callback(value)
                end
            end)
            return SliderFrame
        end

        -- TOGGLE
        function TabFunctions:AddToggle(text, description, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = text
            ToggleFrame.Parent = Content
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(48, 54, 74)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Size = UDim2.new(1, -32, 0, description and 64 or 44)
            ToggleFrame.Position = UDim2.new(0, 16, 0, 0)
            ToggleFrame.ZIndex = 7

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.Parent = ToggleFrame
            ToggleCorner.CornerRadius = UDim.new(0, 8)

            local ToggleBtn = Instance.new("ImageButton")
            ToggleBtn.Parent = ToggleFrame
            ToggleBtn.BackgroundTransparency = 1
            ToggleBtn.Position = UDim2.new(0, 8, 0.5, -16)
            ToggleBtn.Size = UDim2.new(0, 32, 0, 32)
            ToggleBtn.Image = "rbxassetid://6031068420"
            ToggleBtn.ImageColor3 = default and Color3.fromRGB(80, 220, 120) or Color3.fromRGB(60, 60, 60)
            ToggleBtn.ZIndex = 8

            local Label = Instance.new("TextLabel")
            Label.Parent = ToggleFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 48, 0, 0)
            Label.Size = UDim2.new(1, -56, 0, 36)
            Label.Font = Enum.Font.GothamBold
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 16
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 8

            if description then
                local Desc = Instance.new("TextLabel")
                Desc.Parent = ToggleFrame
                Desc.BackgroundTransparency = 1
                Desc.Position = UDim2.new(0, 48, 0, 36)
                Desc.Size = UDim2.new(1, -56, 0, 24)
                Desc.Font = Enum.Font.Gotham
                Desc.Text = description
                Desc.TextColor3 = Color3.fromRGB(180, 200, 220)
                Desc.TextSize = 13
                Desc.TextXAlignment = Enum.TextXAlignment.Left
                Desc.ZIndex = 8
            end

            local toggled = default
            ToggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                ToggleBtn.ImageColor3 = toggled and Color3.fromRGB(80, 220, 120) or Color3.fromRGB(60, 60, 60)
                callback(toggled)
            end)
            return ToggleFrame
        end

        -- NOTIFY
        function TabFunctions:Notify(title, text, duration)
            duration = duration or 3
            local NotifyGui = Instance.new("ScreenGui")
            NotifyGui.Name = "LibraryNotify_" .. tostring(math.random(100000,999999))
            NotifyGui.ResetOnSpawn = false
            NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
            NotifyGui.Parent = getSafeParent()

            local NotifyFrame = Instance.new("Frame")
            NotifyFrame.Name = "NotifyFrame"
            NotifyFrame.Parent = NotifyGui
            NotifyFrame.BackgroundColor3 = Color3.fromRGB(38, 44, 60)
            NotifyFrame.BorderSizePixel = 0
            NotifyFrame.Position = UDim2.new(1, 24, 1, -120)
            NotifyFrame.Size = UDim2.new(0, 320, 0, 80)
            NotifyFrame.ZIndex = 100

            local NotifyCorner = Instance.new("UICorner")
            NotifyCorner.Parent = NotifyFrame
            NotifyCorner.CornerRadius = UDim.new(0, 12)

            local NotifyTitle = Instance.new("TextLabel")
            NotifyTitle.Parent = NotifyFrame
            NotifyTitle.BackgroundTransparency = 1
            NotifyTitle.Position = UDim2.new(0, 16, 0, 8)
            NotifyTitle.Size = UDim2.new(1, -32, 0, 28)
            NotifyTitle.Font = Enum.Font.GothamBold
            NotifyTitle.Text = title
            NotifyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            NotifyTitle.TextSize = 16
            NotifyTitle.TextXAlignment = Enum.TextXAlignment.Left
            NotifyTitle.ZIndex = 101

            local Message = Instance.new("TextLabel")
            Message.Parent = NotifyFrame
            Message.BackgroundTransparency = 1
            Message.Position = UDim2.new(0, 16, 0, 36)
            Message.Size = UDim2.new(1, -32, 0, 36)
            Message.Font = Enum.Font.Gotham
            Message.Text = text
            Message.TextColor3 = Color3.fromRGB(180, 200, 220)
            Message.TextSize = 13
            Message.TextXAlignment = Enum.TextXAlignment.Left
            Message.TextWrapped = true
            Message.ZIndex = 101

            TweenService:Create(NotifyFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
                Position = UDim2.new(1, -344, 1, -120)
            }):Play()
            task.spawn(function()
                task.wait(duration)
                TweenService:Create(NotifyFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
                    Position = UDim2.new(1, 24, 1, -120)
                }):Play()
                task.wait(0.4)
                NotifyGui:Destroy()
            end)
        end

        -- LUA EXECUTOR (remake style)
        function TabFunctions:AddLuaExecutor()
            local ExecutorFrame = Instance.new("Frame")
            ExecutorFrame.Name = "LuaExecutor"
            ExecutorFrame.Parent = Content
            ExecutorFrame.BackgroundColor3 = Color3.fromRGB(48, 54, 74)
            ExecutorFrame.BorderSizePixel = 0
            ExecutorFrame.Size = UDim2.new(1, -32, 0, 260)
            ExecutorFrame.Position = UDim2.new(0, 16, 0, 0)
            ExecutorFrame.ZIndex = 7

            local ExecutorCorner = Instance.new("UICorner")
            ExecutorCorner.Parent = ExecutorFrame
            ExecutorCorner.CornerRadius = UDim.new(0, 8)

            local EditorBox = Instance.new("TextBox")
            EditorBox.Parent = ExecutorFrame
            EditorBox.BackgroundColor3 = Color3.fromRGB(34, 38, 52)
            EditorBox.BorderSizePixel = 0
            EditorBox.Position = UDim2.new(0, 12, 0, 12)
            EditorBox.Size = UDim2.new(1, -24, 0, 100)
            EditorBox.Font = Enum.Font.Code
            EditorBox.Text = "--Type your Lua code here"
            EditorBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            EditorBox.TextSize = 15
            EditorBox.TextXAlignment = Enum.TextXAlignment.Left
            EditorBox.TextYAlignment = Enum.TextYAlignment.Top
            EditorBox.ClearTextOnFocus = false
            EditorBox.MultiLine = true
            EditorBox.RichText = false
            EditorBox.ClipsDescendants = true
            EditorBox.ZIndex = 8

            local EditorCorner = Instance.new("UICorner")
            EditorCorner.Parent = EditorBox
            EditorCorner.CornerRadius = UDim.new(0, 6)

            local ExecuteButton = Instance.new("TextButton")
            ExecuteButton.Parent = ExecutorFrame
            ExecuteButton.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
            ExecuteButton.BorderSizePixel = 0
            ExecuteButton.Position = UDim2.new(1, -92, 0, 120)
            ExecuteButton.Size = UDim2.new(0, 80, 0, 32)
            ExecuteButton.Font = Enum.Font.GothamBold
            ExecuteButton.Text = "실행"
            ExecuteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            ExecuteButton.TextSize = 15
            ExecuteButton.ZIndex = 8

            local ExecuteCorner = Instance.new("UICorner")
            ExecuteCorner.Parent = ExecuteButton
            ExecuteCorner.CornerRadius = UDim.new(0, 6)

            local OutputFrame = Instance.new("Frame")
            OutputFrame.Parent = ExecutorFrame
            OutputFrame.BackgroundColor3 = Color3.fromRGB(34, 38, 52)
            OutputFrame.BorderSizePixel = 0
            OutputFrame.Position = UDim2.new(0, 12, 0, 164)
            OutputFrame.Size = UDim2.new(1, -24, 0, 80)
            OutputFrame.ZIndex = 8

            local OutputCorner = Instance.new("UICorner")
            OutputCorner.Parent = OutputFrame
            OutputCorner.CornerRadius = UDim.new(0, 6)

            local OutputScroll = Instance.new("ScrollingFrame")
            OutputScroll.Parent = OutputFrame
            OutputScroll.BackgroundTransparency = 1
            OutputScroll.Size = UDim2.new(1, 0, 1, 0)
            OutputScroll.ScrollBarThickness = 6
            OutputScroll.CanvasSize = UDim2.new(0, 0, 0, 80)
            OutputScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            OutputScroll.ZIndex = 9

            local OutputLabel = Instance.new("TextLabel")
            OutputLabel.Parent = OutputScroll
            OutputLabel.BackgroundTransparency = 1
            OutputLabel.Position = UDim2.new(0, 0, 0, 0)
            OutputLabel.Size = UDim2.new(1, 0, 0, 0)
            OutputLabel.Font = Enum.Font.Code
            OutputLabel.Text = ""
            OutputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            OutputLabel.TextSize = 13
            OutputLabel.TextXAlignment = Enum.TextXAlignment.Left
            OutputLabel.TextYAlignment = Enum.TextYAlignment.Top
            OutputLabel.TextWrapped = true
            OutputLabel.RichText = false
            OutputLabel.ZIndex = 10

            local function updateOutputScroll()
                OutputLabel.Size = UDim2.new(1, 0, 0, math.max(80, OutputLabel.TextBounds.Y))
                OutputScroll.CanvasSize = UDim2.new(0, 0, 0, OutputLabel.AbsoluteSize.Y)
            end
            OutputLabel:GetPropertyChangedSignal("Text"):Connect(updateOutputScroll)
            updateOutputScroll()

            local function appendOutput(msg, color)
                OutputLabel.Text = OutputLabel.Text .. (OutputLabel.Text ~= "" and "\n" or "") .. msg
                OutputLabel.TextColor3 = color or Color3.fromRGB(200, 200, 200)
                updateOutputScroll()
                OutputScroll.CanvasPosition = Vector2.new(0, math.max(0, OutputLabel.AbsoluteSize.Y - OutputScroll.AbsoluteWindowSize.Y))
            end

            ExecuteButton.MouseButton1Click:Connect(function()
                local code = EditorBox.Text
                code = code:gsub("<.->", "")
                local func, err = loadstring(code)
                if func then
                    local ok, result = pcall(function()
                        local outputLines = {}
                        local oldPrint = print
                        print = function(...)
                            local args = {}
                            for i = 1, select("#", ...) do
                                table.insert(args, tostring(select(i, ...)))
                            end
                            table.insert(outputLines, table.concat(args, "\t"))
                        end
                        local ret = {func()}
                        print = oldPrint
                        if #outputLines > 0 then
                            for _, line in ipairs(outputLines) do
                                appendOutput(line, Color3.fromRGB(200, 200, 200))
                            end
                        end
                        return unpack(ret)
                    end)
                    if ok then
                        appendOutput("실행 성공", Color3.fromRGB(80, 220, 120))
                    else
                        appendOutput("오류: " .. tostring(result), Color3.fromRGB(255, 80, 80))
                    end
                else
                    appendOutput("컴파일 오류: " .. tostring(err), Color3.fromRGB(255, 180, 80))
                end
            end)
            return ExecutorFrame
        end

        -- THEME SELECTOR (remake style)
        function TabFunctions:AddThemeSelector(themes)
            local ThemeFrame = Instance.new("Frame")
            ThemeFrame.Name = "ThemeSelector"
            ThemeFrame.Parent = Content
            ThemeFrame.BackgroundColor3 = Color3.fromRGB(48, 54, 74)
            ThemeFrame.BorderSizePixel = 0
            ThemeFrame.Size = UDim2.new(1, -32, 0, 64)
            ThemeFrame.Position = UDim2.new(0, 16, 0, 0)
            ThemeFrame.ZIndex = 7

            local ThemeCorner = Instance.new("UICorner")
            ThemeCorner.Parent = ThemeFrame
            ThemeCorner.CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel")
            Label.Parent = ThemeFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Size = UDim2.new(1, -24, 0, 28)
            Label.Font = Enum.Font.GothamBold
            Label.Text = "테마 선택"
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 15
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 8

            local Dropdown = Instance.new("TextButton")
            Dropdown.Parent = ThemeFrame
            Dropdown.BackgroundColor3 = Color3.fromRGB(34, 38, 52)
            Dropdown.BorderSizePixel = 0
            Dropdown.Position = UDim2.new(0, 12, 0, 32)
            Dropdown.Size = UDim2.new(1, -24, 0, 24)
            Dropdown.Font = Enum.Font.Gotham
            Dropdown.Text = "테마를 선택하세요"
            Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
            Dropdown.TextSize = 13
            Dropdown.TextXAlignment = Enum.TextXAlignment.Left
            Dropdown.AutoButtonColor = true
            Dropdown.ZIndex = 8

            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.Parent = Dropdown
            DropdownCorner.CornerRadius = UDim.new(0, 6)

            local ListFrame = Instance.new("Frame")
            ListFrame.Parent = ThemeFrame
            ListFrame.BackgroundColor3 = Color3.fromRGB(34, 38, 52)
            ListFrame.BorderSizePixel = 0
            ListFrame.Position = UDim2.new(0, 12, 0, 56)
            ListFrame.Size = UDim2.new(1, -24, 0, 0)
            ListFrame.Visible = false
            ListFrame.ClipsDescendants = true
            ListFrame.ZIndex = 20

            local ListCorner = Instance.new("UICorner")
            ListCorner.Parent = ListFrame
            ListCorner.CornerRadius = UDim.new(0, 6)

            local UIList = Instance.new("UIListLayout")
            UIList.Parent = ListFrame
            UIList.SortOrder = Enum.SortOrder.LayoutOrder
            UIList.Padding = UDim.new(0, 2)

            local themeNames = {}
            for name, _ in pairs(themes) do
                table.insert(themeNames, name)
            end
            table.sort(themeNames)

            local function closeDropdown()
                ListFrame.Visible = false
                ListFrame.Size = UDim2.new(1, 0, 0, 0)
            end

            Dropdown.MouseButton1Click:Connect(function()
                if ListFrame.Visible then
                    closeDropdown()
                else
                    ListFrame.Visible = true
                    ListFrame.Size = UDim2.new(1, 0, 0, #themeNames * 24)
                end
            end)

            for _, name in ipairs(themeNames) do
                local ThemeBtn = Instance.new("TextButton")
                ThemeBtn.Parent = ListFrame
                ThemeBtn.BackgroundColor3 = Color3.fromRGB(48, 54, 74)
                ThemeBtn.BorderSizePixel = 0
                ThemeBtn.Size = UDim2.new(1, 0, 0, 22)
                ThemeBtn.Font = Enum.Font.Gotham
                ThemeBtn.Text = name
                ThemeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                ThemeBtn.TextSize = 13
                ThemeBtn.AutoButtonColor = true
                ThemeBtn.ZIndex = 21

                local BtnCorner = Instance.new("UICorner")
                BtnCorner.Parent = ThemeBtn
                BtnCorner.CornerRadius = UDim.new(0, 6)

                ThemeBtn.MouseButton1Click:Connect(function()
                    Dropdown.Text = name
                    if TabFunctions.SetTheme then
                        TabFunctions:SetTheme(themes[name])
                    end
                    closeDropdown()
                end)
            end

            local UIS = game:GetService("UserInputService")
            UIS.InputBegan:Connect(function(input)
                if ListFrame.Visible and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mouse = UIS:GetMouseLocation()
                    local absPos = ListFrame.AbsolutePosition
                    local absSize = ListFrame.AbsoluteSize
                    if not (mouse.X >= absPos.X and mouse.X <= absPos.X + absSize.X and mouse.Y >= absPos.Y and mouse.Y <= absPos.Y + absSize.Y) then
                        closeDropdown()
                    end
                end
            end)

            return ThemeFrame
        end

        -- THEME SETTER
        function TabFunctions:SetTheme(theme)
            if Main and Main:IsA("Frame") then
                Main.BackgroundColor3 = theme.Background or Main.BackgroundColor3
            end
            if Header and Header:IsA("Frame") then
                Header.BackgroundColor3 = theme.Header or Header.BackgroundColor3
            end
            if TabBar and TabBar:IsA("Frame") then
                TabBar.BackgroundColor3 = theme.TabBar or TabBar.BackgroundColor3
            end
            if ContentContainer and ContentContainer:IsA("Frame") then
                ContentContainer.BackgroundColor3 = theme.Content or ContentContainer.BackgroundColor3
            end
        end

        return TabFunctions
    end

    return Window
end

return Library
