local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Misc        = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Misc"))

local STEP  = 0.01
local MIN   = -9007199254740992
local MAX   = 9007199254740992

local SLIDER_FG_COLOR_ON 			= Color3.fromRGB(68, 171, 218)
local SLIDER_FG_COLOR_OFF			= Color3.fromRGB(47, 161, 214)
local SLIDER_BG_COLOR_ON 			= Color3.fromRGB(60, 60, 60)
local SLIDER_BG_COLOR_OFF 			= Color3.fromRGB(48, 48, 48)

local COLOR_TEXT_ON 		   = Color3.fromRGB(255, 255, 255)
local COLOR_TEXT_OFF       = Color3.fromRGB(47, 161, 214)
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
   Controller.Size 			            = UDim2.new(1, 0, 0, 90)
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

   local Percent = Instance.new('Vector3Value')
   Percent.Name    = 'Percent'
   Percent.Value   =  Vector3.new(0, 0, 0)
   Percent.Parent  = Controller

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
   Control.Size 			            = UDim2.new(0.6, 0, 1, -1)
   Control.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   Control.Style 			            = Enum.FrameStyle.Custom
   Control.Visible                  = true
   Control.ZIndex                   = 1
   Control.Archivable               = true
   Control.Parent = Controller

   -- create X, Y, Z
   local function CreateTextFrame(name, position, connections)
      local Frame = Instance.new("Frame")
      Frame.Name 			            = name
      Frame.AnchorPoint	            = Vector2.new(0, 0)
      Frame.BackgroundColor3         = Color3.fromRGB(48, 48, 48)
      Frame.BackgroundTransparency   = 1
      Frame.BorderColor3             = Color3.fromRGB(48, 48, 48)
      Frame.BorderMode 			      = Enum.BorderMode.Outline
      Frame.BorderSizePixel 			= 0
      Frame.Draggable 			      = false
      Frame.Position 			         = position
      Frame.Selectable               = false
      Frame.Size 			            = UDim2.new(1, 0, 0.333, -1)
      Frame.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
      Frame.Style 			            = Enum.FrameStyle.Custom
      Frame.Visible                  = true
      Frame.ZIndex                   = 1
      Frame.Archivable               = true
      Frame.Parent = Control

      local Label = Instance.new('TextLabel')
      Label.Name 			            = "label"
      Label.AnchorPoint	            = Vector2.new(0, 0)
      Label.AutomaticSize	         = Enum.AutomaticSize.None
      Label.BackgroundColor3        = Color3.fromRGB(255, 255, 255)
      Label.BackgroundTransparency  = 1
      Label.BorderColor3            = Color3.fromRGB(27, 42, 53)
      Label.BorderMode 			      =  Enum.BorderMode.Outline
      Label.BorderSizePixel 			= 0
      Label.Position 			      = UDim2.new(0, 0, 0, 0)
      Label.Selectable              = false
      Label.Size 			            = UDim2.new(0, 10, 1, 0)
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
      Label.Parent = Frame

      local Slider = Instance.new("Frame")
      Slider.Name 			         = "slider"
      Slider.AnchorPoint	         = Vector2.new(0, 0)
      Slider.BackgroundColor3       = Color3.fromRGB(60, 60, 60)
      Slider.BackgroundTransparency = 0
      Slider.BorderColor3           = Color3.fromRGB(27, 42, 53)
      Slider.BorderMode 			   = Enum.BorderMode.Outline
      Slider.BorderSizePixel 			= 0
      Slider.Draggable 			      = false
      Slider.Position 			      = UDim2.new(0, 10, 0, 4)
      Slider.Selectable             = false
      Slider.Size 			         = UDim2.new(0.66, -10, 1, -8)
      Slider.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
      Slider.Style 			         = Enum.FrameStyle.Custom
      Slider.Visible                = true
      Slider.ZIndex                 = 1
      Slider.Archivable             = true
      Slider.Parent = Frame
   
      local SliderFG = Instance.new("Frame")
      SliderFG.Name 			            = "fg"
      SliderFG.AnchorPoint	            = Vector2.new(0, 0)
      SliderFG.BackgroundColor3        = Color3.fromRGB(47, 161, 214)
      SliderFG.BackgroundTransparency  = 0
      SliderFG.BorderColor3            = Color3.fromRGB(27, 42, 53)
      SliderFG.BorderMode 			      = Enum.BorderMode.Outline
      SliderFG.BorderSizePixel 			= 0
      SliderFG.Draggable 			      = false
      SliderFG.Position 			      = UDim2.new(0, 0, 0, 0)
      SliderFG.Selectable              = false
      SliderFG.Size 			            = UDim2.new(0.25, 0, 1, 0)
      SliderFG.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
      SliderFG.Style 			         = Enum.FrameStyle.Custom
      SliderFG.Visible                 = true
      SliderFG.ZIndex                  = 1
      SliderFG.Archivable              = true
      SliderFG.Parent = Slider

      local TextContainer = Instance.new("Frame")
      TextContainer.Name 			         = "text-container"
      TextContainer.AnchorPoint	         = Vector2.new(0, 0)
      TextContainer.BackgroundColor3       = Color3.fromRGB(48, 48, 48)
      TextContainer.BackgroundTransparency = 1
      TextContainer.BorderColor3           = Color3.fromRGB(27, 42, 53)
      TextContainer.BorderMode 			   = Enum.BorderMode.Outline
      TextContainer.BorderSizePixel 			= 0
      TextContainer.Draggable 			      = false
      TextContainer.Position 			      = UDim2.new(0.66, 5, 0, 4)
      TextContainer.Selectable             = false
      TextContainer.Size 			         = UDim2.new(0.33, -6, 1, -8)
      TextContainer.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
      TextContainer.Style 			         = Enum.FrameStyle.Custom
      TextContainer.Visible                = true
      TextContainer.ZIndex                 = 1
      TextContainer.Archivable             = true
      TextContainer.Parent = Frame

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

      local isFocused = false
      local textFocused = false

      table.insert(connections, Slider.MouseEnter:Connect(function()
         if UILocked.Value ~= "ACTIVE" then
            return
         end
         
         Slider.BackgroundColor3 = SLIDER_BG_COLOR_ON
         SliderFG.BackgroundColor3 = SLIDER_FG_COLOR_ON
      end))

      table.insert(connections, Slider.MouseMoved:Connect(function()
         if UILocked.Value ~= "ACTIVE" then
            return
         end
         
         Slider.BackgroundColor3 = SLIDER_BG_COLOR_ON
         SliderFG.BackgroundColor3 = SLIDER_FG_COLOR_ON
      end))

      table.insert(connections, Slider.MouseLeave:Connect(function()
         Slider.BackgroundColor3 = SLIDER_BG_COLOR_OFF
         SliderFG.BackgroundColor3 = SLIDER_FG_COLOR_OFF
      end))

      table.insert(connections, Text.MouseEnter:Connect(function()
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

      return Frame
   end

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections       = {}
   local KEYS              = { "X", "Y", "Z" }
   local controllerHover 	= false
   local sliderHover 		= { X=false, Y=false, Z=false }
   local sliderMouseDown	= { X=false, Y=false, Z=false }
   local textHover 		   = { X=false, Y=false, Z=false }
   local textFocused 		= { X=false, Y=false, Z=false }

   local absPosX, absPosY, absSizeX, absSizeY, posX, posY

   -- mutually exclusive change
   local ignorePercent = false
   local ignoreValueIn = false

   local Frames		= {
      X = CreateTextFrame('X', UDim2.new(0, 0, 0, 0), connections),
      Y = CreateTextFrame('Y', UDim2.new(0, 0, 0.333, 0), connections),
      Z = CreateTextFrame('Z', UDim2.new(0, 0, 0.666, 0), connections)
   }

   local TextContainer		= {
      X = Frames.X:WaitForChild("text-container"),
      Y = Frames.Y:WaitForChild("text-container"),
      Z = Frames.Z:WaitForChild("text-container")
   }

   local Text 				= {
      X = TextContainer.X:WaitForChild("text"):WaitForChild("text"),
      Y = TextContainer.Y:WaitForChild("text"):WaitForChild("text"),
      Z = TextContainer.Z:WaitForChild("text"):WaitForChild("text"),
   }

   local Slider 			= {
      X = Frames.X:WaitForChild("slider"),
      Y = Frames.Y:WaitForChild("slider"),
      Z = Frames.Z:WaitForChild("slider"),
   }

   local SliderFG			= {
      X = Slider.X:WaitForChild("fg"),
      Y = Slider.Y:WaitForChild("fg"),
      Z = Slider.Z:WaitForChild("fg"),
   }

   local function numDecimals(x) 
      local _x = tostring(x)
      local idexOf, _ = string.find(_x, ".", 1, true)
      if idexOf ~= nil then
         return string.len(_x) - (idexOf -1) - 1
      end
      
      return 0
   end

   local function checkUnlock()		
      for i, v in pairs(KEYS) do
         if controllerHover or textHover[v] or textFocused[v] or sliderHover[v] or sliderMouseDown[v] then
            return
         end
      end
      
      spawn(function()
         UILocked.Value = "UNLOCK"
      end)
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

   local function renderText()
      local precision = Precision.Value
      for i, v in pairs(KEYS) do
         Text[v].Text = string.format("%."..precision[v].."f", Value.Value[v])
      end
   end

   for i, key in pairs(KEYS) do
      table.insert(connections, Slider[key].MouseEnter:Connect(function()
         if UILocked.Value ~= "ACTIVE" then
            return
         end
         
         sliderHover[key] = true
      end))
      
      table.insert(connections, Slider[key].MouseMoved:Connect(function()
         if UILocked.Value ~= "ACTIVE" then
            return
         end
         
         sliderHover[key] = true
      end))
      
      table.insert(connections, Slider[key].MouseLeave:Connect(function()	
         sliderHover[key] = false
         checkUnlock()
      end))
      
      table.insert(connections, TextContainer[key].MouseEnter:Connect(function()
         if UILocked.Value ~= "ACTIVE" then
            return
         end	
         
         textHover[key] = true
      end))
      
      table.insert(connections, TextContainer[key].MouseMoved:Connect(function()
         if UILocked.Value ~= "ACTIVE" then
            return
         end	
         
         textHover[key] = true
      end))
      
      table.insert(connections, TextContainer[key].MouseLeave:Connect(function()
         textHover[key] = false
         checkUnlock()
      end))
      
      table.insert(connections, Text[key].Focused:Connect(function(enterPressed, inputObject)
         if UILocked.Value ~= "ACTIVE" then
            return
         end
         
         textFocused[key] = true
      end))
      
      -- On change text by user
      table.insert(connections, Text[key].FocusLost:Connect(function(enterPressed, inputObject)
         if UILocked.Value ~= "ACTIVE" then
            Text[key].Text = Value.Value[key]
            return
         end
         
         if string.len(Text[key].Text) == 0 then
            -- no changes
            Text[key].Text = string.format("%."..Precision.Value[key].."f", Value.Value[key])
         else
            local value = tonumber(Text[key].Text)
            if value == nil then
               -- invalid number
               Text[key].Text = string.format("%."..Precision.Value[key].."f", Value.Value[key])
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

   -- Apply 
   table.insert(connections, Percent.Changed:connect(function()
      
      for i, key in pairs(KEYS) do
         SliderFG[key].Size = UDim2.new(Percent.Value[key], 0, 1, 0)
      end
      
      if ignoreValueIn then
         ignoreValueIn = false
      else
         -- Change input
         ignorePercent = true
         ValueIn.Value = Vector3.new(
            Misc.MapRange(Percent.Value.X, 0, 1, Min.Value.X, Max.Value.X),
            Misc.MapRange(Percent.Value.Y, 0, 1, Min.Value.Y, Max.Value.Y),
            Misc.MapRange(Percent.Value.Z, 0, 1, Min.Value.Z, Max.Value.Z)
         )
      end
      
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
      
      if ignorePercent then
         ignorePercent = false
      else
         ignoreValueIn = true
         Percent.Value = Vector3.new(
            Misc.MapRange(x, Min.Value.X, Max.Value.X, 0, 1),
            Misc.MapRange(y, Min.Value.Y, Max.Value.Y, 0, 1),
            Misc.MapRange(z, Min.Value.Z, Max.Value.Z, 0, 1)
         )
      end
   end))

   table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      if input.UserInputType == Enum.UserInputType.MouseButton1 then
         for i, key in pairs(KEYS) do
            if sliderHover[key] then
               sliderMouseDown[key] = true
            end
         end
      end
   end))

   table.insert(connections, UserInputService.InputEnded:Connect(function(input, gameProcessed)	
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      if input.UserInputType == Enum.UserInputType.MouseButton1 then
         for i, key in pairs(KEYS) do
            if sliderMouseDown[key] then
               sliderMouseDown[key] = false
            end
         end
         
         checkUnlock()	
      end
   end))

   table.insert(connections, UserInputService.InputChanged:connect(function(input, gameProcessed)
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      if input.UserInputType == Enum.UserInputType.MouseMovement then
         for i, key in pairs(KEYS) do
            if sliderMouseDown[key] then
               absPosX = Slider[key].AbsolutePosition.X
               absPosY = Slider[key].AbsolutePosition.Y
               absSizeX = Slider[key].AbsoluteSize.X
               absSizeY = Slider[key].AbsoluteSize.Y		
               posX = input.Position.X
               posY = input.Position.Y
               
               local value
               
               if posX < absPosX then		
                  value = 0
                  
               elseif posX > (absPosX + absSizeX) then		
                  value = 1
                  
               else
                  value = (posX - absPosX)/absSizeX	
               end
               
               local x = Percent.Value.X
               local y = Percent.Value.Y
               local z = Percent.Value.Z
               
               if key == 'X' then
                  x = value
               elseif key == 'Y' then
                  y = value
               else
                  z = value
               end
               
               Percent.Value = Vector3.new(x, y, z)
            end
         end
      end
   end))

   table.insert(connections, UILocked.Changed:connect(function()
      if UILocked.Value ~= "ACTIVE" then
         -- reset when external lock (eg close folder)
         controllerHover	= false
         sliderHover 	= {X=false, Y=false, Z=false}
         sliderMouseDown	= {X=false, Y=false, Z=false}
         textHover 		= {X=false, Y=false, Z=false}
         textFocused 	= {X=false, Y=false, Z=false}
         
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


-- Number slider controller
local function Vector3SliderController(gui, object, property, min, max, step)
	
	local frame, OnRemove = CreateGUI()
	frame.Parent = gui.content
	
	local labelValue 	= frame:WaitForChild("Label")	
	local minValue 		= frame:WaitForChild("Min")
	local maxValue 		= frame:WaitForChild("Max")
	local stepValue 	= frame:WaitForChild("Step")
	local valueValue 	= frame:WaitForChild("Value")		-- Safe value
	local valueInValue	= frame:WaitForChild("ValueIn")		-- Input value, unsafe
	
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

return Vector3SliderController
