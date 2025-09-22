-- Angepasstes Orion-Skript, Tabs hellblau, nur ein Tab mit Toggle ohne Effekt

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

local OrionLib = {
    Elements = {},
    ThemeObjects = {},
    Connections = {},
    Flags = {},
    Themes = {
        Default = {
            Main     = Color3.fromRGB(25, 25, 25),
            Second   = Color3.fromRGB(32, 32, 32),
            Stroke   = Color3.fromRGB(60, 60, 60),
            Divider  = Color3.fromRGB(60, 60, 60),
            Text     = Color3.fromRGB(240, 240, 240),
            TextDark = Color3.fromRGB(150, 150, 150),
            -- Hier neu: Tab Hintergrund hellblau
            TabBackground = Color3.fromRGB(173, 216, 230) -- hellblau
        }
    },
    SelectedTheme = "Default",
    Folder = nil,
    SaveCfg = false
}

-- Hilfsfunktionen etc bleiben wie im Original

-- ... (der Großteil deines Originalcodes hier, unverändert) ...

-- Wichtig: in MakeWindow und MakeTab die Farbwerte des Tabs anpassen
function OrionLib:MakeWindow(WindowConfig)
    -- ... Vorarbeiten etc ...

    -- TabHolder erzeugen wie gehabt
    local TabHolder = AddThemeObject(
        SetChildren(
            SetProps(MakeElement("ScrollFrame", OrionLib.Themes[OrionLib.SelectedTheme].TabBackground, 4), { -- hier hellblau statt weiß
                Size = UDim2.new(1, 0, 1, -50)
            }),
            { MakeElement("List"), MakeElement("Padding", 8, 0, 0, 8) }
        ),
        "Divider"
    )
    AddConnection(TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        TabHolder.CanvasSize = UDim2.new(0, 0, 0, TabHolder.UIListLayout.AbsoluteContentSize.Y + 16)
    end)

    -- Rest vom Fenster
    -- ...

    -- Nur ein Tab erzeugen:
    local TabFunction = {}
    function TabFunction:MakeTab(TabConfig)
        TabConfig = TabConfig or {}
        TabConfig.Name = TabConfig.Name or "Einziger Tab"
        TabConfig.Icon = TabConfig.Icon or ""
        TabConfig.PremiumOnly = TabConfig.PremiumOnly or false

        local TabFrame = SetChildren(
            SetProps(MakeElement("Button"), {
                Size = UDim2.new(1, 0, 0, 30),
                Parent = TabHolder,
                BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].TabBackground
            }),
            {
                AddThemeObject(SetProps(MakeElement("Image", TabConfig.Icon), {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new(0, 10, 0.5, 0),
                    ImageTransparency = 0.4,
                    Name = "Ico"
                }), "Text"),

                AddThemeObject(SetProps(MakeElement("Label", TabConfig.Name, 14), {
                    Size = UDim2.new(1, -35, 1, 0),
                    Position = UDim2.new(0, 35, 0, 0),
                    Font = Enum.Font.GothamSemibold,
                    TextTransparency = 0.4,
                    Name = "Title"
                }), "Text")
            }
        )

        if FirstTab then
            FirstTab = false
            TabFrame.Ico.ImageTransparency = 0
            TabFrame.Title.TextTransparency = 0
            TabFrame.Title.Font = Enum.Font.GothamBlack
            Container.Visible = true
        end

        AddConnection(TabFrame.MouseButton1Click, function()
            -- da es nur einen Tab gibt, kein Umschalten nötig
            -- ggf. hier später Funktion einbauen
        end)

        -- Container für den Tab Content
        local Container = AddThemeObject(
            SetChildren(
                SetProps(MakeElement("ScrollFrame", OrionLib.Themes[OrionLib.SelectedTheme].TabBackground, 5), {
                    Size = UDim2.new(1, -150, 1, -50),
                    Position = UDim2.new(0, 150, 0, 50),
                    Parent = MainWindow,
                    Visible = true, -- sichtbar, da nur Tab
                    Name = "ItemContainer"
                }),
                { MakeElement("List", 0, 6), MakeElement("Padding", 15, 10, 10, 15) }
            ),
            "Divider"
        )
        AddConnection(Container.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            Container.CanvasSize = UDim2.new(0, 0, 0, Container.UIListLayout.AbsoluteContentSize.Y + 30)
        end)

        -- Toggle im Tab hinzufügen, ohne Wirkung
        local elements = {}
        function elements:AddToggle(ToggleConfig)
            ToggleConfig = ToggleConfig or {}
            ToggleConfig.Name = ToggleConfig.Name or "Toggle"
            ToggleConfig.Default = ToggleConfig.Default or false
            ToggleConfig.Callback = ToggleConfig.Callback or function() end -- keine Wirkung
            ToggleConfig.Color = ToggleConfig.Color or Color3.fromRGB(9, 99, 195)
            ToggleConfig.Flag = ToggleConfig.Flag or nil
            ToggleConfig.Save = ToggleConfig.Save or false

            local Toggle = {Value = ToggleConfig.Default, Save = ToggleConfig.Save}
            local Click = SetProps(MakeElement("Button"), {
                Size = UDim2.new(1, 0, 1, 0)
            })
            -- ToggleBox etc wie im Original...
            local ToggleBox = SetChildren(
                SetProps(MakeElement("RoundFrame", ToggleConfig.Color, 0, 4), {
                    Size = UDim2.new(0, 24, 0, 24),
                    Position = UDim2.new(1, -24, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5)
                }),
                {
                    SetProps(MakeElement("Stroke"), { Color = ToggleConfig.Color, Name = "Stroke", Transparency = 0.5 }),
                    SetProps(MakeElement("Image", "rbxassetid://3944680095"), {
                        Size = UDim2.new(0, 20, 0, 20),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        ImageColor3 = Color3.fromRGB(255, 255, 255),
                        Name = "Ico"
                    })
                }
            )

            local ToggleFrame = AddThemeObject(
                SetChildren(
                    SetProps(MakeElement("RoundFrame", OrionLib.Themes[OrionLib.SelectedTheme].TabBackground, 0, 5), {
                        Size = UDim2.new(1, 0, 0, 38),
                        Parent = Container
                    }),
                    {
                        AddThemeObject(SetProps(MakeElement("Label", ToggleConfig.Name, 15), {
                            Size = UDim2.new(1, -12, 1, 0),
                            Position = UDim2.new(0, 12, 0, 0),
                            Font = Enum.Font.GothamBold,
                            Name = "Content"
                        }), "Text"),

                        AddThemeObject(SetProps(MakeElement("Stroke"), "Stroke"), "Stroke"),

                        ToggleBox,
                        Click
                    }
                ),
                "Second"
            )

            -- Toggle Verhalten: nur visuelles Umschalten
            function Toggle:Set(Value)
                Toggle.Value = Value
                TweenService:Create(ToggleBox, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Toggle.Value and ToggleConfig.Color or OrionLib.Themes.Default.Divider
                }):Play()
                TweenService:Create(ToggleBox.Stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Color = Toggle.Value and ToggleConfig.Color or OrionLib.Themes.Default.Stroke
                }):Play()
                TweenService:Create(ToggleBox.Ico, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    ImageTransparency = Toggle.Value and 0 or 1,
                    Size = Toggle.Value and UDim2.new(0, 20, 0, 20) or UDim2.new(0, 8, 0, 8)
                }):Play()
                ToggleConfig.Callback(Toggle.Value) -- hier aktuell leer
            end

            Toggle:Set(Toggle.Value)

            AddConnection(Click.MouseButton1Up, function()
                Toggle:Set(not Toggle.Value)
            end)

            return Toggle
        end

        -- Toggle hinzufügen
        elements:AddToggle({ Name = "Mein Toggle", Default = false })

        return elements
    end

    -- Fenster erzeugen etc...
    -- Hier aufrufen:
    local win = OrionLib:MakeWindow({ Name = "Meine Kopie", SaveConfig = false })
    win:MakeTab({ Name = "Tab1" })

    return OrionLib
end

return OrionLib
