local Root = script.Parent.Parent
local Creator = require(Root.Creator)
local TweenService = game:GetService("TweenService")

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Button"

function Element:New(Idx, Config)
	local Library = self.Library
	assert(Config.Title, "Button - Missing Title.")
	assert(Config.Callback, "Button - Missing Callback.")

	local Button = {
		Title = Config.Title,
		Description = Config.Description,
		Callback = Config.Callback,
		Type = "Button",
	}

	local ButtonFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, true)

	Button.SetTitle = ButtonFrame.SetTitle
	Button.SetDesc = ButtonFrame.SetDesc

	local ClickButton = New("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		Parent = ButtonFrame.Frame,
		AutoButtonColor = false,
	})

	-- เพิ่มแอนิเมชันเอฟเฟกต์แสงตอบสนองตอนกด (Visual Feedback)
	Creator.AddSignal(ClickButton.MouseButton1Down, function()
		TweenService:Create(ButtonFrame.Frame, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.fromRGB(45, 45, 55)
		}):Play()
	end)

	Creator.AddSignal(ClickButton.MouseButton1Up, function()
		TweenService:Create(ButtonFrame.Frame, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		}):Play()
	end)

	Creator.AddSignal(ClickButton.MouseLeave, function()
		TweenService:Create(ButtonFrame.Frame, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		}):Play()
	end)

	Creator.AddSignal(ClickButton.MouseButton1Click, function()
		Library:SafeCallback(Button.Callback)
	end)

	function Button:Destroy()
		ButtonFrame:Destroy()
		Library.Options[Idx] = nil
	end

	Library.Options[Idx] = Button
	return Button
end

return Element
