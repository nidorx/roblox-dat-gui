local TweenService 		   = game:GetService("TweenService")

-- lib
local Lib = game.ReplicatedStorage:WaitForChild('Lib')
local Misc                 = require(Lib:WaitForChild("Misc"))
local GUIUtils             = require(Lib:WaitForChild("GUI"))
local GuiEvents            = require(Lib:WaitForChild("GuiEvents"))
local Constants            = require(Lib:WaitForChild("Constants"))

local Scrollbar = {}
Scrollbar.__index = Scrollbar

local SCROLL_WIDTH   = 5

local TWEEN_INFO = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

function Scrollbar.new(parent, content, contentOffset)

   if contentOffset == nil then 
      contentOffset = 0
   end

   local Frame = GUIUtils.CreateFrame()
   Frame.Name 			            = "Scrollbar"
   Frame.BackgroundColor3        = Constants.BACKGROUND_COLOR
   Frame.BackgroundTransparency  = 0
   Frame.Position 			      = UDim2.new(1, -SCROLL_WIDTH, 0, contentOffset)
   Frame.Parent = parent

   local Thumb = GUIUtils.CreateFrame()
   Thumb.Name 			            = "Thumb"
   Thumb.BackgroundColor3        = Constants.SCROLLBAR_COLOR
   Thumb.BackgroundTransparency  = 0
   Thumb.Position 			      = UDim2.new(0, 0, 0, 0)
   Thumb.Size 			            = UDim2.new(1, 0, 0, 0)
   Thumb.Parent = Frame

   local contentPosition = Instance.new('NumberValue')
   contentPosition.Name    = 'ContentPosition'
   contentPosition.Value   = 0
   contentPosition.Parent  = Frame

   local contentHeight = Instance.new('NumberValue')
   contentHeight.Name    = 'ContentHeight'
   contentHeight.Value   = 0
   contentHeight.Parent  = Frame

   local parentHeight = Instance.new('IntValue')
   parentHeight.Name    = 'ParentHeight'
   parentHeight.Value   = 0
   parentHeight.Parent  = Frame

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------   

   local visible = false
   local positionTween, sizeTween 

   local function updatePosition()
      if Frame.Visible == false then
         return
      end
      
      if positionTween ~= nil then
         positionTween:Cancel()
      end
      
      positionTween = TweenService:Create(Thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { 
         Position = UDim2.new(0.3, 0, contentPosition.Value/contentHeight.Value, 0)
      })
      
      positionTween:Play()
   end

   local function updateSize()

      local thumbSize = (parent.AbsoluteSize.Y-contentOffset)/(contentHeight.Value)

      if thumbSize >= 1 then
         Thumb.Visible = false
         Frame.Size = UDim2.new(0, SCROLL_WIDTH, 0, contentHeight.Value)
      else
         Thumb.Visible = true
         Frame.Size  = UDim2.new(0, SCROLL_WIDTH, 1, -contentOffset)
         
         if sizeTween ~= nil then
            sizeTween:Cancel()
         end

         sizeTween = TweenService:Create(Thumb, TWEEN_INFO, { 
            Size = UDim2.new(1, 0, thumbSize, 0)
         })
         
         sizeTween:Play()
         
         updatePosition()
      end
   end

   local connections = {}

   table.insert(connections, parentHeight.Changed:connect(updateSize))
   table.insert(connections, contentHeight.Changed:connect(updateSize))
   table.insert(connections, contentPosition.Changed:connect(updatePosition))


   local self = setmetatable({
      ['_parent']           = parent, 
      ['_content']          = content,
      ['_parentHeight']     = parentHeight,
      ['_contentHeight']    = contentHeight,
      ['_contentPosition']  = contentPosition,
      ['_contentOffset']    = contentOffset     
   }, Scrollbar)

   self._disconnect = Misc.DisconnectFn(connections, function()
      if self._cancelOnScroll ~= nil then 
         self._cancelOnScroll()
      end

      if self._tween ~= nil then
         self._tween:Cancel()
      end

      if positionTween ~= nil then
         positionTween:Cancel()
      end
      
      if sizeTween ~= nil then
         sizeTween:Cancel()
      end
      
      Frame.Parent = nil
   end)

   return self
end

function Scrollbar:Destroy()
   self._disconnect()
end

function Scrollbar:Update()

   -- remove events
   if self._cancelOnScroll ~= nil then 
      self._cancelOnScroll()
      self._cancelOnScroll = nil
   end

	local frameHeight      = self._parent.Size.Y.Offset
	local contentHeight    = self._content.AbsoluteSize.Y

	if contentHeight > frameHeight - self._contentOffset then

		-- scroll
		self._content.Size 			= UDim2.new(1, -SCROLL_WIDTH, 0, contentHeight)

		local maxPosition			   = -(contentHeight - frameHeight)	
		
		-- animate to new position, if needed
		if self._content.Position.Y.Offset ~= 0 then
			
			local newPosition = math.min(math.max(self._content.Position.Y.Offset, maxPosition), 0)
			
			if self._tween ~= nil then
				self._tween:Cancel()
			end
			
			self._tween = TweenService:Create(self._content, TWEEN_INFO, { 
				Position = UDim2.new(0, 0, 0, newPosition)		 
			})
			
			self._tween:Play()
			
			self._contentPosition.Value = -newPosition
		end

      self._cancelOnScroll = GuiEvents.OnScroll(self._parent, function(z)

         local newPosition = math.min(math.max(self._content.Position.Y.Offset + (z), maxPosition), 0)
				
         if self._tween ~= nil then
            self._tween:Cancel()
         end
         
         self._tween = TweenService:Create(self._content, TWEEN_INFO, { 
            Position =  UDim2.new(0, 0, 0, newPosition)		 
         })
         
         self._tween:Play()         
         self._contentPosition.Value = -newPosition
      end)
	else
		self._contentPosition.Value      = 0
		self._content.Size 					= UDim2.new(1, -SCROLL_WIDTH, 1, 0)
		
		if self._content.Position.Y.Offset ~= 0 then
			-- scroll to top
			if self._tween ~= nil then
				self._tween:Cancel()
			end		
			self._tween = TweenService:Create(self._content, TWEEN_INFO, { 
				Position = UDim2.new(0, 0, 0, 0)		 
			})		
			self._tween:Play()
		end
	end
	
	self._contentHeight.Value  = contentHeight - self._contentOffset
	self._parentHeight.Value   = self._parent.AbsoluteSize.Y
end

return Scrollbar
