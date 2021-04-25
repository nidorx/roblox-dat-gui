local RunService           = game:GetService("RunService")
local UserInputService     = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Players              = game:GetService('Players')
local Player               = Players.LocalPlayer or Players:GetPropertyChangedSignal('LocalPlayer'):Wait()
local PlayerGui            = Player:WaitForChild("PlayerGui")

local Lib = game.ReplicatedStorage:WaitForChild('Lib')
local Timer                = require(Lib:WaitForChild('Timer'))

local GuiEvents = {}

local EL_EVENTS                     = {
   ['*'] = {
      ['OnEnter']       = {},
      ['OnHover']       = {},
      ['OnDown']   = {},
      ['OnUp']     = {},
      ['OnClick']       = {},
      ['OnMove']        = {},
   }
}

local CURRENT_INPUT_POSITION        = nil
local CURRENT_ENTER_OBJECTS         = {}
local NEW_ENTER_OBJECTS             = {}
local CURRENT_TOP_MOST_HOVER        = nil
local IS_DRAGGING                   = false

-- usado no onclick, que deve casar o mousedown com o mouseup
local LAST_MOUSE_DOWN_SEQ         = 0

local function addListener(element, event, callback)
   if element == nil then 
      element = '*'
   end
   local elementEvents = EL_EVENTS[element]
   if elementEvents == nil then 
      elementEvents = {
         ['OnEnter']       = {},
         ['OnHover']       = {},
         ['OnDown']   = {},
         ['OnUp']     = {},
         ['OnClick']       = {},
         ['OnMove']        = {},
      }
      EL_EVENTS[element] = elementEvents
   end

   table.insert(elementEvents[event], callback)

   return function()
      local idx = table.find(elementEvents[event], callback)
      if idx ~= nil then
         table.remove(elementEvents[event], idx)
      end
   end
end

local function isEnter(element)
   if CURRENT_INPUT_POSITION == nil then 
      return false
   else 
      local objects = Player.PlayerGui:GetGuiObjectsAtPosition(CURRENT_INPUT_POSITION.X, CURRENT_INPUT_POSITION.Y)
      return table.find(objects, element) ~= nil
   end
end

local function forceHoverFalse()
   -- call OnHover(false)
   if CURRENT_TOP_MOST_HOVER ~= nil then 
      local element = EL_EVENTS[CURRENT_TOP_MOST_HOVER]
      for _, callback in ipairs(element.OnHover) do
         callback(false)
      end
      CURRENT_TOP_MOST_HOVER = nil
   end
end

local function checkEnter()
   if CURRENT_INPUT_POSITION == nil then 
      NEW_ENTER_OBJECTS = {}
   else 
      NEW_ENTER_OBJECTS = Player.PlayerGui:GetGuiObjectsAtPosition(CURRENT_INPUT_POSITION.X, CURRENT_INPUT_POSITION.Y)
   end

   -- elementos que irão receber o evento onLeave
   local toLeave = CURRENT_ENTER_OBJECTS

   -- elementos que irão receber o evento onEnter
   local toEnter = {}

   -- o elemento que possui evento onHover e está com o maior z-index
   local topMostHover

   for _, obj in ipairs(NEW_ENTER_OBJECTS) do

      local events = EL_EVENTS[obj]

      local idx = table.find(toLeave, obj)
      if idx ~= nil then
         table.remove(toLeave, idx)
      elseif events ~= nil then
         table.insert(toEnter, obj)
      end

      if events ~= nil and #events.OnHover > 0 then
         if not IS_DRAGGING and topMostHover == nil then 
            topMostHover = obj
         end
      end
   end

   -- call OnEnter(false)
   for _, obj in ipairs(toLeave) do
      local element = EL_EVENTS[obj]
      if element ~= nil then

         -- call OnHover(false)
         if CURRENT_TOP_MOST_HOVER == obj then 
            for _, callback in ipairs(element.OnHover) do
               callback(false)
            end
            CURRENT_TOP_MOST_HOVER = nil
         end

         for _, callback in ipairs(element.OnEnter) do
            callback(false)
         end
      end
   end

   if topMostHover ~= CURRENT_TOP_MOST_HOVER and  CURRENT_TOP_MOST_HOVER ~= nil then
      -- call OnHover(false)
      local element = EL_EVENTS[CURRENT_TOP_MOST_HOVER]
      if element ~= nil then
         for _, callback in ipairs(element.OnHover) do
            callback(false)
         end
      end
   end

   -- call OnEnter(true) - odem inversa
   for i = #toEnter, 1, -1 do
      local obj = toEnter[i]
      local element = EL_EVENTS[obj]
      if element ~= nil and #element.OnEnter > 0 then
         for _, callback in ipairs(element.OnEnter) do
            callback(true)
         end
      end
   end

   -- call OnHover(true)
   if topMostHover ~= CURRENT_TOP_MOST_HOVER and topMostHover ~= nil then
      local element = EL_EVENTS[topMostHover]
      if element ~= nil then
         for _, callback in ipairs(element.OnHover) do
            callback(true)
         end
      end
   end
   CURRENT_TOP_MOST_HOVER = topMostHover
   
   CURRENT_ENTER_OBJECTS = NEW_ENTER_OBJECTS
end

local function checkDown()

   LAST_MOUSE_DOWN_SEQ = LAST_MOUSE_DOWN_SEQ + 1

   -- executa usando principio de bubling, do elemento com maior z-index para o com menor z-index
   -- se o callback retornar false, o evento deixa de ser disparado os callbacks dos elementos de tras
   for _, obj in ipairs(CURRENT_ENTER_OBJECTS) do
      local element = EL_EVENTS[obj]
      if element ~= nil then
         local stopPropagation = false
         element.LastMouseDown = LAST_MOUSE_DOWN_SEQ

         for _, callback in ipairs(element.OnDown) do
            if callback() == false then 
               stopPropagation = true
            end
         end

         if stopPropagation then 
            return true
         end
      end
   end

   for _, callback in ipairs(EL_EVENTS['*'].OnDown) do
      callback()
   end

   return false
end

local CURRENT_MOVING_CALLBACK

local function checkUp()

   local intecepted              = false
   local stopPropagationMouseUp  = false
   local stopPropagationClick    = false

   CURRENT_MOVING_CALLBACK = nil

   -- executa usando principio de bubling, do elemento com maior z-index para o com menor z-index
   -- se o callback retornar false, o evento deixa de ser disparado os callbacks dos elementos de tras
   for _, obj in ipairs(CURRENT_ENTER_OBJECTS) do
      local element = EL_EVENTS[obj]
      if element ~= nil then
         
         if not stopPropagationMouseUp then 
            for _, callback in ipairs(element.OnUp) do
               if callback() == false then 
                  intecepted = true
                  stopPropagationMouseUp = true
               end
            end
         end

         -- clicked
         if not stopPropagationClick and element.LastMouseDown == LAST_MOUSE_DOWN_SEQ then 
            intecepted = true
            for _, callback in ipairs(element.OnClick) do
               if callback() == false then 
                  stopPropagationClick = true
               end
            end
         end

         if stopPropagationMouseUp and stopPropagationClick then 
            break
         end
      end
   end

   for _, callback in ipairs(EL_EVENTS['*'].OnUp) do
      callback()
   end

   for _, callback in ipairs(EL_EVENTS['*'].OnClick) do
      callback()
   end

   LAST_MOUSE_DOWN_SEQ = LAST_MOUSE_DOWN_SEQ + 1

   return intecepted
end

local function onMove(posX, posY)
   local position = Vector2.new(posX, posY)

   local intecepted        = false
   local stopPropagation   = false

   if CURRENT_MOVING_CALLBACK ~= nil then 
      if CURRENT_MOVING_CALLBACK(position) == false then 
         intecepted = true
      end
   end

   if not CURRENT_MOVING_CALLBACK then 
      for _, obj in ipairs(CURRENT_ENTER_OBJECTS) do
         local element = EL_EVENTS[obj]
         if element ~= nil then
            
            if element.LastMouseDown == LAST_MOUSE_DOWN_SEQ then
               for _, callback in ipairs(element.OnMove) do
                  if callback(position) == false then 
                     CURRENT_MOVING_CALLBACK = callback
                     intecepted = true

                     -- invalidate any click
                     LAST_MOUSE_DOWN_SEQ = LAST_MOUSE_DOWN_SEQ + 1
                     break
                  end
               end
            end

            if intecepted then
               break
            end
         end
      end
   end

   for _, callback in ipairs(EL_EVENTS['*'].OnMove) do
      callback(position)
   end

   return intecepted
end

ContextActionService:BindActionAtPriority('GuiEventsMouseMovement', function(action, state, input)
   if input.UserInputState == Enum.UserInputState.Begin or input.UserInputState == Enum.UserInputState.Change then
      CURRENT_INPUT_POSITION = input.Position
      checkEnter()

      if input.UserInputState == Enum.UserInputState.Change then
         if onMove(input.Position.X, input.Position.Y) then
            return Enum.ContextActionResult.Sink
         end
      end

   else
      -- out of screen
      CURRENT_INPUT_POSITION = nil
      checkEnter()
   end

   return Enum.ContextActionResult.Pass
end, false, 999999, Enum.UserInputType.MouseMovement)

ContextActionService:BindActionAtPriority('GuiEventsMouseButton1', function(action, state, input)
   
   if input.UserInputState == Enum.UserInputState.Begin then
      if checkDown() then
         return Enum.ContextActionResult.Sink
      end
   elseif input.UserInputState == Enum.UserInputState.End then
      if checkUp() then
         return Enum.ContextActionResult.Sink
      end
   end

   return Enum.ContextActionResult.Pass
end, false, 999998, Enum.UserInputType.MouseButton1)

ContextActionService:BindActionAtPriority('GuiEventsTouch', function(action, state, input)
   if input.UserInputState == Enum.UserInputState.Begin or input.UserInputState == Enum.UserInputState.Change then
      CURRENT_INPUT_POSITION = input.Position
      checkEnter()

      if input.UserInputState == Enum.UserInputState.Begin then
         if checkDown() then
            return Enum.ContextActionResult.Sink
         end
      elseif input.UserInputState == Enum.UserInputState.Change then
         if onMove(input.Position.X, input.Position.Y) then
            return Enum.ContextActionResult.Sink
         end
      end
   else
      if input.UserInputState == Enum.UserInputState.End then
         if checkUp() then
            CURRENT_INPUT_POSITION = nil
            checkEnter()
            return Enum.ContextActionResult.Sink
         end
      end

      CURRENT_INPUT_POSITION = nil
      checkEnter()
   end

   return Enum.ContextActionResult.Pass
end, false, 999999, Enum.UserInputType.Touch)


local timerNewCheck

--[[
   Disparado sempre que o mouse está sobre o elemento (ou quando inicia um evento touch)
]]
function GuiEvents.OnEnter(element, callback)
   local cancel = addListener(element, 'OnEnter', callback)

   if isEnter(element) then 
      callback(true)
   end
   
   return cancel
end

--[[
   Disparado quando o mouse está sobre o elemento e este é o elemento com o Z-index mais alto
]]
function GuiEvents.OnHover(element, callback)
   local cancel = addListener(element, 'OnHover', callback)

   Timer.Clear(timerNewCheck)
   timerNewCheck = Timer.SetTimeout(checkEnter, 10)

   return cancel
end

function GuiEvents.OnDown(element, callback)
   return addListener(element, 'OnDown', callback)
end

function GuiEvents.OnUp(element, callback)
   return addListener(element, 'OnUp', callback)
end

function GuiEvents.OnClick(element, callback)
   return addListener(element, 'OnClick', callback)
end

function GuiEvents.OnMove(element, callback)
   return addListener(element, 'OnMove', callback)
end

function GuiEvents.OnDrag(element, callback, offset)

   local isDragging = false

   local cancelUp
   local cancelMove

   if offset == nil then 
      offset = 0
   end

   local startPosition

   local cancelDown = GuiEvents.OnDown(element, function()

      cancelMove = GuiEvents.OnMove(element, function(position)
         if not isDragging and startPosition == nil then 
            startPosition = position
         end

         local delta = position - startPosition

         if isDragging then
            callback('drag', startPosition, position, delta)

         elseif not isDragging and (math.abs(delta.X) >= offset or math.abs(delta.Y) >= offset) then 
            IS_DRAGGING = true
            forceHoverFalse()
            isDragging = true
            callback('start', startPosition)
         end

         return not isDragging
      end)
      
      cancelUp = GuiEvents.OnUp('*', function()
         if cancelUp ~= nil then
            cancelUp()
         end

         if cancelMove ~= nil then 
            cancelMove()
         end

         if isDragging then 
            IS_DRAGGING = false
            checkEnter()
            callback('end')
         end

         cancelUp       = nil
         cancelMove     = nil
         isDragging     = false
         startPosition  = nil
      end)
   end)

   return function()

      if isDragging then 
         IS_DRAGGING = false
         checkEnter()
         callback('end')
      end

      cancelDown()
      if cancelUp ~= nil then 
         cancelUp()
      end
      if cancelMove ~= nil then 
         cancelMove()
      end
   end
end

local EVENT_SEQ = 1

function GuiEvents.OnScroll(element, callback)

   local cancelDrag

   EVENT_SEQ = EVENT_SEQ+1
   local actionName  = 'dat.Gui.OnScroll_'..EVENT_SEQ

   local cancelEnter = GuiEvents.OnEnter(element, function(enter)

      ContextActionService:UnbindAction(actionName)

      if cancelDrag ~= nil then 
         cancelDrag()
         cancelDrag = nil
      end

      if enter then
         ContextActionService:BindActionAtPriority(actionName, function(actionName, inputState, input)
            if input.UserInputState ~= Enum.UserInputState.Change then
               return Enum.ContextActionResult.Pass
            end
      
            callback(input.Position.Z*50)
            
            return Enum.ContextActionResult.Sink
         end, false, 999999999, Enum.UserInputType.MouseWheel)

         -- for mobile
         local posY 
         cancelDrag = GuiEvents.OnDrag(element, function(event, startPos, position, delta)
            if event == 'start' then
               posY = startPos.Y
      
            elseif event == 'end' then
               posY = nil
      
            elseif event == 'drag' then
               callback((position.Y - posY)*3)
               posY = position.Y
            end
         end, 20)      
      end
   end)

   return function()
      cancelEnter()

      ContextActionService:UnbindAction(actionName)

      if cancelDrag ~= nil then 
         cancelDrag()
         cancelDrag = nil
      end
   end
end

-- local TweenService = game:GetService('TweenService')
-- local GUI = Instance.new("ScreenGui")
-- GUI.Name 			   = "teste"
-- GUI.IgnoreGuiInset	= true -- fullscreen
-- GUI.ZIndexBehavior 	= Enum.ZIndexBehavior.Sibling
-- GUI.DisplayOrder    = 10
-- GUI.Parent 			= PlayerGui

-- for a = 0, 4 do 
--    local frame = Instance.new('Frame')
--    frame.Size 			            = UDim2.new(0, 250, 0, 100)
--    frame.Position 			      = UDim2.new(0.5, -100 + a*20, 0.5, -50 + a*20)
--    frame.BackgroundColor3        = Color3.fromRGB(255, 255, 255)
--    frame.BackgroundTransparency  = 0
--    frame.BorderMode 			      = Enum.BorderMode.Outline
--    frame.BorderSizePixel 			= 1
--    frame.Draggable 			      = false
--    frame.Selectable              = false
--    frame.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
--    frame.Style 			         = Enum.FrameStyle.Custom
--    frame.ZIndex                  = 1
--    frame.Visible                 = true
--    frame.Archivable              = true
--    frame.Parent = GUI

--    local isEnter     = false
--    local isHover     = false

--    -- stop propagation on item 2
--    local propagate = a ~= 2 

--    local function update()
--       if isHover then
--          frame.BackgroundColor3 = Color3.fromRGB(255, 0, 255)

--       elseif isEnter then
--          frame.BackgroundColor3 = Color3.fromRGB(255, 255, 0)

--       else
--          frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
--       end
--    end

--    local function blink(color)
--       local tween = TweenService:Create(frame, TweenInfo.new(1), {BackgroundColor3 = color})
--       tween.Completed:Connect(function(playbackState)
--          update()
--       end)
--       tween:Play()
--    end

--    GuiEvents.OnEnter(frame, function(enter)
--       isEnter = enter
--       print('#'..a..' OnEnter ', enter)
--       update()
--    end)

--    GuiEvents.OnHover(frame, function(hover)
--       isHover = hover
--       print('#'..a..' OnHover ', hover)
--       update()
--    end)

--    GuiEvents.OnDown(frame, function()
--       print('#'..a..' MouseDown')
--       blink(Color3.fromRGB(0, 0, 255))
--       return propagate
--    end)

--    GuiEvents.OnUp(frame, function()
--       print('#'..a..' MouseUp')
--       blink(Color3.fromRGB(0, 255, 255))
--       return propagate
--    end)

--    GuiEvents.OnClick(frame, function()
--       print('#'..a..' Click')
--       blink(Color3.fromRGB(255, 0, 0))
--       return propagate
--    end)

--    local startPos
--    GuiEvents.OnDrag(frame, function(event, start, pos, delta)
--       print('#'..a..' Drag', event, start, pos, delta)
--       if event == 'start' then 
--          startPos = Vector2.new(frame.Position.X.Offset, frame.Position.Y.Offset)
--       elseif event == 'drag' then 
--          local endPos = startPos + delta
--          frame.Position = UDim2.new(0.5, endPos.X, 0.5, endPos.Y)
--       end
--       return propagate
--    end, a * 10)
-- end

return GuiEvents
