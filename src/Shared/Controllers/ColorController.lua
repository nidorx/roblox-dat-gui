local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local function CreateGUI()
   local Controller = Instance.new("Frame")
   Controller.Name 			            = "ColorController"
   Controller.AnchorPoint	            = Vector2.new(0, 0)
   Controller.BackgroundColor3         = Color3.fromRGB(26, 26, 26)
   Controller.BackgroundTransparency   = 0
   Controller.BorderColor3             = Color3.fromRGB(27, 42, 53)
   Controller.BorderMode 			      = Enum.BorderMode.Outline
   Controller.BorderSizePixel 			= 0
   Controller.Draggable 			      = false
   Controller.Position 			         = UDim2.new(0, 0, 0, 60)
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

   local Value = Instance.new('Color3Value')
   Value.Name     = 'Value'
   Value.Value    = Color3.fromRGB(0, 0, 0)
   Value.Parent   = Controller

   local Hue = Instance.new('IntValue')
   Hue.Name     = 'Hue'
   Hue.Value    = 0
   Hue.Parent   = Controller

   local Luminance = Instance.new('IntValue')
   Luminance.Name     = 'Luminance'
   Luminance.Value    = 0
   Luminance.Parent   = Controller

   local Saturation = Instance.new('IntValue')
   Saturation.Name     = 'Saturation'
   Saturation.Value    = 0
   Saturation.Parent   = Controller

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
   LabelText.Text                   = 'Color Label'
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

   local BorderBottom = Instance.new("Frame")
   BorderBottom.Name 			         = "border-bottom"
   BorderBottom.AnchorPoint	         = Vector2.new(0, 0)
   BorderBottom.BackgroundColor3       = Color3.fromRGB(44, 44, 44)
   BorderBottom.BackgroundTransparency = 0
   BorderBottom.BorderColor3           = Color3.fromRGB(44, 44, 44)
   BorderBottom.BorderMode 			   = Enum.BorderMode.Outline
   BorderBottom.BorderSizePixel 			= 0
   BorderBottom.Draggable 			      = false
   BorderBottom.Position 			      = UDim2.new(0, 0, 1, -1)
   BorderBottom.Selectable             = false
   BorderBottom.Size 			         = UDim2.new(1, 0, 0, 1)
   BorderBottom.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   BorderBottom.Style 			         = Enum.FrameStyle.Custom
   BorderBottom.Visible                = true
   BorderBottom.ZIndex                 = 1
   BorderBottom.Archivable             = true
   BorderBottom.Parent = Controller

   local BorderLeft = Instance.new("Frame")
   BorderLeft.Name 			            = "border-left"
   BorderLeft.AnchorPoint	            = Vector2.new(0, 0)
   BorderLeft.BackgroundColor3         = Color3.fromRGB(30, 211, 111)
   BorderLeft.BackgroundTransparency   = 0
   BorderLeft.BorderColor3             = Color3.fromRGB(27, 42, 53)
   BorderLeft.BorderMode 			      = Enum.BorderMode.Outline
   BorderLeft.BorderSizePixel 			= 0
   BorderLeft.Draggable 			      = false
   BorderLeft.Position 			         = UDim2.new(0, 0,0, 0)
   BorderLeft.Selectable               = false
   BorderLeft.Size 			            = UDim2.new(0, 3, 1, 0)
   BorderLeft.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   BorderLeft.Style 			            = Enum.FrameStyle.Custom
   BorderLeft.Visible                  = true
   BorderLeft.ZIndex                   = 2
   BorderLeft.Archivable               = true
   BorderLeft.Parent = Controller

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
   TextContainer.BackgroundTransparency   = 0
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
   Text.Position 			         = UDim2.new(0, 0, 0, 0)
   Text.Selectable               = true
   Text.SelectionStart           = -1
   Text.ShowNativeInput          = true
   Text.Size 			            = UDim2.new(1, 0, 1, 0)
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
   Text.TextColor3 			      = Color3.fromRGB(255, 255, 255)
   Text.TextScaled               = false
   Text.TextSize                 = 14
   Text.TextStrokeColor3 		   = Color3.fromRGB(0, 0, 0)
   Text.TextStrokeTransparency   = 1
   Text.TextTransparency         = 0
   Text.TextTruncate             = Enum.TextTruncate.None
   Text.TextWrapped              = false
   Text.TextXAlignment           = Enum.TextXAlignment.Center
   Text.TextYAlignment           = Enum.TextYAlignment.Center
   Text.Parent = TextContainer

   local Selector = Instance.new("Frame")
   Selector.Name 			            = "selector"
   Selector.AnchorPoint	            = Vector2.new(0, 0)
   Selector.BackgroundColor3        = Color3.fromRGB(34, 34, 34)
   Selector.BackgroundTransparency  = 0
   Selector.BorderColor3            = Color3.fromRGB(34, 34, 34)
   Selector.BorderMode 			      = Enum.BorderMode.Outline
   Selector.BorderSizePixel 			= 3
   Selector.Draggable 			      = false
   Selector.Position 			      = UDim2.new(0, 0, 1, -6)
   Selector.Selectable              = false
   Selector.Size 			            = UDim2.new(0, 122, 0, 102)
   Selector.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   Selector.Style 			         = Enum.FrameStyle.Custom
   Selector.Visible                 = false
   Selector.ZIndex                  = 1
   Selector.Archivable              = true
   Selector.Parent = Control

   local HueSelector = Instance.new("Frame")
   HueSelector.Name 			            = "hue"
   HueSelector.AnchorPoint	            = Vector2.new(0, 0)
   HueSelector.BackgroundColor3        = Color3.fromRGB(255, 255, 255)
   HueSelector.BackgroundTransparency  = 0
   HueSelector.BorderColor3            = Color3.fromRGB(85, 85, 85)
   HueSelector.BorderMode 			      = Enum.BorderMode.Outline
   HueSelector.BorderSizePixel 			= 1
   HueSelector.Draggable 			      = false
   HueSelector.Position 			      = UDim2.new(1, -16, 0, 1)
   HueSelector.Selectable              = false
   HueSelector.Size 			            = UDim2.new(0, 15, 0, 100)
   HueSelector.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   HueSelector.Style 			         = Enum.FrameStyle.Custom
   HueSelector.Visible                 = true
   HueSelector.ZIndex                  = 1
   HueSelector.Archivable              = true
   HueSelector.Parent = Selector

   local HueSelectorSaturation = Instance.new('UIGradient')
   HueSelectorSaturation.Name          = 'Saturation'
   HueSelectorSaturation.Enabled       = true
   HueSelectorSaturation.Rotation      = 90
   HueSelectorSaturation.Transparency  = NumberSequence.new({
      NumberSequenceKeypoint.new(0, 0),
      NumberSequenceKeypoint.new(1, 0)
   })
   HueSelectorSaturation.Color         = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
      ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 0, 255)),
      ColorSequenceKeypoint.new(0.34, Color3.fromRGB(0, 0, 255)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
      ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 0)),
      ColorSequenceKeypoint.new(0.84, Color3.fromRGB(255, 255, 0)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
   })  
   HueSelectorSaturation.Parent   = HueSelector

   local HueKnob = Instance.new("Frame")
   HueKnob.Name 			            = "knob"
   HueKnob.AnchorPoint	            = Vector2.new(0, 0)
   HueKnob.BackgroundColor3         = Color3.fromRGB(255, 255, 255)
   HueKnob.BackgroundTransparency   = 0
   HueKnob.BorderColor3             = Color3.fromRGB(27, 42, 53)
   HueKnob.BorderMode 			      = Enum.BorderMode.Outline
   HueKnob.BorderSizePixel 			= 1
   HueKnob.Draggable 			      = false
   HueKnob.Position 			         = UDim2.new(1, -2, 0.1, 0)
   HueKnob.Selectable               = false
   HueKnob.Size 			            = UDim2.new(0, 4, 0, 2)
   HueKnob.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   HueKnob.Style 			            = Enum.FrameStyle.Custom
   HueKnob.Visible                 = true
   HueKnob.ZIndex                  = 1
   HueKnob.Archivable              = true
   HueKnob.Parent = HueSelector

   local SatLumSelector = Instance.new("Frame")
   SatLumSelector.Name 			            = "saturation"
   SatLumSelector.AnchorPoint	            = Vector2.new(0, 0)
   SatLumSelector.BackgroundColor3        = Color3.fromRGB(255, 255, 255)
   SatLumSelector.BackgroundTransparency  = 0
   SatLumSelector.BorderColor3            = Color3.fromRGB(85, 85, 85)
   SatLumSelector.BorderMode 			      = Enum.BorderMode.Outline
   SatLumSelector.BorderSizePixel 			= 1
   SatLumSelector.Draggable 			      = false
   SatLumSelector.Position 			      = UDim2.new(0, 1, 0, 1)
   SatLumSelector.Selectable              = false
   SatLumSelector.Size 			            = UDim2.new(0, 100, 0, 100)
   SatLumSelector.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   SatLumSelector.Style 			         = Enum.FrameStyle.Custom
   SatLumSelector.Visible                 = true
   SatLumSelector.ZIndex                  = 2
   SatLumSelector.Archivable              = true
   SatLumSelector.Parent = Selector

   local SatLumKnob = Instance.new("Frame")
   SatLumKnob.Name 			            = "knob"
   SatLumKnob.AnchorPoint	            = Vector2.new(0, 0)
   SatLumKnob.BackgroundColor3         = Color3.fromRGB(255, 3, 7)
   SatLumKnob.BackgroundTransparency   = 0
   SatLumKnob.BorderColor3             = Color3.fromRGB(255, 255, 255)
   SatLumKnob.BorderMode 			      = Enum.BorderMode.Outline
   SatLumKnob.BorderSizePixel 			= 2
   SatLumKnob.Draggable 			      = false
   SatLumKnob.Position 			         = UDim2.new(0.4, 0, 0.1, 0)
   SatLumKnob.Rotation                 = 45
   SatLumKnob.Selectable               = false
   SatLumKnob.Size 			            = UDim2.new(0, 10, 0, 10)
   SatLumKnob.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   SatLumKnob.Style 			            = Enum.FrameStyle.Custom
   SatLumKnob.Visible                  = true
   SatLumKnob.ZIndex                   = 2
   SatLumKnob.Archivable               = true
   SatLumKnob.Parent = SatLumSelector

   local Brightness = Instance.new("ImageLabel")
   Brightness.Name 			            = "brightness"
   Brightness.AnchorPoint	            = Vector2.new(0, 0)
   Brightness.BackgroundColor3         = Color3.fromRGB(255, 255, 255)
   Brightness.BackgroundTransparency   = 1
   Brightness.BorderColor3             = Color3.fromRGB(27, 42, 53)
   Brightness.BorderMode 			      = Enum.BorderMode.Outline
   Brightness.BorderSizePixel 			= 1
   Brightness.Position 			         = UDim2.new(0, 0, 0, 0)
   Brightness.Selectable               = false
   Brightness.Size 			            = UDim2.new(0, 100, 0, 100)
   Brightness.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   Brightness.Visible                  = true
   Brightness.ZIndex                   = 2
   Brightness.Archivable               = true
   Brightness.Image                    = 'rbxassetid://5787992121'
   Brightness.ImageColor3              = Color3.fromRGB(255, 255, 255)
   Brightness.ImageTransparency 	      = 0
   Brightness.ScaleType                = Enum.ScaleType.Stretch
   Brightness.SliceScale               = 1
   Brightness.Parent = SatLumSelector

   local SaturationImage = Instance.new("ImageLabel")
   SaturationImage.Name 			         = "saturation"
   SaturationImage.AnchorPoint	         = Vector2.new(0, 0)
   SaturationImage.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
   SaturationImage.BackgroundTransparency = 1
   SaturationImage.BorderColor3           = Color3.fromRGB(27, 42, 53)
   SaturationImage.BorderMode 			   = Enum.BorderMode.Outline
   SaturationImage.BorderSizePixel 			= 1
   SaturationImage.Position 			      = UDim2.new(0, 0, 0, 0)
   SaturationImage.Rotation 			      = -90
   SaturationImage.Selectable             = false
   SaturationImage.Size 			         = UDim2.new(0, 100, 0, 100)
   SaturationImage.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   SaturationImage.Visible                = true
   SaturationImage.ZIndex                 = 1
   SaturationImage.Archivable             = true
   SaturationImage.Image                  = 'rbxassetid://5787998939'
   SaturationImage.ImageColor3            = Color3.fromRGB(255, 0, 0)
   SaturationImage.ImageTransparency 	   = 0
   SaturationImage.ScaleType              = Enum.ScaleType.Stretch
   SaturationImage.SliceScale             = 1
   SaturationImage.Parent = SatLumSelector

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections       = {}
   local controllerHover 	= false
   local selectorHover 	   = false
   local hueHover 			= false
   local hueMouseDown 		= false
   local satLumHover 		= false
   local satLumMouseDown   = false
   local textHover 		   = false
   local textFocused 		= false


   local function updateBorderColor()
      BorderLeft.BackgroundColor3 = Value.Value
   end
   
   table.insert(connections, Value.Changed:connect(updateBorderColor))
   
   table.insert(connections, LabelValue.Changed:connect(function()
      LabelText.Text = LabelValue.Value
   end))


   -- Services
   local Util = {}

   local BLACK = Color3.fromRGB(0, 0, 0)
   local WHITE = Color3.fromRGB(255, 255, 255)

   function Util.bestContrast(color)
      -- http://www.w3.org/TR/AERT#color-contrast
      local brightness = math.round((color.R*255 * 299 + color.G*255 * 587 + color.B*255 * 114)/1000);
      
      if brightness > 125 then
         return BLACK
      else
         return WHITE
      end
   end

   local function changeColor()
      
      local hue, sat, lum = Value.Value:ToHSV()	
      
      local changed = false
      
      if math.floor(239*hue+0.5) ~= Hue.Value then
         hue = Hue.Value/239
         changed = true
      end
      
      if math.floor(240*sat+0.5) ~= Saturation.Value  then
         sat = Saturation.Value/240
         changed = true
      end
      
      if  math.floor(240*lum+0.5) ~= Luminance.Value  then
         lum = Luminance.Value/240
         changed = true
      end
      
      if changed then
         Value.Value = Color3.fromHSV(hue, sat, lum)
      end
   end

   local function renderText()
      local color = Value.Value
      
      TextContainer.BackgroundColor3 = color	
      
      Text.TextColor3 = Util.bestContrast(color)		
      Text.Text = string.format("#%.2X%.2X%.2X", color.R * 255, color.G * 255, color.B * 255)
   end

   local function changeSelector()
      local hue, sat, lum  = Value.Value:ToHSV()	
      
      Hue.Value 			= math.floor(239 * hue + 0.5)	
      Saturation.Value	= math.floor(240 * sat + 0.5)
      Luminance.Value		= math.floor(240 * lum + 0.5)
      
      SatLumKnob.Position 			= UDim2.new(sat, -5, 1-lum , -5)
      SatLumKnob.BorderColor3 		= Util.bestContrast(Value.Value)	
      SatLumKnob.BackgroundColor3 	= Value.Value	
      
      renderText()	
   end

   table.insert(connections, Value.Changed:connect(changeSelector))

   local function color3FromString(hex) 
      local r, g, b, hash
      if string.len(hex) == 6 then
         -- FFFFFF
         r, g, b  = hex:match("(..)(..)(..)")
      elseif string.len(hex) == 7 then
         -- #FFFFFF
         hash, r, g, b  = hex:match("(.)(..)(..)(..)")
      elseif string.len(hex) == 3 then
         -- FFF
         r, g, b  = hex:match("(.)(.)(.)")
         r = r..r
         g = g..g
         b = b..b
      elseif string.len(hex) == 4 then
         -- #FFF
         hash, r, g, b  = hex:match("(.)(.)(.)(.)")
         r = r..r
         g = g..g
         b = b..b
      else
         return nil
      end
      
      r, g, b = tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
      
      return Color3.fromRGB(r, g, b)
   end

   local function checkVisibility()
      if UILocked.Value ~= "ACTIVE" then
         Selector.Visible = false
         
      elseif textHover or textFocused or selectorHover or  hueHover or satLumHover or hueMouseDown or satLumMouseDown then
         Selector.Visible = true
      else
         Selector.Visible = false
      end	
   end

   local function checkUnlock()	
      checkVisibility()
      
      if controllerHover or textHover or textFocused or selectorHover or hueHover or satLumHover or hueMouseDown or satLumMouseDown then
         return
      end
      
      Selector.Visible = false
      
      spawn(function()		
         UILocked.Value = "UNLOCK"
      end)
   end

   table.insert(connections, Hue.Changed:connect(function()
      local hue = Hue.Value
      if hue == 0 then
         hue = 1
      end
      
      HueKnob.Position = UDim2.new(1, -2, 1-hue/239, -1)	
      SaturationImage.ImageColor3 = Color3.fromHSV(Hue.Value/239, 1, 1)
      
      changeColor()
   end))

   table.insert(connections, Saturation.Changed:connect(function()
      changeColor()
   end))

   table.insert(connections, Luminance.Changed:connect(function()
      changeColor()
   end))

   table.insert(connections, Selector.MouseEnter:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      selectorHover = true
      checkVisibility()
   end))

   table.insert(connections, Selector.MouseMoved:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      selectorHover = true
      checkVisibility()
   end))

   table.insert(connections, Selector.MouseLeave:Connect(function()
      selectorHover = false
      checkUnlock()
   end))

   table.insert(connections, Controller.MouseEnter:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      controllerHover = true
      checkVisibility()
   end))

   table.insert(connections, Controller.MouseMoved:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      controllerHover = true
      checkVisibility()
   end))

   table.insert(connections, Controller.MouseLeave:Connect(function()
      controllerHover = false
      checkUnlock()
   end))

   table.insert(connections, SatLumSelector.MouseEnter:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      satLumHover = true
      checkVisibility()
   end))

   table.insert(connections, SatLumSelector.MouseMoved:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      satLumHover = true
      checkVisibility()
   end))

   table.insert(connections, SatLumSelector.MouseLeave:Connect(function()
      satLumHover = false
      checkUnlock()
   end))

   table.insert(connections, HueSelector.MouseEnter:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      hueHover = true
      checkVisibility()
   end))

   table.insert(connections, HueSelector.MouseMoved:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      hueHover = true
      checkVisibility()
   end))

   table.insert(connections, HueSelector.MouseLeave:Connect(function()
      hueHover = false
      checkUnlock()
   end))

   table.insert(connections, TextContainer.MouseEnter:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end	
      
      textHover = true	
      checkVisibility()
   end))

   table.insert(connections, TextContainer.MouseMoved:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end	
      
      textHover = true	
      checkVisibility()
   end))

   table.insert(connections, TextContainer.MouseLeave:Connect(function()
      textHover = false
      checkUnlock()
   end))

   table.insert(connections, Text.Focused:Connect(function(enterPressed, inputObject)
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      textFocused = true
      checkVisibility()	
   end))

   table.insert(connections, Text.FocusLost:Connect(function(enterPressed, inputObject)
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      -- Color.Value
      if string.len(Text.Text) == 0 then
         -- no changes
         renderText()
      else
         local value = color3FromString(Text.Text)
         if value == nil then
            -- invalid color
            renderText()
         else
            -- valid color
            Value.Value = value
         end
      end
      
      textFocused = false
      checkUnlock()
   end))

   local function parseHueMouse(input)
      local posY 		= input.Position.Y
      local absSizeY 	= HueSelector.AbsoluteSize.Y		
      local absPosY 	= HueSelector.AbsolutePosition.Y
      
      local percent = (posY - absPosY)/absSizeY
      
      if percent < 0 then
         percent = 0
      elseif percent > 1 then
         percent = 1
      end
      
      -- 0 to 239	
      Hue.Value =  math.floor(239 *(1-percent) + 0.5)
   end

   local function parseSatLumMouse(input)
      -- Saturation
      local posX 		= input.Position.X
      local absPosX 	= SatLumSelector.AbsolutePosition.X
      local absSizeX 	= SatLumSelector.AbsoluteSize.X
      local percentX	= (posX - absPosX)/absSizeX
      
      if percentX < 0 then
         percentX = 0
      elseif percentX > 1 then
         percentX = 1
      end
      
      Saturation.Value = math.floor(240 * percentX + 0.5)
      
      
      -- Luminance
      local posY 		= input.Position.Y		
      local absPosY 	= SatLumSelector.AbsolutePosition.Y	
      local absSizeY 	= SatLumSelector.AbsoluteSize.Y		
      local percentY	= (posY - absPosY)/absSizeY
      
      if percentY < 0 then
         percentY = 0
      elseif percentY > 1 then
         percentY = 1
      end
      
      Luminance.Value = math.floor(240 * (1-percentY) + 0.5)
   end

   table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      if satLumHover and input.UserInputType == Enum.UserInputType.MouseButton1 then
         satLumMouseDown = true
         parseSatLumMouse(input)
         
      elseif hueHover and input.UserInputType == Enum.UserInputType.MouseButton1 then
         hueMouseDown = true
         parseHueMouse(input)
      end
      
      checkVisibility()
   end))

   table.insert(connections, UserInputService.InputChanged:connect(function(input, gameProcessed)
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      if hueMouseDown and input.UserInputType == Enum.UserInputType.MouseMovement then		
         parseHueMouse(input)
         
      elseif satLumMouseDown and input.UserInputType == Enum.UserInputType.MouseMovement then
         parseSatLumMouse(input)	
         
      end
   end))


   table.insert(connections, UserInputService.InputEnded:Connect(function(input, gameProcessed)	
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      if input.UserInputType == Enum.UserInputType.MouseButton1 then			
         hueMouseDown = false
         satLumMouseDown = false	
         
         checkUnlock()
      end
   end))

   -- reset when external lock (eg close folder)
   table.insert(connections, UILocked.Changed:connect(function()
      if UILocked.Value == "LOCKED" then
         controllerHover 	= false
         selectorHover 		= false
         hueHover 			= false
         hueMouseDown 		= false
         satLumHover 		= false
         satLumMouseDown 	= false
         textHover 			= false
         textFocused 		= false
         checkVisibility()
      end	
   end))

   -- init
   changeSelector()
   Selector.Visible = false
   
   local OnRemove = function()
      for _, conn in ipairs(connections) do
         conn:Disconnect()
      end
      connections = {}
   end

   return Controller, OnRemove
end

-- Provides a text input to alter the string property of an object.
local function ColorController(gui, object, property)
	
	local frame, OnRemove = CreateGUI()
	frame.Parent = gui.content
	
	local colorValue 	= frame:WaitForChild("Value")
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
	colorValue.Changed:connect(function()		
		if not controller._isReadonly then
			object[property] = colorValue.Value
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
		colorValue.Value = value		
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
	colorValue.Value = object[property]
	
	return controller
end

return ColorController
