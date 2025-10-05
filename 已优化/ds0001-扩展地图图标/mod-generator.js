var fs = require('fs')
var data = require('./data.js')
var entities_by_category = []
var entities_by_name = data.entities.slice().map((entity) => entity.name).sort()

for (i = 0; i < data.categories.length; i += 1) {
  var category = data.categories[i]
  var entities = data.entities.slice()
  entities = entities.filter((entity) => entity.category == category)
  entities = entities.sort((entityA, entityB) => entityA.label > entityB.label)
  entities_by_category.push(entities)
}

var modinfo = `
name = "Extended Map Icons"
version = "${data.version}"
description = "Add a greater variety of icons to your map!\\n\\nVersion ${data.version}"
author = "leo"

forumthread = ""

api_version = 6

dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true

icon = "modicon.tex"
icon_atlas = "modicon.xml"

configuration_options = {
  {
${entities_by_category.map(function (entities) {
return `    name = "${entities[0].category}",
    label = "${entities[0].category}",
    default = "true",
    options = { {description = "", data = "true"} }
  },  {
${entities.map(function (entity) {
return `    name = "${entity.name}",
    label = "${entity.label}",
    default = "true",
    options = { {description = "True", data = "true"}, {description = "False", data = "false"} }
`}).join('  },  {\n')}
`}).join('  },  {\n')}
  }
}
`

var modmain = `
local entities = {
${entities_by_name.slice(0, -1).map((entity) => '  "' + entity + '",').join('\n')}
${'  "' + entities_by_name.slice(-1) + '"'}
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
`
fs.writeFileSync('modinfo.lua', modinfo)
fs.writeFileSync('modmain.lua', modmain)
