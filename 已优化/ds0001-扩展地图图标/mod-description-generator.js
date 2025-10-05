var fs = require('fs')
var data = require('./data.js')
var changelog = fs.readFileSync('CHANGELOG.md', 'utf-8')
var table_rows = []
var entity_columns = []
var entity_labels = data.entities.slice().map((entity) => entity.label).sort().map((label) => '[td]' + label + '[/td]')
var MAX_ROW_LENGTH = 5
var max_column_length = Math.floor(entity_labels.length / MAX_ROW_LENGTH)

if (entity_labels.length % MAX_ROW_LENGTH > 0) { max_column_length += 1 }

for (i = 0; entity_labels.length; i += 1) {
  entity_columns[i] = []
  for (j = 0; entity_labels.length && j < max_column_length; j += 1) {
    entity_columns[i].push(entity_labels.splice(0, 1)[0])
  }
}

for (i = 0; i < max_column_length; i += 1) {
  table_rows[i] = []
  for (j = 0; j < MAX_ROW_LENGTH; j += 1) {
    if (entity_columns[j] && entity_columns[j][i] !== undefined) {
      table_rows[i].push(entity_columns[j][i])
    }
  }
}

var description = `Add a greater variety of icons to your map!

Version ${data.version}
---
Inspired by Where's My Beefalo but compatible with Vanilla, Reign of Giants, and Shipwrecked!

Please leave icon requests in the comment section!

The available icons are listed below, each are toggleable in the mod configuration options:

[table]
${table_rows.map((row) => '[tr]' + row.join('') + '[/tr]').join('\n')}
[/table]
---
LATEST CHANGE:

${changelog.split('\n\n')[0]}

Full changelog: https://gitlab.com/star_lion/extended-map-icons/blob/master/CHANGELOG.md
---
Source code available on gitlab: https://gitlab.com/star_lion/extended-map-icons/tree/master 
`

fs.writeFileSync('description.txt', description)
