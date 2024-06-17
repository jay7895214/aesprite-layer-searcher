-- Initialize variables
local searchTerm = ""
local currentIndex = 0
local matchingLayers = {}

-- Define a function to recursively search for layer names in groups
local function searchLayersInGroup(group)
  for i, layer in ipairs(group.layers) do
    if layer.isGroup then
      if layer.name:find(searchTerm) then
        table.insert(matchingLayers, layer)
      end
      searchLayersInGroup(layer)
    elseif layer.name:find(searchTerm) then
      table.insert(matchingLayers, layer)
    end
  end
end

-- Define a function to search for layer names
local function searchLayers()
  matchingLayers = {}
  local sprite = app.activeSprite
  if not sprite then return end

  for i, layer in ipairs(sprite.layers) do
    if layer.isGroup then
      if layer.name:find(searchTerm) then
        table.insert(matchingLayers, layer)
      end
      searchLayersInGroup(layer)
    elseif layer.name:find(searchTerm) then
      table.insert(matchingLayers, layer)
    end
  end
end

-- Define a function to find the next layer that meets the condition
local function findNext()
  if #matchingLayers == 0 then return end

  currentIndex = currentIndex + 1
  if currentIndex > #matchingLayers then
    currentIndex = 1
  end

  app.activeLayer = matchingLayers[currentIndex]
end

-- Update the UI display
local function updateUI(dlg)
  local layerName = app.activeLayer and app.activeLayer.name or "None"
  local resultText = string.format("(%d/%d) Current Layer: %s", currentIndex, #matchingLayers, layerName)
  dlg:modify{id="result", text=resultText}
end

-- Create the UI
local dlg = Dialog("Search Layers")

dlg:entry{
  id="searchTerm",
  label="Search Term:",
  text=searchTerm,
  onchange=function()
    searchTerm = dlg.data.searchTerm
    currentIndex = 0
    searchLayers()
    updateUI(dlg)
  end
}

dlg:button{
  id="findNext",
  text="Find Next",
  onclick=function()
    findNext()
    updateUI(dlg)
  end
}

dlg:label{
  id="result",
  text="(0/0) Current Layer: None"
}

dlg:show{wait=false}