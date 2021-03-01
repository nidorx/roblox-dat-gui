--[[
   Roblox-dat.GUI v1.2 [2021-02-28 21:05]

   A lightweight graphical user interface and controller library. 
   
   Roblox dat.GUI allows you to easily manipulate variables and fire functions on 
   the fly, inspired by the venerable dat-gui.

   dat.GUI magically generates a graphical user interface (sliders, 
   color selector, etc) for each of your variables.

   https://github.com/nidorx/roblox-dat-gui

   Discussions about this script are at https://devforum.roblox.com/t/817209

   ------------------------------------------------------------------------------

   MIT License

   Copyright (c) 2021 Alex Rodin

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in all
   copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE.
]]
local Mouse 	            = game.Players.LocalPlayer:GetMouse()
local Camera 	            = workspace.CurrentCamera
local Players 	            = game:GetService("Players")
local TweenService 		   = game:GetService("TweenService")
local UserInputService     = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local GUIUtils             = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("GUI"))
local Constants            = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Constants"))
local Misc                 = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Misc"))
local Player 	            = Players.LocalPlayer
local PlayerGui            = Player:WaitForChild("PlayerGui")

-- controllers
local Controllers             = game.ReplicatedStorage:WaitForChild("Controllers")
local ColorController			= require(Controllers:WaitForChild("ColorController"))
local OptionController 			= require(Controllers:WaitForChild("OptionController"))
local StringController 			= require(Controllers:WaitForChild("StringController"))
local BooleanController 		= require(Controllers:WaitForChild("BooleanController"))
local NumberController 			= require(Controllers:WaitForChild("NumberController"))
local FunctionController 		= require(Controllers:WaitForChild("FunctionController"))
local NumberSliderController	= require(Controllers:WaitForChild("NumberSliderController"))
local Vector3Controller			= require(Controllers:WaitForChild("Vector3Controller"))
local Vector3SliderController	= require(Controllers:WaitForChild("Vector3SliderController"))

local Constants         = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Constants"))

local BG_COLOR_ON 			= Color3.fromRGB(17, 17, 17)
local LABEL_COLOR_DISABLED	= Color3.fromRGB(136, 136, 136)



local function CreateGUIFolder(connections)

   local Folder = GUIUtils.CreateFrame()
   Folder.Name 			         = "Folder"
   Folder.BackgroundTransparency = 1
   Folder.Size 			         = UDim2.new(1, 0, 0, 30)

   local LabelValue = Instance.new('StringValue')
   LabelValue.Name = 'Label'
   LabelValue.Parent = Folder

   local UILocked = Instance.new('StringValue')
   UILocked.Name = 'UILocked'
   UILocked.Parent = Folder

   local Closed = Instance.new('BoolValue')
   Closed.Name     = 'Closed'
   Closed.Value    = false
   Closed.Parent   = Folder

   local borderBottom = GUIUtils.CreateFrame()
   borderBottom.Name 			         = "BorderBottom"
   borderBottom.BackgroundColor3       = Constants.BORDER_COLOR
   borderBottom.Position 			      = UDim2.new(0, 0, 1, -1)
   borderBottom.Size 			         = UDim2.new(1, 0, 0, 1)
   borderBottom.ZIndex                 = 2
   borderBottom.Parent = Folder

   local Content = GUIUtils.CreateFrame()
   Content.Name 			            = "Content"
   Content.BackgroundTransparency   = 1
   Content.Position 			         = UDim2.new(0, 5, 1, 0)
   Content.Size 			            = UDim2.new(1, -5, 0, 100)
   Content.Parent = Folder

   local Title = GUIUtils.CreateFrame()
   Title.Name 			            = "Title"
   Title.BackgroundColor3        = Constants.FOLDER_COLOR
   Title.Size 			            = UDim2.new(1, 0, 0, 30)
   Title.Parent = Folder

   local LabelText = GUIUtils.CreateLabel()
   LabelText.Position 			      = UDim2.new(0, 16, 0, 0)
   LabelText.Size 			         = UDim2.new(1, -16, 1, -1)
   LabelText.Parent = Title

   local Chevron = GUIUtils.CreateFrame()
   Chevron.Name 			            = "chevron"
   Chevron.BackgroundColor3         = Constants.LABEL_COLOR
   Chevron.BackgroundTransparency   = 0
   Chevron.Position 			         = UDim2.new(0, 6, 0.5, -3)
   Chevron.Size 			            = UDim2.new(0, 5, 0, 5)
   Chevron.Rotation                 = 45
   Chevron.ZIndex                   = 2
   Chevron.Parent = Title

   local ChevronMask = GUIUtils.CreateFrame()
   ChevronMask.Name 			            = "Mask"
   ChevronMask.BackgroundColor3        = Constants.FOLDER_COLOR
   ChevronMask.BackgroundTransparency  = 0
   ChevronMask.Position 			      = UDim2.new(0, -2, 0, -2)
   ChevronMask.Size 			            = UDim2.new(0, 5, 0, 5)
   ChevronMask.Rotation                = 45
   ChevronMask.ZIndex                  = 1
   ChevronMask.Parent = Chevron

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   -- variables
   local hover = false

   table.insert(connections, Title.MouseEnter:Connect(function()
      hover = true
   end))

   table.insert(connections, Title.MouseMoved:Connect(function()
      hover = true
   end))

   table.insert(connections, Title.MouseLeave:Connect(function()
      hover = false
   end))

   table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
      if gameProcessed then
         return
      end
      if hover and UILocked.Value == "ACTIVE"  and input.UserInputType == Enum.UserInputType.MouseButton1 then
         Closed.Value = not Closed.Value
      end
   end))

   table.insert(connections, Closed.Changed:connect(function()
      if Closed.Value then
         Chevron.Rotation = -45
      else
         Chevron.Rotation = 45
      end
   end))

   table.insert(connections, LabelValue.Changed:connect(function()
      LabelText.Text = LabelValue.Value
   end))

   return Folder
end

local function CreateGUIScrollbar(connections)
   local Scrollbar = GUIUtils.CreateFrame()
   Scrollbar.Name 			         = "Scrollbar"
   Scrollbar.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
   Scrollbar.BackgroundTransparency = 0
   Scrollbar.Position 			      = UDim2.new(1, 0, 0, 0)
   Scrollbar.Size 			         = UDim2.new(0, 5, 1, 0)

   local Thumb = GUIUtils.CreateFrame()
   Thumb.Name 			            = "thumb"
   Thumb.BackgroundColor3        = Color3.fromRGB(103, 103, 103)
   Thumb.BackgroundTransparency  = 0
   Thumb.Position 			      = UDim2.new(0, 0, 0.24, 0)
   Thumb.Size 			            = UDim2.new(1, 0, 0.2, 0)
   Thumb.Parent = Scrollbar

   local ContentPosition = Instance.new('NumberValue')
   ContentPosition.Name    = 'ContentPosition'
   ContentPosition.Value   = 0
   ContentPosition.Parent  = Scrollbar

   local ContentSize = Instance.new('NumberValue')
   ContentSize.Name    = 'ContentSize'
   ContentSize.Value   = 0
   ContentSize.Parent  = Scrollbar

   local FrameSize = Instance.new('IntValue')
   FrameSize.Name    = 'FrameSize'
   FrameSize.Value   = 0
   FrameSize.Parent  = Scrollbar

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------   

   local visible = false
   local ScrollTween, SizeTween 

   local function updatePosition()
      if Scrollbar.Visible == false then
         return
      end

      if ScrollTween ~= nil then
         ScrollTween:Cancel()
      end		
      ScrollTween = TweenService:Create(Thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quint,Enum.EasingDirection.Out), { 
         Position = UDim2.new(0.3, 0, ContentPosition.Value/ContentSize.Value, 0)
      })		
      ScrollTween:Play()
   end

   local function updateSize()
      local contentSize 	= ContentSize.Value
      local scrollSize 	= Scrollbar.AbsoluteSize.Y

      local thumbSize = scrollSize/contentSize

      if thumbSize >= 1 then
         Scrollbar.Visible = false
         
      else
         Scrollbar.Visible = true
         
         if SizeTween ~= nil then
            SizeTween:Cancel()
         end		
         SizeTween = TweenService:Create(Thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quint,Enum.EasingDirection.Out), { 
            Size = UDim2.new(0.7, 0, thumbSize, 0)
         })		
         SizeTween:Play()
         
         updatePosition()
      end
   end

   table.insert(connections, FrameSize.Changed:connect(updateSize))
   table.insert(connections, ContentSize.Changed:connect(updateSize))
   table.insert(connections, ContentPosition.Changed:connect(updatePosition))

   return Scrollbar
end

local function CreateGUICloseButton(connections)
   local Button = GUIUtils.CreateFrame()
   Button.Name 			         = "CloseButton"
   Button.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
   Button.BackgroundTransparency = 0
   Button.Size 			         = UDim2.new(1, 0, 0, 20)

   local ClosedValue = Instance.new('BoolValue')
   ClosedValue.Name     = 'Closed'
   ClosedValue.Value    = false
   ClosedValue.Parent   = Button

   local LabelText = GUIUtils.CreateLabel()
   LabelText.Text                   = 'Close Controls'
   LabelText.TextXAlignment         = Enum.TextXAlignment.Center
   LabelText.Parent = Button

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------   

   local hover = false

   table.insert(connections, Button.MouseEnter:Connect(function()
      hover = true
   end))

   table.insert(connections, Button.MouseMoved:Connect(function()
      hover = true
   end))

   table.insert(connections, Button.MouseLeave:Connect(function()
      hover = false
   end))

   table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
      if hover and input.UserInputType == Enum.UserInputType.MouseButton1 then
         ClosedValue.Value = not ClosedValue.Value
      end
   end))

   table.insert(connections, ClosedValue.Changed:connect(function()
      if ClosedValue.Value then
         LabelText.Text = "Open Controls"
      else
         LabelText.Text = "Close Controls"
      end
   end))

   return Button
end



-- detach (remove template from UI)

-- @TODO: create controllers for the most used classes
-- https://developer.roblox.com/en-us/api-reference/data-types
-- https://roblox.fandom.com/wiki/List_of_classes_by_category

-- A lightweight controller library for Roblox. It allows you to easily 
-- manipulate variables and fire functions on the fly.
local GUI = {}
GUI.__index = GUI

GUI.DEFAULT_WIDTH = 250

-- defines the control or GUI that has mastery over UI events
local function lockUI(gui, controller)
	
	local root = gui.getRoot()	
	
	if root.LockedController and root.LockedController ~= controller then
		root.LockedControllerNext = controller
		
		-- remove next lock after timeout
		spawn(function()
			wait(0.1)
			if root.LockedControllerNext == controller then
				root.LockedControllerNext = nil
			end
		end)
	elseif root.LockedController == nil then
		root.LockedController = controller		
		
		local function iterate(gui)	
			local locked = false
			for index = 1, #gui.children do
				local child = gui.children[index]
				if child.isGui then
					-- ignore if parent is closed
					if child.closed ~= false then
						if iterate(child) then
							-- set folder z-index
							locked = true
							child.frame.ZIndex 	 = 100	
							child.UILocked.Value 	= "ACTIVE"
						else
							child.UILocked.Value = "LOCKED"
						end
					else
						child.UILocked.Value = "LOCKED"
					end
					
				else
					if child ~= controller then
						-- Lock others
						child.frame.ZIndex 	 = 1
						child.UILocked.Value = "LOCKED"
					else
						-- Activate this	
						child.frame.ZIndex  	= 100
						child.UILocked.Value 	= "ACTIVE"
						locked = true
					end
				end
			end

			return locked
		end
		
		iterate(root)
	end
end

-- faz o unlock da controller ativa apenas quando ela solicita
local function unlockUI(gui, controller)
	
	local root = gui.getRoot()	
	
	if root.LockedController ~= nil and  root.LockedController ~= controller then		
		-- relock, only the locked component can remove the lock
		controller.frame.ZIndex  	= 1
		controller.UILocked.Value 	= "LOCKED"
		return
	end
	
	root.LockedController = nil
	
	local function iterate(gui)	
		for index = 1, #gui.children do
			local child = gui.children[index]
			
			-- reset folder and controller z-index
			child.frame.ZIndex = 1
			
			if child.isGui then
				-- dont ignores closed
				child.UILocked.Value = "ACTIVE"
				iterate(child)
			else
				child.UILocked.Value 	= "LOCKED"
			end
		end
	end
	
	iterate(root)
	
	-- has next?		
	if root.LockedControllerNext ~= nil and  root.LockedControllerNext ~= controller then	
		local nextCtrl = root.LockedControllerNext
		root.LockedControllerNext = nil
		lockUI(gui, nextCtrl)			
	end
end

-- defines the control or GUI that has mastery over UI events
local function lockAllUI(gui)
	-- controller.UILocked
	local root = gui.getRoot()
	
	root.LockedController = nil
	root.LockedControllerNext = nil
	
	local function iterate(gui)	
		for index = 1, #gui.children do
			local child = gui.children[index]
			if child.isGui then
				iterate(child)
				
			else
				child.UILocked.Value = "LOCKED"
			end
		end
	end
	
	iterate(root)
end

-- iterate across all elements to define their relative positions
local function resize(gui)
	
	local root = gui.getRoot()
	
	lockAllUI(root)
	
	local function iterate(gui, pos)
		
		if gui.closed.Value == false then
			for index = 1, #gui.children do
				local child = gui.children[index]
				child.frame.Position = UDim2.new(0, 0, 0, pos)
				
				if child.isGui then
					local childHeight = iterate(child, 0)
					pos = pos + childHeight
				else
					pos = pos + child.height
				end
			end
		end
		
		if root == gui then
			gui.frame.Size = UDim2.new(0, gui.width, 0, pos)
		else
			-- title height
			pos = pos + gui.frameTitle.Size.Y.Offset
		end	
		
		return pos
	end
	
	iterate(root, 20)
	
	-- scroll	
	
	local contentSize 		= root.frame.AbsoluteSize.Y
	local screenSize 		   = Camera.ViewportSize.Y
	local closeButtonSize   = root.closeButton.AbsoluteSize.Y
	if contentSize > screenSize - closeButtonSize then
		
		-- scroll
		local totalContentSize 		= root.frame.Size.Y.Offset
		root.Content.Size 			= UDim2.new(1, 0, 0, totalContentSize)		
		root.frame.Size 			   = UDim2.new(0, root.width, 0, screenSize)
		local maxPosition			   = -(totalContentSize - screenSize)	
		
		-- animate to new position, if needed
		if root.Content.Position.Y.Offset ~= 0 then
			
			local newPosition = math.min(math.max(root.Content.Position.Y.Offset, maxPosition), 0)
			
			if root.ScrollTween ~= nil then
				root.ScrollTween:Cancel()
			end
			
			root.ScrollTween = TweenService:Create(root.Content, TweenInfo.new(0.2, Enum.EasingStyle.Quint,Enum.EasingDirection.Out), { 
				Position =  UDim2.new(0, 0, 0, newPosition)		 
			})
			
			root.ScrollTween:Play()
			
			root.ScrollContentPosition.Value = -newPosition
		end
		
		ContextActionService:BindAction("dat.GUI.Scroll",  function(actionName, inputState, input)
			if input.UserInputType == Enum.UserInputType.MouseWheel and input.UserInputState == Enum.UserInputState.Change and root.HOVER then 
				
				local newPosition = math.min(math.max(root.Content.Position.Y.Offset + (input.Position.Z*50), maxPosition), 0)
				
				if root.ScrollTween ~= nil then
					root.ScrollTween:Cancel()
				end
				
				root.ScrollTween = TweenService:Create(root.Content, TweenInfo.new(0.2, Enum.EasingStyle.Quint,Enum.EasingDirection.Out), { 
					Position =  UDim2.new(0, 0, 0, newPosition)		 
				})
				
				root.ScrollTween:Play()
				
				root.ScrollContentPosition.Value = -newPosition
				
				return Enum.ContextActionResult.Sink
			end
			
			return Enum.ContextActionResult.Pass
		end,  false,  Enum.UserInputType.MouseWheel)
	else
		root.ScrollContentPosition.Value = 0
		root.Content.Size 					= UDim2.new(1, 0, 1, 0)
		root.closeButton.Position 			= UDim2.new(0, 0, 0, 0)
		
		if root.Content.Position.Y.Offset ~= 0 then
			-- scroll to top
			if root.ScrollTween ~= nil then
				root.ScrollTween:Cancel()
			end		
			root.ScrollTween = TweenService:Create(root.Content, TweenInfo.new(0.2, Enum.EasingStyle.Quint,Enum.EasingDirection.Out), { 
				Position =  UDim2.new(0, 0, 0, 0)		 
			})		
			root.ScrollTween:Play()
		end
		
		-- remove events
		ContextActionService:UnbindAction("dat.GUI.Scroll")
	end
	
	root.ScrollContentSize.Value	= contentSize
	root.ScrollFrameSize.Value    = root.frame.AbsoluteSize.Y
end


--[[
Constructor, Example: "local gui = dat.GUI.new({name = 'My GUI'})"

Params:
	[params]			Object		
	[params.name]		String			The name of this GUI.
	[params.load]		Object			JSON object representing the saved state of this GUI.
	[params.parent]		dat.gui.GUI		The GUI I'm nested in.
	[params.autoPlace]	Boolean	true	
	[params.hideable]	Boolean	true	If true, GUI is shown/hidden by h keypress.
	[params.closed]		Boolean	false	If true, starts closed
	[params.closeOnTop]	Boolean	false	If true, close/open button shows on top of the GUI
]]
function GUI.new(params)
	
	-- remove game UI
	game.StarterGui:SetCore("TopbarEnabled", false)
	
	if params == nil then
		params = {}
	end
	
	local gui = {
		isGui 		= true,
		parent 		= params.parent,
		_name 		= params.name,
		width 		= GUI.DEFAULT_WIDTH,
		children 	= {},
		connections = {},
	}
	
	if params == nil then
		params = {}
	end
	
	if gui.parent == nil then
		gui.GUI = Instance.new("ScreenGui")
		gui.GUI.Name 			= "dat.GUI"
		gui.GUI.IgnoreGuiInset	= true -- fullscreen
		gui.GUI.ZIndexBehavior 	= Enum.ZIndexBehavior.Sibling
		gui.GUI.Parent 			= PlayerGui
		
		gui.frame  = GUIUtils.CreateFrame()
		gui.frame.Name 						= "root"		
		gui.frame.Size 						= UDim2.new(0, gui.width, 0, 0)		
		gui.frame.Position					= UDim2.new(1, -(gui.width +15), 0, 0)
		gui.frame.BackgroundTransparency = 1
		gui.frame.Parent = gui.GUI
		
		gui.Content   = GUIUtils.CreateFrame()
		gui.Content.Name 					      = "Content"		
		gui.Content.Size 					      = UDim2.new(1, 0, 1, 0)
		gui.Content.Position 				   = UDim2.new(0, 0, 0, 20)
		gui.Content.BackgroundTransparency  = 1
		gui.Content.Parent = gui.frame
		
		-- scrollbar
		local scrollbar            = CreateGUIScrollbar(gui.connections)	
		gui.ScrollFrameSize 		   = scrollbar:WaitForChild("FrameSize")	
		gui.ScrollContentSize 		= scrollbar:WaitForChild("ContentSize")	
		gui.ScrollContentPosition 	= scrollbar:WaitForChild("ContentPosition")			
		scrollbar.Parent = gui.frame
		
		-- Global close button
		gui.closeButton = CreateGUICloseButton(gui.connections);
		gui.closeButton.Parent = gui.frame
		
		gui.closed = gui.closeButton:WaitForChild("Closed")	
		
		-- used for scroll
		gui.frame.MouseEnter:Connect(function()
			gui.HOVER = true
		end)
		
		gui.frame.MouseLeave:Connect(function()
			gui.HOVER = false
		end)
		
		-- on resize screen, resize gui		
		local onResize = Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			resize(gui)
		end)
		
		table.insert(gui.connections, onResize)
		
	else	
		gui.frame = CreateGUIFolder(gui.connections)
		gui.frame.Name 						   = "folder_"..gui._name
		gui.frameTitle 						   = gui.frame:WaitForChild("Title")
		gui.frame.BackgroundTransparency 	= 1	
		gui.frame.Parent = gui.parent.Content
		
		gui.Content    = gui.frame:WaitForChild("Content")		
		gui.closed 	   = gui.frame:WaitForChild("Closed")
		gui.UILocked   = gui.frame:WaitForChild("UILocked")
		
		local Label = gui.frame:WaitForChild("Label")
		Label.Value = gui._name
	end
	
	--resizable: params.autoPlace,
	--hideable: params.autoPlace
	--closeOnTop: false,
	--autoPlace: true,
	
	-- On close/open
	gui.closed.Changed:connect(function()		
		gui.Content.Visible = not gui.closed.Value
		resize(gui)
	end)	
	
	--[[
	Adds a new Controller to the GUI. The type of controller created is inferred from the 
	initial value of object[property]. For color properties, see addColor.

	Returns: Controller - The controller that was added to the GUI.

	Params:
		object	Object	The object to be manipulated
		property	String	The name of the property to be manipulated
		[min]	Number	Minimum allowed value
		[max]	Number	Maximum allowed value
		[step]	Number	Increment by which to change value
		
	Examples:
		Add a string controller.
			gui:add({name = 'Sam'}, 'name')
			
		Add a number controller slider.
			gui:add({age = 45}, 'age', 0, 100)
	]]
	function gui.add(object, property, ...)
		
		if object[property] == nil then
			error("Object has no property ".. property)
		end		
		
		local controller
		local initialValue 		   = object[property];
		local initialValueType 	   = type(initialValue)
		local initialValueTypeOf   = typeof(initialValue)
      local isInstance           = initialValueTypeOf == "Instance" 
		local arguments 		= {...}
		
		if initialValueTypeOf == "Vector3" or (isInstance and initialValue:IsA('Vector3Value')) then
			
			local min = arguments[1]
			local max = arguments[2]
			local step = arguments[3]

         local isVector3Value = (isInstance and initialValue:IsA('Vector3Value'))
			
			-- Has min and max? (slider)
			if min ~= nil and max ~= nil then
				controller = Vector3SliderController(gui, object, property, min, max, step, isVector3Value)
			else
				controller = Vector3Controller(gui, object, property, min, max, step, isVector3Value)
			end
			
		elseif initialValueTypeOf == "Color3"  or (isInstance and initialValue:IsA('Color3Value')) then
			controller = ColorController(gui, object, property, (isInstance and initialValue:IsA('Color3Value')))
			
		elseif initialValueTypeOf == "EnumItem" or (arguments[1] ~= nil and typeof(arguments[1]) == "Enum") then
			-- Enum options
			controller = OptionController(gui, object, property, arguments[1])
			
		elseif arguments[1] ~= nil and type(arguments[1]) == "table" then
         -- Providing options
         controller = OptionController(gui, object, property, arguments[1])
         
      elseif (initialValueTypeOf == "number" or (isInstance and initialValue:IsA('NumberValue'))) then
            
         local min = arguments[1]
         local max = arguments[2]
         local step = arguments[3]

         local isNumberValue = (isInstance and initialValue:IsA('NumberValue'))
         
         -- Has min and max? (slider)
         if min ~= nil and max ~= nil and type(min) == "number" and type(max) == "number" then
            controller = NumberSliderController(gui, object, property, min, max, step, isNumberValue)
         else
            controller = NumberController(gui, object, property, min, max, step, isNumberValue)
         end
         
      elseif (initialValueTypeOf == "boolean" or (isInstance and initialValue:IsA('BoolValue'))) then
         controller = BooleanController(gui, object, property, (isInstance and initialValue:IsA('BoolValue')))
         
      elseif (initialValueTypeOf == "string" or (isInstance and initialValue:IsA('StringValue'))) then
         local isMultiline = arguments[1] == true
         controller = StringController(gui, object, property, isMultiline, (isInstance and initialValue:IsA('StringValue')))
         
      elseif (type(initialValue) == "function") then
         controller = FunctionController(gui, object, property, arguments[1])
         
      end	
		
		if controller == nil then
			return error("It was not possible to identify the controller builder, check the parameters")
		end
		
		table.insert(gui.children, controller)
		
		-------------------------------------------------------------------------------
		-- UI Lock mechanism
		-- @see https://devforum.roblox.com/t/guis-sink-input-even-when-covered/343684
		-------------------------------------------------------------------------------
		local frame = controller.frame
		frame.Name 		= property
		controller._name = property
		
		local UILocked
		
		-- Indicates locked state UNLOCK, ACTIVE, LOCKED
		if frame:FindFirstChild("UILocked") == nil then
			UILocked = Instance.new("StringValue")
			UILocked.Name = "UILocked"
			UILocked.Parent = frame			
		end
		
		UILocked = controller.frame:WaitForChild("UILocked")
		UILocked.Value = "LOCKED"
		
		controller.UILocked = UILocked
		
		-- On mouse enter, try to register in the lock queue 	
		frame.MouseEnter:Connect(function()
			if not controller._isReadonly then
				lockUI(gui, controller)
			end			
		end)
		
		-- On mouse move, try to register in the lock queue 
		frame.MouseMoved:Connect(function()
			if not controller._isReadonly then
				lockUI(gui, controller)
			end
		end)
		
		UILocked.Changed:connect(function()			
			if UILocked.Value == "UNLOCK" then
				-- try to unlock
				unlockUI(gui, controller)	
			end
			
			if controller._isReadonly then
				frame.BackgroundColor3 = Constants.BACKGROUND_COLOR
				
			else
				if UILocked.Value == "ACTIVE" then
					frame.BackgroundColor3 = BG_COLOR_ON
				else				
					frame.BackgroundColor3 = Constants.BACKGROUND_COLOR
				end
			end
		end)
		
		frame.BackgroundColor3 = Constants.BACKGROUND_COLOR
		
		-------------------------------------------------------------------------------
		
		-- adds readonly/disabled method
		controller._isReadonly = false
		controller.readonly = function(option)
			if option == nil then
				option = true
			end
			
			controller._isReadonly = option
			
			if controller.label ~= nil then
				if controller._isReadonly then
					local lineThrough = Instance.new('Frame')
					lineThrough.Size = UDim2.new(0, controller.label.TextBounds.X, 0, 1)
					lineThrough.Position = UDim2.new(0, 0, 0.5, 0)
					lineThrough.BackgroundColor3 = LABEL_COLOR_DISABLED
					lineThrough.BackgroundTransparency = 0.4
					lineThrough.BorderSizePixel = 0
					lineThrough.Name = "LineThrough"
					lineThrough.Parent = controller.label
					
					controller.label.TextColor3 = LABEL_COLOR_DISABLED					
				else
					controller.label.TextColor3 = Constants.LABEL_COLOR					
					if controller.label:FindFirstChild("LineThrough") ~= nil then
						controller.label:FindFirstChild("LineThrough").Parent = nil
					end
				end
			end
			
			return controller
		end
		
		-- container.appendChild(name);
		-- gui.__controllers.push(controller);
		resize(gui)
		
		return controller
	end
	
	--[[
	Creates a new subfolder GUI instance.
	
	Returns: dat.GUI - The new folder.
	
	Params:
		name String The new folder.
		
	Error:
		if this GUI already has a folder by the specified name
	]]
	function gui.addFolder(name)
		
		-- We have to prevent collisions on names in order to have a key 
		-- by which to remember saved values (@TODO Future implementation, save as JSON)
		for index = 1, #gui.children do
			local child = gui.children[index]
			if child.isGui and child._name == name then
				error("You already have a folder in this GUI by the name \""..name.."\"");
			end
		end
		
		local folder = GUI.new({
			name = name, 
			parent = gui
		})
		
		table.insert(gui.children, folder)
		
		resize(gui)
		
		return folder
	end	
	
	--[[
	Removes the GUI from the game and unbinds all event listeners.
	]]
	function gui.remove()
		lockAllUI(gui)
		
		for index = 1, #gui.children do
			-- folders and controllers
			gui.children[index].remove()
		end
		
		if gui.parent ~= nil then
			gui.parent.removeChild(gui)
		end
		
		for index = 1, #gui.connections do
			gui.connections[index]:Disconnect()
		end
		
		if gui.GUI ~= nil then
			gui.GUI.Parent = nil
			gui.GUI = nil
		end
		
		if gui.frame ~= nil then
			gui.frame.Parent = nil
			gui.frame = nil
		end
		
		if gui.Content ~= nil then
			gui.Content.Parent = nil
			gui.Content = nil
		end
		
		if gui.closeButton ~= nil then
			gui.closeButton.Parent = nil
			gui.closeButton = nil
		end
		
		-- clear all references
		gui.children = {}
		gui.connections = {}
		gui.ScrollFrameSize = nil
		gui.ScrollContentSize = nil
		gui.ScrollContentPosition = nil
		gui.closed = nil
		
		-- finally
		gui = nil
	end
	
	--[[
	Removes the given controller/folder from the GUI.

	Params:
		controller	Controller
	]]
	function gui.removeChild(item)
      if item._is_removing == true then
         return
      end

		local itemIdx = -1
		for index = 1, #gui.children do
			local child = gui.children[index]
			if child == item then
            -- avoid recursion
            child._is_removing = true

            child.remove()
            itemIdx = index
				-- child.frame.Parent = nil
				break
			end
		end
		
		if itemIdx > 0 then
			table.remove(gui.children, itemIdx)
		end
		
		resize(gui)
		
		return gui
	end
	
	-- Opens the GUI
	function gui.open()
		gui.closed.Value = false
		return gui
	end
	
	-- Closes the GUI
	function gui.close()
		gui.closed.Value = true
		return gui
	end
	
	function gui.setWidth(width)
		if gui.parent == nil then			
			gui.width = width			
			gui.frame.Size		= UDim2.new(0, gui.width, 0, 0)		
			gui.frame.Position  = UDim2.new(1, -(gui.width +15), 0, 0)
			
			resize(gui)
		end
		
		return gui
	end	
	
	-- Returns: dat.GUI - the topmost parent GUI of a nested GUI.
	function gui.getRoot()
		local g = gui;
		while g.parent ~= nil do
			g = g.parent;
		end
		return g;
	end


   unlockUI(gui, nil)
	
	return gui
end

return GUI
