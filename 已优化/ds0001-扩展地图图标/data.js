module.exports = {
  version: "1.7",
  categories: [
    MOBS = "MOBS",
    MOBS_KOALEFANTS = "MOBS - KOALEFANTS",
    MOBS_GIANTS = "MOBS - GIANTS",
    MOBS_SW = "MOBS - SHIPWRECKED",
    MOBS_SW_BOSSES = "MOBS - SHIPWRECKED BOSSES",
    VEGETATION = "VEGETATION",
    MUSHROOMS = "MUSHROOMS",
    STRUCTURES = "STRUCTURES",
    STRUCTURES_WALLS = "STRUCTURES - WALLS",
    ITEMS = "ITEMS",
    THINGS = "THINGS",
    MISCELLANEOUS = "MISCELLANEOUS"
  ],
  entities: [
    // mobs
    { name: "tentacle", label: "Tentacles" , category: MOBS},
    { name: "beefalo", label: "Beefalo", category: MOBS },
    { name: "babybeefalo", label: "Baby Beefalo", category: MOBS },
    { name: "bishop", label: "Clockwork Bishop", category: MOBS },
    { name: "knight", label: "Clockwork Knight", category: MOBS },
    { name: "rook", label: "Clockwork Rooks", category: MOBS },
    { name: "rocky", label: "Rock Lobsters", category: MOBS },
    { name: "lightninggoat", label: "Volt Goats", category: MOBS },
    { name: "leif", label: "Treeguards", category: MOBS },
    { name: "leif_sparse", label: "Lumpy Treeguards", category: MOBS },
    // mobs - koalefants
    { name: "koalefant_summer", label: "Summer Koalefants", category: MOBS_KOALEFANTS },
    { name: "koalefant_winter", label: "Winter Koalefants", category: MOBS_KOALEFANTS },
    // mobs - giants
    { name: "bearger", label: "Bearger", category: MOBS_GIANTS },
    { name: "deerclops", label: "Deerclops", category: MOBS_GIANTS },
    { name: "dragonfly", label: "Dragonfly", category: MOBS_GIANTS },
    { name: "moose", label: "Moose/Goose", category: MOBS_GIANTS },
    // mobs - sw
    { name: "ballphin", label: "Bottlenosed Ballphins", category: MOBS_SW },
    { name: "swordfish", label: "Swordfish", category: MOBS_SW },
    { name: "doydoy", label: "Doydoys", category: MOBS_SW },
    { name: "doydoybaby", label: "Baby Doydoys", category: MOBS_SW },
    { name: "ox", label: "Water Beefalo", category: MOBS_SW },
    // mobs - sw bosses
    { name: "treeguard", label: "Palm Treeguards", category: MOBS_SW_BOSSES },
    { name: "tigershark", label: "Tiger Shark", category: MOBS_SW_BOSSES },
    { name: "kraken", label: "Quacken", category: MOBS_SW_BOSSES },
    { name: "twister", label: "Sealnado", category: MOBS_SW_BOSSES },
    // vegetation
    { name: "carrot_planted", label: "Carrots", category: VEGETATION },
    { name: "mandrake", label: "Mandrakes", category: VEGETATION },
    // mushrooms
    { name: "green_mushroom", label: "Green Mushrooms", category: MUSHROOMS },
    { name: "red_mushroom", label: "Red Mushrooms", category: MUSHROOMS },
    { name: "blue_mushroom", label: "Blue Mushrooms", category: MUSHROOMS },
    // structures
    { name: "pigtorch", label: "Pig Torches", category: STRUCTURES },
    { name: "pighead", label: "Pig Heads", category: STRUCTURES },
    { name: "mermhead", label: "Merm Heads", category: STRUCTURES },
    { name: "skeleton", label: "Skeletons", category: STRUCTURES },
    { name: "houndbone", label: "Bones", category: STRUCTURES },
    { name: "wildborehead", label: "Wildbore Heads", category: STRUCTURES },
    // structures - walls
    { name: "wall_hay", label: "Hay Walls", category: STRUCTURES_WALLS },
    { name: "wall_wood", label: "Wood Walls", category: STRUCTURES_WALLS },
    { name: "wall_stone", label: "Stone Walls", category: STRUCTURES_WALLS },
    { name: "wall_ruins", label: "Thulecite Walls", category: STRUCTURES_WALLS },
    { name: "wall_limestone", label: "Limestone Walls", category: STRUCTURES_WALLS },
    { name: "sandbagsmall", label: "Sandbags", category: STRUCTURES_WALLS },
    // items
    { name: "chester_eyebone", label: "Chester's Eye Bone", category: ITEMS },
    { name: "packim_fishbone", label: "Packim's Fishbone", category: ITEMS },
    { name: "flint", label: "Flint", category: ITEMS },
    // things
    { name: "teleportato_box", label: "Box Thing", category: THINGS },
    { name: "teleportato_crank", label: "Crank Thing", category: THINGS },
    { name: "teleportato_potato", label: "Metal Potato Thing", category: THINGS },
    { name: "teleportato_ring", label: "Ring Thing", category: THINGS },
    // miscellaneous
    { name: "flotsam", label: "Flotsams", category: MISCELLANEOUS },
    { name: "animal_track", label: "Animal Tracks", category: MISCELLANEOUS },
    { name: "rabbithole", label: "Rabbit Holes", category: MISCELLANEOUS },
    { name: "crabhole", label: "Crabbit Dens", category: MISCELLANEOUS},
    { name: "molehill", label: "Molehills", category: MISCELLANEOUS }
  ]
}
