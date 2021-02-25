
local UserInputService = game:GetService("UserInputService")

local function CreateGUI()
   local Controller = Instance.new("Frame")
   Controller.Name 			            = "FunctionController"
   Controller.AnchorPoint	            = Vector2.new(0, 0)
   Controller.BackgroundColor3         = Color3.fromRGB(26, 26, 26)
   Controller.BackgroundTransparency   = 0
   Controller.BorderColor3             = Color3.fromRGB(27, 42, 53)
   Controller.BorderMode 			      = Enum.BorderMode.Outline
   Controller.BorderSizePixel 			= 0
   Controller.Draggable 			      = false
   Controller.Position 			         = UDim2.new(0, 0, 0, 90)
   Controller.Selectable               = false
   Controller.Size 			            = UDim2.new(1, 0, 0, 30)
   Controller.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   Controller.Style 			            = Enum.FrameStyle.Custom
   Controller.Visible                  = true
   Controller.ZIndex                   = 1
   Controller.Archivable               = true

   local LabelValue = Instance.new('StringValue')
   LabelValue.Name = 'Label'
   LabelValue.Parent = Controller

   local UILocked = Instance.new('StringValue')
   UILocked.Name = 'UILocked'
   UILocked.Parent = Controller

   local OnClickEvent = Instance.new('BindableEvent')
   OnClickEvent.Name     = 'OnClick'
   OnClickEvent.Parent   = Controller

   local LabelText = Instance.new('TextLabel')
   LabelText.Name 			         = "LabelText"
   LabelText.AnchorPoint	         = Vector2.new(0, 0)
   LabelText.AutomaticSize	         = Enum.AutomaticSize.None
   LabelText.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
   LabelText.BackgroundTransparency = 1
   LabelText.BorderColor3           = Color3.fromRGB(27, 42, 53)
   LabelText.BorderMode 			   = Enum.BorderMode.Outline
   LabelText.BorderSizePixel 			= 0
   LabelText.Position 			      = UDim2.new(0, 10, 0, 0)
   LabelText.Selectable             = false
   LabelText.Size 			         = UDim2.new(1, -10, 1, -1)
   LabelText.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   LabelText.Visible                = true
   LabelText.ZIndex                 = 1
   LabelText.Archivable             = true
   LabelText.Font                   = Enum.Font.SourceSans
   LabelText.LineHeight             = 1
   LabelText.RichText               = false
   LabelText.Text                   = 'Function Label'
   LabelText.TextColor3 			   = Color3.fromRGB(238, 238, 238)
   LabelText.TextScaled             = false
   LabelText.TextSize               = 14
   LabelText.TextStrokeColor3 		= Color3.fromRGB(0, 0, 0)
   LabelText.TextStrokeTransparency = 1
   LabelText.TextTransparency       = 0
   LabelText.TextTruncate           = Enum.TextTruncate.AtEnd
   LabelText.TextWrapped            = false
   LabelText.TextXAlignment         = Enum.TextXAlignment.Left
   LabelText.TextYAlignment         = Enum.TextYAlignment.Center
   LabelText.Parent = Controller

   local borderBottom = Instance.new("Frame")
   borderBottom.Name 			         = "border-bottom"
   borderBottom.AnchorPoint	         = Vector2.new(0, 0)
   borderBottom.BackgroundColor3       = Color3.fromRGB(44, 44, 44)
   borderBottom.BackgroundTransparency = 0
   borderBottom.BorderColor3           = Color3.fromRGB(44, 44, 44)
   borderBottom.BorderMode 			   = Enum.BorderMode.Outline
   borderBottom.BorderSizePixel 			= 0
   borderBottom.Draggable 			      = false
   borderBottom.Position 			      = UDim2.new(0, 0, 1, -1)
   borderBottom.Selectable             = false
   borderBottom.Size 			         = UDim2.new(1, 0, 0, 1)
   borderBottom.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   borderBottom.Style 			         = Enum.FrameStyle.Custom
   borderBottom.Visible                = true
   borderBottom.ZIndex                 = 1
   borderBottom.Archivable             = true
   borderBottom.Parent = Controller

   local borderLeft = Instance.new("Frame")
   borderLeft.Name 			            = "border-left"
   borderLeft.AnchorPoint	            = Vector2.new(0, 0)
   borderLeft.BackgroundColor3         = Color3.fromRGB(230, 29, 95)
   borderLeft.BackgroundTransparency   = 0
   borderLeft.BorderColor3             = Color3.fromRGB(27, 42, 53)
   borderLeft.BorderMode 			      = Enum.BorderMode.Outline
   borderLeft.BorderSizePixel 			= 0
   borderLeft.Draggable 			      = false
   borderLeft.Position 			         = UDim2.new(0, 0,0, 0)
   borderLeft.Selectable               = false
   borderLeft.Size 			            = UDim2.new(0, 3, 1, 0)
   borderLeft.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   borderLeft.Style 			            = Enum.FrameStyle.Custom
   borderLeft.Visible                  = true
   borderLeft.ZIndex                   = 2
   borderLeft.Archivable               = true
   borderLeft.Parent = Controller

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections = {}

   table.insert(connections, Controller.MouseLeave:Connect(function()	
      spawn(function()
         UILocked.Value = "UNLOCK"
      end)
   end))

   table.insert(connections, UserInputService.InputEnded:Connect(function(input, gameProcessed)
      if gameProcessed then
         return
      end
      if UILocked.Value == "ACTIVE" and input.UserInputType == Enum.UserInputType.MouseButton1 then
         OnClickEvent:Fire()
      end
   end))

   table.insert(connections, LabelValue.Changed:connect(function()
      LabelText.Text = LabelValue.Value
   end))

   local OnRemove = function()
      for _, conn in ipairs(connections) do
         conn:Disconnect()
      end
      connections = {}
   end

   return Controller, OnRemove
end

-- Provides a GUI interface to fire a specified method, a property of an object.
-- @TODO: Disabled
local function FunctionController(gui, object, property, text)
	
	local frame, OnRemove =  CreateGUI()
	frame.Parent = gui.content
	
	local onClickEvent 	= frame:WaitForChild("OnClick")
	local labelValue 	= frame:WaitForChild("Label")	
	
	-- The function to be called on change.
	local onChange
	
	local controller = {
		frame = frame,
		label = frame:WaitForChild("LabelText"),
		height = frame.AbsoluteSize.Y
	}
	
	------------------------------------------------------------------
	-- Configure events
	------------------------------------------------------------------
	onClickEvent.Event:connect(function()	
		if not controller._isReadonly then
			if onChange ~= nil then
				onChange();
			end
			controller.getValue()(object)
		end
	end)
	
	------------------------------------------------------------------
	-- Public functions
	------------------------------------------------------------------
	
	function controller.onChange(fnc)
		onChange = fnc;
		return controller;
	end	
	
	function controller.setValue(value)
		if not controller._isReadonly then
			object[property] = value
		end
		
		return controller;
	end
	
	function controller.getValue()		
		return object[property]
	end
	
	-- Removes the controller from its parent GUI.
	function controller.remove()

      OnRemove()
		
		gui.removeChild(controller)
		
		if controller.frame ~= nil then
			controller.frame.Parent = nil
			controller.frame = nil
		end		
		
		controller = nil
	end
	
	-- Sets the name of the controller.
	function controller.name(name)
		labelValue.Value = name
		return controller
	end
	
	------------------------------------------------------------------
	-- Set initial values
	------------------------------------------------------------------
	
	if text == nil or string.len(text) == 0 then
		labelValue.Value = property	
	else
		labelValue.Value = text	
	end
	
	return controller
end

return FunctionController
