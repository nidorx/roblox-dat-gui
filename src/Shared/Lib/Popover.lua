local Camera 	            = workspace.CurrentCamera

-- lib
local Lib = game.ReplicatedStorage:WaitForChild('Lib')
local GUIUtils    = require(Lib:WaitForChild("GUI"))
local Constants   = require(Lib:WaitForChild("Constants"))

local POPOVER_SEQ = 0

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

   if position == nil or position == '' then 
      position = 'top'
   end

   if offset == nil then 
      offset = 0
   end

   return setmetatable({
      ['_reference']  = reference,
      ['_position']   = position,
      ['_offset']     = offset, 
      ['Frame']       = frame,      
   }, Popover)
end

function Popover:Resize(size)
   self.Frame.Size = UDim2.new(0, size.X, 0, size.Y)
   if self.Frame.Visible then
      self:Show()
   end
end

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
      if posY < -Constants.GUI_INSET then 
         -- on bottom
         posY = refPos.Y + refSiz.Y + self._offset
      end

   elseif self._position == 'bottom' then
      posX = refPos.X + (refSiz.X/2) - size.X/2

      posY = refPos.Y + refSiz.Y + self._offset
      if (posY + size.Y) > scrSiz.Y - Constants.GUI_INSET then 
         -- on top
         posY = refPos.Y - size.Y - self._offset
      end
      
   elseif self._position == 'left' then
      posY = refPos.Y + (refSiz.Y/2) - (size.Y/2)
      if posY < - Constants.GUI_INSET then 
         posY = - Constants.GUI_INSET
      end
      if (posY + size.Y) > scrSiz.Y - Constants.GUI_INSET then 
         posY = scrSiz.Y - Constants.GUI_INSET - size.Y
      end

      posX = refPos.X - size.X - self._offset
      if posX  < 0 then 
         -- on right
         posX = refPos.X + refSiz.X + self._offset
      end
   
   else
      -- right
      posY = refPos.Y + (refSiz.Y/2) - (size.Y/2)
      if posY < - Constants.GUI_INSET then 
         posY = - Constants.GUI_INSET
      end
      if (posY + size.Y) > scrSiz.Y - Constants.GUI_INSET then 
         posY = scrSiz.Y - Constants.GUI_INSET - size.Y
      end

      posX = refPos.X + refSiz.X + self._offset
      if (posX + size.X) > scrSiz.X then 
         -- on left
         posX = refPos.X - size.X - self._offset
      end
   end

   self.Frame.Position  = UDim2.new(0, posX, 0, posY+Constants.GUI_INSET)
   self.Frame.Visible   = true
end

function Popover:Hide()
   self.Frame.Visible = false
end

function Popover:Destroy()
   self.Frame.Parent = nil
   self.Frame = nil
   self._reference = nil
end

return Popover
