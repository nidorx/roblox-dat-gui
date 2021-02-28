local Mouse 	         = game.Players.LocalPlayer:GetMouse()
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local Misc              = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Misc"))
local GUIUtils          = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("GUI"))
local Constants         = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Constants"))

local function CreateGUI()

   local UnlockOnMouseLeave = Instance.new('BoolValue')
   UnlockOnMouseLeave.Value = true

   local Controller, Control, OnLock, OnUnLock, OnMouseEnter, OnMouseMoved, OnMouseLeave, ControllerDisconnect 
      = GUIUtils.CreateControllerWrapper({
         Name                 = 'NumberController',
         Color                = Constants.NUMBER_COLOR,
         UnlockOnMouseLeave   = UnlockOnMouseLeave
      })

   local ValueIn = Instance.new('NumberValue')
   ValueIn.Name     = 'ValueIn'
   ValueIn.Parent   = Controller

   local Step = Instance.new('NumberValue')
   Step.Name    = 'Step'
   Step.Value   = 0.01
   Step.Parent  = Controller

   local Precision = Instance.new('IntValue')
   Precision.Name    = 'Precision'
   Precision.Value   = 2
   Precision.Parent  = Controller

   local RenderText = Misc.CreateTextNumberFn(Precision)

   local TextContainer = Instance.new("Frame")
   TextContainer.Name 			            = "text-container"
   TextContainer.AnchorPoint	            = Vector2.new(0, 0)
   TextContainer.BackgroundColor3         = Color3.fromRGB(48, 48, 48)
   TextContainer.BackgroundTransparency   = 1
   TextContainer.BorderColor3             = Color3.fromRGB(48, 48, 48)
   TextContainer.BorderMode 			      = Enum.BorderMode.Outline
   TextContainer.BorderSizePixel 			= 0
   TextContainer.Draggable 			      = false
   TextContainer.Position 			         = UDim2.new(0.66, 5, 0, 4)
   TextContainer.Selectable               = false
   TextContainer.Size 			            = UDim2.new(0.33, -6, 1, -8)
   TextContainer.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   TextContainer.Style 			            = Enum.FrameStyle.Custom
   TextContainer.Visible                  = true
   TextContainer.ZIndex                   = 1
   TextContainer.Archivable               = true
   TextContainer.Parent = Control

   local IsControllerActive = Instance.new('BoolValue')

   local TextValue, TextFrame, TextOnFocus, TextOnFocusLost, TextDisconnect =  GUIUtils.CreateInput({
      Color    = Constants.NUMBER_COLOR,
      Active   = IsControllerActive,
      Render   = RenderText,
      Parse    = function (text, value)
         if string.len(text) == 0 then
            -- no changes
            return '0'
         else
            local text = tonumber(text)
            if text == nil then
               -- invalid number
               return value.Value
            else
               -- valid number
               return RenderText(text)
            end
         end
      end,
   })
   TextFrame.Parent = TextContainer

   local SliderContainer = Instance.new("Frame")
   SliderContainer.BackgroundTransparency = 1
   SliderContainer.BorderMode 			   = Enum.BorderMode.Outline
   SliderContainer.BorderSizePixel 			= 0
   SliderContainer.Draggable 			      = false
   SliderContainer.Position 			      = UDim2.new(0, 0, 0, 4)
   SliderContainer.Selectable             = false
   SliderContainer.Size 			         = UDim2.new(0.66, 0, 1, -8)
   SliderContainer.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   SliderContainer.Style 			         = Enum.FrameStyle.Custom
   SliderContainer.Visible                = true
   SliderContainer.ZIndex                 = 1
   SliderContainer.Archivable             = true
   SliderContainer.Parent = Control

   local SliderFrame, SliderValue, Min, Max, Percent, SliderOnFocus, SliderOnFocusLost, SliderDisconnect = GUIUtils.CreateSlider({
      Active   = IsControllerActive
   });

   SliderFrame.Parent = SliderContainer

   IsControllerActive.Value   = false

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections = {}
   local textFocus   = false

   table.insert(connections, OnLock:Connect(function()
      UnlockOnMouseLeave.Value   = true
      IsControllerActive.Value   = false
   end))

   table.insert(connections, OnUnLock:Connect(function()
      IsControllerActive.Value = true
   end))

   table.insert(connections, TextOnFocus:Connect(function()
      UnlockOnMouseLeave.Value   = false
      textFocus = true
   end))
   
   table.insert(connections, TextOnFocusLost:Connect(function()
      UnlockOnMouseLeave.Value   = true
      textFocus = false
   end))
   
   table.insert(connections, SliderOnFocus:Connect(function()
      UnlockOnMouseLeave.Value   = false
   end))
   
   table.insert(connections, SliderOnFocusLost:Connect(function()
      UnlockOnMouseLeave.Value   = true
   end))

   -- On change steps
   table.insert(connections, Step.Changed:connect(function()
      Precision.Value = Misc.CountDecimals(Step.Value);
      if TextValue.Value ~= nil then
         TextValue.Value = '0'..TextValue.Value
      end
   end))

    -- On change value (safe)
   table.insert(connections, SliderValue.Changed:connect(function()
      TextValue.Value = tostring(SliderValue.Value)
   end))

   table.insert(connections, TextValue.Changed:connect(function()
      if textFocus then
         SliderValue.Value = tonumber(TextValue.Value)
      end
   end))

   -- On change value from outside
   table.insert(connections, ValueIn.Changed:connect(function()
      local value = math.max(math.min(ValueIn.Value, Max.Value), Min.Value)
      
      if value % Step.Value ~= 0 then
         value = math.round(value/Step.Value) * Step.Value
      end

      if ValueIn.Value ~= value then
         ValueIn.Value = value
      else
         -- change slider value
         SliderValue.Value = value
         spawn(function()
            TextValue.Value = tostring(SliderValue.Value)
         end)
      end      
   end))

   return Controller, SliderValue, ValueIn, Min, Max, Step, 
      Misc.DisconnectFn(connections, ControllerDisconnect, TextDisconnect, SliderDisconnect)
end

-- Number slider controller
local function NumberSliderController(gui, object, property, min, max, step)
	
	local frame, valueValue, valueInValue, minValue, maxValue, stepValue, DisconnectGUI = CreateGUI()
	frame.Parent = gui.content
	
	local labelValue 	   = frame:WaitForChild("Label")
	
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
			object[property] = valueValue.Value
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
		valueInValue.Value = value
		
		return controller;
	end
	
	function controller.getValue()
		return object[property]
	end
	
	function controller.min(min)
		minValue.Value = min
		return controller
	end
	
	function controller.max(max)
		maxValue.Value = max
		return controller
	end
	
	function controller.step(step)
		stepValue.Value = step
		return controller
	end
	
	-- Removes the controller from its parent GUI.
	function controller.remove()

      DisconnectGUI()
		
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
	valueInValue.Value = object[property]
	
	if min ~= nil then
		minValue.Value = min
	end
	
	if max ~= nil then
		maxValue.Value = max
	end
	
	if step ~= nil then
		stepValue.Value = step
	end
	
	return controller
end

return NumberSliderController
