local Players              = game:GetService('Players')
local Player               = Players.LocalPlayer or Players:GetPropertyChangedSignal('LocalPlayer'):Wait()
local PlayerGui            = Player:WaitForChild("PlayerGui")

local SCREEN_GUI = Instance.new("ScreenGui")
SCREEN_GUI.Name 			   = "dat.GUI"
SCREEN_GUI.IgnoreGuiInset	= true -- fullscreen
SCREEN_GUI.ZIndexBehavior 	= Enum.ZIndexBehavior.Sibling
SCREEN_GUI.DisplayOrder    = 6
SCREEN_GUI.Parent 			= PlayerGui

local MODAL_GUI = Instance.new("ScreenGui")
MODAL_GUI.Name 			   = "dat.GUI.Modal"
MODAL_GUI.IgnoreGuiInset	= true -- fullscreen
MODAL_GUI.ZIndexBehavior 	= Enum.ZIndexBehavior.Sibling
MODAL_GUI.DisplayOrder     = 7
MODAL_GUI.Parent 			   = PlayerGui

-- https://devforum.roblox.com/t/gui-absoluteposition-doesnt-respect-ignoreguiinset/1168583/5
local GUI_INSET = 36

return {
   ['GUI_INSET']                 = GUI_INSET,
   ['SCREEN_GUI']                = SCREEN_GUI,
   ['MODAL_GUI']                 = MODAL_GUI,
   -- general
   ['BACKGROUND_COLOR']          = Color3.fromRGB(26, 26, 26),
   ['BACKGROUND_COLOR_HOVER']    = Color3.fromRGB(17, 17, 17),
   ['SCROLLBAR_COLOR']           = Color3.fromRGB(103, 103, 103),
   ['BORDER_COLOR']              = Color3.fromRGB(44, 44, 44),
   ['BORDER_COLOR_2']            = Color3.fromRGB(85, 85, 85),
   ['LABEL_COLOR']               = Color3.fromRGB(238, 238, 238),
   ['LABEL_COLOR_DISABLED']	   = Color3.fromRGB(136, 136, 136),
   ['CLOSE_COLOR']               = Color3.fromRGB(234, 53, 51),
   -- folder
   ['FOLDER_COLOR']              = Color3.fromRGB(0, 0, 0),
   -- boolean
   ['BOOLEAN_COLOR'] 			   = Color3.fromRGB(128, 103, 135),
   ['CHECKBOX_COLOR_ON'] 	      = Color3.fromRGB(47, 161, 214),
   ['CHECKBOX_COLOR_OFF'] 	      = Color3.fromRGB(60, 60, 60),
   ['CHECKBOX_COLOR_HOVER']      = Color3.fromRGB(48, 48, 48),
   ['CHECKBOX_COLOR_IMAGE']      = Color3.fromRGB(255, 255, 255),
   -- string
   ['STRING_COLOR']              = Color3.fromRGB(30, 211, 111),
   -- number
   ['NUMBER_COLOR']		         = Color3.fromRGB(47, 161, 214),
   ['NUMBER_COLOR_HOVER']		   = Color3.fromRGB(68, 171, 218),
   -- function
   ['FUNCTION_COLOR']		      = Color3.fromRGB(230, 29, 95),
   -- input
   ['INPUT_COLOR'] 	            = Color3.fromRGB(48, 48, 48),
   ['INPUT_COLOR_HOVER']	      = Color3.fromRGB(60, 60, 60),
   ['INPUT_COLOR_FOCUS']         = Color3.fromRGB(73, 73, 73),
   ['INPUT_COLOR_FOCUS_TXT']     = Color3.fromRGB(255, 255, 255),
   ['INPUT_COLOR_PLACEHOLDER']   = Color3.fromRGB(117, 117, 117),
   -- icons
   ['ICON_CHEVRON']              = 'rbxassetid://6690562401',
   ['ICON_CHECKMARK']            = 'rbxassetid://6690588631',
   ['ICON_RESIZE']               = 'rbxassetid://6690641141',
   ['ICON_DRAG']                 = 'rbxassetid://6690641345',
   ['ICON_RESIZE_SE']            = 'rbxassetid://6700720657',
   ['ICON_PIN']                  = 'rbxassetid://6690641252',
   -- Cursor
   ['CURSOR_RESIZE_SE']          = 'rbxassetid://6700682562',
}




