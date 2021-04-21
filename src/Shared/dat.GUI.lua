--[[
   Roblox-dat.GUI v1.2.2 [2021-04-10 02:50]

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
local Camera 	      = workspace.CurrentCamera

-- lib
local Lib = game.ReplicatedStorage:WaitForChild('Lib')
local Panel          = require(Lib:WaitForChild("Panel"))
local GUIUtils       = require(Lib:WaitForChild("GUI"))
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


-- @TODO: create controllers for the most used classes
-- https://developer.roblox.com/en-us/api-reference/data-types
-- https://roblox.fandom.com/wiki/List_of_classes_by_category

-- A lightweight controller library for Roblox. It allows you to easily 
-- manipulate variables and fire functions on the fly.
local DatGUI = {}
DatGUI.__index = DatGUI

--[[
   Constructor, Example: "local gui = dat.GUI.new({name = 'My GUI'})"

   Params:
      [params]             Object		
      [params.name]		   String			The name of this GUI.
      [params.load]		   Object			JSON object representing the saved state of this GUI.
      [params.parent]		dat.gui.GUI		The GUI I'm nested in.
      [params.closed]		Boolean	false	If true, starts closed
      [params.closeable]	Boolean	false	If false the panel can be moved
]]
function DatGUI.new(params)
	
	-- remove game UI
	-- game.StarterGui:SetCore("TopbarEnabled", false)
	
	if params == nil then
		params = {}
	end

   local name = params.name
   if name == nil or name == '' then
      name = 'dat.GUI'
   end

	local gui = {
		name 		   = name,
		isGui 		= true,
		parent 		= params.parent,
		children 	= {}
	}

   local width = params.width
   if width == nil or width < Panel.MIN_WIDTH then 
      width = Panel.MIN_WIDTH
   end

   local panel = Panel.new()
   gui.Panel      = panel
   gui.Content    = panel.Content
   panel.Label.Value = gui.name

   local panelOnDestroy = panel:OnDestroy(function()
      gui.remove()
   end)
	
	if gui.parent == nil then
      panel:Detach(params.closeable)
      panel:Move(Camera.ViewportSize.X-(width + 15), 0)
      panel:Resize(width, Camera.ViewportSize.Y)
      panel.Frame.Name = gui.name
	else	
		panel.Frame.Name = gui.parent.name.."_"..gui.name
      panel:AttachTo(gui.parent.Content)
	end

   local function configureController(controller, property)

      table.insert(gui.children, controller)
		
		-------------------------------------------------------------------------------
		-- UI Lock mechanism
		-- @see https://devforum.roblox.com/t/guis-sink-input-even-when-covered/343684
		-------------------------------------------------------------------------------
		local frame       = controller.frame
		frame.Name 		   = property
		controller.name   = property
		
      frame.BackgroundColor3 = Constants.BACKGROUND_COLOR
      
      GUIUtils.OnHover(frame, function(hover)
         if hover then
            frame.BackgroundColor3 = Constants.BACKGROUND_COLOR_HOVER
         else
            frame.BackgroundColor3 = Constants.BACKGROUND_COLOR
         end
      end)
		
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
					lineThrough.Size                    = UDim2.new(0, controller.label.TextBounds.X, 0, 1)
					lineThrough.Position                = UDim2.new(0, 0, 0.5, 0)
					lineThrough.BackgroundColor3        = Constants.LABEL_COLOR_DISABLED
					lineThrough.BackgroundTransparency  = 0.4
					lineThrough.BorderSizePixel         = 0
					lineThrough.Name                    = "LineThrough"
					lineThrough.Parent = controller.label
					
					controller.label.TextColor3 = Constants.LABEL_COLOR_DISABLED					
				else
					controller.label.TextColor3 = Constants.LABEL_COLOR					
					if controller.label:FindFirstChild("LineThrough") ~= nil then
						controller.label:FindFirstChild("LineThrough").Parent = nil
					end
				end
			end
			
			return controller
		end
		
		return controller
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
		local initialValue 		   = object[property];
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
		
		return configureController(controller, property)
	end

   --[[
      Adiciona um elemento personalizado

      @param name (string)    O label do controller
      @param config (object)  As configurações desse controller
         {
            Frame    = Frame,
            Color    = Color3,
            OnRemove = function
            Height   = number,
            Methods  = { [Name:String] => function }
         }
   ]]
   function gui.addCustom(name, config)      
      return configureController(CustomController(gui, name, config), name)
   end
	
	--[[
      Creates a new subfolder GUI instance.
      
      Returns: dat.GUI - The new folder.
      
      @param name (String) The new folder.
         
      Error:
         if this GUI already has a folder by the specified name
	]]
	function gui.addFolder(name)
		
		-- We have to prevent collisions on names in order to have a key 
		-- by which to remember saved values (@TODO Future implementation, save as JSON)
		for index = 1, #gui.children do
			local child = gui.children[index]
			if child.isGui and child.name == name then
				error("You already have a folder in this GUI by the name \""..name.."\"");
			end
		end
		
		local folder = DatGUI.new({
			name     = name, 
			parent   = gui
		})
		
		table.insert(gui.children, folder)
		
		return folder
	end	
	
	--[[
	   Removes the GUI from the game and unbinds all event listeners.
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
      gui.Panel:Destroy()
		
		-- finally
		gui = nil
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
      Permite redimensionar um root
   ]]
	function gui.resize(width, height)
		gui.Panel:Resize(width, height)
		return gui
	end

   --[[
      Atualiza a posição da instancia
   ]]
   function gui.move(left, top)
      gui.Panel:Move(left, top)
		return gui
	end

   if params.closed == true then 
      gui.close()
   end

	return gui
end

return DatGUI
