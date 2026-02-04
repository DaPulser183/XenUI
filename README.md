# XenUI - Roblox UI Library

Modern, draggable, tweened UI library. **Loadstring ready!**

## Loadstring (Exploits / Quick Scripts)
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/DaPulser183/XenUI/main/Source.lua"))()
local win = Library:CreateWindow({Title = "XenUI Demo", Size = UDim2.new(0, 450, 0, 350)})
win:Button("Hello XenUI!", function() print("Loaded!") end)
