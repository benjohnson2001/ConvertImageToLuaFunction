function clearConsoleWindow()
  reaper.ShowConsoleMsg("")
end

function print(arg)
  reaper.ShowConsoleMsg(tostring(arg))
end

clearConsoleWindow()


-- get image path

local userComplied, imagePath = reaper.GetUserFileNameForRead("", "select image file", "png")

if not userComplied then
	return
end

-- get image dimensions

local imageIndex = 0
gfx.loadimg(imageIndex, imagePath)
local width, height = gfx.getimgdim(imageIndex)

-- get pixel information

Pixel = {}
Pixel.__index = Pixel

function Pixel:new(x, y, r, g, b)

  local self = {}
  setmetatable(self, Pixel)

  self.x = x
  self.y = y
  self.r = r
  self.g = g
  self.b = b

  return self
end

local function openWindow(width, height)

	local width = width
	local height = height
	local dockState = 0
	local x = 0
	local y = 0
	gfx.init("", width, height, dockState, x, y)
end

function loadImage()

	local imageIndex = 0
	gfx.loadimg(imageIndex, imagePath)
	gfx.blit(imageIndex, 1.0, 0.0)
end

openWindow(width, height)
loadImage()

pixels = {}

for x = 1, width do

	for y = 1, height do

		gfx.x = x
		gfx.y = y
		local r, g, b = gfx.getpixel()

		table.insert(pixels, Pixel:new(x, y, r, g, b))
	end
end

-- print source code

local output = {}
table.insert(output, "function drawImage()\n\n")

for i = 1, #pixels do

  local pixel = pixels[i]

	table.insert(output, "    gfx.x = " .. pixel.x .. "\n")
	table.insert(output, "    gfx.y = " .. pixel.y .. "\n")
	table.insert(output, "    gfx.setpixel(" .. pixel.r .. ", " .. pixel.g .. ", " .. pixel.b .. ")\n")
end

table.insert(output, "end")

local function splitByChunk(text, chunkSize)
    local s = {}
    for i=1, #text, chunkSize do
        s[#s+1] = text:sub(i,i+chunkSize - 1)
    end
    return s
end

local chunkSize = 7453
local strings = splitByChunk(table.concat(output, ""), chunkSize)
for i, string in ipairs(strings) do
   print("\n\n" .. i .. "\n----\n\n")
   print(string)
end

