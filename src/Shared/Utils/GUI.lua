local UserInputService  = game:GetService("UserInputService")
local Misc              = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Misc"))
local Constants         = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Constants"))

local GUIUtils = {}

local function foo()
   
end

--[[
   Instantiating a generic frame
]]
function GUIUtils.CreateFrame(params)
   local frame = Instance.new("Frame")
   frame.AnchorPoint	            = Vector2.new(0, 0)
   frame.Position 			      = UDim2.new(0, 0, 0, 0)
   frame.Size 			            = UDim2.new(1, 0, 1, 0)
   frame.BackgroundColor3        = Constants.BACKGROUND_COLOR
   frame.BackgroundTransparency  = 0
   frame.BorderMode 			      = Enum.BorderMode.Outline
   frame.BorderSizePixel 			= 0
   frame.Draggable 			      = false
   frame.Selectable              = false
   frame.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   frame.Style 			         = Enum.FrameStyle.Custom
   frame.ZIndex                  = 1
   frame.Visible                 = true
   frame.Archivable              = true

   if params ~= nil then
      for key, value in pairs(params) do
         frame[key] = value
      end
   end

   return frame
end

--[[
   Creates the generic controller wrapper

   Params
      config = {
         Name                 = String,
         Height               = Number,
         Color                = Color3,
         UnlockOnMouseLeave   = BoolValue
      }
   Returns 
      Controller     = Frame
      Control        = Frame
      OnLock         = BindableEvent Fired when controller is locked
      OnUnLock       = BindableEvent Fired when controller is released
      OnMouseEnter   = BindableEvent 
      OnMouseMoved   = BindableEvent
      OnMouseLeave   = BindableEvent
      Disconnect     = Function Need to be called to Disconnect all events
]]
function GUIUtils.CreateControllerWrapper(config)

   if config.Height == nil then
      config.Height = 30
   end

   if config.Color == nil then
      config.Color = Color3.fromRGB(27, 42, 53)
   end

   if config.UnlockOnMouseLeave == nil then
      config.UnlockOnMouseLeave = Instance.new('BoolValue')
      config.UnlockOnMouseLeave.Value = true
   end

   local Controller = GUIUtils.CreateFrame()   
   Controller.Name 			            = config.Name
   Controller.Size 			            = UDim2.new(1, 0, 0, config.Height)

   local LabelValue = Instance.new('StringValue')
   LabelValue.Name = 'Label'
   LabelValue.Parent = Controller

   local UILocked = Instance.new('StringValue')
   UILocked.Name = 'UILocked'
   UILocked.Parent = Controller

   local LabelText = Instance.new('TextLabel')
   LabelText.Name 			         = "LabelText"
   LabelText.AnchorPoint	         = Vector2.new(0, 0)
   LabelText.AutomaticSize	         = Enum.AutomaticSize.None
   LabelText.BackgroundTransparency = 1
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
   LabelText.Text                   = 'Label'
   LabelText.TextColor3 			   = Constants.LABEL_COLOR
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

   local borderBottom = GUIUtils.CreateFrame()
   borderBottom.Name 			         = "BorderBottom"
   borderBottom.BackgroundColor3       = Constants.BORDER_COLOR
   borderBottom.Position 			      = UDim2.new(0, 0, 1, -1)
   borderBottom.Size 			         = UDim2.new(1, 0, 0, 1)
   borderBottom.Parent = Controller

   local borderLeft = GUIUtils.CreateFrame()
   borderLeft.Name 			            = "BorderLeft"
   borderLeft.BackgroundColor3         = config.Color
   borderLeft.Size 			            = UDim2.new(0, 3, 1, 0)
   borderLeft.ZIndex                   = 2
   borderLeft.Parent = Controller

   local Control = GUIUtils.CreateFrame()
   Control.Name 			            = "Control"
   Control.BackgroundTransparency   = 1
   Control.Position 			         = UDim2.new(0.4, 0, 0, 0)
   Control.Size 			            = UDim2.new(0.6, 0, 1, -1)
   Control.Parent = Controller

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections    = {}
   local hover          = false
   local OnLock         = Instance.new('BindableEvent')
   local OnUnLock       = Instance.new('BindableEvent')
   local OnMouseEnter   = Instance.new('BindableEvent')
   local OnMouseMoved   = Instance.new('BindableEvent')
   local OnMouseLeave   = Instance.new('BindableEvent')

   table.insert(connections, LabelValue.Changed:Connect(function()
      LabelText.Text = LabelValue.Value
   end))

   table.insert(connections, Controller.MouseEnter:Connect(function()
      if UILocked.Value ~= 'ACTIVE' then
         return
      end

      hover = true
      
      OnMouseEnter:Fire()
   end))

   table.insert(connections, Controller.MouseMoved:Connect(function()
      if UILocked.Value ~= 'ACTIVE' then
         return
      end

      hover = true
      
      OnMouseMoved:Fire()
   end))

   table.insert(connections, config.UnlockOnMouseLeave.Changed:connect(function()
      if not hover and config.UnlockOnMouseLeave.Value then
         UILocked.Value = 'UNLOCK'
      end
   end))

   table.insert(connections, Controller.MouseLeave:Connect(function()	

      if config.UnlockOnMouseLeave.Value then
         UILocked.Value = 'UNLOCK'         
      end

      hover = false
      
      OnMouseLeave:Fire()
   end))

   -- reset when external lock (eg close folder)
   table.insert(connections, UILocked.Changed:Connect(function()
      if UILocked.Value == 'LOCKED' then	
         -- @TODO: está sendo invocado duas vezes, resolver, pode ser no dat.GUI.lua
         hover = false
         OnLock:Fire()
      else 
         OnUnLock:Fire()
      end
   end))

   return Controller, Control, 
            OnLock.Event, OnUnLock.Event, OnMouseEnter.Event, OnMouseMoved.Event, OnMouseLeave.Event, 
            Misc.DisconnectFn(connections)
end

local ActiveDummy =  Instance.new('BoolValue')
ActiveDummy.Value = true

local RenderDummy = function(text)
   return text
end

local ParseDummy = RenderDummy

--[[
   Generic input creation

   Params
      config = {
         Color       = Color3,
         Active      = BoolValue
         MultiLine   = Boolean
         Render      = Function(String) : String
         Parse       = Function(String, EnterPressed, InputObject) : Any
         ChangeColors = Boolean
      }
   Returns 
      Value          = StringValue
      TextFrame      = Frame
      OnFocused      = BindableEvent 
      OnFocusLost    = BindableEvent
      Disconnect     = Function Need to be called to Disconnect all events
]]
function GUIUtils.CreateInput(config)

   if config.Color == nil then
      config.Color = Constants.NUMBER_COLOR
   end

   if config.Active == nil then
      config.Active = ActiveDummy
   end

   if config.MultiLine == nil then
      config.MultiLine = false
   end

   if config.Render == nil then
      config.Render = RenderDummy
   end

   if config.Parse == nil then
      config.Parse = ParseDummy
   end

   if config.ChangeColors == nil then
      config.ChangeColors = true
   end

   local Value = Instance.new('StringValue')
   Value.Name     = 'Value'

   local TextFrame = GUIUtils.CreateFrame()
   TextFrame.Name 			         = 'TextFrame'
   TextFrame.BackgroundColor3       = Constants.INPUT_COLOR
   TextFrame.Size 			         = UDim2.new(1, 0, 1, 0)

   local Text = Instance.new("TextBox")
   Text.Name 			            = 'TextBox'
   Text.Text                     = ''
   Text.AnchorPoint	            = Vector2.new(0, 0)
   Text.BackgroundTransparency   = 1
   Text.BorderMode 			      = Enum.BorderMode.Outline
   Text.BorderSizePixel 			= 0
   Text.ClearTextOnFocus 			= false
   Text.CursorPosition 			   = 1
   Text.MultiLine 			      = config.MultiLine
   Text.Position 			         = UDim2.new(0, 2, 0, 0)
   Text.Selectable               = true
   Text.SelectionStart           = -1
   Text.ShowNativeInput          = true
   Text.Size 			            = UDim2.new(1, -4, 1, 0)
   Text.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   Text.TextEditable 			   = false
   Text.Visible                  = true
   Text.Active                   = false
   Text.ZIndex                   = 1
   Text.Archivable               = true
   Text.Font                     = Enum.Font.SourceSans
   Text.LineHeight               = 1
   Text.RichText                 = false
   Text.TextColor3 			      = config.Color
   Text.TextScaled               = false
   Text.TextSize                 = 14
   Text.TextStrokeTransparency   = 1
   Text.TextTransparency         = 0
   Text.TextTruncate             = Enum.TextTruncate.None
   Text.TextWrapped              = false
   Text.TextXAlignment           = Enum.TextXAlignment.Left
   Text.TextYAlignment           = Enum.TextYAlignment.Center
   Text.Parent = TextFrame

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections    = {}
   local focused        = false
   local OnFocused      = Instance.new('BindableEvent')
   local OnFocusLost    = Instance.new('BindableEvent')

   table.insert(connections, config.Active.Changed:Connect(function()
      if config.Active.Value then
         Text.Active       = true
         Text.Selectable   = true
         Text.TextEditable = true
      else
         Text.Active       = false
         Text.Selectable   = false
         Text.TextEditable = false

         if focused then
            Text:ReleaseFocus()
         end
      end
   end))

   table.insert(connections, Value.Changed:Connect(function()
      Text.Text = config.Render(Value.Value)
   end))

   table.insert(connections, Text.Focused:Connect(function()
      if not config.Active.Value then
         spawn(function()
            if not config.Active.Value then
               Text:ReleaseFocus()
            end
         end)
         return
      end

      focused = true

      if config.ChangeColors then
         Text.TextColor3            = Constants.INPUT_COLOR_FOCUS_TXT
         TextFrame.BackgroundColor3 = Constants.INPUT_COLOR_FOCUS	
      end

      OnFocused:Fire()
   end))
   
   table.insert(connections, Text.FocusLost:Connect(function(enterPressed, inputObject)
      focused        = false
      
      if config.ChangeColors then
         Text.TextColor3            = config.Color
         TextFrame.BackgroundColor3 = Constants.INPUT_COLOR
      end
      
      Value.Value = config.Parse(Text.Text, Value)
      Text.Text = config.Render(Value.Value)

      OnFocusLost:Fire()
   end))

   table.insert(connections, Text.MouseEnter:Connect(function()
      if not config.Active.Value then
         return
      end
      
      if not focused then
         if config.ChangeColors then
            TextFrame.BackgroundColor3 = Constants.INPUT_COLOR_HOVER
         end
      end
   end))
   
   table.insert(connections, Text.MouseMoved:Connect(function()
      if not config.Active.Value then
         return
      end
      
      if not focused then
         if config.ChangeColors then 
            TextFrame.BackgroundColor3 = Constants.INPUT_COLOR_HOVER
         end
      end
   end))
   
   table.insert(connections, Text.MouseLeave:Connect(function()
      if not focused then
         if config.ChangeColors then 
            TextFrame.BackgroundColor3 = Constants.INPUT_COLOR
         end
      end
   end))
   
   return Value, TextFrame, OnFocused.Event, OnFocusLost.Event, Misc.DisconnectFn(connections)
end

--[[
   Creates a generic slider

   Params
      config = {
         Active   = BoolValue,
         Value    = Number,
         Min      = Number,
         Max      = Number
      }

   Returns 
      SliderFrame    = Frame
      Value          = NumberValue
      Min            = NumberValue
      Max            = NumberValue
      Percent        = NumberValue
      OnFocused      = BindableEvent 
      OnFocusLost    = BindableEvent
      Disconnect     = Function Need to be called to Disconnect all events
]]
function GUIUtils.CreateSlider(config)

   if config.Active == nil then
      config.Active = ActiveDummy
   end

   if config.Min == nil then
      config.Min = Misc.NUMBER_MIN
   end

   if config.Max == nil then
      config.Max = Misc.NUMBER_MAX
   end

   local Value = Instance.new('NumberValue')
   Value.Name  = 'Value'

   local Min = Instance.new('NumberValue')
   Min.Name    = 'Min'
   
   local Max = Instance.new('NumberValue')
   Max.Name    = 'Max'
   
   local Percent = Instance.new('NumberValue')
   Percent.Name    = 'Percent'
   Percent.Value   = 0

   local Slider = GUIUtils.CreateFrame()
   Slider.Name 			         = 'Slider'
   Slider.BackgroundColor3       = Color3.fromRGB(60, 60, 60)
   Slider.BackgroundTransparency = 0
   Slider.BorderMode 			   = Enum.BorderMode.Outline

   local SliderFG = GUIUtils.CreateFrame()
   SliderFG.Name 			            = 'SliderFG'
   SliderFG.BackgroundColor3        = Constants.NUMBER_COLOR
   SliderFG.BackgroundTransparency  = 0
   SliderFG.Size 			            = UDim2.new(0, 0, 1, 0)
   SliderFG.Parent = Slider

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections    = {}
   local sliderHover 		= false
   local sliderMouseDown	= false
   local absPosX, absPosY, absSizeX, absSizeY, posX, posY
   -- mutually exclusive change
   local ignorePercent = false
   local ignoreValueIn = false

   local OnFocused      = Instance.new('BindableEvent')
   local OnFocusLost    = Instance.new('BindableEvent')

   table.insert(connections, Slider.MouseEnter:Connect(function()
      if not config.Active.Value then
         return
      end
      
      sliderHover = true
      Slider.BackgroundColor3    = Constants.INPUT_COLOR_HOVER
      SliderFG.BackgroundColor3 = Constants.NUMBER_COLOR_HOVER
   end))

   table.insert(connections, Slider.MouseMoved:Connect(function()
      if not config.Active.Value then
         return
      end
      
      sliderHover = true
      Slider.BackgroundColor3    = Constants.INPUT_COLOR_HOVER
      SliderFG.BackgroundColor3  = Constants.NUMBER_COLOR_HOVER
   end))

   table.insert(connections, Slider.MouseLeave:Connect(function()
      sliderHover = false
      Slider.BackgroundColor3    = Constants.INPUT_COLOR
      SliderFG.BackgroundColor3  = Constants.NUMBER_COLOR
   end))

   table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
      if not config.Active.Value then
         return
      end
      
      if sliderHover and input.UserInputType == Enum.UserInputType.MouseButton1 then
         sliderMouseDown = true
         OnFocused:Fire()
      end
   end))

   table.insert(connections, UserInputService.InputEnded:Connect(function(input, gameProcessed)	
      if not config.Active.Value then
         return
      end
      
      if sliderMouseDown and input.UserInputType == Enum.UserInputType.MouseButton1 then
         sliderMouseDown = false
         OnFocusLost:Fire()
      end
   end))

   table.insert(connections, UserInputService.InputChanged:Connect(function(input, gameProcessed)
      if not config.Active.Value then
         return
      end
      
      if sliderMouseDown and input.UserInputType == Enum.UserInputType.MouseMovement then
         absPosX  = Slider.AbsolutePosition.X
         absPosY  = Slider.AbsolutePosition.Y
         absSizeX = Slider.AbsoluteSize.X
         absSizeY = Slider.AbsoluteSize.Y

         posX = input.Position.X
         posY = input.Position.Y
         
         if posX < absPosX then			
            Percent.Value = 0
            
         elseif posX > (absPosX + absSizeX) then			
            Percent.Value = 1
            
         else
            Percent.Value = (posX - absPosX)/absSizeX		
         end
      end
   end))
  
   table.insert(connections, Percent.Changed:Connect(function()
      SliderFG.Size = UDim2.new(Percent.Value, 0, 1, 0)

      spawn(function()
         Value.Value = Misc.MapRange(Percent.Value, 0, 1, Min.Value, Max.Value)
      end)
   end))

   -- On change value from outside
   table.insert(connections, Value.Changed:Connect(function()
      local value 	= math.max( math.min(Value.Value, Max.Value), Min.Value)
      
      if value ~= Value.Value then
         spawn(function()
            Value.Value = math.max(math.min(Value.Value, Max.Value), Min.Value)
         end)
      else
         spawn(function()
            Percent.Value = Misc.MapRange(Value.Value, Min.Value, Max.Value, 0, 1)
         end)
      end
   end))

   table.insert(connections, Min.Changed:Connect(function()
      Value.Value = math.max( math.min(Value.Value, Max.Value), Min.Value)
      spawn(function()
         Percent.Value = Misc.MapRange(Value.Value, Min.Value, Max.Value, 0, 1)
      end)
   end))

   table.insert(connections, Max.Changed:Connect(function()
      Value.Value = math.max( math.min(Value.Value, Max.Value), Min.Value)
      spawn(function()
         Percent.Value = Misc.MapRange(Value.Value, Min.Value, Max.Value, 0, 1)
      end)
   end))

   -- Initialize values
   Min.Value   = config.Min
   Max.Value   = config.Max
   Value.Value = config.Value

   return Slider, Value, Min, Max, Percent, OnFocused.Event, OnFocusLost.Event, Misc.DisconnectFn(connections)
end


return GUIUtils
