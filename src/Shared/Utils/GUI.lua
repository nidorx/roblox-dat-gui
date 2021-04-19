local RunService           = game:GetService("RunService")
local UserInputService     = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Player               = game.Players.LocalPlayer or game.Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local Mouse                = Player:GetMouse()
local Camera 	            = workspace.CurrentCamera
local Misc                 = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Misc"))
local Constants            = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Constants"))

local GUIUtils = {}

-- https://devforum.roblox.com/t/gui-absoluteposition-doesnt-respect-ignoreguiinset/1168583/5
local GUI_INSET = 36



local POPOVER_SEQ    = 0

local Popover = {}
Popover.__index = Popover

function Popover.new(reference, size, position, offset)
   local frame = GUIUtils.CreateFrame()
   POPOVER_SEQ = POPOVER_SEQ +1
   frame.Name = 'Popover#'..POPOVER_SEQ

   frame.Parent                  = Constants.MODAL_GUI
   frame.Size                    = UDim2.new(0, size.X, 0, size.Y)
   frame.BackgroundTransparency  = 1
   frame.Visible                 = false
   frame.ZIndex                  = 1000
   -- frame.Active                  = true

   if position == nil or position == '' then 
      position = 'top'
   end

   if offset == nil then 
      offset = 0
   end

   return setmetatable({
      _reference  = reference,
      _position   = position,
      _offset     = offset, 
      Frame       = frame,      
   }, Popover)
end

-- @TODO: ESTOU AQUI, CRIANDO UM POPOVER
function Popover:Show()
   local refPos = self._reference.AbsolutePosition
   local refSiz = self._reference.AbsoluteSize
   local scrSiz = Camera.ViewportSize

   local size = self.Frame.AbsoluteSize

   local posX
   local posY

   local offset = self._offset

   if self._position == 'top' then
      posX = refPos.X + (refSiz.X/2) - size.X/2

      posY = refPos.Y - size.Y - self._offset 
      if posY < -GUI_INSET then 
         -- on bottom
         posY = refPos.Y + refSiz.Y + self._offset
      end

   elseif self._position == 'bottom' then
      posX = refPos.X + (refSiz.X/2) - size.X/2

      posY = refPos.Y + refSiz.Y + self._offset
      if (posY + size.Y) > scrSiz.Y - GUI_INSET then 
         -- on top
         posY = refPos.Y - size.Y - self._offset
      end
      
   elseif self._position == 'left' then
      posY = refPos.Y + (refSiz.Y/2) - (size.Y/2)
      if posY < - GUI_INSET then 
         posY = - GUI_INSET
      end
      if (posY + size.Y) > scrSiz.Y - GUI_INSET then 
         posY = scrSiz.Y - GUI_INSET - size.Y
      end

      posX = refPos.X - size.X - self._offset
      if posX  < 0 then 
         -- on right
         posX = refPos.X + refSiz.X + self._offset
      end
   
   else
      -- right
      posY = refPos.Y + (refSiz.Y/2) - (size.Y/2)
      if posY < - GUI_INSET then 
         posY = - GUI_INSET
      end
      if (posY + size.Y) > scrSiz.Y - GUI_INSET then 
         posY = scrSiz.Y - GUI_INSET - size.Y
      end

      posX = refPos.X + refSiz.X + self._offset
      if (posX + size.X) > scrSiz.X then 
         -- on left
         posX = refPos.X - size.X - self._offset
      end
   end

   self.Frame.Position  = UDim2.new(0, posX, 0, posY+GUI_INSET)
   self.Frame.Visible   = true

   -- on Change _reference property Show Again
end

function Popover:Hide()
   self.Frame.Visible = false
end

function Popover:Destroy()
   self.Frame.Parent = nil
   self.Frame = nil
   self._reference = nil
end

local PANEL_MIN_WIDTH   = 250
local PANEL_MAX_WIDTH   = 500
local PANEL_MIN_HEIGHT  = 100
local SNAP_TOLERANCE    = 15

-- os painéis que servem de guia para movimentação e resize
local SNAP_PANELS = {}

local Panel = {}
Panel.__index = Panel

function Panel.new()
   local Frame = GUIUtils.CreateFrame()
   Frame.Name 			            = "Panel"
   Frame.Size 			            = UDim2.new(0, 250, 0, 250)
   Frame.BackgroundTransparency  = 0.9
   Frame.Parent                  = Constants.SCREEN_GUI
  
   local Content = GUIUtils.CreateFrame()
   Content.Name 			            = "Content"
   Content.BackgroundTransparency   = 1
   Content.Position 			         = UDim2.new(0, 5, 1, 0)
   Content.Size 			            = UDim2.new(1, -5, 0, 100)
   Content.Parent = Frame

   local TitleFrame = GUIUtils.CreateFrame()
   TitleFrame.Name 			         = "Title"
   TitleFrame.BackgroundColor3      = Constants.FOLDER_COLOR
   TitleFrame.Size 			         = UDim2.new(1, 0, 0, 30)
   TitleFrame.Parent = Frame

   local LabelText = GUIUtils.CreateLabel()
   LabelText.Position 			      = UDim2.new(0, 16, 0, 0)
   LabelText.Size 			         = UDim2.new(1, -16, 1, -1)
   LabelText.Parent = TitleFrame

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local Closed = Instance.new('BoolValue')
   Closed.Name     = 'Closed'
   Closed.Value    = false
   Closed.Parent   = Frame

   local Label = Instance.new('StringValue')
   Label.Name = 'Label'
   Label.Parent = Frame

   local connections = {}

   table.insert(connections, GUIUtils.OnClick(TitleFrame, function(el, input)
      Closed.Value = not Closed.Value
   end))

   table.insert(connections, Label.Changed:connect(function()
      LabelText.Text = Label.Value
   end))

   return setmetatable({
      _detached      = false,
      _atached       = false,
      _disconnect    = Misc.DisconnectFn(connections, function()
         Frame.Parent = nil
      end),
      Closed         = Closed,
      Label          = Label,
      Frame          = Frame,
      TitleFrame     = TitleFrame,
   }, Panel)
end

function Panel:Destroy()
   self._disconnect()
   if self._detached == true then 
      self._disconnectDetach()
   end
   if self._atached == true then 
      self._disconnectAtach()
   end
end

function Panel:Atach()
   if self._detached == true then 
      self._disconnectDetach()
   end
   if self._atached == true then 
      return
   end

   self._atached     = true
   local connections = {}

   local BorderBottom = GUIUtils.CreateFrame()
   BorderBottom.Name 			         = "BorderBottom"
   BorderBottom.BackgroundColor3       = Constants.BORDER_COLOR
   BorderBottom.Position 			      = UDim2.new(0, 0, 1, -1)
   BorderBottom.Size 			         = UDim2.new(1, 0, 0, 1)
   BorderBottom.ZIndex                 = 2
   BorderBottom.Parent = self.Frame

   local Chevron = GUIUtils.CreateImageLabel(Constants.ICON_CHEVRON)
   Chevron.Name 			            = "Chevron"
   Chevron.Position 			         = UDim2.new(0, 6, 0.5, -3)
   Chevron.Size 			            = UDim2.new(0, 5, 0, 5)
   Chevron.ImageColor3              = Constants.LABEL_COLOR
   Chevron.Rotation                 = 90
   Chevron.Parent = self.TitleFrame

   if self.Closed.Value then
      Chevron.Rotation = 0
   else
      Chevron.Rotation = 90
   end

   table.insert(connections, self.Closed.Changed:connect(function(closed)
      if closed then
         Chevron.Rotation = 0
      else
         Chevron.Rotation = 90
      end
   end))

   self._disconnectAtach = Misc.DisconnectFn(connections, function()
      self._atached        = false
      Chevron.Parent       = nil
      BorderBottom.Parent  = nil
   end)
end

function Panel:Detach()
   if self._atached == true then 
      self._disconnectAtach()
   end
   if self._detached == true then 
      return
   end

   self._detached    = true
   local connections = {}

   -- Resizable
   local ResizeHandle = GUIUtils.CreateFrame()
   ResizeHandle.Name 			            = "ResizeHandleSE"
   ResizeHandle.BackgroundTransparency  = 1
   ResizeHandle.Size 			            = UDim2.new(0, 20, 0, 20)
   ResizeHandle.Position 			      = UDim2.new(1, -17, 1, -17)
   ResizeHandle.ZIndex                  = 10
   ResizeHandle.Parent = self.Frame

   local ResizeIcon = GUIUtils.CreateImageLabel(Constants.ICON_RESIZE_SE)
   ResizeIcon.Size         = UDim2.new(0, 11, 0, 11)
   ResizeIcon.ImageColor3  = Constants.BACKGROUND_COLOR
   ResizeIcon.Parent       = ResizeHandle

   -- table.insert(connections, GUIUtils.OnHover(Resize, function(hover)
   --    isHover = hover
   --    update()
   -- end))

   local framePosStart
   local sizeStart
   local mouseCursor
   local isHover
   local isScaling
   local mouseCursorOld

   table.insert(connections, GUIUtils.OnDrag(self.TitleFrame, function(el, event, startPos, position, delta)
      if event == 'start' then
         framePosStart = Vector2.new(self.Frame.Position.X.Offset, self.Frame.Position.Y.Offset)

      elseif event == 'end' then
         framePosStart = nil

      elseif event == 'drag' then
         local framePos = framePosStart + delta
         self:Move(framePos.X, framePos.Y)
      end
   end, 10))

   local function updateMouse()
      if isHover or isScaling then         
         if mouseCursorOld == nil then 
            mouseCursorOld = Mouse.Icon
         end
         Mouse.Icon = mouseCursor
      else
         Mouse.Icon = mouseCursorOld or ''
      end
   end

   table.insert(connections, GUIUtils.OnHover(ResizeHandle, function(hover)
      isHover = hover

      if hover then 
         mouseCursor = Constants.CURSOR_RESIZE_SE
      end
      updateMouse()
   end))

   table.insert(connections, GUIUtils.OnDrag(ResizeHandle, function(el, event, startPos, position, delta)
      if event == 'start' then
         isScaling = true
         sizeStart = Vector2.new(self.Frame.Size.X.Offset, self.Frame.Size.Y.Offset)
         updateMouse()
         
      elseif event == 'end' then
         isScaling = false
         sizeStart = nil
         updateMouse()

      elseif event == 'drag' then
         local frameSize = sizeStart + delta
         self:Resize(frameSize.X, frameSize.Y)
      end
   end))

   self._disconnectDetach = Misc.DisconnectFn(connections, function()
      self._detached          = false
      ResizeHandle.Parent   = nil

      if SNAP_PANELS[self] then 
         SNAP_PANELS[self] = nil
      end
   end)

   self:_updateSnapInfo()
end

--[[
   Só permite redimensionar o painel se ele estiver separado
]]
function Panel:Resize(width, height)
   if self._detached ~= true then 
      return
   end

   local frame = self.Frame

   local left  = frame.Position.X.Offset
   local top   = frame.Position.Y.Offset

   local x1 = left
   local x2 = left + width
   local y1 = top
   local y2 = top + height
   
   --[[
         t
      l  +----------------+ r
         |                |
         |                |
         +----------------+  
         b

         y1
      x1 +----------------+ x2
         |                |
         |                |
         +----------------+
         y2
   ]]
   for p, other in pairs(SNAP_PANELS) do
      local canSnap = true
      if
         p == self or
         x1 > other.r + SNAP_TOLERANCE or 
         x2 < other.l - SNAP_TOLERANCE or
         y1 > other.b + SNAP_TOLERANCE or
         y2 < other.t - SNAP_TOLERANCE
      then 
         canSnap = false
      end

      if canSnap then
         
         -- ts
         if math.abs( other.t - y2 ) <= SNAP_TOLERANCE then
            height = other.t - y1
         end

         -- bs
         if math.abs( other.b - y2 ) <= SNAP_TOLERANCE then 
            height = other.b - y1
         end
         
         -- ls
         if math.abs( other.l - x2 ) <= SNAP_TOLERANCE then 
            width = other.l - x1
         end
         
         -- rs
         if math.abs( other.r - x2 ) <= SNAP_TOLERANCE then 
            width = other.r - x1
         end
      end
   end
   
   width    = math.clamp(width, PANEL_MIN_WIDTH, PANEL_MAX_WIDTH)
   height   = math.clamp(height, PANEL_MIN_HEIGHT, Camera.ViewportSize.Y)   
   frame.Size = UDim2.new(0, width, 0, height)

   self:_updateSnapInfo()
end

function Panel:Move(left, top)
   if self._detached ~= true then 
      return
   end

   local frame = self.Frame

   local width    = frame.Size.X.Offset
   local height   = frame.Size.Y.Offset

   local x1 = left
   local x2 = left + width
   local y1 = top
   local y2 = top + height

   --[[
      @see https://github.com/jquery/jquery-ui/blob/main/ui/widgets/draggable.js

         t
      l  +----------------+ r
         |                |
         |                |
         +----------------+  
         b

         y1
      x1 +----------------+ x2
         |                |
         |                |
         +----------------+
         y2

   ]]
   for p, other in pairs(SNAP_PANELS) do
      local canSnap = true
      if
         p == self or
         x1 > other.r + SNAP_TOLERANCE or 
         x2 < other.l - SNAP_TOLERANCE or
         y1 > other.b + SNAP_TOLERANCE or
         y2 < other.t - SNAP_TOLERANCE
      then 
         canSnap = false
      end

      if canSnap then          
         ----------------------------------
         -- outer
         ----------------------------------
         
         -- ts
         if math.abs( other.t - y2 ) <= SNAP_TOLERANCE then 
            top = other.t - height
         end
         
         -- bs
         if math.abs( other.b - y1 ) <= SNAP_TOLERANCE then 
            top = other.b
         end
         
         -- ls
         if math.abs( other.l - x2 ) <= SNAP_TOLERANCE then 
            left = other.l - width
         end
         
         -- rs
         if math.abs( other.r - x1 ) <= SNAP_TOLERANCE then 
            left = other.r
         end

         ----------------------------------
         -- inner
         ----------------------------------

         -- ts
         if math.abs( other.t - y1 ) <= SNAP_TOLERANCE then 
            top = other.t
         end
         
         -- bs
         if math.abs( other.b - y2 ) <= SNAP_TOLERANCE then 
            top = other.b - height
         end
         
         -- ls
         if math.abs( other.l - x1 ) <= SNAP_TOLERANCE then 
            left = other.l
         end
         
         -- rs
         if math.abs( other.r - x2 ) <= SNAP_TOLERANCE then 
            left = other.r - width
         end
      end
   end

   local screenGUI = frame.Parent
   local posMaxX = screenGUI.AbsoluteSize.X - width
   local posMaxY = screenGUI.AbsoluteSize.Y - height
   
   left = math.clamp(left, 0, math.max(posMaxX, 0))
   top = math.clamp(top, 0, math.max(posMaxY, 0))
   frame.Position = UDim2.new(0, left, 0, top)

   self:_updateSnapInfo()   
end

--[[
   Para os painéis que estão soltos, atualiza sua dimensão e posição, usado para que o snap aconteça durante o move e
   resize
]]
function Panel:_updateSnapInfo()
   local frame    = self.Frame
   local width    = frame.Size.X.Offset
   local height   = frame.Size.Y.Offset
   local left     = frame.Position.X.Offset
   local top      = frame.Position.Y.Offset

   SNAP_PANELS[self] = {
      l = left,
      r = left + width,
      t = top,
      b = top + height
   }
end

function GUIUtils.CreatePanel(reference, size, position, offset)
   return Panel.new(reference, size, position, offset)
end


function GUIUtils.CreatePopover(reference, size, position, offset)
   return Popover.new(reference, size, position, offset)
end

function GUIUtils.CreateImageLabel(image)
   local Check = Instance.new("ImageLabel")
   Check.Name 			            = "Icon"
   Check.AnchorPoint	            = Vector2.new(0, 0)
   Check.BackgroundTransparency  = 1
   Check.BorderSizePixel 			= 0
   Check.Selectable              = false
   Check.Position 			      = UDim2.new(0, 4, 0, 4)
   Check.Size 			            = UDim2.new(1, -8, 1, -8)
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
   Instantiating a generic TextLabel
]]
function GUIUtils.CreateLabel(params)
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
function GUIUtils.CreateControllerWrapper(config)

   if config.Height == nil then
      config.Height = 30
   end

   if config.Color == nil then
      config.Color = Color3.fromRGB(27, 42, 53)
   end

   local Controller = GUIUtils.CreateFrame()   
   Controller.Name 			            = config.Name
   Controller.Size 			            = UDim2.new(1, 0, 0, config.Height)

   local LabelValue = Instance.new('StringValue')
   LabelValue.Name = 'Label'
   LabelValue.Parent = Controller

   local LabelText = GUIUtils.CreateLabel()
   LabelText.Position 			      = UDim2.new(0, 10, 0, 0)
   LabelText.Size 			         = UDim2.new(0.4, -10, 1, -1)
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

   table.insert(connections, LabelValue.Changed:Connect(function()
      LabelText.Text = LabelValue.Value
   end))

   return Controller, Control, Misc.DisconnectFn(connections)
end

local ActiveDummy =  Instance.new('BoolValue')
ActiveDummy.Value = true

local RenderDummy = function(text)
   return text
end

local ParseDummy = RenderDummy


local TEXT_REPLICATE_ATTRS = {}

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

   local TextFake = GUIUtils.CreateLabel()
   TextFake.Name              = 'TextBoxFake'
   TextFake.Position          = Text.Position
   TextFake.TextXAlignment    = Text.TextXAlignment
   TextFake.TextYAlignment    = Text.TextYAlignment
   TextFake.TextColor3        = Text.TextColor3
   TextFake.Size              = Text.Size
   TextFake.Parent = TextFrame

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------
  
   local connections    = {}
   local focused        = false
   local OnFocused      = Instance.new('BindableEvent')
   local OnFocusLost    = Instance.new('BindableEvent')

   table.insert(connections, Value.Changed:Connect(function()
      Text.Text      = config.Render(Value.Value)
      TextFake.Text  = Text.Text
   end))

   table.insert(connections, Text.Focused:Connect(function()
      focused = true

      if config.ChangeColors then
         Text.TextColor3            = Constants.INPUT_COLOR_FOCUS_TXT
         TextFrame.BackgroundColor3 = Constants.INPUT_COLOR_FOCUS	
      end

      OnFocused:Fire()
   end))
   
   table.insert(connections, Text.FocusLost:Connect(function(enterPressed, input)
      focused        = false

      if config.ChangeColors then
         Text.TextColor3            = config.Color
         TextFrame.BackgroundColor3 = Constants.INPUT_COLOR
      end
      
      Value.Value    = config.Parse(Text.Text, Value)
      Text.Text      = config.Render(Value.Value)
      TextFake.Text  = Text.Text

      OnFocusLost:Fire()
   end))

   table.insert(connections, GUIUtils.OnHover(TextFrame, function(hover)
      if not focused then
         if hover then 
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
            if hover then 
               TextFrame.BackgroundColor3 = Constants.INPUT_COLOR_HOVER
            else
               TextFrame.BackgroundColor3 = Constants.INPUT_COLOR
            end
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
   local absPosX, absPosY, absSizeX, absSizeY, posX, posY

   local isHover     = false
   local isDragging  = false

   local OnFocused      = Instance.new('BindableEvent')
   local OnFocusLost    = Instance.new('BindableEvent')

   local function updateColors()
      if isHover or isDragging then 
         Slider.BackgroundColor3    = Constants.INPUT_COLOR_HOVER
         SliderFG.BackgroundColor3 = Constants.NUMBER_COLOR_HOVER
      else
         Slider.BackgroundColor3    = Constants.INPUT_COLOR
         SliderFG.BackgroundColor3  = Constants.NUMBER_COLOR
      end
   end

   table.insert(connections, GUIUtils.OnHover(Slider, function(hover)
      isHover = hover
      updateColors()
   end))

   table.insert(connections, GUIUtils.OnDrag(Slider, function(el, event, startPos, position, delta)
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
         Value.Value = Misc.MapRange(Percent.Value, 0, 1, Min.Value, Max.Value)
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
            Percent.Value = Misc.MapRange(Value.Value, Min.Value, Max.Value, 0, 1)
         end)
      end
   end))

   table.insert(connections, Min.Changed:Connect(function()
      Value.Value = math.clamp(Value.Value, Min.Value, Max.Value)
      spawn(function()
         Percent.Value = Misc.MapRange(Value.Value, Min.Value, Max.Value, 0, 1)
      end)
   end))

   table.insert(connections, Max.Changed:Connect(function()
      Value.Value = math.clamp(Value.Value, Min.Value, Max.Value)
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

local EVENT_SEQ               = 0
local IS_DRAGGING             = false
local HOVER_ELEMENTS_REF      = {}
local TOPMOST_HOVER_ELM       = nil

local function updateTopmost(x, y)
   local objects = Player.PlayerGui:GetGuiObjectsAtPosition(x, y)
   TOPMOST_HOVER_ELM = nil
   for _, obj in ipairs(objects) do
      for _, ref in ipairs(HOVER_ELEMENTS_REF) do
         if ref.Element == obj then
            TOPMOST_HOVER_ELM = obj
            return
         end
      end
   end
end

UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		updateTopmost(input.Position.X, input.Position.Y)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
      updateTopmost(input.Position.X, input.Position.Y)
	end
end)

local function checkForHoverAfterDrag()
   for _, ref in ipairs(HOVER_ELEMENTS_REF) do
      if ref.Element == TOPMOST_HOVER_ELM then
         ref.Callback(true)
         return
      end
   end
end

function GUIUtils.OnHover(element, callback, ignoreZindex)

   local connections = {}

   local reference = { Element = element, Callback = callback }
   table.insert(HOVER_ELEMENTS_REF, reference)

   table.insert(connections, element.MouseEnter:Connect(function()
      if IS_DRAGGING then
         return
      end
      
      if TOPMOST_HOVER_ELM == element or ignoreZindex == true then
         callback(true)
      end
   end))

   table.insert(connections, element.MouseMoved:Connect(function()
      if IS_DRAGGING then
         return
      end
      
      if TOPMOST_HOVER_ELM == element or ignoreZindex == true then
         callback(true)
      end
   end))
   
   table.insert(connections, element.MouseLeave:Connect(function()
      callback(false)
   end))

   -- init check
   spawn(function()
      local pos = element.AbsolutePosition
      local siz = element.AbsoluteSize
      local tx = pos.X
      local ty = pos.Y
      if
         Mouse.X >= tx and
         Mouse.Y >= ty and
         Mouse.X <= tx + siz.X and
         Mouse.Y <= ty + siz.Y
      then
         if IS_DRAGGING then
            return
         end
         if TOPMOST_HOVER_ELM == element or ignoreZindex == true then
            callback(true)
         end
      end
   end)

   return Misc.DisconnectFnEvent(connections, function()
      local idx = table.find(HOVER_ELEMENTS_REF, reference)
      if idx ~= nil then
         table.remove(HOVER_ELEMENTS_REF, idx)
      end
   end)
end

function GUIUtils.OnFocus(element, callback)

   EVENT_SEQ = EVENT_SEQ+1

   local actionName  = 'dat.Gui.OnClick_'..EVENT_SEQ
   local isHover     = false
   local connections = {}
   
   table.insert(connections,  GUIUtils.OnHover(element, function(hover)
      isHover = hover
   end))
   
   ContextActionService:BindAction(actionName, function(actionName, inputState, input)
      if not isHover or inputState ~= Enum.UserInputState.End then
         return Enum.ContextActionResult.Pass
      end

      callback(element, input)
      
      return Enum.ContextActionResult.Sink
   end, false, Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch)

   return Misc.DisconnectFnEvent(connections, function()
      ContextActionService:UnbindAction(actionName)
   end)
end


--[[
   Adiciona um evento de onClick em um elemento
]]
function GUIUtils.OnClick(element, callback)

   EVENT_SEQ = EVENT_SEQ+1

   local actionName  = 'dat.Gui.OnClick_'..EVENT_SEQ
   local isHover     = false
   local connections = {}
   
   table.insert(connections,  GUIUtils.OnHover(element, function(hover)
      isHover = hover
   end))
   
   ContextActionService:BindAction(actionName, function(actionName, inputState, input)
      if not isHover or inputState ~= Enum.UserInputState.End then
         return Enum.ContextActionResult.Pass
      end

      callback(element, input)
      
      return Enum.ContextActionResult.Sink
   end, false, Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch)

   return Misc.DisconnectFnEvent(connections, function()
      ContextActionService:UnbindAction(actionName)
   end)
end

--[[
   Adiciona um evento de scroll em um elemento
]]
function GUIUtils.OnScroll(element, callback)

   EVENT_SEQ = EVENT_SEQ+1

   local actionName  = 'dat.Gui.OnScroll_'..EVENT_SEQ
   local isHover     = false
   local connections = {}
   
   table.insert(connections, GUIUtils.OnHover(element, function(hover)
      isHover = hover
   end, true))
   
   ContextActionService:BindActionAtPriority(actionName, function(actionName, inputState, input)
      if not isHover or input.UserInputState ~= Enum.UserInputState.Change then
         return Enum.ContextActionResult.Pass
      end


      callback(element, input)
      
      return Enum.ContextActionResult.Sink
   end, false, 999999999, Enum.UserInputType.MouseWheel)

   return Misc.DisconnectFnEvent(connections, function()
      ContextActionService:UnbindAction(actionName)
   end)
end

--[[
   Adiciona funcionalidade de Drag
]]
function GUIUtils.OnDrag(element, callback, offset)

   EVENT_SEQ = EVENT_SEQ + 1

   local actionName  = 'dat.Gui.OnDrag_'..EVENT_SEQ
   local isHover     = false
   local isDragging  = false
   local connections = {}
   local startPos    = nil
   local hasBegin    = true

   if offset == nil then 
      offset = 0
   end

   table.insert(connections, GUIUtils.OnHover(element, function(hover)
      isHover = hover
   end))

   ContextActionService:BindActionAtPriority(actionName, function(actionName, inputState, input)
      if isDragging  then

         if inputState == Enum.UserInputState.End then
            
            local wasDragging = IS_DRAGGING

            isDragging = false
            IS_DRAGGING = false
            checkForHoverAfterDrag()

            if wasDragging then
               callback(element, 'end')
               return Enum.ContextActionResult.Sink
            else
               return Enum.ContextActionResult.Pass
            end
         end
         
         local position = Vector2.new(input.Position.X, input.Position.Y)
         local delta    = position - startPos
         
         if IS_DRAGGING then
            callback(element, 'drag', startPos, position, delta)
            return Enum.ContextActionResult.Sink
         else
            -- start real drag after offset
            if math.abs(delta.X) > offset or math.abs(delta.Y) > offset then
               IS_DRAGGING = true
               callback(element, 'start', startPos)
               callback(element, 'drag', startPos, position, delta)
               return Enum.ContextActionResult.Sink
            end
         end
      elseif inputState == Enum.UserInputState.Begin and input.UserInputType ~= Enum.UserInputType.MouseMovement then
         if isHover then
            isDragging  = true
            startPos = Vector2.new(input.Position.X, input.Position.Y)
         end
      end
      
      return Enum.ContextActionResult.Pass
   end, false, 999999999, Enum.UserInputType.MouseMovement, Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch)

   return Misc.DisconnectFnEvent(connections, function()
      ContextActionService:UnbindAction(actionName)
   end)
end

-- teste
local panelA = Panel.new()
panelA:Detach()
-- local panelB = Panel.new()

local panelB = Panel.new()
panelB:Detach()

local panelC = Panel.new()
panelC:Detach()


return GUIUtils
