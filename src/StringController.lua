local RunService = game:GetService("RunService")

local function CreateGUI()
   local Controller = Instance.new("Frame")
   Controller.Name 			            = "StringController"
   Controller.AnchorPoint	            = Vector2.new(0, 0)
   Controller.BackgroundColor3         = Color3.fromRGB(26, 26, 26)
   Controller.BackgroundTransparency   = 0
   Controller.BorderColor3             = Color3.fromRGB(27, 42, 53)
   Controller.BorderMode 			      = Enum.BorderMode.Outline
   Controller.BorderSizePixel 			= 0
   Controller.Draggable 			      = false
   Controller.Position 			         = UDim2.new(0, 0, 0, 120)
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

   local Value = Instance.new('StringValue')
   Value.Name     = 'Value'
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
   LabelText.Text                   = 'String Label'
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
   borderLeft.BackgroundColor3         = Color3.fromRGB(30, 211, 111)
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

   local TextContainer = Instance.new("Frame")
   TextContainer.Name 			            = "text-container"
   TextContainer.AnchorPoint	            = Vector2.new(0, 0)
   TextContainer.BackgroundColor3         = Color3.fromRGB(48, 48, 48)
   TextContainer.BackgroundTransparency   = 1
   TextContainer.BorderColor3             = Color3.fromRGB(48, 48, 48)
   TextContainer.BorderMode 			      = Enum.BorderMode.Outline
   TextContainer.BorderSizePixel 			= 0
   TextContainer.Draggable 			      = false
   TextContainer.Position 			         = UDim2.new(0, 0, 0, 4)
   TextContainer.Selectable               = false
   TextContainer.Size 			            = UDim2.new(1, -2, 1, -8)
   TextContainer.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   TextContainer.Style 			            = Enum.FrameStyle.Custom
   TextContainer.Visible                  = true
   TextContainer.ZIndex                   = 1
   TextContainer.Archivable               = true
   TextContainer.Parent = Control

   local TextFrame = Instance.new("Frame")
   TextFrame.Name 			            = "text"
   TextFrame.AnchorPoint	            = Vector2.new(0, 0)
   TextFrame.BackgroundColor3         = Color3.fromRGB(48, 48, 48)
   TextFrame.BackgroundTransparency   = 0
   TextFrame.BorderColor3             = Color3.fromRGB(27, 42, 53)
   TextFrame.BorderMode 			      = Enum.BorderMode.Outline
   TextFrame.BorderSizePixel 			= 0
   TextFrame.Draggable 			      = false
   TextFrame.Position 			         = UDim2.new(0, 0, 0, 0)
   TextFrame.Selectable               = false
   TextFrame.Size 			            = UDim2.new(1, 0, 1, 0)
   TextFrame.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   TextFrame.Style 			            = Enum.FrameStyle.Custom
   TextFrame.Visible                  = true
   TextFrame.ZIndex                   = 1
   TextFrame.Archivable               = true
   TextFrame.Parent = TextContainer

   local Text = Instance.new("TextBox")
   Text.Name 			            = "text"
   Text.AnchorPoint	            = Vector2.new(0, 0)
   Text.BackgroundColor3         = Color3.fromRGB(48, 48, 48)
   Text.BackgroundTransparency   = 1
   Text.BorderColor3             = Color3.fromRGB(27, 42, 53)
   Text.BorderMode 			      = Enum.BorderMode.Outline
   Text.BorderSizePixel 			= 0
   Text.ClearTextOnFocus 			= false
   Text.CursorPosition 			   = 1
   Text.MultiLine 			      = false
   Text.Position 			         = UDim2.new(0, 2, 0, 0)
   Text.Selectable               = true
   Text.SelectionStart           = -1
   Text.ShowNativeInput          = true
   Text.Size 			            = UDim2.new(1, -4, 1, 0)
   Text.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   Text.TextEditable 			   = true
   Text.Visible                  = true
   Text.ZIndex                   = 1
   Text.Archivable               = true
   Text.Font                     = Enum.Font.SourceSans
   Text.LineHeight               = 1
   Text.PlaceholderColor3        = Color3.fromRGB(47, 161, 214)
   Text.RichText                 = false
   Text.Text                     = 'text'
   Text.TextColor3 			      = Color3.new(30, 211, 111)
   Text.TextScaled               = false
   Text.TextSize                 = 14
   Text.TextStrokeColor3 		   = Color3.new(0, 0, 0)
   Text.TextStrokeTransparency   = 1
   Text.TextTransparency         = 0
   Text.TextTruncate             = Enum.TextTruncate.None
   Text.TextWrapped              = false
   Text.TextXAlignment           = Enum.TextXAlignment.Left
   Text.TextYAlignment           = Enum.TextYAlignment.Center
   Text.Parent = TextFrame

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections       = {}
   local controllerHover	= false
   local textFocused 		= false

   table.insert(connections, LabelValue.Changed:connect(function()
      LabelText.Text = LabelValue.Value
   end))
   
   local function checkUnlock()	
      if controllerHover or textFocused then
         return
      end
      
      spawn(function()
         UILocked.Value = "UNLOCK"
      end)
   end
   
   table.insert(connections,Controller.MouseEnter:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      controllerHover = true
   end))
   
   table.insert(connections,Controller.MouseMoved:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      controllerHover = true
   end))
   
   table.insert(connections,Controller.MouseLeave:Connect(function()
      controllerHover = false
      checkUnlock()
   end))
   
   table.insert(connections,Text.Focused:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      textFocused = true
   end))
   
   -- On change text by user
   table.insert(connections,Text.FocusLost:Connect(function(enterPressed, inputObject)
      if UILocked.Value ~= "ACTIVE" then
         Text.Text = Value.Value
      else
         Value.Value = Text.Text
      end	
      
      textFocused = false
      
      checkUnlock()
   end))
   
   table.insert(connections,UILocked.Changed:connect(function()
      if UILocked.Value ~= "ACTIVE" then
         -- reset when external lock (eg close folder)		
         controllerHover	= false
         textFocused		= false
         Text.Active = false
         Text.Selectable = false
         Text.TextEditable = false
      else
         Text.Active = true
         Text.Selectable = true
         Text.TextEditable = true
      end
   end))
   
   -- On change value (safe)
   table.insert(connections,Value.Changed:connect(function()
      Text.Text = Value.Value
   end))
   
   local OnRemove = function()
      for _, conn in ipairs(connections) do
         conn:Disconnect()
      end
      connections = {}
   end

   return Controller, OnRemove
end

-- Provides a text input to alter the string property of an object.
local function StringController(gui, object, property)
	
	local frame, OnRemove = CreateGUI()
	frame.Parent = gui.content
	
	local stringValue 	= frame:WaitForChild("Value")
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
	stringValue.Changed:connect(function()		
		if not controller._isReadonly then
			object[property] = stringValue.Value
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
		stringValue.Value = value
		
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
	stringValue.Value = object[property]
	
	return controller
end

return StringController
