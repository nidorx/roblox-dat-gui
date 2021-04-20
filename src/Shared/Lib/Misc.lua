local Misc = {}

-- Misc.NUMBER_MIN         = -9007199254740992
-- Misc.NUMBER_MAX         = 9007199254740992
Misc.NUMBER_STEP        = 0.01
Misc.NUMBER_PRECISION   = 2
Misc.AXES   = { 'X', 'Y', 'Z' }

--[[
   Create an event disconnect function, a pattern used on all controllers
]]
function Misc.DisconnectFn(connections, ...)

   local disconnectFns = {...}

   return function()

      for _, disconnect in ipairs(disconnectFns) do
         disconnect()
      end

      for _, conn in ipairs(connections) do
         conn:Disconnect()
      end

      table.clear(connections)
   end
end

function Misc.DisconnectFnEvent(connections, ...)
   local disconnectFn = Misc.DisconnectFn(connections, table.unpack({...}))
   return {
      Disconnect = function(self)
         disconnectFn()
      end
   }
end

--[[
   Gets the number of decimals a number has
]]
function Misc.CountDecimals(x) 
   local _x = tostring(x)
   local idexOf, _ = string.find(_x, ".", 1, true)
   if idexOf ~= nil then
      return string.len(_x) - (idexOf -1) - 1
   end
   
   return 0
end

--[[
   Creating a function allows you to format text as numbers with defined precision
]]
function Misc.CreateTextNumberFn(Precision)
   return function(value)
      if value == nil then
         value = ''
      end

      if string.len(value) == 0 then
         value =  ''
      else
         value = tonumber(value)
         if value == nil then
            value =  ''
         else
            value = string.format("%."..Precision.Value.."f", value)
         end
      end
   
      return value
   end
end

function Misc.CreateTextNumberFn(Precision)
   return function(value)
      if value == nil then
         value = ''
      end
      
      if string.len(value) == 0 then
         value =  ''
      else
         value = tonumber(value)
         if value == nil then
            value =  ''
         else
            value = string.format("%."..Precision.Value.."f", value)
         end
      end
   
      return value
   end
end

--[[
   Linearly map a value from an input range to an output range
   https://rosettacode.org/wiki/Map_range#Lua
]]
function Misc.MapRange(x, inMin, inMax, outMin, outMax)
   return outMin + (x - inMin)*(outMax - outMin)/(inMax - inMin) 
end

local BLACK = Color3.fromRGB(0, 0, 0)
local WHITE = Color3.fromRGB(255, 255, 255)

--[[
   Get best contrast to collor
]]
function Misc.BestContrast(color)
   -- http://www.w3.org/TR/AERT#color-contrast
   local brightness = math.round((color.R*255 * 299 + color.G*255 * 587 + color.B*255 * 114)/1000);
   
   if brightness > 125 then
      return BLACK
   else
      return WHITE
   end
end

function Misc.Color3FromString(hex) 
   local r, g, b, hash
   if string.len(hex) == 6 then
      -- FFFFFF
      r, g, b  = hex:match("(..)(..)(..)")
   elseif string.len(hex) == 7 then
      -- #FFFFFF
      hash, r, g, b  = hex:match("(.)(..)(..)(..)")
   elseif string.len(hex) == 3 then
      -- FFF
      r, g, b  = hex:match("(.)(.)(.)")
      r = r..r
      g = g..g
      b = b..b
   elseif string.len(hex) == 4 then
      -- #FFF
      hash, r, g, b  = hex:match("(.)(.)(.)(.)")
      r = r..r
      g = g..g
      b = b..b
   else
      return nil
   end
   
   r, g, b = tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)   
   return Color3.fromRGB(r, g, b)
end

return Misc

