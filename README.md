# datGUI
<div align="center">
    <h1>Roblox dat.GUI</h1>
    <img src="./logo.png" width="350" />
    <p align="center">
        A lightweight graphical user interface and controller library
    </p>    
    <p>
        <a href="https://badge.fury.io/js/react-native-ui-blueprint">
            https://www.roblox.com/library/5802329341/dat-GUI
        </a>
    </p>
</div>

<br>

**Roblox dat.GUI** allows you to easily manipulate variables and fire functions on the fly, inspired by the venerable dat-gui.

dat.GUI magically generates a graphical user interface (sliders, color selector, etc) for each of your variables.

dat.gui's niche is in listening to and controlling data such that it can be visualized into charts or other graphics. Creating a new DAT.GUI instance provides a new sliding pane for which to add controls to:

## Use cases

* To visually debug the various variables in your scripts during development
* To create a rich interface for your auxiliary tools (map editors, effects editors, etc.)
* For the construction of fast administrative interfaces

## Demo

Try out the [live demo](https://www.roblox.com/games/5801132990/dat-GUI), you can edit source code too.

## Installation

1. Download the latest release [here](https://www.roblox.com/library/5802329341/dat-GUI)

2. In Roblox Studio, right click `StarterPlayer -> StarterCharacterScripts`, select "Insert from File...", and open the downloaded release

## How to Edit (on Windows)

1. Make sure Rojo 0.5.x or later is installed
2. Clone this repository to your computer
3. Set the location to this repo's root directory and run this command in CMD/PowerShell/Cmder:

```powershell
rojo serve
```
4. Create a new project on Roblox Studio and install Rojo Plugin, then, connect
5. Edit sources with Visual Studio Code, all changes will replicated automaticaly to Roblox Studio


## Build (on Windows)

1. Make sure Rojo 0.5.x or later is installed
2. Clone this repository to your computer
3. Set the location to this repo's root directory and run this command in PowerShell:

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

##  @TODO
- [ ] Improve documentation (1 example of each type)
- [ ] ability to move the gui window around by dragging (or at least have some parameters to control where it’s placed)
- [ ] linethrough effect should be optional (maybe another method like readonly and disabled)
- [ ] BUG (making the first option of the dropdown the current value)
- [ ] BUG (Sometimes a controller does not unlock the UI)
- [ ] ability to set the color of text for folders (Themes)
- [ ] Allow adding multiple GUI (tab system maybe)
- [ ] Allow custom controllers (Controller Factory)
- [ ] Add CFrame controller (number & slider)
- [ ] Remove duplicate codes
- [ ] Fix Roblox library icon
