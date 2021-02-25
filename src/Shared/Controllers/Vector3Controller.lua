local RunService = game:GetService("RunService")

local STEP  = 0.01
local MIN   = -9007199254740992
local MAX   = 9007199254740992

local COLOR_TEXT_ON 		   = Color3.fromRGB(255, 255, 255)
local COLOR_TEXT_OFF		   = Color3.fromRGB(47, 161, 214)
local COLOR_TEXT_BG_ON 		= Color3.fromRGB(73, 73, 73)
local COLOR_TEXT_BG_OFF 	= Color3.fromRGB(48, 48, 48)
local COLOR_TEXT_BG_HOVER	= Color3.fromRGB(60, 60, 60)

local function CreateGUI()
   local Controller = Instance.new("Frame")
   Controller.Name 			            = "Vector3Controller"
   Controller.AnchorPoint	            = Vector2.new(0, 0)
   Controller.BackgroundColor3         = Color3.fromRGB(26, 26, 26)
   Controller.BackgroundTransparency   = 0
   Controller.BorderColor3             = Color3.fromRGB(27, 42, 53)
   Controller.BorderMode 			      = Enum.BorderMode.Outline
   Controller.BorderSizePixel 			= 0
   Controller.Draggable 			      = false
   Controller.Position 			         = UDim2.new(0, 0, 0, 150)
   Controller.Selectable               = false
   Controller.Size 			            = UDim2.new(1, 0, 0, 50)
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

   local Value = Instance.new('Vector3Value')
   Value.Name     = 'Value'
   Value.Value    = Vector3.new(0, 0, 0)
   Value.Parent   = Controller

   local ValueIn = Instance.new('Vector3Value')
   ValueIn.Name     = 'ValueIn'
   ValueIn.Value    = Vector3.new(0, 0, 0)
   ValueIn.Parent   = Controller

   local Min = Instance.new('Vector3Value')
   Min.Name    = 'Min'
   Min.Value   = Vector3.new(MIN, MIN, MIN)
   Min.Parent  = Controller

   local Max = Instance.new('Vector3Value')
   Max.Name    = 'Max'
   Max.Value   = Vector3.new(MAX, MAX, MAX)
   Max.Parent  = Controller

   local Step = Instance.new('Vector3Value')
   Step.Name    = 'Step'
   Step.Value   = Vector3.new(STEP, STEP, STEP)
   Step.Parent  = Controller

   local Precision = Instance.new('Vector3Value')
   Precision.Name    = 'Precision'
   Precision.Value   =  Vector3.new(2, 2, 2)
   Precision.Parent  = Controller

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
   borderLeft.BackgroundColor3         = Color3.fromRGB(47, 161, 214)
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
   Control.Size 			            = UDim2.new(0.6, -2, 1, -1)
   Control.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   Control.Style 			            = Enum.FrameStyle.Custom
   Control.Visible                  = true
   Control.ZIndex                   = 1
   Control.Archivable               = true
   Control.Parent = Controller

   -- create X, Y, Z
   local function CreateTextFrame(name, position, connections)
      local TextContainer = Instance.new("Frame")
      TextContainer.Name 			            = name
      TextContainer.AnchorPoint	            = Vector2.new(0, 0)
      TextContainer.BackgroundColor3         = Color3.fromRGB(48, 48, 48)
      TextContainer.BackgroundTransparency   = 1
      TextContainer.BorderColor3             = Color3.fromRGB(48, 48, 48)
      TextContainer.BorderMode 			      = Enum.BorderMode.Outline
      TextContainer.BorderSizePixel 			= 0
      TextContainer.Draggable 			      = false
      TextContainer.Position 			         = position
      TextContainer.Selectable               = false
      TextContainer.Size 			            = UDim2.new(0.333, -4, 1, -28)
      TextContainer.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
      TextContainer.Style 			            = Enum.FrameStyle.Custom
      TextContainer.Visible                  = true
      TextContainer.ZIndex                   = 1
      TextContainer.Archivable               = true
      TextContainer.Parent = Control

      local Label = Instance.new('TextLabel')
      Label.Name 			            = "label"
      Label.AnchorPoint	            = Vector2.new(0, 0)
      Label.AutomaticSize	         = Enum.AutomaticSize.None
      Label.BackgroundColor3        = Color3.fromRGB(255, 255, 255)
      Label.BackgroundTransparency  = 1
      Label.BorderColor3            = Color3.fromRGB(27, 42, 53)
      Label.BorderMode 			      =  Enum.BorderMode.Outline
      Label.BorderSizePixel 			= 0
      Label.Position 			      = UDim2.new(0, 0, 1, 0)
      Label.Selectable              = false
      Label.Size 			            = UDim2.new(1, 0, 1, 0)
      Label.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
      Label.Visible                 = true
      Label.ZIndex                  = 1
      Label.Archivable              = true
      Label.Font                    = Enum.Font.SourceSans
      Label.LineHeight              = 1
      Label.RichText                = false
      Label.Text                    = name:lower()
      Label.TextColor3 			      = Color3.fromRGB(117, 117, 117)
      Label.TextScaled              = false
      Label.TextSize                = 14
      Label.TextStrokeColor3 		   = Color3.fromRGB(0, 0, 0)
      Label.TextStrokeTransparency  = 1
      Label.TextTransparency        = 0
      Label.TextTruncate            = Enum.TextTruncate.AtEnd
      Label.TextWrapped             = false
      Label.TextXAlignment          = Enum.TextXAlignment.Center
      Label.TextYAlignment          = Enum.TextYAlignment.Center
      Label.Parent = TextContainer

      local TextFrame = Instance.new("Frame")
      TextFrame.Name 			         = "text"
      TextFrame.AnchorPoint	         = Vector2.new(0, 0)
      TextFrame.BackgroundColor3       = Color3.fromRGB(48, 48, 48)
      TextFrame.BackgroundTransparency = 0
      TextFrame.BorderColor3           = Color3.fromRGB(27, 42, 53)
      TextFrame.BorderMode 			   = Enum.BorderMode.Outline
      TextFrame.BorderSizePixel 			= 0
      TextFrame.Draggable 			      = false
      TextFrame.Position 			      = UDim2.new(0, 0, 0, 0)
      TextFrame.Selectable             = false
      TextFrame.Size 			         = UDim2.new(1, 0, 1, 0)
      TextFrame.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
      TextFrame.Style 			         = Enum.FrameStyle.Custom
      TextFrame.Visible                = true
      TextFrame.ZIndex                 = 1
      TextFrame.Archivable             = true
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
      Text.RichText                 = false
      Text.Text                     = 'text'
      Text.TextColor3 			      = Color3.fromRGB(47, 161, 214)
      Text.TextScaled               = false
      Text.TextSize                 = 14
      Text.TextStrokeColor3 		   = Color3.fromRGB(0, 0, 0)
      Text.TextStrokeTransparency   = 1
      Text.TextTransparency         = 0
      Text.TextTruncate             = Enum.TextTruncate.None
      Text.TextWrapped              = false
      Text.TextXAlignment           = Enum.TextXAlignment.Left
      Text.TextYAlignment           = Enum.TextYAlignment.Center
      Text.Parent = TextFrame

      -- SCRIPTS -------------------------------------------------------------------------------------------------------

      local textFocused = false

      table.insert(connections, Text.MouseEnter:Connect(function()
         if UILocked.Value ~= "ACTIVE" then
            return
         end
         
         if textFocused == false then
            TextFrame.BackgroundColor3 = COLOR_TEXT_BG_HOVER
         end
      end))

      table.insert(connections, Text.MouseMoved:Connect(function()
         if UILocked.Value ~= "ACTIVE" then
            return
         end
         
         if textFocused == false then
            TextFrame.BackgroundColor3 = COLOR_TEXT_BG_HOVER
         end
      end))

      table.insert(connections, Text.MouseLeave:Connect(function()
         if textFocused == false then
            TextFrame.BackgroundColor3 = COLOR_TEXT_BG_OFF
         end
      end))

      table.insert(connections, Text.Focused:Connect(function(enterPressed, inputObject)
         if UILocked.Value ~= "ACTIVE" then
            return
         end
         
         textFocused = true
         Text.TextColor3 = COLOR_TEXT_ON
         TextFrame.BackgroundColor3 = COLOR_TEXT_BG_ON	
      end))

      table.insert(connections, Text.FocusLost:Connect(function(enterPressed, inputObject)
         textFocused = false
         Text.TextColor3 = COLOR_TEXT_OFF
         TextFrame.BackgroundColor3 = COLOR_TEXT_BG_OFF
      end))

      -- reset when external lock (eg close folder)
      table.insert(connections, UILocked.Changed:connect(function()
         if UILocked.Value == "LOCKED" then
            textFocused = false
            Text.TextColor3 = COLOR_TEXT_OFF
            TextFrame.BackgroundColor3 = COLOR_TEXT_BG_OFF
         end
      end))

      return Text
   end

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections       = {}
   local KEYS              = { "X", "Y", "Z" }
   local controllerHover	= false
   local textFocused 		= { X=false, Y=false, Z=false }

   -- Elements
   local Text  = {
      X = CreateTextFrame('X', UDim2.new(0, 0, 0, 4), connections),
      Y = CreateTextFrame('Y', UDim2.new(0.333, 2, 0, 4), connections),
      Z = CreateTextFrame('Z', UDim2.new(0.666, 4, 0, 4), connections),
   }
   
   local function checkUnlock()	
      if controllerHover then
         return
      end
      
      for i, v in pairs(KEYS) do
         if textFocused[v] then
            return
         end
      end
      
      spawn(function()
         UILocked.Value = "UNLOCK"
      end)
   end
   
   local function numDecimals(x) 
      local _x = tostring(x)
      local idexOf, _ = string.find(_x, ".", 1, true)
      if idexOf ~= nil then
         return string.len(_x) - (idexOf -1) - 1;
      end
      
      return 0;
   end
   
   local function map(x, inMin, inMax, outMin, outMax)
      return (x - inMin)*(outMax - outMin)/(inMax - inMin) + outMin
   end
   
   local function renderText()
      local precision = Precision.Value
      for i, v in pairs(KEYS) do
         Text[v].Text = string.format("%."..precision[v].."f", Value.Value[v])
      end
   end

   table.insert(connections, LabelValue.Changed:connect(function()
      LabelText.Text = LabelValue.Value
   end))

   
   table.insert(connections, Controller.MouseEnter:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      controllerHover = true
   end))
   
   table.insert(connections, Controller.MouseMoved:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      controllerHover = true
   end))
   
   table.insert(connections, Controller.MouseLeave:Connect(function()
      controllerHover = false
      checkUnlock()
   end))
   
   for i, key in pairs(KEYS) do
      table.insert(connections, Text[key].Focused:Connect(function()
         if UILocked.Value ~= "ACTIVE" then
            return
         end
         
         textFocused[key] = true
      end))
      
      -- On change text by user
      table.insert(connections, Text[key].FocusLost:Connect(function(enterPressed, inputObject)
         if UILocked.Value ~= "ACTIVE" then
            Text[key].Text = Value.Value[key]
         end
         
         if string.len(Text[key].Text) == 0 then
            -- no changes
            renderText()
         else
            local value = tonumber(Text[key].Text)
            if value == nil then
               -- invalid number
               renderText()
            else
               -- valid number
               local x = Value.Value.X
               local y = Value.Value.Y
               local z = Value.Value.Z
               
               if key == 'X' then
                  x = value
               elseif key == 'Y' then
                  y = value
               else
                  z = value
               end
               
               ValueIn.Value = Vector3.new(x, y, z)
            end
         end
         
         textFocused[key] = false		
         checkUnlock()
      end))
   end
   
   -- On change steps
   table.insert(connections, Step.Changed:connect(function()	
      Precision.Value = Vector3.new(numDecimals(Step.Value.X), numDecimals(Step.Value.Y), numDecimals(Step.Value.Z))
      renderText()
   end))
   
   -- On change value (safe)
   table.insert(connections, Value.Changed:connect(function()
      renderText()
   end))
   
   -- On change value from outside
   table.insert(connections, ValueIn.Changed:connect(function()	
      local x = ValueIn.Value.X
      local y = ValueIn.Value.Y
      local z = ValueIn.Value.Z
      
      for i, key in pairs(KEYS) do
         local value = math.max(math.min(ValueIn.Value[key], Max.Value[key]), Min.Value[key])
         
         if value % Step.Value[key] ~= 0 then
            value = math.round(value/Step.Value[key]) * Step.Value[key]
         end
         
         if key == 'X' then
            x = value
         elseif key == 'Y' then
            y = value
         else
            z = value
         end
      end
      
      
      Value.Value = Vector3.new(x, y, z)
   end))
   
   table.insert(connections, UILocked.Changed:connect(function()
      if UILocked.Value ~= "ACTIVE" then
         -- reset when external lock (eg close folder)
         controllerHover		= false
         textFocused 		= {X=false, Y=false, Z=false}
         for i, key in pairs(KEYS) do
            Text[key].Active 	= false
            Text[key].Selectable = false
            Text[key].TextEditable = false
         end
      else
         for i, key in pairs(KEYS) do
            Text[key].Active 	= true
            Text[key].Selectable = true
            Text[key].TextEditable = true
         end
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

-- Vector3 controller
local function Vector3Controller(gui, object, property, min, max, step)
	
	local frame, OnRemove = CreateGUI()
	frame.Parent = gui.content
	
	local labelValue 	   = frame:WaitForChild("Label")	
	local minValue 		= frame:WaitForChild("Min")
	local maxValue 		= frame:WaitForChild("Max")
	local stepValue 	   = frame:WaitForChild("Step")
	local valueValue 	   = frame:WaitForChild("Value")    -- Safe value
	local valueInValue   = frame:WaitForChild("ValueIn")	-- Input value, unsafe
	
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
	valueValue.Changed:connect(function()	
		if not controller._isReadonly then
			object[property] = valueValue.Value;
		end
		
		if onChange ~= nil then
			onChange(object[property]);
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
		if typeof(value) == "number" then
			value = Vector3.new(value, value, value)
		end
		valueInValue.Value = value
		
		return controller;
	end
	
	function controller.getValue()
		return object[property]
	end
	
	function controller.min(min)
		if typeof(min) == "number" then
			min = Vector3.new(min, min, min)
		end
		minValue.Value = min
		return controller
	end
	
	function controller.max(max)
		if typeof(max) == "number" then
			max = Vector3.new(max, max, max)
		end
		maxValue.Value = max
		return controller
	end
	
	function controller.step(step)
		if typeof(step) == "number" then
			step = Vector3.new(step, step, step)
		end
		stepValue.Value = step
		return controller
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
		
		-- tables (dirty checking before render, Instance.Changed or Instance.GetPropertyChangedSignal dont work for position, CFrame, etc)
		local oldValueX = object[property].X
		local oldValueY = object[property].Y
		local oldValueZ = object[property].Z
		listenConnection = RunService.RenderStepped:Connect(function(step)
			local value = object[property]
			if value.X ~= oldValueX or value.Y ~= oldValueY or value.Z ~= oldValueZ then
				oldValueX = value.X
				oldValueY = value.Y
				oldValueZ = value.Z
				controller.setValue(object[property])
			end
		end)
		
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
	
	if min ~= nil then
		if typeof(min) == "number" then
			min = Vector3.new(min, min, min)
		end
		minValue.Value = min
	end
	
	if max ~= nil then
		if typeof(max) == "number" then
			max = Vector3.new(max, max, max)
		end
		maxValue.Value = max
	end
	
	if step ~= nil then
		if typeof(step) == "number" then
			step = Vector3.new(step, step, step)
		end
		stepValue.Value = step
	end
	
	valueInValue.Value = object[property]
	
	return controller
end

return Vector3Controller
