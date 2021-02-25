
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")

local BG_COLOR_ON 			= Color3.fromRGB(47, 161, 214)
local BG_COLOR_OFF 			= Color3.fromRGB(60, 60, 60)
local BG_COLOR_HOVER 		= Color3.fromRGB(48, 48, 48)

local CreateGUI = function()
   local Controller = Instance.new("Frame")
   Controller.Name 			            = "BooleanController"
   Controller.AnchorPoint	            = Vector2.new(0, 0)
   Controller.BackgroundColor3        = Color3.fromRGB(26, 26, 26)
   Controller.BackgroundTransparency  = 0
   Controller.BorderColor3            = Color3.fromRGB(27, 42, 53)
   Controller.BorderMode 			      = Enum.BorderMode.Outline
   Controller.BorderSizePixel 			= 0
   Controller.Draggable 			      = false
   Controller.Position 			      = UDim2.new(0, 0, 0, 60)
   Controller.Selectable              = false
   Controller.Size 			            = UDim2.new(1, 0, 0, 30)
   Controller.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   Controller.Style 			         = Enum.FrameStyle.Custom
   Controller.Visible                 = true
   Controller.ZIndex                  = 1

   local LabelValue = Instance.new('StringValue')
   LabelValue.Name = 'Label'
   LabelValue.Parent = Controller

   local UILocked = Instance.new('StringValue')
   UILocked.Name = 'UILocked'
   UILocked.Parent = Controller

   local Value = Instance.new('BoolValue')
   Value.Name     = 'Value'
   Value.Value    = false
   Value.Parent   = Controller

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
   LabelText.Size 			         = UDim2.new(0.4, -10, 1, -1)
   LabelText.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   LabelText.Visible                = true
   LabelText.ZIndex                 = 1
   LabelText.Archivable             = true
   LabelText.Font                   = Enum.Font.SourceSans
   LabelText.LineHeight             = 1
   LabelText.RichText               = false
   LabelText.Text                   = 'Boolean Label'
   LabelText.TextColor3 			   = Color3.new(238, 238, 238)
   LabelText.TextScaled             = false
   LabelText.TextSize               = 14
   LabelText.TextStrokeColor3 		= Color3.new(0, 0, 0)
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
   borderLeft.BackgroundColor3         = Color3.fromRGB(128, 103, 135)
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

   local Control = Instance.new("Frame")
   Control.Name 			            = "control"
   Control.AnchorPoint	            = Vector2.new(0, 0)
   Control.BackgroundColor3         = Color3.fromRGB(255, 255, 255)
   Control.BackgroundTransparency   = 1
   Control.BorderColor3             = Color3.fromRGB(27, 42, 53)
   Control.BorderMode 			      = Enum.BorderMode.Outline
   Control.BorderSizePixel 			= 0
   Control.Draggable 			      = false
   Control.Position 			         = UDim2.new(0.4, 0, 0, 0)
   Control.Selectable               = false
   Control.Size 			            = UDim2.new(0.6, 0, 1, -1)
   Control.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   Control.Style 			            = Enum.FrameStyle.Custom
   Control.Visible                  = true
   Control.ZIndex                   = 1
   Control.Archivable               = true
   Control.Parent = Controller

   local Checkbox = Instance.new("Frame")
   Checkbox.Name 			            = "checkbox"
   Checkbox.AnchorPoint	            = Vector2.new(0, 0)
   Checkbox.BackgroundColor3        = Color3.fromRGB(60, 60, 60)
   Checkbox.BackgroundTransparency  = 0
   Checkbox.BorderColor3            = Color3.fromRGB(27, 42, 53)
   Checkbox.BorderMode 			      = Enum.BorderMode.Outline
   Checkbox.BorderSizePixel 			= 0
   Checkbox.Draggable 			      = false
   Checkbox.Position 			      = UDim2.new(0, 0, 0, 4)
   Checkbox.Selectable              = false
   Checkbox.Size 			            = UDim2.new(0, 21, 1, -8)
   Checkbox.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   Checkbox.Style 			         = Enum.FrameStyle.Custom
   Checkbox.Visible                 = true
   Checkbox.ZIndex                  = 1
   Checkbox.Archivable              = true
   Checkbox.Parent = Control

   local Image = Instance.new("ImageLabel")
   Image.Name 			            = "check"
   Image.AnchorPoint	            = Vector2.new(0, 0)
   Image.BackgroundColor3        = Color3.fromRGB(255, 255, 255)
   Image.BackgroundTransparency  = 1
   Image.BorderColor3            = Color3.fromRGB(27, 42, 53)
   Image.BorderMode 			      = Enum.BorderMode.Outline
   Image.BorderSizePixel 			= 1
   Image.Position 			      = UDim2.new(0, 4, 0, 4)
   Image.Selectable              = false
   Image.Size 			            = UDim2.new(1, -8, 1, -8)
   Image.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   Image.Visible                 = false
   Image.ZIndex                  = 1
   Image.Archivable              = true
   Image.Image                   = 'rbxassetid://5786049629'
   Image.ImageColor3             = Color3.fromRGB(255, 255, 255)
   Image.ImageTransparency 	   = 0
   Image.ScaleType               = Enum.ScaleType.Stretch
   Image.SliceScale              = 1
   Image.Parent = Checkbox


   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections = {}


   table.insert(connections, Controller.MouseLeave:Connect(function()
      UILocked.Value = "UNLOCK"
   end))
   

   table.insert(connections, LabelValue.Changed:connect(function()
      LabelText.Text = LabelValue.Value
   end))

   -- variables
   local hover = false

   local changeColor = function ()
      if Value.Value then
         Checkbox.BackgroundColor3 = BG_COLOR_ON
      elseif hover then
         Checkbox.BackgroundColor3 = BG_COLOR_HOVER
      else
         Checkbox.BackgroundColor3 = BG_COLOR_OFF
      end
   end

   -- On change value (safe)
   table.insert(connections, Value.Changed:connect(function()
      Image.Visible = Value.Value
      changeColor()
   end))

   table.insert(connections, Control.MouseEnter:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      hover = true
      changeColor()
   end))

   table.insert(connections, Control.MouseMoved:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      hover = true
      changeColor()
   end))

   table.insert(connections, Control.MouseLeave:Connect(function()	
      hover = false
      changeColor()
   end))

   table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
      if UILocked.Value == "ACTIVE" and input.UserInputType == Enum.UserInputType.MouseButton1 then
         Value.Value = not Value.Value
      end
   end))

   -- reset when external lock (eg close folder)
   table.insert(connections, UILocked.Changed:connect(function()
      if UILocked.Value == "LOCKED" then		
         hover = false
         changeColor()
      end
   end))

   local OnRemove = function()
      for _, conn in ipairs(connections) do
         conn:Disconnect()
      end
      connections = {}
   end

   return Controller, OnRemove
end

-- Provides a checkbox input to alter the boolean property of an object.
local BooleanController = function(gui, object, property)
	
	local frame, OnRemove = CreateGUI()
	frame.Parent = gui.content
	
	local boolValue 	= frame:WaitForChild("Value")
	local labelValue 	= frame:WaitForChild("Label")
	
	-- The function to be called on change.
	local onChange	
	local listenConnection
	
	local controller = {
		frame = frame,
		label = frame:WaitForChild("LabelText"),
		height = frame.AbsoluteSize.Y
	}
	
	------------------------------------------------------------------
	-- Configure events
	------------------------------------------------------------------
	boolValue.Changed:connect(function()	
		if not controller._isReadonly then
			object[property] = boolValue.Value
		end
		
		if onChange ~= nil then
			onChange(object[property])
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
		if value == true or value == false then
			boolValue.Value = value
		end
		
		return controller;
	end
	
	function controller.getValue()
		return object[property]
	end
	
	-- Removes the controller from its parent GUI.
	function controller.remove()
		
      OnRemove()

		if listenConnection ~= nil then
			listenConnection:Disconnect()
		end
		
		gui.removeChild(controller)
		
		if controller.frame ~= nil then
			controller.frame.Parent = nil
			controller.frame = nil
		end		
		
		controller = nil
      
	end
	
	-- Sets controller to listen for changes on its underlying object.
	function controller.listen()
		if listenConnection ~= nil then
			return
		end
		
		if object['IsA'] ~= nil then
			-- roblox Interface
			listenConnection = object:GetPropertyChangedSignal(property):Connect(function(value)            
				controller.setValue(object[property])
			end)
			
		else
			-- tables (dirty checking before render)
			local oldValue = object[property]
			listenConnection = RunService.RenderStepped:Connect(function(step)
				if object[property] ~= oldValue then
					oldValue = object[property]
					controller.setValue(object[property])
				end
			end)
		end
		
		return controller
	end
	
	-- Sets the name of the controller.
	function controller.name(name)
		labelValue.Value = name
		return controller
	end
	
	------------------------------------------------------------------
	-- Set initial values
	------------------------------------------------------------------
	labelValue.Value = property	

   controller.setValue(object[property])
	
	return controller
end

return BooleanController
