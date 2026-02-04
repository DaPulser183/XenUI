local Library = loadstring(game:HttpGet("YOUR_GITHUB_RAW_URL_HERE"))()
local win = Library:CreateWindow({Title = "Hub"})
win:Button("Test", function() print("Works!") end)
