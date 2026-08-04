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
        key = "wrath_bladestorm",
        originalName = "Battlegear of Wrath",
        displayName = "Wrath of the Blade Master",

        items = {
            16959, 16960, 16961, 16962,
            16963, 16964, 16965, 16966,
        },

        itemNames = {
            "Bracelets of Wrath",
            "Waistband of Wrath",
            "Pauldrons of Wrath",
            "Legplates of Wrath",
            "Helm of Wrath",
            "Gauntlets of Wrath",
            "Sabatons of Wrath",
            "Breastplate of Wrath",
        },

        stockItemNames = {
            "Bracelets of Wrath",
            "Waistband of Wrath",
            "Pauldrons of Wrath",
            "Legplates of Wrath",
            "Helm of Wrath",
            "Gauntlets of Wrath",
            "Sabatons of Wrath",
            "Breastplate of Wrath",
        },

        bonuses = {
            {
                pieces = 3,
                text = "Increases the damage you deal with two-handed melee weapons by 2%.",
            },
            {
                pieces = 5,
                text = "20% chance after using an offensive ability requiring Rage that your next offensive ability requires 5 less Rage to use.",
            },
            {
                pieces = 8,
                spellId = 23548,
                spellNameId = 9632,
                text = "Whirlwind also unleashes Bladestorm for 9 sec, striking nearby enemies every 3 sec. This effect can occur once every 30 sec.",
            },
        },
    },
    {
        key = "dreadnaught_protection",
        originalName = "Dreadnaught's Battlegear",
        displayName = "The Bone Warden Dreadnaught",

        -- Only the eight armor pieces count toward the Bartcraft set.
        items = {
            22416, -- Dreadnaught Breastplate
            22417, -- Dreadnaught Legplates
            22418, -- Dreadnaught Helmet
            22419, -- Dreadnaught Pauldrons
            22420, -- Dreadnaught Sabatons
            22421, -- Dreadnaught Gauntlets
            22422, -- Dreadnaught Waistguard
            22423, -- Dreadnaught Bracers
        },

        itemNames = {
            "Dreadnaught Breastplate",
            "Dreadnaught Legplates",
            "Dreadnaught Helmet",
            "Dreadnaught Pauldrons",
            "Dreadnaught Sabatons",
            "Dreadnaught Gauntlets",
            "Dreadnaught Waistguard",
            "Dreadnaught Bracers",
        },

        stockItemNames = {
            "Dreadnaught Breastplate",
            "Dreadnaught Legplates",
            "Dreadnaught Helmet",
            "Dreadnaught Pauldrons",
            "Dreadnaught Sabatons",
            "Dreadnaught Gauntlets",
            "Dreadnaught Waistguard",
            "Dreadnaught Bracers",
        },

        -- Allow the addon to rewrite the tooltip even when the old ring
        -- itself is inspected, but do not count it as a set piece.
        tooltipItems = {
            23059, -- Ring of the Dreadnaught
        },

        -- Remove this stock ninth member from the visible set list.
        hiddenMemberNames = {
            "Ring of the Dreadnaught",
        },

        bonuses = {
            {
                pieces = 2,
                text = "Increases the damage done by your Revenge ability by 75.",
            },
            {
                pieces = 4,
                text = "Improves your chance to hit with Taunt and Challenging Shout by 5%.",
            },
            {
                pieces = 6,
                text = "Improves your chance to hit with Sunder Armor, Devastate, Heroic Strike, Revenge, and Shield Slam by 5%.",
            },
            {
                pieces = 8,

                -- Original Dreadnaught trigger now grants Bone Shield.
                spellId = 28845,
                spellNameId = 27688,

                text = "When your health drops below 20%, you gain Bone Shield for 5 sec. This effect can occur once every 60 sec.",
            },
        },
    },
    {
        key = "lawbringer_healing",
        originalName = "Lawbringer Armor",
        displayName = "Lawbringer’s Sanctuary",

        items = {
            16853, -- Lawbringer Chestguard
            16854, -- Lawbringer Helm
            16855, -- Lawbringer Legplates
            16856, -- Lawbringer Spaulders
            16857, -- Lawbringer Bracers
            16858, -- Lawbringer Belt
            16859, -- Lawbringer Boots
            16860, -- Lawbringer Gauntlets
        },

        itemNames = {
            "Lawbringer Chestguard",
            "Lawbringer Helm",
            "Lawbringer Legplates",
            "Lawbringer Spaulders",
            "Lawbringer Bracers",
            "Lawbringer Belt",
            "Lawbringer Boots",
            "Lawbringer Gauntlets",
        },

        stockItemNames = {
            "Lawbringer Chestguard",
            "Lawbringer Helm",
            "Lawbringer Legplates",
            "Lawbringer Spaulders",
            "Lawbringer Bracers",
            "Lawbringer Belt",
            "Lawbringer Boots",
            "Lawbringer Gauntlets",
        },

                bonuses = {
            {
                pieces = 3,

                -- Custom aura actually granted by Bartcraft
                spellId = 900953,

                -- Original spell whose behavior was copied
                spellNameId = 28787,

                text = "Your Cleanse spell also heals the target for 200.",
            },
            {
                pieces = 5,

                -- Custom copy of spell 20249
                spellId = 900954,
                spellNameId = 20249,

                text = "Increases the critical effect chance of your Flash of Light spell by 2%.",
            },
            {
                pieces = 5,

                -- Custom copy of spell 20359
                spellId = 900955,
                spellNameId = 20359,

                text = "Increases the critical effect chance of your Holy Light spell by 2%.",
            },
            {
                pieces = 8,

                -- Approved custom Lawbringer 8-piece aura
                spellId = 21747,
                spellNameId = 23544,

                text = "Consecration now heals your allies over time while they stand on consecrated ground.",
            },
        },
    },
    {
        key = "judgement_retribution",
        originalName = "Judgement Armor",
        displayName = "Divine Judgement",

        items = {
            16951, -- Judgement Bindings
            16952, -- Judgement Belt
            16953, -- Judgement Spaulders
            16954, -- Judgement Legplates
            16955, -- Judgement Crown
            16956, -- Judgement Gauntlets
            16957, -- Judgement Sabatons
            16958, -- Judgement Breastplate
        },

        itemNames = {
            "Judgement Bindings",
            "Judgement Belt",
            "Judgement Spaulders",
            "Judgement Legplates",
            "Judgement Crown",
            "Judgement Gauntlets",
            "Judgement Sabatons",
            "Judgement Breastplate",
        },

        stockItemNames = {
            "Judgement Bindings",
            "Judgement Belt",
            "Judgement Spaulders",
            "Judgement Legplates",
            "Judgement Crown",
            "Judgement Gauntlets",
            "Judgement Sabatons",
            "Judgement Breastplate",
        },

        bonuses = {
            {
                pieces = 3,

                -- Spell 23565 was overwritten server-side with spell 20224.
                spellId = 23565,
                spellNameId = 20224,

                text = "Increases the damage dealt by your Seal of Righteousness and Judgement of Righteousness by 3%.",
            },
            {
                pieces = 5,

                -- Stock Judgement 5-piece bonus remains unchanged.
                spellId = 41782,

                text = "Increases damage and healing done by magical spells and effects by up to 47.",
            },
            {
                pieces = 8,

                -- Judgement now queues Holy Strike instead of dealing immediate bonus damage.
                spellId = 23591,
                spellNameId = 13953,

                text = "Casting Judgement replaces your next auto attack with Holy Strike.",
            },
        },
    },
    {
        key = "redemption_protection",
        originalName = "Redemption Armor",
        displayName = "Aegis of the Redeemer",

        -- Only the eight armor pieces count toward the Bartcraft set.
        items = {
            22424, -- Redemption Wristguards
            22425, -- Redemption Tunic
            22426, -- Redemption Handguards
            22427, -- Redemption Legguards
            22428, -- Redemption Headpiece
            22429, -- Redemption Spaulders
            22430, -- Redemption Boots
            22431, -- Redemption Girdle
        },

        itemNames = {
            "Redemption Wristguards",
            "Redemption Tunic",
            "Redemption Handguards",
            "Redemption Legguards",
            "Redemption Headpiece",
            "Redemption Spaulders",
            "Redemption Boots",
            "Redemption Girdle",
        },

        stockItemNames = {
            "Redemption Wristguards",
            "Redemption Tunic",
            "Redemption Handguards",
            "Redemption Legguards",
            "Redemption Headpiece",
            "Redemption Spaulders",
            "Redemption Boots",
            "Redemption Girdle",
        },

        -- Allow the addon to rewrite the old ring tooltip, but do not
        -- count it as a set piece or show it in the visible member list.
        tooltipItems = {
            23066, -- Ring of Redemption
        },

        hiddenMemberNames = {
            "Ring of Redemption",
        },

        bonuses = {
            {
                pieces = 2,
                spellId = 28775,
                text = "Increases the threat generated by Holy Shield by 20%.",
            },
            {
                pieces = 4,
                spellId = 28774,
                text = "Increases damage done by Holy spells and effects by up to 54.",
            },
            {
                pieces = 6,
                spellId = 28789,
                text = "Increases your chance to hit with melee attacks and spells by 2%.",
            },
            {
                pieces = 8,
                spellId = 28787,
                text = "Avenger's Shield becomes instant cast and applies Holy Sunder to every enemy hit, reducing their armor.",
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
