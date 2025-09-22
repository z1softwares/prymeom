--// Mini Dark UI Library (ähnlich Orion UI)
--// by ChatGPT (free use)

local UILib = {}

-- CreateWindow
function UILib:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")

    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
    MainFrame.Size = UDim2.new(0, 500, 0, 320)

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    Title.Parent = MainFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.Size = UDim2.new(1, -20, 0, 30)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title or "Dark Window"
    Title.TextColor3 = Color3.fromRGB(200, 200, 200)
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Tab Menu
    local TabFrame = Instance.new("Frame")
    TabFrame.Parent = MainFrame
    TabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabFrame.Size = UDim2.new(0, 120, 1, -40)
    TabFrame.Position = UDim2.new(0, 0, 0, 40)

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabFrame
    TabList.Padding = UDim.new(0, 5)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder

    -- Container für Tabs
    local TabContainer = Instance.new("Frame")
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundTransparency = 1
    TabContainer.Size = UDim2.new(1, -130, 1, -40)
    TabContainer.Position = UDim2.new(0, 130, 0, 40)

    local Tabs = {}
    local Window = {}

    function Window:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabFrame
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 16

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Parent = TabContainer
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.Visible = false
        TabPage.BackgroundTransparency = 1
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.ScrollBarThickness = 6

        local UIList = Instance.new("UIListLayout")
        UIList.Parent = TabPage
        UIList.Padding = UDim.new(0, 6)
        UIList.SortOrder = Enum.SortOrder.LayoutOrder

        -- Wechsel zwischen Tabs
        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Page.Visible = false
            end
            TabPage.Visible = true
        end)

        local TabObj = {}

        -- Button
        function TabObj:Button(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Parent = TabPage
            Btn.Size = UDim2.new(1, -10, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Btn.Font = Enum.Font.Gotham
            Btn.Text = text or "Button"
            Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            Btn.TextSize = 16
            Btn.MouseButton1Click:Connect(function()
                if callback then pcall(callback) end
            end)
        end

        -- Toggle
        function TabObj:Toggle(text, default, callback)
            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Parent = TabPage
            ToggleBtn.Size = UDim2.new(1, -10, 0, 35)
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ToggleBtn.Font = Enum.Font.Gotham
            ToggleBtn.Text = text .. " : " .. tostring(default and "ON" or "OFF")
            ToggleBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
            ToggleBtn.TextSize = 16

            local state = default or false
            ToggleBtn.MouseButton1Click:Connect(function()
                state = not state
                ToggleBtn.Text = text .. " : " .. (state and "ON" or "OFF")
                if callback then pcall(callback, state) end
            end)
        end

        -- Slider
        function TabObj:Slider(text, min, max, default, callback)
            local Frame = Instance.new("Frame")
            Frame.Parent = TabPage
            Frame.Size = UDim2.new(1, -10, 0, 50)
            Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

            local Label = Instance.new("TextLabel")
            Label.Parent = Frame
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.Gotham
            Label.Text = text .. ": " .. tostring(default)
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 14

            local SliderBack = Instance.new("Frame")
            SliderBack.Parent = Frame
            SliderBack.Size = UDim2.new(1, -20, 0, 10)
            SliderBack.Position = UDim2.new(0, 10, 0, 30)
            SliderBack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

            local Fill = Instance.new("Frame")
            Fill.Parent = SliderBack
            Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(100, 180, 255)

            local UIS = game:GetService("UserInputService")
            local held = false

            SliderBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    held = true
                end
            end)
            SliderBack.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    held = false
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if held and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local percent = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * percent)
                    Fill.Size = UDim2.new(percent, 0, 1, 0)
                    Label.Text = text .. ": " .. tostring(value)
                    if callback then pcall(callback, value) end
                end
            end)
        end

        Tabs[name] = { Page = TabPage, Btn = TabButton }
        if #TabFrame:GetChildren() == 2 then -- erster Tab auto aktiv
            TabPage.Visible = true
        end

        return TabObj
    end

    return Window
end

return UILib
