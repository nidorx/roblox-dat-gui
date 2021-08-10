local RunService           = game:GetService("RunService")
local UserInputService     = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Players              = game:GetService('Players')
local Player               = Players.LocalPlayer or Players:GetPropertyChangedSignal('LocalPlayer'):Wait()
local Mouse                = Player:GetMouse()

-- lib
local Lib = game.ReplicatedStorage:WaitForChild('Lib')
local Misc                 = require(Lib:WaitForChild("Misc"))
local Constants            = require(Lib:WaitForChild("Constants"))
local GuiEvents            = require(Lib:WaitForChild("GuiEvents"))

local GUIUtils = {}

--[[
  Create an ImageLabel 

  @param image {String}
  @return ImageLabel
]]
function GUIUtils.createImageLabel(image)
   local Check = Instance.new("ImageLabel")
   Check.Name 			            = "Icon"
   Check.AnchorPoint	            = Vector2.new(0, 0)
   Check.BackgroundTransparency  = 1
   Check.BorderSizePixel 			= 0
   Check.Selectable              = false
   Check.Position 			      = UDim2.new(0, 4, 0, 3)
   Check.Size 			            = UDim2.new(1, -8, 1, -6)
   Check.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   Check.Visible                 = true
   Check.ZIndex                  = 2
   Check.Archivable              = true
   Check.Image                   = image
   Check.ImageColor3             = Constants.CHECKBOX_COLOR_IMAGE
   Check.ImageTransparency 	   = 0
   Check.ScaleType               = Enum.ScaleType.Stretch
   Check.SliceScale              = 1

   return Check
end

--[[
   Instantiating a generic Frame

   @params {Table}
   @return Frame
]]
function GUIUtils.createFrame(params)
   local frame = Instance.new('Frame')
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
   Instantiating a generic TextLabel

   @params {Table}
   @return TextLabel
]]
function GUIUtils.createTextLabel(params)
   local label = Instance.new('TextLabel')
   label.Name 			            = "LabelText"
   label.AnchorPoint	            = Vector2.new(0, 0)
   label.AutomaticSize	         = Enum.AutomaticSize.None
   label.BackgroundTransparency  = 1
   label.BorderMode 			      = Enum.BorderMode.Outline
   label.BorderSizePixel 			= 0
   label.Position 			      = UDim2.new(0, 0, 0, 0)
   label.Selectable              = false
   label.Size 			            = UDim2.new(1, 0, 1, 0)
   label.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   label.Visible                 = true
   label.ZIndex                  = 1
   label.Archivable              = true
   label.Font                    = Enum.Font.SourceSans
   label.LineHeight              = 1
   label.RichText                = false
   label.Text                    = ''
   label.TextColor3 			      = Constants.LABEL_COLOR
   label.TextScaled              = false
   label.TextSize                = 14
   label.TextStrokeTransparency  = 1
   label.TextTransparency        = 0
   label.TextTruncate            = Enum.TextTruncate.AtEnd
   label.TextWrapped             = false
   label.TextXAlignment          = Enum.TextXAlignment.Left
   label.TextYAlignment          = Enum.TextYAlignment.Center

   

   if params ~= nil then
      for key, value in pairs(params) do
         label[key] = value
      end
   end

   return label
end

--[[
   Creates the generic controller wrapper

   Params
      config = {
         Name                 = String,
         Height               = Number,
         Color                = Color3
      }
   Returns 
      Controller     = Frame
      Control        = Frame
      Disconnect     = Function Need to be called to Disconnect all events
]]
function GUIUtils.createControllerWrapper(config)

   if config.Height == nil then
      config.Height = 30
   end

   if config.Color == nil then
      config.Color = Color3.fromRGB(27, 42, 53)
   end

   local Controller = GUIUtils.createFrame()   
   Controller.Name   = config.Name
   Controller.Size 	= UDim2.new(1, 0, 0, config.Height)

   local Readonly = Instance.new('BoolValue')
   Readonly.Name   = 'Readonly'
   Readonly.Value  = false
   Readonly.Parent = Controller

   local LabelVisible = Instance.new('BoolValue')
   LabelVisible.Name   = 'LabelVisible'
   LabelVisible.Value  = true
   LabelVisible.Parent = Controller

   local LabelValue = Instance.new('StringValue')
   LabelValue.Name   = 'Label'
   LabelValue.Parent = Controller

   local LabelText = GUIUtils.createTextLabel()
   LabelText.Position   = UDim2.new(0, 6, 0, 0)
   LabelText.Size 		= UDim2.new(0.4, -6, 1, -1)
   LabelText.Parent = Controller

   local borderBottom = GUIUtils.createFrame()
   borderBottom.Name 			   = "BorderBottom"
   borderBottom.BackgroundColor3 = Constants.BORDER_COLOR
   borderBottom.Position 			= UDim2.new(0, 0, 1, -1)
   borderBottom.Size 			   = UDim2.new(1, 0, 0, 1)
   borderBottom.Parent = Controller

   local borderLeft = GUIUtils.createFrame()
   borderLeft.Name 			      = "BorderLeft"
   borderLeft.BackgroundColor3   = config.Color
   borderLeft.Size 			      = UDim2.new(0, 3, 1, 0)
   borderLeft.ZIndex             = 2
   borderLeft.Parent = Controller

   local Control = GUIUtils.createFrame()
   Control.Name 			            = "Control"
   Control.BackgroundTransparency   = 1
   Control.Position 			         = UDim2.new(0.4, 0, 0, 0)
   Control.Size 			            = UDim2.new(0.6, 0, 1, -1)
   Control.Parent = Controller

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections    = {}

   table.insert(connections, LabelValue.Changed:Connect(function()
      LabelText.Text = LabelValue.Value
   end))

   table.insert(connections, LabelVisible.Changed:Connect(function()
      LabelText.Visible = LabelVisible.Value
      if LabelVisible.Value then 
         Control.Position 			         = UDim2.new(0.4, 0, 0, 0)
         Control.Size 			            = UDim2.new(0.6, 0, 1, -1)
      else
         Control.Position 			         = UDim2.new(0, 6, 0, 0)
         Control.Size 			            = UDim2.new(1, -6, 1, -1)
      end
   end))


   return Controller, Control, Misc.disconnectFn(connections)
end

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
function GUIUtils.createInput(config)

   if config.Color == nil then
      config.Color = Constants.NUMBER_COLOR
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

   local TextFrame = GUIUtils.createFrame()
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
   Text.Size 			            = UDim2.new(1, -4, 1, 0)
   Text.SelectionStart           = -1
   Text.ShowNativeInput          = true
   Text.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   Text.Selectable               = false
   Text.Visible                  = false
   Text.TextEditable 			   = false
   Text.Active                   = false
   Text.Archivable               = false
   Text.ZIndex                   = 1
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
   if config.MultiLine then 
      Text.TextYAlignment           = Enum.TextYAlignment.Top
   end
   Text.Parent = TextFrame

   local TextFake = GUIUtils.createTextLabel()
   TextFake.Name              = 'TextBoxFake'
   TextFake.Position          = Text.Position
   TextFake.TextXAlignment    = Text.TextXAlignment
   TextFake.TextYAlignment    = Text.TextYAlignment
   TextFake.TextColor3        = Text.TextColor3
   TextFake.Size              = Text.Size
   TextFake.Parent = TextFrame

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------
  
   local connections    = {}
   local isFocused      = false
   local isHover        = false
   local OnFocused      = Instance.new('BindableEvent')
   local OnFocusLost    = Instance.new('BindableEvent')
   local isReadOnly     

   local function updateVisibility()

      if isFocused and not config.Readonly.Value then
         if config.ChangeColors then
            Text.TextColor3            = Constants.INPUT_COLOR_FOCUS_TXT
            TextFrame.BackgroundColor3 = Constants.INPUT_COLOR_FOCUS	
         end
      else
         if isHover and not config.Readonly.Value then 
            TextFake.ZIndex   = -1
            TextFake.Visible  = false
            Text.Selectable   = true
            Text.Visible      = true
            Text.TextEditable = true
            Text.Active       = true
         else
            TextFake.ZIndex   = 2
            TextFake.Visible  = true
            Text.Selectable   = false
            Text.Visible      = false
            Text.TextEditable = false
            Text.Active       = false
         end
         
         if config.ChangeColors then
            if isHover and not config.Readonly.Value then 
               TextFrame.BackgroundColor3 = Constants.INPUT_COLOR_HOVER
            else
               Text.TextColor3            = config.Color
               TextFrame.BackgroundColor3 = Constants.INPUT_COLOR
            end
         end
      end
   end

   table.insert(connections, Value.Changed:Connect(function()
      Text.Text      = config.Render(Value.Value)
      TextFake.Text  = Text.Text
   end))

   table.insert(connections, Text.Focused:Connect(function()
      isFocused = true
      updateVisibility()

      OnFocused:Fire()
   end))
   
   table.insert(connections, Text.FocusLost:Connect(function(enterPressed, input)
      isFocused = false
      updateVisibility()
      
      Value.Value    = config.Parse(Text.Text, Value)
      Text.Text      = config.Render(Value.Value)
      TextFake.Text  = Text.Text

      OnFocusLost:Fire()
   end))

   table.insert(connections, GuiEvents.onHover(TextFrame, function(hover)
      isHover = hover
      updateVisibility()
   end))
   
   return Value, TextFrame, OnFocused.Event, OnFocusLost.Event, Misc.disconnectFn(connections)
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
function GUIUtils.createSlider(config)

   if config.Min == nil then
      config.Min = -math.huge
   end

   if config.Max == nil then
      config.Max = math.huge
   end

   local Value = Instance.new('NumberValue')
   Value.Name  = 'Value'

   local Min = Instance.new('NumberValue')
   Min.Name    = 'Min'
   Min.Value = -math.huge
   
   local Max = Instance.new('NumberValue')
   Max.Name    = 'Max'
   Max.Value = math.huge
   
   local Percent = Instance.new('NumberValue')
   Percent.Name    = 'Percent'
   Percent.Value   = 0

   local Slider = GUIUtils.createFrame()
   Slider.Name 			         = 'Slider'
   Slider.BackgroundColor3       = Color3.fromRGB(60, 60, 60)
   Slider.BackgroundTransparency = 0
   Slider.BorderMode 			   = Enum.BorderMode.Outline

   local SliderFG = GUIUtils.createFrame()
   SliderFG.Name 			            = 'SliderFG'
   SliderFG.BackgroundColor3        = Constants.NUMBER_COLOR
   SliderFG.BackgroundTransparency  = 0
   SliderFG.Size 			            = UDim2.new(0, 0, 1, 0)
   SliderFG.Parent = Slider

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections    = {}
   local absPosX, absPosY, absSizeX, absSizeY, posX, posY

   local isHover     = false
   local isDragging  = false

   local OnFocused      = Instance.new('BindableEvent')
   local OnFocusLost    = Instance.new('BindableEvent')

   local function updateColors()
      if not config.Readonly.Value and (isHover or isDragging) then 
         Slider.BackgroundColor3    = Constants.INPUT_COLOR_HOVER
         SliderFG.BackgroundColor3 = Constants.NUMBER_COLOR_HOVER
      else
         Slider.BackgroundColor3    = Constants.INPUT_COLOR
         SliderFG.BackgroundColor3  = Constants.NUMBER_COLOR
      end
   end

   table.insert(connections, GuiEvents.onHover(Slider, function(hover)
      isHover = hover
      updateColors()
   end))

   table.insert(connections, GuiEvents.onDrag(Slider, function(event, startPos, position, delta)
      if config.Readonly.Value then 
         return
      end

      if event == 'start' then
         isDragging = true
         updateColors()
         OnFocused:Fire()
         
      elseif event == 'end' then
         isDragging = false
         updateColors()
         OnFocusLost:Fire()

      elseif event == 'drag' then
         
         absPosX  = Slider.AbsolutePosition.X
         absPosY  = Slider.AbsolutePosition.Y
         absSizeX = Slider.AbsoluteSize.X
         absSizeY = Slider.AbsoluteSize.Y

         posX = position.X
         posY = position.Y
         
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
         Value.Value = Misc.mapRange(Percent.Value, 0, 1, Min.Value, Max.Value)
      end)
   end))

   -- On change value from outside
   table.insert(connections, Value.Changed:Connect(function()
      local value = math.clamp(Value.Value, Min.Value, Max.Value)
      
      if value ~= Value.Value then
         spawn(function()
            Value.Value = math.clamp(Value.Value, Min.Value, Max.Value)
         end)
      else
         spawn(function()
            Percent.Value = Misc.mapRange(Value.Value, Min.Value, Max.Value, 0, 1)
         end)
      end
   end))

   table.insert(connections, Min.Changed:Connect(function()
      Value.Value = math.clamp(Value.Value, Min.Value, Max.Value)
      spawn(function()
         Percent.Value = Misc.mapRange(Value.Value, Min.Value, Max.Value, 0, 1)
      end)
   end))

   table.insert(connections, Max.Changed:Connect(function()
      Value.Value = math.clamp(Value.Value, Min.Value, Max.Value)
      spawn(function()
         Percent.Value = Misc.mapRange(Value.Value, Min.Value, Max.Value, 0, 1)
      end)
   end))

   -- Initialize values
   Min.Value   = config.Min
   Max.Value   = config.Max
   Value.Value = config.Value

   return Slider, Value, Min, Max, Percent, OnFocused.Event, OnFocusLost.Event, Misc.disconnectFn(connections)
end

return GUIUtils
