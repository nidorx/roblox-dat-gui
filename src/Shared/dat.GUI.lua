--[[
   Roblox-dat.GUI v1.2.4 [2021-08-10 02:02]

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

-- lib
local Lib = game.ReplicatedStorage:WaitForChild('Lib')
local Panel          = require(Lib:WaitForChild("Panel"))
local Popover        = require(Lib:WaitForChild("Popover"))
local Scrollbar      = require(Lib:WaitForChild("Scrollbar"))
local GUIUtils       = require(Lib:WaitForChild("GUIUtils"))
local GuiEvents      = require(Lib:WaitForChild("GuiEvents"))
local Constants      = require(Lib:WaitForChild("Constants"))

-- controllers
local Controllers             = game.ReplicatedStorage:WaitForChild("Controllers")
local ColorController			= require(Controllers:WaitForChild("ColorController"))
local OptionController 			= require(Controllers:WaitForChild("OptionController"))
local StringController 			= require(Controllers:WaitForChild("StringController"))
local BooleanController 		= require(Controllers:WaitForChild("BooleanController"))
local CustomController	      = require(Controllers:WaitForChild("CustomController"))
local NumberController 			= require(Controllers:WaitForChild("NumberController"))
local FunctionController 		= require(Controllers:WaitForChild("FunctionController"))
local NumberSliderController	= require(Controllers:WaitForChild("NumberSliderController"))
local Vector3Controller			= require(Controllers:WaitForChild("Vector3Controller"))
local Vector3SliderController	= require(Controllers:WaitForChild("Vector3SliderController"))

local DatGUI = {}
DatGUI.__index = DatGUI

-- expose the lib
DatGUI.Lib = {
   Panel       = Panel, 
   Popover     = Popover,
   Scrollbar   = Scrollbar,
   GUIUtils    = GUIUtils,
   GuiEvents   = GuiEvents,
   Constants   = Constants
}

local function configureController(gui, controller, property)

   table.insert(gui.children, controller)
   
   local frame       = controller.frame
   frame.Name 		   = property
   controller.name   = property
   
   local labelText      = frame:WaitForChild("LabelText")
   local labelVisible   = frame:WaitForChild("LabelVisible")

   local OnRemove = Instance.new('BindableEvent')

   local oldRemoveFn

   -- allows to be informed when the controller is removed
   controller.onRemove = function(callback)
      -- changes the behavior of the original remove from the controller
      if oldRemoveFn == nil then
         oldRemoveFn = controller.remove
         controller.remove = function()
            if controller._is_removing_parent then
               return
            end
            OnRemove:Fire()
   
            oldRemoveFn()
         end
      end

      return OnRemove.Event:Connect(callback)
   end
   
   -- show/hide label
   controller.label = function(visible)
      labelVisible.Value = visible ~= false
      return controller
   end
   
   -- Sets the name of the controller
   if type(controller.name) ~= 'function' then  
      local labelValue 	   = frame:WaitForChild("Label")
      labelValue.Value     = property

      controller.name  = function(name)
         labelValue.Value = name
         return controller
      end
   end

   -- Add a help box when the cursor is positioned over the controller
   local helpPopover
   local helpText
   local helpTitle
   function controller.help(text)
      if helpPopover == nil then
         helpPopover = Popover.new(frame, Vector2.new(200, 60), 'left', 3)
         helpPopover.Frame.BorderColor3      = Constants.LABEL_COLOR
         helpPopover.Frame.BorderSizePixel   = 1
         helpPopover.Frame.BackgroundTransparency = 0

         local helpContent = GUIUtils.createFrame()
         helpContent.Name     = "Content"
         helpContent.Size 	   = UDim2.new(1, 0, 1, 0)
         helpContent.ClipsDescendants  = true
         helpContent.Parent   = helpPopover.Frame

         local helpContentInner = GUIUtils.createFrame()
         helpContentInner.Name     = "Inner"
         helpContentInner.Parent   = helpContent

         helpTitle = GUIUtils.createTextLabel()
         helpTitle.Name       = 'Title'
         helpTitle.TextColor3 = Constants.NUMBER_COLOR
         helpTitle.Size 	   = UDim2.new(1, -6, 0, 16)
         helpTitle.Position   = UDim2.new(0, 3, 0, 0)
         helpTitle.Parent = helpContentInner

         helpText = GUIUtils.createTextLabel()
         helpText.Name        = 'Text'
         helpText.TextWrapped = true
         helpText.RichText    = true
         helpText.Size 	      = UDim2.new(1, -6, 1, 0)
         helpText.Position    = UDim2.new(0, 3, 0, 16)
         helpText.Parent = helpContentInner
        
         local scrollbar  = Scrollbar.new(helpContent, helpContentInner, 0)

         local isPopoverHover = false
         local isControllerHover = false

         local function updatePopover()
            if isControllerHover or isPopoverHover then
               helpContentInner.Size = UDim2.new(1, 0, 0, helpText.TextBounds.Y + 16)
               helpText.Size = UDim2.new(1, 0, 1, -16)

               helpTitle.Text = labelText.Text
               scrollbar:update()
               helpPopover:show(true, Constants.LABEL_COLOR)
            else
               helpPopover:hide()
            end
         end

         local cancelOnEnter = GuiEvents.onEnter(frame, function(hover)
            isControllerHover = hover
            updatePopover()
         end)

         local cancelOnEnter = GuiEvents.onHover(helpPopover.Frame, function(hover)
            isPopoverHover = hover
            updatePopover()
         end)

         controller.onRemove(function()
            cancelOnEnter()
            scrollbar:destroy()
            helpPopover:destroy()
         end)
      end

      helpText.Text = text         
      
      return controller
   end
   
   frame.BackgroundColor3 = Constants.BACKGROUND_COLOR
   
   local onHoverCancel = GuiEvents.onHover(frame, function(hover)
      if hover then
         frame.BackgroundColor3 = Constants.BACKGROUND_COLOR_HOVER
      else
         frame.BackgroundColor3 = Constants.BACKGROUND_COLOR
      end
   end)
   controller.onRemove(function()
      onHoverCancel()
   end)
   
   -- adds readonly/disabled method
   local Readonly = frame:WaitForChild("Readonly")
   Readonly.Changed:Connect(function(isReadonly)
      if labelText ~= nil then
         if isReadonly then
            local lineThrough = Instance.new('Frame')
            lineThrough.Size                    = UDim2.new(0, labelText.TextBounds.X, 0, 1)
            lineThrough.Position                = UDim2.new(0, 0, 0.5, 0)
            lineThrough.BackgroundColor3        = Constants.LABEL_COLOR_DISABLED
            lineThrough.BackgroundTransparency  = 0.4
            lineThrough.BorderSizePixel         = 0
            lineThrough.Name                    = "LineThrough"
            lineThrough.Parent = labelText
            
            labelText.TextColor3 = Constants.LABEL_COLOR_DISABLED					
         else
            labelText.TextColor3 = Constants.LABEL_COLOR					
            if labelText:FindFirstChild("LineThrough") ~= nil then
               labelText:FindFirstChild("LineThrough").Parent = nil
            end
         end
      end
   end)

   -- Disable editing of values by the controller
   controller.readonly = function(value)
      if value == nil then
         value = true
      end
      Readonly.Value = value
      return controller
   end
   
   return controller
end

--[[
   Constructor, Example: "local gui = dat.GUI.new({name = 'My GUI'})"

   Params:
      [params]             Object		
      [params.name]		   String			The name of this GUI.
      [params.parent]		dat.gui.GUI		The GUI I'm nested in.
      [params.closed]		Boolean	false	If true, starts closed
      [params.width]		   Number	      The initial width of the GUI
      [params.closeable]	Boolean	false	If true, this GUI can be permanently closed
      [params.fixed]	      Boolean	false	If true, this folder cannot be unpinned from the parent.
]]
function DatGUI.new(params)
	
	if params == nil then
		params = {}
	end

   local name = params.name
   if name == nil or name == '' then
      name = 'dat.GUI'
   end

	local gui = {
		['_name'] 		= name,
		['isGui'] 		= true,
		['parent'] 		= params.parent,
		['children']   = {}
	}

   local width = params.width
   if width == nil or width < Panel.MIN_WIDTH then 
      width = Panel.MIN_WIDTH
   end

   local panel = Panel.new()
   gui.Panel      = panel
   gui.Content    = panel.Content
   panel.Label.Value = gui._name

   local guiOnRemove    = Instance.new('BindableEvent')
   local panelOnDestroy = panel:onDestroy(function()
      gui.remove()
   end)
	
	if gui.parent == nil then
      panel:detach(params.closeable)
      panel:move(Constants.SCREEN_GUI.AbsoluteSize.X-(width + 15), 0)
      panel:resize(width, Constants.SCREEN_GUI.AbsoluteSize.Y)
      panel.Frame.Name = gui._name
	else	
		panel.Frame.Name = gui.parent._name.."_"..gui._name
      panel:attachTo(gui.parent.Content, params.fixed)
	end

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
		local initialValue 		   = object[property]
		local initialValueType 	   = type(initialValue)
		local initialValueTypeOf   = typeof(initialValue)
      local isInstance           = initialValueTypeOf == "Instance" 
		local arguments 		      = {...}
		
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
		
		return configureController(gui, controller, property)
	end

   --[[
      Allows creation of custom controllers

      @param name {string} The name of the controller
      @param config {object} The settings of this controller
         {
            frame    = Frame,       The content that will be presented in the controller
            color    = Color3,      The color of the controller's side edge
            height   = number,      the height of the content
            onRemove = function     Invoked when controller is destroyed
            methods  = {            Allows you to add custom methods that can be invoked by the instance
               [Name:String] => function 
            } 
         }
   ]]
   function gui.addCustom(name, config) 
      return configureController(gui, CustomController(gui, name, config), name)
   end

   --[[
      Add a control that displays an image.

      @param assetId {string}
      @param height {number}
      @return Controller
   ]]
   function gui.addLogo(assetId, height) 
      local frame = Instance.new('Frame')
      frame.BorderSizePixel         = 0
      frame.BackgroundTransparency  = 1

      local image = GUIUtils.createImageLabel(assetId)
      image.Name 			= 'Logo'
      image.Position 	= UDim2.new(0, 0, 0, 0)
      image.Size 			= UDim2.new(1, 0, 1, 0)
      image.ScaleType   = Enum.ScaleType.Fit
      image.Parent = frame

      local controller = gui.addCustom(assetId, {
         frame = frame,
         height = height
      }) 
      controller.label(false)

      return controller
   end
	
	--[[
      Creates a new subfolder GUI instance.
      
      Returns: dat.GUI - The new folder.
      
      @param name (String) The new folder.
         
      Error:
         if this GUI already has a folder by the specified name
	]]
	function gui.addFolder(name, params)
      if params == nil then
         params = {}
      end
      params.name = name
      params.parent = gui

		local folder = DatGUI.new(params)
		table.insert(gui.children, folder)
		return folder
	end	

   --[[
      allows to be informed when the gui is removed

      @return RBXScriptConnection
   ]]
   function gui.onRemove(callback)
      return guiOnRemove.Event:Connect(callback)
   end
	
	--[[
	   Removes the GUI and unbinds all event listeners.
	]]
	function gui.remove()
      
      if gui._is_removing_parent then
         return
      end
      
      
		for index = table.getn(gui.children), 1, -1  do
			-- folders and controllers
			gui.children[index].remove()
		end
		
		if gui.parent ~= nil then
         -- avoid recursion
         gui._is_removing_parent = true
			gui.parent.removeChild(gui)
		end

      panelOnDestroy:Disconnect()
      gui.Panel:destroy()
		
		-- finally
		gui = nil

      guiOnRemove:Fire()
	end
	
	--[[
	   Removes the given controller/folder from the GUI.

	   @param item	Controller
	]]
	function gui.removeChild(item)
      if item._is_removing_child == true then
         return
      end

		local itemIdx = -1
		for index = 1, #gui.children do
			local child = gui.children[index]
			if child == item then
            -- avoid recursion
            child._is_removing_child = true

            child.remove()
            itemIdx = index
				break
			end
		end
		
		if itemIdx > 0 then
			table.remove(gui.children, itemIdx)
		end
		
		return gui
	end
	
	-- Opens the GUI
	function gui.open()
		gui.Panel.Closed.Value = false
		return gui
	end
	
	-- Closes the GUI
	function gui.close()
		gui.Panel.Closed.Value = true
		return gui
	end
	
   --[[
      Allows to resize the gui. Only applicable when parent==nil or is unpinned from parent

      @param width {number}
      @param height {number}
   ]]
	function gui.resize(width, height)
		gui.Panel:resize(width, height)
		return gui
	end

   --[[
      Updates the position of the instance. Only applicable when parent==nil or is unpinned from parent

      @param hor  {number|"left"|"right"|"center"} If negative, consider the position from the 
         right edge of the screen
      @param vert {number|"top"|"bottom"|"center"} If negative, consider the position from the bottom 
         edge of the screen
   ]]
   function gui.move(hor, vert)
      gui.Panel:move(hor, vert)
		return gui
	end

   -- Sets the name of the gui
   function  gui.name(name)
      panel.Label.Value = name
      return gui     
   end

   -- Add a action icon
   -- @see Panel:addAction
   function gui.action(config)
      return panel:addAction(config)
   end

   if params.closed == true then 
      gui.close()
   end

	return gui
end

return DatGUI
