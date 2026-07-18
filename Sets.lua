BartcraftTooltipSets = {
    {
        key = "might_fury",
        originalName = "Battlegear of Might",
        displayName = "Might of the Mountain",

        items = {
            16861, 16862, 16863, 16864,
            16865, 16866, 16867, 16868,
        },

        itemNames = {
            "Bracers of Might",
            "Sabatons of Might",
            "Gauntlets of Might",
            "Belt of Might",
            "Breastplate of Might",
            "Helm of Might",
            "Legplates of Might",
            "Pauldrons of Might",
        },

        stockItemNames = {
            "Bracers of Might",
            "Sabatons of Might",
            "Gauntlets of Might",
            "Belt of Might",
            "Breastplate of Might",
            "Helm of Might",
            "Legplates of Might",
            "Pauldrons of Might",
        },

        bonuses = {
            {
                pieces = 3,
                spellId = 30816,
                text = "Increases your chance to hit with melee attacks while dual wielding by 2%.",
            },
            {
                pieces = 5,
                spellId = 12322,
                text = "Gives you a chance to generate 1 additional Rage when you deal melee damage with a weapon.",
            },
            {
                pieces = 8,
                spellId = 900209,
                spellNameId = 37605,
                fallbackName = "spell 37605",
                textPrefix = "Your melee attacks have a chance to trigger ",
                textSuffix = ".",
            },
        },
    },
    {
        key = "dragon_fangs",
        originalName = "Spider's Kiss",
        displayName = "Corrupted Fangs of the Fallen",

        items = {
            19346, -- Fang of Vaelastrasz
            20578, -- Fang of Eranikus
        },

        itemNames = {
            "Fang of Vaelastrasz",
            "Fang of Eranikus",
        },

        -- These are the two names stored in the original Spider's Kiss DBC row.
        -- Core.lua replaces them on every tooltip pass, equipped or unequipped.
        stockItemNames = {
            "Fang of the Crystal Spider",
            "Venomspitter",
        },

        bonuses = {
            {
                pieces = 2,
                spellId = 17332,
                text = "Chance on hit: All attacks are guaranteed to land and critically strike for 3 sec.",
            },
        },
    },
    {
        key = "rage_of_the_mountain",
        originalName = "Shard of the Gods",
        displayName = "Rage of the Mountain",

        items = {
            11369, -- Ironfoe, Fury of Forgewright
            12883, -- Ironfel, Orc-slayer
        },

        itemNames = {
            "Ironfoe, Fury of Forgewright",
            "Ironfel, Orc-slayer",
        },

        -- These are the two names stored in the original Shard of the Gods row.
        -- They are always rewritten and never intentionally shown by the addon.
        stockItemNames = {
            "Shard of the Flame",
            "Shard of the Scale",
        },

        bonuses = {
            {
                pieces = 2,
                spellId = 18681,
                text = "Successful extra melee attacks have a chance to provoke the Rage of the Mountain King.",
            },
        },
    },
}
