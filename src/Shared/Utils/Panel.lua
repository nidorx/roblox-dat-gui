local Player               = game.Players.LocalPlayer or game.Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local Mouse                = Player:GetMouse()
local Camera 	            = workspace.CurrentCamera
local Misc                 = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Misc"))
local Constants            = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Constants"))
local GUIUtils             = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("GUI"))
local Timer                = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Timer"))
local Scrollbar            = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Scrollbar"))

local PANEL_MIN_WIDTH      = 250
local PANEL_MAX_WIDTH      = 500
local PANEL_MIN_HEIGHT     = 100
local SNAP_TOLERANCE       = 15
local PANEL_HEADER_HEIGHT  = 30

-- os painéis que servem de guia para movimentação e resize
local SNAP_PANELS = {}

local ROOT_PANELS = {}

local Panel = {}
Panel.__index = Panel

function Panel.new()
   local Frame = GUIUtils.CreateFrame()
   Frame.Name 			               = 'Panel'
   Frame.Size 			               = UDim2.new(0, 250, 0, 250)
   Frame.BackgroundTransparency     = 0.9
   Frame.ClipsDescendants           = true
   Frame.Parent                     = Constants.SCREEN_GUI
  
   local Content = GUIUtils.CreateFrame()
   Content.Name 			            = 'Content'
   Content.BackgroundTransparency   = 1
   Content.Position 			         = UDim2.new(0, 5, 0, PANEL_HEADER_HEIGHT)
   Content.Size 			            = UDim2.new(1, -5, 0, -PANEL_HEADER_HEIGHT)
   Content.Parent = Frame

   local BorderBottom = GUIUtils.CreateFrame()
   BorderBottom.Name 			      = 'BorderBottom'
   BorderBottom.BackgroundColor3    = Constants.BORDER_COLOR
   BorderBottom.Position 			   = UDim2.new(0, 0, 0, PANEL_HEADER_HEIGHT-1)
   BorderBottom.Size 			      = UDim2.new(1, 0, 0, 1)
   BorderBottom.ZIndex              = 2
   BorderBottom.Parent = Frame

   local Header = GUIUtils.CreateFrame()
   Header.Name 			            = 'Header'
   Header.BackgroundColor3          = Constants.FOLDER_COLOR
   Header.Size 			            = UDim2.new(1, 0, 0, PANEL_HEADER_HEIGHT)
   Header.Parent = Frame

   local LabelText = GUIUtils.CreateLabel()
   LabelText.Name                   = 'Label'
   LabelText.Position 			      = UDim2.new(0, 16, 0, 0)
   LabelText.Size 			         = UDim2.new(1, -16, 1, -1)
   LabelText.Parent = Header

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local Closed = Instance.new('BoolValue')
   Closed.Name     = 'Closed'
   Closed.Value    = false
   Closed.Parent   = Frame

   local Label = Instance.new('StringValue')
   Label.Name     = 'Label'
   Label.Parent   = Frame

   local panel =  setmetatable({
      _detached      = false,
      _atached       = false,
      Closed         = Closed,
      Label          = Label,
      LabelText      = LabelText,
      Frame          = Frame,
      Content        = Content,
      Header         = Header,
   }, Panel)
   
   Frame:SetAttribute('IsPanel', true)
   Frame:SetAttribute('IsClosed', false)
   
   local connections = {}
   
   table.insert(connections, GUIUtils.OnClick(Header, function(el, input)
      Closed.Value = not Closed.Value
   end))

   -- On close/open
   table.insert(connections, Closed.Changed:connect(function()
      Frame:SetAttribute('IsClosed', Closed.Value)
      panel:UpdateContentSize()
	end))

   table.insert(connections, Label.Changed:connect(function()
      LabelText.Text = Label.Value
   end))

   panel._disconnect = Misc.DisconnectFn(connections, function()
      Frame.Parent = nil
   end)

   return panel
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

   self.Frame.Size 			          = UDim2.new(1, 0, 0, 250)
   self.Frame.BackgroundTransparency = 1
   self.LabelText.TextXAlignment     = Enum.TextXAlignment.Left

   local Chevron = GUIUtils.CreateImageLabel(Constants.ICON_CHEVRON)
   Chevron.Name 			            = "Chevron"
   Chevron.Position 			         = UDim2.new(0, 6, 0.5, -3)
   Chevron.Size 			            = UDim2.new(0, 5, 0, 5)
   Chevron.ImageColor3              = Constants.LABEL_COLOR
   Chevron.Rotation                 = 90
   Chevron.Parent = self.Header

   local function onCloseChange()
      if self.Closed.Value then
         Chevron.Rotation = 0
      else
         Chevron.Rotation = 90
      end
   end
   onCloseChange()
   table.insert(connections, self.Closed.Changed:Connect(onCloseChange))

   self._disconnectAtach = Misc.DisconnectFn(connections, function()
      self._atached        = false
      Chevron.Parent       = nil
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

   ROOT_PANELS[self.Frame] = self

   self.Frame.BackgroundTransparency = 0.9
   self.LabelText.TextXAlignment     = Enum.TextXAlignment.Center

   local InnerShadow = GUIUtils.CreateImageLabel('rbxassetid://6704730899')
   InnerShadow.Name 			   = "Shadow"
   InnerShadow.Position 		= UDim2.new(0, 0, 1, 0)
   InnerShadow.Size 			   = UDim2.new(1, 0, 0, 20)
   InnerShadow.ImageColor3    = Color3.fromRGB(0, 0, 0)
   InnerShadow.Parent = self.Header

   -- Resizable
   local ResizeHandle = GUIUtils.CreateFrame()
   ResizeHandle.Name 			            = "ResizeHandleSE"
   ResizeHandle.BackgroundTransparency  = 1
   ResizeHandle.Size 			            = UDim2.new(0, 20, 0, 20)
   ResizeHandle.Position 			      = UDim2.new(1, -17, 1, -17)
   ResizeHandle.ZIndex                  = 10
   ResizeHandle.Parent = self.Frame

   local ResizeIcon = GUIUtils.CreateImageLabel(Constants.ICON_RESIZE_SE)
   ResizeIcon.Size               = UDim2.new(0, 11, 0, 11)
   ResizeIcon.ImageColor3        = Constants.LABEL_COLOR
   ResizeIcon.ImageTransparency  = 0.8
   ResizeIcon.Parent             = ResizeHandle

   local framePosStart
   local sizeStart
   local mouseCursor
   local isHover
   local isScaling
   local mouseCursorOld

   local function onCloseChange()

      local frame = self.Frame

      if self.Closed.Value then
         ResizeHandle.Visible = false

         self._openSize = {
            Width    = frame.Size.X.Offset,
            Height   = frame.Size.Y.Offset
         }

         frame.Size     = UDim2.new(0, self._openSize.Width, 0, PANEL_HEADER_HEIGHT)
      else
         ResizeHandle.Visible = true
         local width    = PANEL_MIN_WIDTH
         local height   = PANEL_MIN_HEIGHT

         if self._openSize then 
            width    = self._openSize.Width
            height   = self._openSize.Height            
         end

         self._openSize       = nil
         frame.Size     = UDim2.new(0, width, 0, height)
      end
      
      self:_checkConstraints()
      self:_updateSnapInfo()
   end

   onCloseChange()

   table.insert(connections, self.Closed.Changed:Connect(onCloseChange))

   table.insert(connections, GUIUtils.OnDrag(self.Header, function(el, event, startPos, position, delta)
      if event == 'start' then
         framePosStart = Vector2.new(self.Frame.Position.X.Offset, self.Frame.Position.Y.Offset)

      elseif event == 'end' then
         framePosStart = nil

      elseif event == 'drag' then
         local framePos = framePosStart + delta
         self:Move(framePos.X, framePos.Y)
      end
   end, 10))

   local function updateMouseOnResize()
      if isHover or isScaling then         
         if mouseCursorOld == nil then 
            mouseCursorOld = Mouse.Icon
         end
         Mouse.Icon = mouseCursor
         ResizeIcon.ImageTransparency = 0
      else
         Mouse.Icon = mouseCursorOld or ''
         ResizeIcon.ImageTransparency = 0.8
      end
   end

   table.insert(connections, GUIUtils.OnHover(ResizeHandle, function(hover)
      isHover = hover

      if hover then 
         mouseCursor = Constants.CURSOR_RESIZE_SE
      end
      updateMouseOnResize()
   end))

   table.insert(connections, GUIUtils.OnDrag(ResizeHandle, function(el, event, startPos, position, delta)
      if event == 'start' then
         isScaling = true
         sizeStart = Vector2.new(self.Frame.Size.X.Offset, self.Frame.Size.Y.Offset)
         updateMouseOnResize()
         
      elseif event == 'end' then
         isScaling = false
         sizeStart = nil
         updateMouseOnResize()

      elseif event == 'drag' then
         local frameSize = sizeStart + delta
         self:Resize(frameSize.X, frameSize.Y)
      end
   end))

   local updateTimeout

   table.insert(connections, self.Content.DescendantAdded:Connect(function(descendant)
      Timer.Clear(updateTimeout)
      updateTimeout = Timer.SetTimeout(function()
         self:UpdateContentSize()
      end, 10)
   end))

   table.insert(connections, self.Content.DescendantRemoving:Connect(function(descendant)
      Timer.Clear(updateTimeout)
      updateTimeout = Timer.SetTimeout(function()
         self:UpdateContentSize()
      end, 10)
   end))

   self._scrollbar = Scrollbar.new(self.Frame, self.Content, PANEL_HEADER_HEIGHT)

   self._disconnectDetach = Misc.DisconnectFn(connections, function()
      self._detached          = false
      ResizeHandle.Parent     = nil
      InnerShadow.Parent           = nil

      if SNAP_PANELS[self] then 
         SNAP_PANELS[self] = nil
      end

      self._scrollbar:Destroy()
      ROOT_PANELS[self.Frame] = nil
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

   self:UpdateContentSize()
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

function Panel:_getRootFrame()
   local frame = self.Frame;
   while frame.Parent ~= Constants.SCREEN_GUI do
      frame = frame.Parent;
   end
   return frame;
end

function Panel:UpdateContentSize()

   local rootFrame = self:_getRootFrame()

   local updateTimeout = rootFrame:GetAttribute("UpdateContentSizeTimeout")
   Timer.Clear(updateTimeout)

   updateTimeout = Timer.SetTimeout(function()      
      -- itera sobre todos os elementos ajustando suas posições relativas e contabilizando o tamanho total do conteúdo
      local function iterate(frame, position)
         position = position + PANEL_HEADER_HEIGHT
         local content = frame:FindFirstChild('Content')
         if frame:GetAttribute("IsClosed") == true then
            content.Visible = false
         else
            content.Visible = true
            for _, child in pairs(content:GetChildren()) do
               if child:GetAttribute("IsPanel") == true then
                  child.Position = UDim2.new(0, 0, 0, position)
                  position = position + iterate(child, 0)
               else
                  child.Position = UDim2.new(0, 0, 0, position)
                  position = position + child.AbsoluteSize.Y
               end
            end
         end
         
         if rootFrame ~= frame then
            -- title height
            frame.Size = UDim2.new(1, 0, 0, position)
         else
            -- root auto size while not resized by user
            -- frame.Size = UDim2.new(0, frame.Size.X.Offset, 0, math.min(position, frame.Parent.AbsoluteSize.Y))
            content.Size = UDim2.new(1, 0, 0, position)
         end
         
         return position
      end
      
      iterate(rootFrame, 0)

      if ROOT_PANELS[rootFrame] then 
         ROOT_PANELS[rootFrame]._scrollbar:Update()
      end
   end, 10)

   rootFrame:SetAttribute("UpdateContentSizeTimeout", updateTimeout)
end

--[[
   Quando o painel não está preso, verifica se o mesmo está  dentro da tela, fazendo as movimentações necessárias
]]
function Panel:_checkConstraints()
   if self._detached ~= true then 
      return
   end

   local frame = self.Frame

   local left     = frame.Position.X.Offset
   local top      = frame.Position.Y.Offset
   local width    = frame.Size.X.Offset
   local height   = frame.Size.Y.Offset

   local screenGUI = frame.Parent
   local posMaxX = screenGUI.AbsoluteSize.X - width
   local posMaxY = screenGUI.AbsoluteSize.Y - height
   
   left = math.clamp(frame.Position.X.Offset, 0, math.max(posMaxX, 0))
   top = math.clamp(frame.Position.Y.Offset, 0, math.max(posMaxY, 0))
   frame.Position = UDim2.new(0, left, 0, top)

   width    = math.clamp(width, PANEL_MIN_WIDTH, PANEL_MAX_WIDTH)

   local minHeight = PANEL_MIN_HEIGHT
   if self.Closed.Value then 
      minHeight = PANEL_HEADER_HEIGHT
   end

   height   = math.clamp(height, minHeight, Camera.ViewportSize.Y)   
   frame.Size = UDim2.new(0, width, 0, height)
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

return Panel
