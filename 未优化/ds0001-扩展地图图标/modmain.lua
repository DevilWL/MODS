
local entities = {
  "animal_track",
  "babybeefalo",
  "ballphin",
  "bearger",
  "beefalo",
  "bishop",
  "blue_mushroom",
  "carrot_planted",
  "chester_eyebone",
  "crabhole",
  "deerclops",
  "doydoy",
  "doydoybaby",
  "dragonfly",
  "flint",
  "flotsam",
  "green_mushroom",
  "houndbone",
  "knight",
  "koalefant_summer",
  "koalefant_winter",
  "kraken",
  "leif",
  "leif_sparse",
  "lightninggoat",
  "mandrake",
  "mermhead",
  "molehill",
  "moose",
  "ox",
  "packim_fishbone",
  "pighead",
  "pigtorch",
  "rabbithole",
  "red_mushroom",
  "rocky",
  "rook",
  "sandbagsmall",
  "skeleton",
  "swordfish",
  "teleportato_box",
  "teleportato_crank",
  "teleportato_potato",
  "teleportato_ring",
  "tentacle",
  "tigershark",
  "treeguard",
  "twister",
  "wall_hay",
  "wall_limestone",
  "wall_ruins",
  "wall_stone",
  "wall_wood",
  "wildborehead"
}

Assets = {}

for entities_count = 1, #entities do
    local entity = entities[entities_count]
    if GetModConfigData(entity) == "true" then
        table.insert(Assets, Asset("IMAGE", "images/" .. entity .. ".tex"))
        table.insert(Assets, Asset("ATLAS", "images/" .. entity .. ".xml"))
        AddMinimapAtlas("images/" .. entity .. ".xml")
        AddPrefabPostInit(entity, function (inst) inst.entity:AddMiniMapEntity():SetIcon(inst.prefab .. ".tex") end)
    end
end
