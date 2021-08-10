local Players              = game:GetService('Players')
local Player               = Players.LocalPlayer or Players:GetPropertyChangedSignal('LocalPlayer'):Wait()
local Mouse                = Player:GetMouse()

local Lib = game.ReplicatedStorage:WaitForChild('Lib')
local Misc        = require(Lib:WaitForChild("Misc"))
local Timer       = require(Lib:WaitForChild("Timer"))
local Popover     = require(Lib:WaitForChild("Popover"))
local Constants   = require(Lib:WaitForChild("Constants"))
local GuiEvents   = require(Lib:WaitForChild("GuiEvents"))
local GUIUtils    = require(Lib:WaitForChild("GUIUtils"))
local Scrollbar   = require(Lib:WaitForChild("Scrollbar"))

local MIN_WIDTH         = 250
local MAX_WIDTH         = 500
local MIN_HEIGHT        = 60
local HEADER_HEIGHT     = 30
local SNAP_TOLERANCE    = 15
local ACTION_SIZE       = 10
local ACTION_PADDING    = 5
local ACTION_FRAME_SIZE = ACTION_SIZE + ACTION_PADDING*2
local ACTION_MARGIN     = (HEADER_HEIGHT-ACTION_FRAME_SIZE)/2

local PANEL_ID_SEQ         = 0
local PANEL_ZINDEX         = 0

-- the panels that serve as a guide for moving and resize
local SNAP_PANELS = {}
local PANEL_BY_ID = {}

local Panel = {}
Panel.__index = Panel

Panel.MIN_WIDTH = MIN_WIDTH

--[[
   The basic structure of the GUI. Can be used to create custom dashboards outside of the DAT.GUI framework
]]
function Panel.new()

   PANEL_ID_SEQ = PANEL_ID_SEQ + 1

   local ID = PANEL_ID_SEQ

   local Frame = GUIUtils.createFrame()
   Frame.Name 			               = 'Panel'
   Frame.Size 			               = UDim2.new(0, 250, 0, 250)
   Frame.BackgroundTransparency     = 0.95
   Frame.ClipsDescendants           = true
   Frame.LayoutOrder                = 0
  
   local Content = GUIUtils.createFrame()
   Content.Name 			            = 'Content'
   Content.BackgroundTransparency   = 1
   Content.Position 			         = UDim2.new(0, 5, 0, HEADER_HEIGHT)
   Content.Size 			            = UDim2.new(1, -5, 0, -HEADER_HEIGHT)
   Content.Parent = Frame

   local Header = GUIUtils.createFrame()
   Header.Name 			            = 'Header'
   Header.BackgroundColor3          = Constants.FOLDER_COLOR
   Header.Size 			            = UDim2.new(1, 0, 0, HEADER_HEIGHT)
   Header.Parent = Frame

   local Border = GUIUtils.createFrame()
   Border.Name 			            = 'BorderBottom'
   Border.BackgroundColor3          = Constants.BORDER_COLOR
   Border.Position 			         = UDim2.new(0, 0, 1, -1)
   Border.Size 			            = UDim2.new(1, 0, 0, 1)
   Border.ZIndex                    = 1
   Border.Parent = Header

   local LabelText = GUIUtils.createTextLabel()
   LabelText.Name                   = 'Label'
   LabelText.Position 			      = UDim2.new(0, 16, 0, 0)
   LabelText.Size 			         = UDim2.new(1, -16, 1, -1)
   LabelText.Parent = Header

   local onDestroy = Instance.new('BindableEvent')

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local Closed = Instance.new('BoolValue')
   Closed.Name     = 'Closed'
   Closed.Value    = false
   Closed.Parent   = Frame

   local Label = Instance.new('StringValue')
   Label.Name     = 'Label'
   Label.Parent   = Frame

   local panel =  setmetatable({
      ['_id']        = ID,
      ['_detached']  = false,
      ['_atached']   = false,
      ['_onDestroy'] = onDestroy,
      ['_actions']   = {},
      ['Closed']     = Closed,
      ['Label']      = Label,
      ['LabelText']  = LabelText,
      ['Frame']      = Frame,
      ['Content']    = Content,
      ['Header']     = Header
   }, Panel)
   
   Frame:SetAttribute('IsPanel', true)
   Frame:SetAttribute('PanelId', ID)
   Frame:SetAttribute('IsClosed', false)
   
   local connections = {}

   local lastChildLayoutOrder = 0

   -- quando remove e adiona o mesmo objeto, ele deve voltar ao seu lugar original
   table.insert(connections, Content.ChildAdded:Connect(function(child)
      local layoutOrder = child:GetAttribute('LayoutOrderOnPanel_'..ID)
      if layoutOrder == nil then 
         layoutOrder = lastChildLayoutOrder
         lastChildLayoutOrder = lastChildLayoutOrder+1
      end
      child.LayoutOrder = layoutOrder
      child:SetAttribute('LayoutOrderOnPanel_'..ID, layoutOrder)
   end))

   table.insert(connections, GuiEvents.onDown(Header, function(el, input)
      if panel._detached == true then
         PANEL_ZINDEX = PANEL_ZINDEX + 1
         Frame.ZIndex = PANEL_ZINDEX
      end
   end))
   
   table.insert(connections, GuiEvents.onClick(Header, function()
      Closed.Value = not Closed.Value
      return false
   end))
   
   -- On close/open
   table.insert(connections, Closed.Changed:connect(function()
      Frame:SetAttribute('IsClosed', Closed.Value)
      panel:updateContentSize()
	end))

   table.insert(connections, Label.Changed:connect(function()
      LabelText.Text = Label.Value
   end))

   local function updateContentSize()
      panel:updateContentSize()
   end

   table.insert(connections, Content.ChildAdded:Connect(updateContentSize))
   table.insert(connections, Content.ChildRemoved:Connect(updateContentSize))

   panel._disconnect = Misc.disconnectFn(connections, function()
      Frame.Parent = nil
   end)

   PANEL_BY_ID[panel._id] = panel

   return panel
end

--[[
   Add an action button on the right side of the header

   @param config.icon         {string}       Required
   @param config.title        {string}       Optional
   @param config.color        {Color3}       Optional
   @param config.colorHover   {Color3}       Optional
   @param config.onHover      {function()}   Optional
   @param config.onClick      {function()}   Optional

   @return { frame:Frame, remove: function() }
]]
function Panel:addAction(config)

   local frame = GUIUtils.createFrame()
   frame.Name 			               = 'Action'
   frame.Position 			         = UDim2.new(0, ACTION_MARGIN, 0, 0)
   frame.Size 			               = UDim2.new(0,  ACTION_FRAME_SIZE, 0, ACTION_FRAME_SIZE)
   frame.BackgroundTransparency     = 1
   frame.Parent = self.Header

   local icon = GUIUtils.createImageLabel(config.icon)
   icon.Name 			            = 'Icon'
   icon.Position 			         = UDim2.new(0, ACTION_PADDING, 0, ACTION_PADDING)
   icon.Size 			            = UDim2.new(0, ACTION_SIZE, 0, ACTION_SIZE)
   icon.ImageTransparency        = 0.7
   icon.Parent = frame

   local color = config.color
   if color == nil then
      color = Constants.LABEL_COLOR
   end
   local colorHover = config.colorHover
   if colorHover == nil then
      colorHover = color
   end
   icon.ImageColor3 = color

   local connections = {}

   local popover = nil
   if config.title ~= nil then
      local text = GUIUtils.createTextLabel()
      text.BackgroundColor3         = Constants.BACKGROUND_COLOR
      text.BackgroundTransparency   = 0
      text.BorderSizePixel 			= 1
      text.BorderColor3             = Constants.BORDER_COLOR
      text.Name                     = 'Title'
      text.TextWrapped              = true
      text.RichText                 = true
      text.TextXAlignment           = Enum.TextXAlignment.Center
      text.Text                     = config.title

      -- to calculate TextBounds
      text.Parent = Constants.SCREEN_GUI
      popover = Popover.new(frame, text.TextBounds + Vector2.new(4, 2), 'top', 0)
      text.Parent = popover.Frame
   end

   table.insert(connections, GuiEvents.onHover(frame, function(hover)
      if hover then
         icon.ImageColor3 = colorHover
         icon.ImageTransparency = 0

         if popover ~= nil then
            popover:show()
         end
      else
         icon.ImageColor3 = color
         icon.ImageTransparency = 0.7

         if popover ~= nil then
            popover:hide()
         end
      end

      if config.onHover ~= nil then
         config.onHover(hover)
      end
   end))
   
   if config.onClick ~= nil then
      table.insert(connections, GuiEvents.onClick(frame, function()
         config.onClick()
         return false
      end))
   end

   local action
   action = {
      ['frame'] = frame,
      ['remove'] = Misc.disconnectFn(connections, function()
         frame.Parent = nil
         local idx = table.find(self._actions, action)
         if idx ~= nil then
            table.remove(self._actions, idx)
         end

         if popover ~= nil then
            popover:destroy()
            popover = nil
         end

         self:_updateActions()
      end)
   }
   table.insert(self._actions, action)
   
   self:_updateActions()

   return action
end

--[[
   Add this panel to another element.

   When doing this, the panel loses some features like scrollbar, resizing and moving

   @param parent {Frame}
   @param isFixed {Bool} When true, no longer allow unpin this panel
]]
function Panel:attachTo(parent, isFixed)
   if self._detached == true then 
      self._disconnectDetach()
   end
   if self._atached == true then 
      return
   end

   self._atached     = true
   local connections = {}

   self.Frame.Size 			            = UDim2.new(1, 0, 0, 250)
   self.Frame.Visible                  = true
   self.Frame.BackgroundTransparency   = 1
   self.Frame.ZIndex                   = 0
   -- self.Content.Position 			      = UDim2.new(0, 5, 0, HEADER_HEIGHT)
   self.Content.Position               = UDim2.new(0, 5, 0, 0)
   self.LabelText.TextXAlignment       = Enum.TextXAlignment.Left

   local ChevronIcon = GUIUtils.createImageLabel(Constants.ICON_CHEVRON)
   ChevronIcon.Name 			            = 'Chevron'
   ChevronIcon.Position 			      = UDim2.new(0, 6, 0.5, -3)
   ChevronIcon.Size 			            = UDim2.new(0, 5, 0, 5)
   ChevronIcon.ImageColor3             = Constants.LABEL_COLOR
   ChevronIcon.Rotation                = 90
   ChevronIcon.Parent = self.Header

   self.Frame.Parent = parent

   local function onCloseChange()
      if self.Closed.Value then
         ChevronIcon.Rotation = 0
      else
         ChevronIcon.Rotation = 90
      end
      self:updateContentSize()
   end

   onCloseChange()

   table.insert(connections, self.Closed.Changed:Connect(onCloseChange))

   if isFixed ~= true then
      self._detachAction = self:addAction({
         icon = Constants.ICON_PIN,
         title = "Detach",
         onClick = function()
            self:detach()
         end
      })
   end

   self._disconnectAtach = Misc.disconnectFn(connections, function()
      self._atached        = false
      ChevronIcon.Parent   = nil

      if self._detachAction ~= nil then
         local action = self._detachAction
         self._detachAction = nil
         action.remove()
      end

      self._hasDetachIcon = false
   end)
end

--[[
   Unpin this panel from the parent element

   @param closeable {bool} When true, display panel close button, if false, display panel atach button
]]
function Panel:detach(closeable)
   if self._atached == true then
      if closeable  ~= true then
         self._detachedFrom = self.Frame.Parent
      end
      self._disconnectAtach()
   end
   
   if self._detached == true then 
      return
   end

   self._detached    = true
   local connections = {}

   self.Frame.Visible                  = false
   self.Frame.BackgroundTransparency   = 0.95
   self.LabelText.TextXAlignment       = Enum.TextXAlignment.Center
   self.Content.Position 	            = UDim2.new(0, 0, 0, 0)

   PANEL_ZINDEX = PANEL_ZINDEX + 1
   self.Frame.ZIndex = PANEL_ZINDEX
   
   local InnerShadow = GUIUtils.createImageLabel('rbxassetid://6704730899')
   InnerShadow.Name 			      = 'Shadow'
   InnerShadow.Position 		   = UDim2.new(0, 0, 1, 0)
   InnerShadow.Size 			      = UDim2.new(1, 0, 0, 20)
   InnerShadow.ImageColor3       = Color3.fromRGB(0, 0, 0)
   InnerShadow.ImageTransparency = 0.5
   InnerShadow.Parent = self.Header

   -- Resizable
   local ResizeHandle = GUIUtils.createFrame()
   ResizeHandle.Name 			         = 'ResizeHandleSE'
   ResizeHandle.BackgroundTransparency = 1
   ResizeHandle.Size 			         = UDim2.new(0, 20, 0, 20)
   ResizeHandle.Position 			      = UDim2.new(1, -17, 1, -17)
   ResizeHandle.ZIndex                 = 10
   ResizeHandle.Parent = self.Frame

   local ResizeIcon = GUIUtils.createImageLabel(Constants.ICON_RESIZE_SE)
   ResizeIcon.Size               = UDim2.new(0, 11, 0, 11)
   ResizeIcon.ImageColor3        = Constants.LABEL_COLOR
   ResizeIcon.ImageTransparency  = 0.8
   ResizeIcon.Parent             = ResizeHandle

   local function onCloseChange()

      if self.Closed.Value then
         ResizeHandle.Visible = false
      else
         ResizeHandle.Visible = true
      end
      
      self:updateContentSize()
   end

   if closeable  == true then
      self._closeAction = self:addAction({
         icon  = Constants.ICON_CLOSE,
         title = "Close",
         colorHover = Constants.CLOSE_COLOR,
         onClick = function()
            self:destroy()
         end
      })
   end

   -- adiciona habilidade de reconectar-se ao lugar de origem
   local Atach
   if self._detachedFrom ~= nil then 
      local origin = self._detachedFrom
      self._atachAction = self:addAction({
         icon = Constants.ICON_PIN,
         title = "Atach",
         onClick = function()
            self:attachTo(origin)
         end
      })

      local width  = self.Frame.AbsoluteSize.X
      local height = self.Frame.AbsoluteSize.Y
      local left   = self.Frame.AbsolutePosition.X - (width+10)

      if left < 0 then 
         -- right side
         left = self.Frame.AbsolutePosition.X + ( width + 10)
      end

      local top = self.Frame.AbsolutePosition.Y + Constants.GUI_INSET

      Timer.SetTimeout(function()
         self:resize(width, height)
         self:move(left, top)
         onCloseChange()
      end, 0)
   end

   self.Frame.Parent = Constants.SCREEN_GUI

   local framePosStart
   local sizeStart
   local mouseCursor
   local isHover
   local isScaling
   local mouseCursorOld

   onCloseChange()

   table.insert(connections, self.Closed.Changed:Connect(onCloseChange))

   table.insert(connections, GuiEvents.onDrag(self.Header, function(event, startPos, position, delta)
      if event == 'start' then
         framePosStart = Vector2.new(self.Frame.Position.X.Offset, self.Frame.Position.Y.Offset)

      elseif event == 'end' then
         framePosStart = nil

      elseif event == 'drag' then
         local framePos = framePosStart + delta
         self:move(framePos.X, framePos.Y)
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

   table.insert(connections, GuiEvents.onHover(ResizeHandle, function(hover)
      isHover = hover

      if hover then 
         mouseCursor = Constants.CURSOR_RESIZE_SE
      end
      updateMouseOnResize()
   end))

   table.insert(connections, GuiEvents.onDrag(ResizeHandle, function(event, startPos, position, delta)
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
         self:resize(frameSize.X, frameSize.Y)
      end
   end))

   table.insert(connections, Constants.SCREEN_GUI.Changed:Connect(function()
      local pos = self.Frame.AbsolutePosition
      self:move(pos.X, pos.Y)
   end))
   
   self._scrollbar = Scrollbar.new(self.Frame, self.Content, HEADER_HEIGHT)
   
   self:updateContentSize()

   self._disconnectDetach = Misc.disconnectFn(connections, function()
      self._scrollbar:destroy()

      ResizeHandle.Parent     = nil
      InnerShadow.Parent      = nil
      
      if self._atachAction ~= nil then 
         local action = self._atachAction
         self._atachAction = nil
         action.remove()
      end

      if self._closeAction ~= nil then 
         local action = self._closeAction
         self._closeAction = nil
         action.remove()
      end
      
      if SNAP_PANELS[self] then 
         SNAP_PANELS[self] = nil
      end
      
      self._openSize          = nil
      self._detached          = false
   end)

   self:_updateSnapInfo()
end

--[[
   Allows you to resize the panel only if it is separated
]]
function Panel:resize(width, height)
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
   
   width    = math.clamp(width, MIN_WIDTH, MAX_WIDTH)
   height   = math.clamp(height, MIN_HEIGHT, Constants.SCREEN_GUI.AbsoluteSize.Y)   
   frame.Size = UDim2.new(0, width, 0, height)

   self._size = {
      Width    = width,
      Height   = height
   }

   self:_checkConstraints()
   self:_updateSnapInfo()
   self:updateContentSize()
end

--[[
   Allows the panel to be moved (only when it is not fixed)

   @param hor  {Number|"left"|"right"|"center"} Horizontal position. If negative, consider the position from the 
      right edge of the screen
   @param vert {Number|"top"|"bottom"|"center"} Vertical position. If negative, consider the position from the bottom 
      edge of the screen
]]
function Panel:move(hor, vert)
   if self._detached ~= true then 
      return
   end
   local frame = self.Frame
   local screenGUI = frame.Parent

   local width    = frame.Size.X.Offset
   local height   = frame.Size.Y.Offset

   if hor == 'center' then 
      hor = (screenGUI.AbsoluteSize.X/2) - (width/2)
   elseif hor == 'left' then 
      hor = 15
   elseif hor == 'right' then 
      hor = screenGUI.AbsoluteSize.X - (width + 15) 
   end

   if vert == 'center' then 
      vert = (screenGUI.AbsoluteSize.Y/2) - (height/2)
   elseif vert == 'top' then 
      vert = 0
   elseif vert == 'bottom' then 
      vert = screenGUI.AbsoluteSize.Y - height
   end

   local left = hor
   local top  = vert

   if left < 0 then
      left = screenGUI.AbsoluteSize.X - (width + 15) + left
   end

   if top < 0 then
      top = screenGUI.AbsoluteSize.Y - height + top
   end

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

  
   local posMaxX = screenGUI.AbsoluteSize.X - width
   local posMaxY = screenGUI.AbsoluteSize.Y - height

   left = math.clamp(left, 0, math.max(posMaxX, 0))
   top = math.clamp(top, 0, math.max(posMaxY, 0))
   frame.Position = UDim2.new(0, left, 0, top)

   self:_checkConstraints()
   self:_updateSnapInfo()
end

--[[
   Force update of content size information. Informs parents about the content
   update and triggers the scrollbar update
]]
function Panel:updateContentSize()
   Timer.Clear(self._updateContentSizeTimeout)
   self._updateContentSizeTimeout = Timer.SetTimeout(function()
      
      local oldHeight = self.Frame.AbsoluteSize.Y
      local newHeight = oldHeight
      
      -- itera sobre todos os elementos ajustando suas posições relativas e contabilizando o tamanho total do conteúdo
      if self.Closed.Value == true then
         self.Content.Visible = false
         newHeight = HEADER_HEIGHT
      else
         self.Content.Visible = true

         -- sort by layout order
         -- use https://developer.roblox.com/en-us/api-reference/class/UIListLayout ?
         
         local layoutOrders = {}
         local layoutOrdersChild = {}
         
         for _, child in pairs(self.Content:GetChildren()) do
            local layoutOrder = child:GetAttribute('LayoutOrderOnPanel_'..self._id)
            table.insert(layoutOrders, layoutOrder)
            layoutOrdersChild[layoutOrder] = child
         end
         
         table.sort(layoutOrders)
         
         local position = HEADER_HEIGHT
         for _, layoutOrder in ipairs(layoutOrders) do
            local child = layoutOrdersChild[layoutOrder]
            child.Position = UDim2.new(0, 0, 0, position)
            position = position + child.AbsoluteSize.Y
         end
         newHeight = position

         if self._detached == true then
            newHeight = math.max(MIN_HEIGHT, newHeight)
         end
      end
      
      self.Frame.Visible = true
      if oldHeight ~= newHeight then
         if self._detached == true then
            self.Content.Size       = UDim2.new(1, 0, 0, newHeight)
            
            local frame = self.Frame

            if self.Closed.Value then
               frame.Size = UDim2.new(0, frame.Size.X.Offset, 0, HEADER_HEIGHT)
            else
               local width    = frame.Size.X.Offset
               local height   = math.max(MIN_HEIGHT, newHeight)

               if self._size then
                  width    = self._size.Width
                  height   = self._size.Height    
               end
               frame.Size = UDim2.new(0, width, 0, height)
            end
            self:_checkConstraints()
            self:_updateSnapInfo()

            Timer.SetTimeout(function()
               self._scrollbar:update()
            end, 10)
         else
            self.Frame.Size   = UDim2.new(1, 0, 0, newHeight)
            self.Content.Size = UDim2.new(1, -5, 1, 0)

            local parent = self:_getParentPanel()
            if parent ~= nil then 
               parent:updateContentSize()
            end
         end
      end
   end, 10)
end

--[[
   Add a callback to be executed when this panel is destroyed

   @param callback {function}
   @return RBXScriptConnection
]]
function Panel:onDestroy(callback)
   return self._onDestroy.Event:Connect(callback)
end

--[[
   destroy this instance
]]
function Panel:destroy()
   self._disconnect()

   if self._detached == true then 
      self._disconnectDetach()
   end
   if self._atached == true then 
      self._disconnectAtach()
   end

   for i,action in ipairs(self._actions) do
      action.remove()
   end
   self._actions = {}

   self._onDestroy:Fire()
   PANEL_BY_ID[self._id] = nil
end

--[[
   Update header action icons
]]
function Panel:_updateActions()

   local actions = {}
   for i,action in ipairs(self._actions) do
      if action ~= self._detachAction and action ~= self._atachAction and action ~= self._closeAction then
         table.insert(actions, action)
      end
   end

   if self._detachAction ~= nil then
      table.insert(actions, self._detachAction)
   elseif self._atachAction ~= nil then
      table.insert(actions, self._atachAction)
   end

   if self._closeAction ~= nil then
      table.insert(actions, self._closeAction)
   end

   self._actions = actions

   local offset = #self._actions*ACTION_FRAME_SIZE+ACTION_MARGIN
   for i,action in ipairs(self._actions) do
      action.frame.Position = UDim2.new(1, -offset + ((i-1)*ACTION_FRAME_SIZE), 0, ACTION_MARGIN)
   end
end

function Panel:_getParentPanel()
   local frame = self.Frame.Parent;
   while frame ~= nil and frame ~= Constants.SCREEN_GUI do
      if frame:GetAttribute('IsPanel') == true then
         return PANEL_BY_ID[frame:GetAttribute('PanelId')]
      end
      frame = frame.Parent;
   end
end

--[[
   When the panel is not stuck, it checks if it is inside the screen, making the necessary movements
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

   width    = math.clamp(width, MIN_WIDTH, MAX_WIDTH)

   local minHeight = MIN_HEIGHT
   if self.Closed.Value then 
      minHeight = HEADER_HEIGHT
   end

   height   = math.clamp(height, minHeight, Constants.SCREEN_GUI.AbsoluteSize.Y)   
   frame.Size = UDim2.new(0, width, 0, height)
end

--[[
   For panels that are loose, update their dimension and position, used for snapping during move and resize
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
