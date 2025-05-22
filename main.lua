-- Safe Roblox environment check
local ok, game = pcall(function() return game end)
if not ok or not game or not game.GetService then
    return {}
end

local Library = {}

-- Helper to get a safe parent for GUIs (for loadstring compatibility)
local function getSafeParent()
    local parent
    if typeof and typeof(gethui) == "function" then
        local s, res = pcall(gethui)
        if s and typeof(res) == "Instance" and (res:IsA("ScreenGui") or res:IsA("Folder") or res:IsA("PlayerGui")) then
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

-- ... (여기에 기존 Library:CreateWindow 함수 이하 전체 코드 붙여넣기) ...
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
    
    local IntroFrame = Instance.new("Frame")
    IntroFrame.Name = "IntroFrame"
    IntroFrame.Parent = ScreenGui
    IntroFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    IntroFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
    IntroFrame.Position = UDim2.new(0.5, -125, 0.5, -50)
    IntroFrame.Size = UDim2.new(0, 250, 0, 100)
    
    local IntroCorner = Instance.new("UICorner")
    IntroCorner.Parent = IntroFrame
    IntroCorner.CornerRadius = UDim.new(0, 6)
    
    local IntroTitle = Instance.new("TextLabel")
    IntroTitle.Name = "IntroTitle"
    IntroTitle.Parent = IntroFrame
    IntroTitle.BackgroundTransparency = 1
    IntroTitle.Position = UDim2.new(0, 0, 0, 20)
    IntroTitle.Size = UDim2.new(1, 0, 0, 30)
    IntroTitle.Font = Enum.Font.GothamBold
    IntroTitle.Text = title
    IntroTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    IntroTitle.TextSize = 18
    
    local IntroSubtitle = Instance.new("TextLabel")
    IntroSubtitle.Name = "IntroSubtitle"
    IntroSubtitle.Parent = IntroFrame
    IntroSubtitle.BackgroundTransparency = 1
    IntroSubtitle.Position = UDim2.new(0, 0, 0, 50)
    IntroSubtitle.Size = UDim2.new(1, 0, 0, 30)
    IntroSubtitle.Font = Enum.Font.Gotham
    IntroSubtitle.Text = "Loading..."
    IntroSubtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    IntroSubtitle.TextSize = 14
    
    IntroFrame.BackgroundTransparency = 1
    IntroTitle.TextTransparency = 1
    IntroSubtitle.TextTransparency = 1
    
    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    TweenService:Create(IntroFrame, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(IntroTitle, tweenInfo, {TextTransparency = 0}):Play()
    TweenService:Create(IntroSubtitle, tweenInfo, {TextTransparency = 0}):Play()
    
    task.spawn(function()
        task.wait(2)
        local fadeOut = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(IntroFrame, fadeOut, {BackgroundTransparency = 1}):Play()
        TweenService:Create(IntroTitle, fadeOut, {TextTransparency = 1}):Play()
        TweenService:Create(IntroSubtitle, fadeOut, {TextTransparency = 1}):Play()
        task.wait(0.5)
        IntroFrame:Destroy()
        Main.Visible = true
    end)
    
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Main.BorderColor3 = Color3.fromRGB(60, 60, 60)
    Main.BorderSizePixel = 1
    Main.Position = UDim2.new(0.5, -250, 0.5, -150)
    Main.Size = UDim2.new(0, 500, 0, 300)
    Main.Active = true
    pcall(function() Main.Draggable = true end) -- Draggable may error in some environments
    Main.Visible = false
    
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

    -- Ensure TabList is parented to TabHolder for proper tab listing
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
    
    -- Store all tabs and their contents for switching
    Window._tabs = Window._tabs or {}
    Window._tabContents = Window._tabContents or {}

    function Window:CreateTab(name)
        local Tab = Instance.new("TextButton")
        local Content = Instance.new("ScrollingFrame")
        local ContentList = Instance.new("UIListLayout")
        
        Tab.Name = name
        Tab.Parent = TabHolder
        Tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Tab.BorderColor3 = Color3.fromRGB(60, 60, 60)
        Tab.BorderSizePixel = 1
        Tab.Size = UDim2.new(1, 0, 0, 25)
        Tab.Font = Enum.Font.Gotham
        Tab.Text = "  " .. name
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        Tab.TextSize = 11
        Tab.TextXAlignment = Enum.TextXAlignment.Left
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.Parent = Tab
        TabCorner.CornerRadius = UDim.new(0, 6)
        
        Content.Name = name.."Content"
        Content.Parent = ContentContainer
        Content.BackgroundTransparency = 1
        Content.Size = UDim2.new(1, 0, 1, 0)
        Content.Visible = false -- Only show when selected
        Content.ScrollBarThickness = 2
        Content.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        
        ContentList.Parent = Content
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 8)

        -- Store tab and content for switching
        table.insert(Window._tabs, Tab)
        table.insert(Window._tabContents, Content)

        -- Tab switching logic
        Tab.MouseButton1Click:Connect(function()
            for i, c in ipairs(Window._tabContents) do
                c.Visible = false
                Window._tabs[i].BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end
            Content.Visible = true
            Tab.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
        end)

        -- If this is the first tab, select it by default
        if #Window._tabs == 1 then
            Content.Visible = true
            Tab.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
        end
        
        local TabFunctions = {}

        function TabFunctions:Notify(title, text, duration)
            duration = duration or 3
            
            local NotifyGui = Instance.new("ScreenGui")
            NotifyGui.Name = "LibraryNotify_" .. tostring(math.random(100000,999999))
            NotifyGui.ResetOnSpawn = false
            NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            NotifyGui.Parent = getSafeParent()
            
            local NotifyFrame = Instance.new("Frame")
            local Title = Instance.new("TextLabel")
            local Message = Instance.new("TextLabel")
            
            NotifyFrame.Name = "NotifyFrame"
            NotifyFrame.Parent = NotifyGui
            NotifyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            NotifyFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
            NotifyFrame.Position = UDim2.new(1, 5, 0.8, 0)
            NotifyFrame.Size = UDim2.new(0, 250, 0, 80)
            
            local NotifyCorner = Instance.new("UICorner")
            NotifyCorner.Parent = NotifyFrame
            NotifyCorner.CornerRadius = UDim.new(0, 6)
            
            Title.Name = "Title"
            Title.Parent = NotifyFrame
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 10, 0, 5)
            Title.Size = UDim2.new(1, -20, 0, 25)
            Title.Font = Enum.Font.GothamBold
            Title.Text = title
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            Message.Name = "Message"
            Message.Parent = NotifyFrame
            Message.BackgroundTransparency = 1
            Message.Position = UDim2.new(0, 10, 0, 30)
            Message.Size = UDim2.new(1, -20, 1, -35)
            Message.Font = Enum.Font.Gotham
            Message.Text = text
            Message.TextColor3 = Color3.fromRGB(200, 200, 200)
            Message.TextSize = 12
            Message.TextWrapped = true
            Message.TextXAlignment = Enum.TextXAlignment.Left
            
            local TweenService = game:GetService("TweenService")
            
            local slideIn = TweenService:Create(NotifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -260, 0.8, 0)
            })
            slideIn:Play()
            
            task.spawn(function()
                task.wait(duration)
                local slideOut = TweenService:Create(NotifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                    Position = UDim2.new(1, 5, 0.8, 0)
                })
                slideOut:Play()
                slideOut.Completed:Connect(function()
                    NotifyGui:Destroy()
                end)
            end)
        end
        
        function TabFunctions:AddButton(text, description, callback)
            local Button = Instance.new("TextButton")
            local Description = Instance.new("TextLabel")
            
            Button.Name = text
            Button.Parent = Content
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Button.BorderColor3 = Color3.fromRGB(60, 60, 60)
            Button.BorderSizePixel = 1
            Button.Size = UDim2.new(0.95, 0, 0, description and 45 or 30)
            Button.Position = UDim2.new(0.025, 0, 0, 0)
            Button.Font = Enum.Font.Gotham
            Button.Text = "   " .. text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 13
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Button.TextYAlignment = Enum.TextYAlignment.Center
            Button.AutoButtonColor = false
            
            if description then
                Description.Parent = Button
                Description.BackgroundTransparency = 1
                Description.Position = UDim2.new(0, 8, 0.5, 0)
                Description.Size = UDim2.new(1, -16, 0, 20)
                Description.Font = Enum.Font.Gotham
                Description.Text = description
                Description.TextColor3 = Color3.fromRGB(200, 200, 200)
                Description.TextSize = 11
                Description.TextXAlignment = Enum.TextXAlignment.Left
            end
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.Parent = Button
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            
            Button.MouseButton1Click:Connect(callback)
            
            return Button
        end

        function TabFunctions:AddText(text, description)
            local TextLabel = Instance.new("TextLabel")
            local Description = Instance.new("TextLabel")
            
            TextLabel.Name = text
            TextLabel.Parent = Content
            TextLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TextLabel.BorderColor3 = Color3.fromRGB(60, 60, 60)
            TextLabel.BorderSizePixel = 1
            TextLabel.Size = UDim2.new(0.95, 0, 0, description and 45 or 30)
            TextLabel.Position = UDim2.new(0.025, 0, 0, 0)
            TextLabel.Font = Enum.Font.Gotham
            TextLabel.Text = "   " .. text
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 13
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.TextYAlignment = Enum.TextYAlignment.Center
            
            if description then
                Description.Parent = TextLabel
                Description.BackgroundTransparency = 1
                Description.Position = UDim2.new(0, 8, 0.6, -2)
                Description.Size = UDim2.new(1, -16, 0, 20)
                Description.Font = Enum.Font.Gotham
                Description.Text = description
                Description.TextColor3 = Color3.fromRGB(200, 200, 200)
                Description.TextSize = 11
                Description.TextXAlignment = Enum.TextXAlignment.Left
            end
            
            return TextLabel
        end
        
        function TabFunctions:AddSlider(text, description, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            local SliderText = Instance.new("TextLabel")
            local Description = Instance.new("TextLabel")
            local SliderButton = Instance.new("TextButton")
            local SliderInner = Instance.new("Frame")
            local Value = Instance.new("TextLabel")
            
            SliderFrame.Name = text
            SliderFrame.Parent = Content
            SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            SliderFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
            SliderFrame.BorderSizePixel = 1
            SliderFrame.Size = UDim2.new(0.95, 0, 0, description and 60 or 45)
            SliderFrame.Position = UDim2.new(0.025, 0, 0, 0)
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.Parent = SliderFrame
            SliderCorner.CornerRadius = UDim.new(0, 6)
            
            SliderText.Parent = SliderFrame
            SliderText.BackgroundTransparency = 1
            SliderText.Position = UDim2.new(0, 8, 0, 0)
            SliderText.Size = UDim2.new(1, -16, 0, 25)
            SliderText.Font = Enum.Font.Gotham
            SliderText.Text = text
            SliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderText.TextSize = 13
            SliderText.TextXAlignment = Enum.TextXAlignment.Left
            SliderText.TextYAlignment = Enum.TextYAlignment.Center
            
            if description then
                Description.Parent = SliderFrame
                Description.BackgroundTransparency = 1
                Description.Position = UDim2.new(0, 8, 0, 18)
                Description.Size = UDim2.new(1, -16, 0, 20)
                Description.Font = Enum.Font.Gotham
                Description.Text = description
                Description.TextColor3 = Color3.fromRGB(200, 200, 200)
                Description.TextSize = 11
                Description.TextXAlignment = Enum.TextXAlignment.Left
            end
            
            SliderButton.Parent = SliderFrame
            SliderButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            SliderButton.BorderColor3 = Color3.fromRGB(60, 60, 60)
            SliderButton.BorderSizePixel = 1
            SliderButton.Position = UDim2.new(0, 8, 1, -15)
            SliderButton.Size = UDim2.new(1, -16, 0, 8)
            SliderButton.Text = ""
            SliderButton.AutoButtonColor = false
            
            local SliderButtonCorner = Instance.new("UICorner")
            SliderButtonCorner.Parent = SliderButton
            SliderButtonCorner.CornerRadius = UDim.new(0, 4)
            
            SliderInner.Parent = SliderButton
            SliderInner.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            SliderInner.BorderSizePixel = 0
            SliderInner.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            
            local SliderInnerCorner = Instance.new("UICorner")
            SliderInnerCorner.Parent = SliderInner
            SliderInnerCorner.CornerRadius = UDim.new(0, 4)
            
            Value.Parent = SliderFrame
            Value.BackgroundTransparency = 1
            Value.Position = UDim2.new(0.9, 0, 0, 0)
            Value.Size = UDim2.new(0.1, -10, 0, 25)
            Value.Font = Enum.Font.Gotham
            Value.Text = tostring(default)
            Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Value.TextSize = 13
            Value.TextYAlignment = Enum.TextYAlignment.Center
            
            local dragging = false
            local UserInputService = game:GetService("UserInputService")
            
            SliderButton.InputBegan:Connect(function(input)
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
                    local relativePos = mousePos.X - SliderButton.AbsolutePosition.X
                    local percentage = math.clamp(relativePos / SliderButton.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + ((max - min) * percentage))
                    
                    SliderInner.Size = UDim2.new(percentage, 0, 1, 0)
                    Value.Text = tostring(value)
                    callback(value)
                end
            end)
        end

        function TabFunctions:AddToggle(text, description, default, callback)
            local ToggleFrame = Instance.new("Frame")
            local ToggleButton = Instance.new("TextButton")
            local ToggleInner = Instance.new("Frame")
            local Description = Instance.new("TextLabel")
            
            ToggleFrame.Name = text
            ToggleFrame.Parent = Content
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ToggleFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
            ToggleFrame.BorderSizePixel = 1
            ToggleFrame.Size = UDim2.new(0.95, 0, 0, description and 45 or 30)
            ToggleFrame.Position = UDim2.new(0.025, 0, 0, 0)
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.Parent = ToggleFrame
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Parent = ToggleFrame
            ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ToggleButton.BorderColor3 = Color3.fromRGB(60, 60, 60)
            ToggleButton.BorderSizePixel = 1
            ToggleButton.Position = UDim2.new(0, 8, 0.5, -8)
            ToggleButton.Size = UDim2.new(0, 16, 0, 16)
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.Parent = ToggleButton
            ToggleButtonCorner.CornerRadius = UDim.new(0, 4)
            
            ToggleInner.Name = "ToggleInner"
            ToggleInner.Parent = ToggleButton
            ToggleInner.BackgroundColor3 = default and Color3.fromRGB(80, 220, 120) or Color3.fromRGB(60, 60, 60)
            ToggleInner.BorderSizePixel = 0
            ToggleInner.Size = UDim2.new(1, 0, 1, 0)
            ToggleInner.Visible = default
            
            local ToggleInnerCorner = Instance.new("UICorner")
            ToggleInnerCorner.Parent = ToggleInner
            ToggleInnerCorner.CornerRadius = UDim.new(0, 4)
            
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Parent = ToggleFrame
            TextLabel.BackgroundTransparency = 1
            TextLabel.Position = UDim2.new(0, 32, 0, 0)
            TextLabel.Size = UDim2.new(1, -40, description and 0.5 or 1, 0)
            TextLabel.Font = Enum.Font.Gotham
            TextLabel.Text = text
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 13
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.TextYAlignment = Enum.TextYAlignment.Center
            
            if description then
            Description.Parent = ToggleFrame
            Description.BackgroundTransparency = 1
            Description.Position = UDim2.new(0, 32, 0.5, -2)
            Description.Size = UDim2.new(1, -40, 0.5, 0)
            Description.Font = Enum.Font.Gotham
            Description.Text = description
            Description.TextColor3 = Color3.fromRGB(200, 200, 200)
            Description.TextSize = 11
            Description.TextXAlignment = Enum.TextXAlignment.Left
            end
            
            local toggled = default
            ToggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            ToggleInner.Visible = toggled
            ToggleInner.BackgroundColor3 = toggled and Color3.fromRGB(80, 220, 120) or Color3.fromRGB(60, 60, 60)
            callback(toggled)
            end)
            
            return ToggleFrame
        end

        -- Syntax highlight helper
        function TabFunctions:AddLuaExecutor()
            local ExecutorFrame = Instance.new("Frame")
            ExecutorFrame.Name = "LuaExecutor"
            ExecutorFrame.Parent = Content
            ExecutorFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ExecutorFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
            ExecutorFrame.BorderSizePixel = 1
            ExecutorFrame.Size = UDim2.new(0.95, 0, 0, 120)
            ExecutorFrame.Position = UDim2.new(0.025, 0, 0, 0)

            local ExecutorCorner = Instance.new("UICorner")
            ExecutorCorner.Parent = ExecutorFrame
            ExecutorCorner.CornerRadius = UDim.new(0, 6)

            -- Syntax highlight label (on top of the TextBox)
            local HighlightLabel = Instance.new("TextLabel")
            HighlightLabel.Parent = ExecutorFrame
            HighlightLabel.BackgroundTransparency = 1
            HighlightLabel.Position = UDim2.new(0, 8, 0, 8)
            HighlightLabel.Size = UDim2.new(1, -16, 0, 70)
            HighlightLabel.Font = Enum.Font.Code
            HighlightLabel.Text = ""
            HighlightLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            HighlightLabel.TextSize = 13
            HighlightLabel.TextXAlignment = Enum.TextXAlignment.Left
            HighlightLabel.TextYAlignment = Enum.TextYAlignment.Top
            HighlightLabel.RichText = true
            HighlightLabel.ClipsDescendants = true
            HighlightLabel.ZIndex = 3 -- Make sure highlight is above the TextBox

            local TextBox = Instance.new("TextBox")
            TextBox.Parent = ExecutorFrame
            TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            TextBox.BackgroundTransparency = 1 -- Make background fully transparent
            TextBox.BorderColor3 = Color3.fromRGB(60, 60, 60)
            TextBox.BorderSizePixel = 1
            TextBox.Position = UDim2.new(0, 8, 0, 8)
            TextBox.Size = UDim2.new(1, -16, 0, 70)
            TextBox.Font = Enum.Font.Code
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.TextSize = 13
            TextBox.TextXAlignment = Enum.TextXAlignment.Left
            TextBox.TextYAlignment = Enum.TextYAlignment.Top
            TextBox.ClearTextOnFocus = false
            TextBox.MultiLine = true
            TextBox.RichText = true -- RichText를 true로 설정하여 겹침 현상 방지
            TextBox.ClipsDescendants = true
            TextBox.ZIndex = 2

            local TextBoxCorner = Instance.new("UICorner")
            TextBoxCorner.Parent = TextBox
            TextBoxCorner.CornerRadius = UDim.new(0, 4)

            local ExecuteButton = Instance.new("TextButton")
            ExecuteButton.Parent = ExecutorFrame
            ExecuteButton.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
            ExecuteButton.BorderColor3 = Color3.fromRGB(60, 60, 60)
            ExecuteButton.BorderSizePixel = 1
            ExecuteButton.Position = UDim2.new(1, -88, 1, -36)
            ExecuteButton.Size = UDim2.new(0, 80, 0, 28)
            ExecuteButton.Font = Enum.Font.GothamBold
            ExecuteButton.Text = "실행"
            ExecuteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            ExecuteButton.TextSize = 13
            ExecuteButton.ZIndex = 2

            local ExecuteButtonCorner = Instance.new("UICorner")
            ExecuteButtonCorner.Parent = ExecuteButton
            ExecuteButtonCorner.CornerRadius = UDim.new(0, 4)

            local OutputLabel = Instance.new("TextLabel")
            OutputLabel.Parent = ExecutorFrame
            OutputLabel.BackgroundTransparency = 1
            OutputLabel.Position = UDim2.new(0, 8, 1, -60)
            OutputLabel.Size = UDim2.new(1, -100, 0, 20)
            OutputLabel.Font = Enum.Font.Gotham
            OutputLabel.Text = ""
            OutputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            OutputLabel.TextSize = 12
            OutputLabel.TextXAlignment = Enum.TextXAlignment.Left
            OutputLabel.TextYAlignment = Enum.TextYAlignment.Center
            OutputLabel.ZIndex = 2

            -- 간단한 Lua syntax 하이라이트 함수
            local keywords = {
                ["and"]=true, ["break"]=true, ["do"]=true, ["else"]=true, ["elseif"]=true, ["end"]=true,
                ["false"]=true, ["for"]=true, ["function"]=true, ["if"]=true, ["in"]=true, ["local"]=true,
                ["nil"]=true, ["not"]=true, ["or"]=true, ["repeat"]=true, ["return"]=true, ["then"]=true,
                ["true"]=true, ["until"]=true, ["while"]=true
            }
            local function highlightLua(code)
                -- 문자열 강조 (따옴표 안의 문자열)
                code = code:gsub("(%-%-.-)\n", "<font color=\"#888888\">%1</font>\n") -- 한 줄 주석
                code = code:gsub("(%-%-.*)$", "<font color=\"#888888\">%1</font>") -- 마지막 줄 주석
                code = code:gsub("(['\"]).-.-%1", function(str)
                    return "<font color=\"#FFD700\">" .. str .. "</font>"
                end)
                
                -- 숫자 강조
                code = code:gsub("(%d+)", "<font color=\"#7EC0EE\">%1</font>")
                -- 키워드 강조
                code = code:gsub("(%a[%w_]*)", function(word)
                    if keywords[word] then
                        return "<font color=\"#FF8080\">" .. word .. "</font>"
                    end
                    return word
                end)
                return code
            end

            -- TextBox 입력 변경 시 하이라이트 적용 (HighlightLabel에만 적용)
            TextBox:GetPropertyChangedSignal("Text"):Connect(function()
                local text = TextBox.Text
                HighlightLabel.Text = highlightLua(text)
            end)
            -- 초기 하이라이트
            HighlightLabel.Text = highlightLua(TextBox.Text)

            ExecuteButton.MouseButton1Click:Connect(function()
                -- RichText 제거 후 실행
                local code = TextBox.Text
                -- RichText 태그 제거
                code = code:gsub("<.->", "")
                local func, err = loadstring(code)
                if func then
                    local ok, result = pcall(func)
                    if ok then
                        OutputLabel.Text = "실행 성공"
                        OutputLabel.TextColor3 = Color3.fromRGB(80, 220, 120)
                    else
                        OutputLabel.Text = "오류: " .. tostring(result)
                        OutputLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                    end
                else
                    OutputLabel.Text = "컴파일 오류: " .. tostring(err)
                    OutputLabel.TextColor3 = Color3.fromRGB(255, 180, 80)
                end
            end)

            return ExecutorFrame
        end
        
        return TabFunctions
        end

    return Window
end

return Library
--[[
-- 사용 예시
local Window = Library:CreateWindow("My Window")
local Tab1 = Window:CreateTab("Tab 1")
local Tab2 = Window:CreateTab("Tab 2")
Tab1:AddButton("Click Me", "This is a button", function()
    print("Button clicked!")
end)
Tab1:AddText("Hello World", "This is a text label")
Tab1:AddSlider("Volume", "Adjust the volume", 0, 100, 50, function(value)
    print("Volume set to: " .. value)
end)
Tab1:AddToggle("Enable Feature", "Enable or disable this feature", false, function(enabled)
    print("Feature enabled: " .. tostring(enabled))
end)
Tab1:AddLuaExecutor()
Tab2:AddButton("Click Me Too", "This is another button", function()
    print("Another button clicked!")
end)
]]
