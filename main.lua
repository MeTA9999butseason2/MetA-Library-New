-- Safe Roblox environment check
local ok, game = pcall(function() return game end)
if not ok or not game or not game.GetService then
    return {}
end

local Library = {}
print("V 0.2.5 UI ReWork")

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
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = getSafeParent()

    local Main = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local TabHolder = Instance.new("Frame")
    local TabList = Instance.new("UIListLayout")
    local ContentContainer = Instance.new("Frame")
    local CloseButton = Instance.new("TextButton")
    local MinimizeButton = Instance.new("TextButton")
    
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Main.BorderColor3 = Color3.fromRGB(60, 60, 60)
    Main.BorderSizePixel = 1
    Main.Position = UDim2.new(0.5, -250, 0.5, -150)
    Main.Size = UDim2.new(0, 500, 0, 300)
    Main.Active = true
    pcall(function() Main.Draggable = true end)
    Main.Visible = false

    -- Intro Remake Start
    local IntroFrame = Instance.new("Frame")
    IntroFrame.Name = "IntroFrame"
    IntroFrame.Parent = ScreenGui
    IntroFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    IntroFrame.BorderColor3 = Color3.fromRGB(60, 60, 120)
    IntroFrame.Position = UDim2.new(0.5, -175, 0.5, -90)
    IntroFrame.Size = UDim2.new(0, 350, 0, 180)
    IntroFrame.BackgroundTransparency = 1

    local IntroCorner = Instance.new("UICorner")
    IntroCorner.Parent = IntroFrame
    IntroCorner.CornerRadius = UDim.new(0, 12)

    local Glow = Instance.new("ImageLabel")
    Glow.Parent = IntroFrame
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://5107185114"
    Glow.ImageColor3 = Color3.fromRGB(60, 120, 255)
    Glow.Size = UDim2.new(1, 40, 1, 40)
    Glow.Position = UDim2.new(-0.05, 0, -0.05, 0)
    Glow.ZIndex = 0
    Glow.ImageTransparency = 0.7

    local Logo = Instance.new("ImageLabel")
    Logo.Parent = IntroFrame
    Logo.BackgroundTransparency = 1
    Logo.Size = UDim2.new(0, 64, 0, 64)
    Logo.Position = UDim2.new(0.5, -32, 0, 18)
    Logo.Image = "rbxassetid://6031071050" -- Roblox logo, replace with your own if needed
    Logo.ImageColor3 = Color3.fromRGB(60, 120, 255)
    Logo.ImageTransparency = 1

    local IntroTitle = Instance.new("TextLabel")
    IntroTitle.Name = "IntroTitle"
    IntroTitle.Parent = IntroFrame
    IntroTitle.BackgroundTransparency = 1
    IntroTitle.Position = UDim2.new(0, 0, 0, 90)
    IntroTitle.Size = UDim2.new(1, 0, 0, 36)
    IntroTitle.Font = Enum.Font.GothamBlack
    IntroTitle.Text = title
    IntroTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    IntroTitle.TextSize = 26
    IntroTitle.TextTransparency = 1

    local IntroSubtitle = Instance.new("TextLabel")
    IntroSubtitle.Name = "IntroSubtitle"
    IntroSubtitle.Parent = IntroFrame
    IntroSubtitle.BackgroundTransparency = 1
    IntroSubtitle.Position = UDim2.new(0, 0, 0, 128)
    IntroSubtitle.Size = UDim2.new(1, 0, 0, 24)
    IntroSubtitle.Font = Enum.Font.Gotham
    IntroSubtitle.Text = "MetA Library 로딩중..."
    IntroSubtitle.TextColor3 = Color3.fromRGB(180, 200, 255)
    IntroSubtitle.TextSize = 16
    IntroSubtitle.TextTransparency = 1

    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    -- Animate in
    TweenService:Create(IntroFrame, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(IntroTitle, tweenInfo, {TextTransparency = 0}):Play()
    TweenService:Create(IntroSubtitle, tweenInfo, {TextTransparency = 0}):Play()
    TweenService:Create(Logo, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {ImageTransparency = 0}):Play()

    -- Animate glow pulse
    task.spawn(function()
        while IntroFrame.Parent do
            TweenService:Create(Glow, TweenInfo.new(1, Enum.EasingStyle.Sine), {ImageTransparency = 0.4}):Play()
            task.wait(1)
            TweenService:Create(Glow, TweenInfo.new(1, Enum.EasingStyle.Sine), {ImageTransparency = 0.7}):Play()
            task.wait(1)
        end
    end)

    -- Animate out after delay
    task.spawn(function()
        task.wait(2.2)
        local fadeOut = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        TweenService:Create(IntroFrame, fadeOut, {BackgroundTransparency = 1}):Play()
        TweenService:Create(IntroTitle, fadeOut, {TextTransparency = 1}):Play()
        TweenService:Create(IntroSubtitle, fadeOut, {TextTransparency = 1}):Play()
        TweenService:Create(Logo, fadeOut, {ImageTransparency = 1}):Play()
        TweenService:Create(Glow, fadeOut, {ImageTransparency = 1}):Play()
        task.wait(0.6)
        IntroFrame:Destroy()
        Main.Visible = true
    end)
    -- Intro Remake End
    
    Title.Name = "Title" 
    Title.Parent = Main
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Title.BorderColor3 = Color3.fromRGB(60, 60, 60)
    Title.BorderSizePixel = 1
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.Font = Enum.Font.Gotham
    Title.Text = "   " .. title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.Parent = Title
    TitleCorner.CornerRadius = UDim.new(0, 6)
    
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = Title
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.Position = UDim2.new(1, -25, 0, 5)
    CloseButton.Size = UDim2.new(0, 15, 0, 15)
    CloseButton.Font = Enum.Font.Gotham
    CloseButton.Text = ""
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.Parent = CloseButton
    CloseCorner.CornerRadius = UDim.new(1, 0)
    
    CloseButton.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = game:GetService("TweenService"):Create(Main, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        })
        tween.Completed:Connect(function()
            ScreenGui:Destroy()
        end)
        tween:Play()
    end)
    
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = Title
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    MinimizeButton.Position = UDim2.new(1, -45, 0, 5)
    MinimizeButton.Size = UDim2.new(0, 15, 0, 15)
    MinimizeButton.Font = Enum.Font.Gotham
    MinimizeButton.Text = ""
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.Parent = MinimizeButton
    MinimizeCorner.CornerRadius = UDim.new(1, 0)
    
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if minimized then
            local tween = game:GetService("TweenService"):Create(Main, tweenInfo, {
                Size = UDim2.new(0, 500, 0, 25)
            })
            tween:Play()
            tween.Completed:Connect(function()
                TabHolder.Visible = false
                ContentContainer.Visible = false
            end)
        else
            TabHolder.Visible = true
            ContentContainer.Visible = true
            local tween = game:GetService("TweenService"):Create(Main, tweenInfo, {
                Size = UDim2.new(0, 500, 0, 300)
            })
            tween:Play()
        end
    end)
    
    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Main
    TabHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabHolder.BorderColor3 = Color3.fromRGB(60, 60, 60)
    TabHolder.BorderSizePixel = 1
    TabHolder.Position = UDim2.new(0, 0, 0, 25)
    TabHolder.Size = UDim2.new(0, 100, 1, -25)

    TabList.Parent = TabHolder
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = Main
    ContentContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ContentContainer.BorderColor3 = Color3.fromRGB(60, 60, 60)
    ContentContainer.BorderSizePixel = 1
    ContentContainer.Position = UDim2.new(0, 100, 0, 25)
    ContentContainer.Size = UDim2.new(1, -100, 1, -25)
    
    local Window = {}
    Window._tabs = Window._tabs or {}
    Window._tabContents = Window._tabContents or {}

    -- Tab creation
    function Window:AddTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabButton_" .. tabName
        TabButton.Parent = TabHolder
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        TabButton.BorderColor3 = Color3.fromRGB(60, 60, 120)
        TabButton.Size = UDim2.new(1, -10, 0, 30)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(200, 220, 255)
        TabButton.TextSize = 14
        TabButton.AutoButtonColor = true

        local TabCorner = Instance.new("UICorner")
        TabCorner.Parent = TabButton
        TabCorner.CornerRadius = UDim.new(0, 6)

        local TabContent = Instance.new("Frame")
        TabContent.Name = "TabContent_" .. tabName
        TabContent.Parent = ContentContainer
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false

        Window._tabs[tabName] = TabButton
        Window._tabContents[tabName] = TabContent

        TabButton.MouseButton1Click:Connect(function()
            for name, content in pairs(Window._tabContents) do
                content.Visible = false
                if Window._tabs[name] then
                    Window._tabs[name].BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                end
            end
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
        end)

        -- Select first tab by default
        if #ContentContainer:GetChildren() == 1 then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
        end

        return TabContent
    end

    -- Add UI element to tab
    function Window:AddLabel(tabName, text)
        local tab = Window._tabContents[tabName]
        if not tab then return end
        local Label = Instance.new("TextLabel")
        Label.Parent = tab
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(1, -20, 0, 24)
        Label.Position = UDim2.new(0, 10, 0, #tab:GetChildren() * 28)
        Label.Font = Enum.Font.Gotham
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(220, 220, 255)
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        return Label
    end

    function Window:AddButton(tabName, text, callback)
        local tab = Window._tabContents[tabName]
        if not tab then return end
        local Button = Instance.new("TextButton")
        Button.Parent = tab
        Button.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
        Button.Size = UDim2.new(1, -20, 0, 28)
        Button.Position = UDim2.new(0, 10, 0, #tab:GetChildren() * 32)
        Button.Font = Enum.Font.Gotham
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.AutoButtonColor = true

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.Parent = Button
        ButtonCorner.CornerRadius = UDim.new(0, 6)

        Button.MouseButton1Click:Connect(function()
            if callback then
                pcall(callback)
            end
        end)
        return Button
    end

    function Window:AddToggle(tabName, text, default, callback)
        local tab = Window._tabContents[tabName]
        if not tab then return end
        local Toggle = Instance.new("TextButton")
        Toggle.Parent = tab
        Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        Toggle.Size = UDim2.new(1, -20, 0, 28)
        Toggle.Position = UDim2.new(0, 10, 0, #tab:GetChildren() * 32)
        Toggle.Font = Enum.Font.Gotham
        Toggle.Text = text .. (default and " [ON]" or " [OFF]")
        Toggle.TextColor3 = default and Color3.fromRGB(60, 220, 120) or Color3.fromRGB(220, 60, 60)
        Toggle.TextSize = 14
        Toggle.AutoButtonColor = true

        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.Parent = Toggle
        ToggleCorner.CornerRadius = UDim.new(0, 6)

        local state = default
        Toggle.MouseButton1Click:Connect(function()
            state = not state
            Toggle.Text = text .. (state and " [ON]" or " [OFF]")
            Toggle.TextColor3 = state and Color3.fromRGB(60, 220, 120) or Color3.fromRGB(220, 60, 60)
            if callback then
                pcall(callback, state)
            end
        end)
        return Toggle
    end

    function Window:AddTextbox(tabName, placeholder, callback)
        local tab = Window._tabContents[tabName]
        if not tab then return end
        local Box = Instance.new("TextBox")
        Box.Parent = tab
        Box.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        Box.Size = UDim2.new(1, -20, 0, 28)
        Box.Position = UDim2.new(0, 10, 0, #tab:GetChildren() * 32)
        Box.Font = Enum.Font.Gotham
        Box.Text = ""
        Box.PlaceholderText = placeholder
        Box.TextColor3 = Color3.fromRGB(255, 255, 255)
        Box.TextSize = 14

        local BoxCorner = Instance.new("UICorner")
        BoxCorner.Parent = Box
        BoxCorner.CornerRadius = UDim.new(0, 6)

        Box.FocusLost:Connect(function(enter)
            if enter and callback then
                pcall(callback, Box.Text)
            end
        end)
        return Box
    end

    return Window
end
return Library
