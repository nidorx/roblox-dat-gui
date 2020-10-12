# datGUI

A lightweight graphical user interface and controller library that allows you to easily manipulate variables and fire functions on the fly, inspired by the venerable dat-gui.

dat.GUI magically generates a graphical user interface (sliders, color selector, etc) for each of your variables.

dat.gui's niche is in listening to and controlling data such that it can be visualized into charts or other graphics. Creating a new DAT.GUI instance provides a new sliding pane for which to add controls to:

## Demo

Try out the [live demo](https://www.roblox.com/games/5801132990/dat-GUI), you can edit source code too.

## Installation

1. Download the latest release [here](https://github.com/nidorx/roblox-dat-gui/releases)

2. In Roblox Studio, right click `StarterPlayer -> StarterCharacterScripts`, select "Insert from File...", and open the downloaded release

## Build

1. Make sure Rojo is installed 0.5.x or later is installed

2. Clone this repository to your computer

3. Set the location to this repo's root directory and run this command in the shell:

```powershell
rojo build -o $env:USERPROFILE/Downloads/dat.GUI.rbxmx default.project.json
```

4. Follow the installation steps, as if the file created in "Downloads" was a release

## How to use

1. In your script, import the dat.GUI and instantiate it

```lua
local datGUI = require(Character:WaitForChild("dat.GUI"))

-- Create an instance, which also creates a UI pane
local gui = datGUI.new();
```

2. With the pane ready, new controls can be added.  Fields can be of type:

    * string,
    * number,
    * boolean,
    * function,
    * Options (Enum, Array, Object),  
    * Color3,
    * Vector3, with a number slider available depending on options passed to it

Here's how you can create a field of each type:

```lua
-- My sample object
local obj = {
   name = "Alex Rodin",
   num = 1,
   winner = true
};

-- String field
gui.add(obj, "name");

-- Number field with slider
gui.add(obj, "num").min(1).max(50).step(1);

-- Checkbox field
gui.add(obj, "winner");
```
