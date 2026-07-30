-- MountOverride.lua
-- Bartcraft custom mount presentation overrides for WoW 2.4.3.
--
-- This module changes client-side presentation only:
--   * Blizzard spellbook icon, visible name, and tooltip
--   * BartcraftMounts custom Mount Collection icon, visible name, and tooltip
--   * Active player buff icon and tooltip
--
-- It does NOT alter spell casting, secure button attributes, movement speed,
-- mount models, riding requirements, area restrictions, or server behavior.

local DRAGONHAWK_ICON = "Interface\\Icons\\Ability_Hunter_Pet_DragonHawk"

BartcraftMountOverrides = BartcraftMountOverrides or {}
BartcraftMountOverrideVersion = "2.4.0"

-- ---------------------------------------------------------------------------
-- Mount registry
--
-- Add future custom mounts here. The table key must be the real spell ID
-- learned by the player.
-- ---------------------------------------------------------------------------

BartcraftMountOverrides[36027] = {
    spellBookName = "Golden Dragonhawk",
    buffName = "Golden Dragonhawk",
    icon = DRAGONHAWK_ICON,
    castText = "3 sec cast",
    description = "Summons and dismisses a rideable Golden Dragonhawk. This is a very fast mount. This mount can only be summoned in Outland.",
    buffText = "Increases flight speed by 280%.",
    auraNames = {
        "Golden Dragonhawk",
        "Summon Golden Dragonhawk",
        "Summon Golden Dragonhawk Hatchling",
    },
}

BartcraftMountOverrides[36028] = {
    spellBookName = "Red Dragonhawk",
    buffName = "Red Dragonhawk",
    icon = DRAGONHAWK_ICON,
    castText = "3 sec cast",
    description = "Summons and dismisses a rideable Red Dragonhawk. This is a very fast mount. This mount can only be summoned in Outland.",
    buffText = "Increases flight speed by 280%.",
    auraNames = {
        "Red Dragonhawk",
        "Summon Red Dragonhawk",
        "Summon Red Dragonhawk Hatchling",
    },
}

BartcraftMountOverrides[36029] = {
    spellBookName = "Silver Dragonhawk",
    buffName = "Silver Dragonhawk",
    icon = DRAGONHAWK_ICON,
    castText = "3 sec cast",
    description = "Summons and dismisses a rideable Silver Dragonhawk. This is a very fast mount. This mount can only be summoned in Outland.",
    buffText = "Increases flight speed by 280%.",
    auraNames = {
        "Silver Dragonhawk",
        "Summon Silver Dragonhawk",
        "Summon Silver Dragonhawk Hatchling",
    },
}

BartcraftMountOverrides[36031] = {
    spellBookName = "Blue Dragonhawk",
    buffName = "Blue Dragonhawk",
    icon = DRAGONHAWK_ICON,
    castText = "3 sec cast",
    description = "Summons and dismisses a rideable Blue Dragonhawk. This is a very fast mount. This mount can only be summoned in Outland.",
    buffText = "Increases flight speed by 280%.",
    auraNames = {
        "Blue Dragonhawk",
        "Summon Blue Dragonhawk",
        "Summon Blue Dragonhawk Hatchling",
    },
}

BartcraftMountOverrides[24576] = {
    spellBookName = "Obsidian Drake",
    buffName = "Obsidian Drake",
    icon = "Interface\\Icons\\INV_Misc_Head_Dragon_Black",
    castText = "3 sec cast",
    description = "Summons and dismisses a rideable Obsidian Drake. This is a very fast mount.",
    buffText = "Increases movement speed by 100%.",
    auraNames = {
        "Obsidian Drake",
        "Summon Obsidian Drake",
        "Chromatic Mount",
    },
}

BartcraftMountOverrides[42929] = {
    spellBookName = "Azure Drake",
    buffName = "Azure Drake",
    icon = "Interface\\Icons\\INV_Misc_Head_Dragon_Blue",
    castText = "3 sec cast",
    description = "Summons and dismisses a rideable Azure Drake. This is a very fast mount.",
    buffText = "Increases movement speed by 100%.",
    auraNames = {
        "Azure Drake",
        "Summon Azure Drake",
        "[DNT] Test Mount",
    },
}

BartcraftMountOverrides[39910] = {
    spellBookName = "Emerald Drake",
    buffName = "Emerald Drake",
    icon = "Interface\\Icons\\INV_Misc_Head_Dragon_Green",
    castText = "3 sec cast",
    description = "Summons and dismisses a rideable Emerald Drake. This is a very fast mount.",
    buffText = "Increases movement speed by 100%.",
    auraNames = {
        "Emerald Drake",
        "Summon Emerald Drake",
        "Riding Clefthoof",
    },
}

BartcraftMountOverrides[16082] = {
    spellBookName = "Ruby Drake",
    buffName = "Ruby Drake",
    icon = "Interface\\Icons\\INV_Misc_Head_Dragon_01",
    castText = "3 sec cast",
    description = "Summons and dismisses a rideable Ruby Drake. This is a very fast mount.",
    buffText = "Increases movement speed by 100%.",
    auraNames = {
        "Ruby Drake",
        "Summon Ruby Drake",
        "Palomino Stallion",
    },
}

BartcraftMountOverrides[39450] = {
    spellBookName = "Bronze Drake",
    buffName = "Bronze Drake",
    icon = "Interface\\Icons\\INV_Misc_Head_Dragon_Bronze",
    castText = "3 sec cast",
    description = "Summons and dismisses a rideable Bronze Drake. This is a very fast mount.",
    buffText = "Increases movement speed by 100%.",
    auraNames = {
        "Bronze Drake",
        "Summon Bronze Drake",
        "Tallstrider",
    },
}

BartcraftMountOverrides[10804] = {
    spellBookName = "Chromatic Drake",
    buffName = "Chromatic Drake",
    icon = "Interface\\Icons\\INV_Misc_Head_Dragon_Red",
    castText = "3 sec cast",
    description = "Summons and dismisses a rideable Chromatic Drake. This is a very fast mount.",
    buffText = "Increases movement speed by 100%.",
    auraNames = {
        "Chromatic Drake",
        "Summon Chromatic Drake",
        "Summon Turquoise Tallstrider",
        "Turquoise Tallstrider",
    },
}

-- ---------------------------------------------------------------------------
-- Internal state
-- ---------------------------------------------------------------------------

local auraNameToMount = {}
local hookedBuffButtons = {}
local hookedCollectionButtons = {}

local nativeHooksInstalled = false
local actionBarHooksInstalled = false
local mountCollectionHookInstalled = false

-- Diagnostic globals. These are safe to inspect with /run.
BartcraftMountHooksInstalled = false
BartcraftMountActionBarHookInstalled = false
BartcraftMountCollectionHookInstalled = false

-- ---------------------------------------------------------------------------
-- Shared helpers
-- ---------------------------------------------------------------------------

local function G(name)
    if getglobal then
        return getglobal(name)
    end

    if _G then
        return _G[name]
    end

    return nil
end

local function ExtractSpellId(link)
    if not link then return nil end

    local _, _, spellId = string.find(link, "spell:(%d+)")
    return tonumber(spellId)
end

local function BuildAuraNameLookup()
    auraNameToMount = {}

    for _, mountData in pairs(BartcraftMountOverrides) do
        for _, auraName in ipairs(mountData.auraNames or {}) do
            auraNameToMount[auraName] = mountData
        end
    end
end

local function GetMountFromSpellBookIndex(spellBookIndex, bookType)
    if not spellBookIndex or not GetSpellLink then return nil, nil end

    bookType = bookType or BOOKTYPE_SPELL or "spell"

    local spellLink = GetSpellLink(spellBookIndex, bookType)
    local spellId = ExtractSpellId(spellLink)

    if not spellId then return nil, nil end

    return BartcraftMountOverrides[spellId], spellId
end

local function SetMountTooltip(owner, mountData, isBuff)
    if not owner or not mountData or not GameTooltip then return end

    if not GameTooltip:IsOwned(owner) then
        GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
    end

    GameTooltip:ClearLines()

    if isBuff then
        GameTooltip:AddLine(mountData.buffName, 1.00, 0.82, 0.00)
        GameTooltip:AddLine(mountData.buffText, 1.00, 1.00, 1.00, true)
    else
        GameTooltip:AddLine(mountData.spellBookName, 1.00, 0.82, 0.00)
        GameTooltip:AddLine(mountData.castText, 1.00, 1.00, 1.00)
        GameTooltip:AddLine(mountData.description, 1.00, 0.82, 0.00, true)
    end

    GameTooltip:Show()
end

-- ---------------------------------------------------------------------------
-- Blizzard spellbook overrides
-- ---------------------------------------------------------------------------

local function GetMountFromNativeSpellButton(button)
    if not button or not button.GetID then return nil, nil end
    if not SpellBookFrame or not SpellBook_GetSpellID then return nil, nil end

    local bookType = SpellBookFrame.bookType or BOOKTYPE_SPELL or "spell"
    local spellBookIndex = SpellBook_GetSpellID(button:GetID())

    return GetMountFromSpellBookIndex(spellBookIndex, bookType)
end

local function ApplyNativeSpellButtonOverride(button)
    local mountData = GetMountFromNativeSpellButton(button)
    if not mountData then return end

    local buttonName = button:GetName()
    if not buttonName then return end

    local iconTexture = G(buttonName .. "IconTexture")
    local spellName = G(buttonName .. "SpellName")
    local subSpellName = G(buttonName .. "SubSpellName")

    if iconTexture then
        iconTexture:SetTexture(mountData.icon)
    end

    if spellName then
        spellName:SetText(mountData.spellBookName)

        -- Removing the inherited pet rank line gives the custom name the same
        -- vertical alignment as an ordinary mount spell.
        if spellName.ClearAllPoints then
            spellName:ClearAllPoints()
            spellName:SetPoint("LEFT", button, "RIGHT", 4, 2)
        end
    end

    if subSpellName then
        subSpellName:SetText("")
    end
end

local function ApplyNativeSpellTooltipOverride(button)
    local mountData = GetMountFromNativeSpellButton(button)
    if not mountData then return end

    SetMountTooltip(button, mountData, false)
end

local function InstallNativeSpellbookHooks()
    if nativeHooksInstalled then return end
    if not hooksecurefunc then return end

    nativeHooksInstalled = true

    if SpellButton_UpdateButton then
        hooksecurefunc("SpellButton_UpdateButton", function()
            ApplyNativeSpellButtonOverride(this)
        end)
    end

    if SpellButton_OnEnter then
        hooksecurefunc("SpellButton_OnEnter", function(button)
            ApplyNativeSpellTooltipOverride(button or this)
        end)
    end

    BartcraftMountHooksInstalled = true
end


-- ---------------------------------------------------------------------------
-- Blizzard action-bar overrides
--
-- TBC action slots may expose a spellbook index rather than the final spell ID.
-- Resolve the action through GetSpellLink/GetSpellName before consulting the
-- Bartcraft registry. Read-only API wrappers then cover the default action bar
-- and action-bar addons that use the standard texture and tooltip APIs.
-- ---------------------------------------------------------------------------

local originalGetActionTexture = nil
local originalSetAction = nil
local actionApiOverridesInstalled = false

local function GetMountFromActionSlot(actionSlot)
    if not actionSlot then return nil, nil end

    local spellId = nil

    -- Some 2.4.3 builds expose a direct spell link for an action slot.
    if GetActionLink then
        spellId = ExtractSpellId(GetActionLink(actionSlot))
    end

    if spellId and BartcraftMountOverrides[spellId] then
        return BartcraftMountOverrides[spellId], spellId
    end

    if GetActionInfo then
        local actionType, actionId, actionSubType = GetActionInfo(actionSlot)

        if actionType == "spell" and actionId then
            local bookType = BOOKTYPE_SPELL or "spell"

            if actionSubType == "pet" then
                bookType = BOOKTYPE_PET or "pet"
            end

            -- On TBC this actionId can be the spellbook slot. Resolve its link
            -- first rather than assuming it is the final DBC spell ID.
            if GetSpellLink then
                spellId = ExtractSpellId(GetSpellLink(actionId, bookType))
            end

            if spellId and BartcraftMountOverrides[spellId] then
                return BartcraftMountOverrides[spellId], spellId
            end

            -- Compatibility fallback for clients that do return the real ID.
            local numericActionId = tonumber(actionId)
            if numericActionId and BartcraftMountOverrides[numericActionId] then
                return BartcraftMountOverrides[numericActionId], numericActionId
            end

            -- Final fallback: match the underlying learned spell's stock name.
            if GetSpellName then
                local actionSpellName = GetSpellName(actionId, bookType)
                local mountData = actionSpellName and auraNameToMount[actionSpellName]

                if mountData then
                    return mountData, spellId
                end
            end
        end
    end

    return nil, nil
end

local function GetMountFromActionButton(button)
    if not button then return nil, nil end

    local actionSlot = button.action

    if not actionSlot and ActionButton_CalculateAction then
        actionSlot = ActionButton_CalculateAction(button)
    end

    return GetMountFromActionSlot(actionSlot)
end

local function RewriteActionTooltip(tooltip, actionSlot)
    if not tooltip then return end

    local mountData = GetMountFromActionSlot(actionSlot)
    if not mountData then return end

    tooltip:ClearLines()
    tooltip:AddLine(mountData.spellBookName, 1.00, 0.82, 0.00)
    tooltip:AddLine(mountData.castText, 1.00, 1.00, 1.00)
    tooltip:AddLine(mountData.description, 1.00, 0.82, 0.00, true)
    tooltip:Show()
end

local function ApplyActionButtonOverride(button)
    local mountData = GetMountFromActionButton(button)
    if not mountData then return end

    local buttonName = button:GetName()
    if not buttonName then return end

    local icon = G(buttonName .. "Icon")

    if icon then
        icon:SetTexture(mountData.icon)
    end

    if GameTooltip and GameTooltip:IsOwned(button) then
        RewriteActionTooltip(GameTooltip, button.action)
    end
end

local function ApplyActionButtonTooltipOverride(button)
    if not button then return end

    local actionSlot = button.action

    if not actionSlot and ActionButton_CalculateAction then
        actionSlot = ActionButton_CalculateAction(button)
    end

    RewriteActionTooltip(GameTooltip, actionSlot)
end

local function RefreshKnownActionButtons()
    local prefixes = {
        "ActionButton",
        "BonusActionButton",
        "MultiBarBottomLeftButton",
        "MultiBarBottomRightButton",
        "MultiBarRightButton",
        "MultiBarLeftButton",
    }

    for _, prefix in ipairs(prefixes) do
        for i = 1, 12 do
            local button = G(prefix .. i)

            if button then
                ApplyActionButtonOverride(button)
            end
        end
    end
end

local function InstallActionApiOverrides()
    if actionApiOverridesInstalled then return end
    actionApiOverridesInstalled = true

    -- Every stock action button obtains its icon through GetActionTexture.
    -- Override only the returned texture for registered Bartcraft mounts.
    if GetActionTexture then
        originalGetActionTexture = GetActionTexture

        GetActionTexture = function(actionSlot)
            local mountData = GetMountFromActionSlot(actionSlot)

            if mountData then
                return mountData.icon
            end

            return originalGetActionTexture(actionSlot)
        end
    end

    -- ActionButton_SetTooltip ultimately calls GameTooltip:SetAction.
    -- Wrapping the tooltip method also supports compatible action-bar addons.
    if GameTooltip and GameTooltip.SetAction then
        originalSetAction = GameTooltip.SetAction

        GameTooltip.SetAction = function(self, actionSlot)
            local result = originalSetAction(self, actionSlot)
            RewriteActionTooltip(self, actionSlot)
            return result
        end
    end

    BartcraftMountActionApiOverrideInstalled = true
end

local function InstallActionBarHooks()
    InstallActionApiOverrides()

    if actionBarHooksInstalled then
        RefreshKnownActionButtons()
        return
    end

    if not hooksecurefunc then return end

    actionBarHooksInstalled = true

    if ActionButton_Update then
        hooksecurefunc("ActionButton_Update", function()
            ApplyActionButtonOverride(this)
        end)
    end

    if ActionButton_SetTooltip then
        hooksecurefunc("ActionButton_SetTooltip", function(button)
            ApplyActionButtonTooltipOverride(button or this)
        end)
    end

    BartcraftMountActionBarHookInstalled = true
    RefreshKnownActionButtons()
end

-- ---------------------------------------------------------------------------
-- Active buff overrides
--
-- The Bartcraft client is not guaranteed to expose its visible aura button as
-- BuffButton1, BuffButton2, etc. Therefore the primary fix is applied at the
-- aura API and tooltip-method level. Any frame that asks the client for this
-- buff's texture receives the Bartcraft mount icon.
-- ---------------------------------------------------------------------------

local originalGetPlayerBuffTexture = nil
local originalSetPlayerBuff = nil
local auraApiOverridesInstalled = false

local function GetMountFromBuffIndex(buffIndex)
    if buffIndex == nil or not GetPlayerBuffName then return nil end

    local auraName = GetPlayerBuffName(buffIndex)
    if not auraName then return nil end

    return auraNameToMount[auraName]
end

local function RewriteBuffTooltip(tooltip, buffIndex)
    if not tooltip then return end

    local mountData = GetMountFromBuffIndex(buffIndex)
    if not mountData then return end

    tooltip:ClearLines()
    tooltip:AddLine(mountData.buffName, 1.00, 0.82, 0.00)
    tooltip:AddLine(mountData.buffText, 1.00, 1.00, 1.00, true)
    tooltip:Show()
end

local function InstallAuraApiOverrides()
    if auraApiOverridesInstalled then return end
    auraApiOverridesInstalled = true

    -- The stock TBC buff frame calls GetPlayerBuffTexture every time it draws
    -- an aura. Replacing only this read-only API changes the displayed icon
    -- without changing the aura, spell, casting, or server behavior.
    if GetPlayerBuffTexture then
        originalGetPlayerBuffTexture = GetPlayerBuffTexture

        GetPlayerBuffTexture = function(buffIndex)
            local mountData = GetMountFromBuffIndex(buffIndex)

            if mountData then
                return mountData.icon
            end

            return originalGetPlayerBuffTexture(buffIndex)
        end
    end

    -- The stock tooltip repeatedly calls GameTooltip:SetPlayerBuff while the
    -- cursor remains over an aura. Wrapping that method ensures our text is
    -- restored after every stock tooltip refresh.
    if GameTooltip and GameTooltip.SetPlayerBuff then
        originalSetPlayerBuff = GameTooltip.SetPlayerBuff

        GameTooltip.SetPlayerBuff = function(self, buffIndex)
            local result = originalSetPlayerBuff(self, buffIndex)
            RewriteBuffTooltip(self, buffIndex)
            return result
        end
    end

    BartcraftMountAuraApiOverrideInstalled = true
end

-- Keep the frame-level hook as a compatibility fallback for clients or aura
-- addons that use Blizzard's dynamically-created BuffButton frames.
local function ApplyBuffIconOverride(button)
    if not button or not button.GetID then return end

    local mountData = GetMountFromBuffIndex(button:GetID())
    if not mountData then return end

    local buttonName = button:GetName()
    local icon = buttonName and G(buttonName .. "Icon")

    if icon then
        icon:SetTexture(mountData.icon)
    end
end

local function ApplyBuffTooltipOverride(button)
    if not button or not button.GetID or not GameTooltip then return end
    if not GameTooltip:IsOwned(button) then return end

    RewriteBuffTooltip(GameTooltip, button:GetID())
end

local function HookBuffButton(button)
    if not button or hookedBuffButtons[button] then return end

    hookedBuffButtons[button] = true

    if button.HookScript then
        local hookedButton = button

        button:HookScript("OnEnter", function()
            ApplyBuffTooltipOverride(hookedButton)
        end)

        button:HookScript("OnUpdate", function()
            ApplyBuffIconOverride(hookedButton)
            ApplyBuffTooltipOverride(hookedButton)
        end)
    end
end

local function InstallBuffHooks()
    InstallAuraApiOverrides()

    if not hooksecurefunc or not BuffButton_Update then return end
    if BartcraftMountBuffHookInstalled then return end

    BartcraftMountBuffHookInstalled = true

    hooksecurefunc("BuffButton_Update", function(buttonName, index, filter)
        if filter ~= "HELPFUL" then return end

        local button = G(buttonName .. index)
        if not button then return end

        HookBuffButton(button)
        ApplyBuffIconOverride(button)
        ApplyBuffTooltipOverride(button)
    end)
end

-- ---------------------------------------------------------------------------
-- Other-unit aura overrides
--
-- TargetFrame and compatible unit-frame addons obtain another unit's aura
-- name and icon through UnitBuff(). Their hover tooltips use
-- GameTooltip:SetUnitBuff(). Wrap those read-only presentation APIs so every
-- player with BartcraftTooltips sees registered custom mounts correctly on
-- other mounted players.
-- ---------------------------------------------------------------------------

local originalUnitBuff = nil
local originalSetUnitBuff = nil
local unitAuraApiOverridesInstalled = false

local function GetMountFromUnitBuff(unit, index, filter)
    if not originalUnitBuff or not unit or not index then return nil end

    local auraName = originalUnitBuff(unit, index, filter)
    if not auraName then return nil end

    return auraNameToMount[auraName]
end

local function RewriteUnitBuffTooltip(tooltip, unit, index, filter)
    if not tooltip then return end

    local mountData = GetMountFromUnitBuff(unit, index, filter)
    if not mountData then return end

    tooltip:ClearLines()
    tooltip:AddLine(mountData.buffName, 1.00, 0.82, 0.00)
    tooltip:AddLine(mountData.buffText, 1.00, 1.00, 1.00, true)
    tooltip:Show()
end

local function InstallUnitAuraApiOverrides()
    if unitAuraApiOverridesInstalled then return end
    unitAuraApiOverridesInstalled = true

    -- TBC UnitBuff returns:
    -- name, rank, icon, count, duration, timeLeft
    -- Preserve every gameplay value and replace only the visible name/icon.
    if UnitBuff then
        originalUnitBuff = UnitBuff

        UnitBuff = function(unit, index, filter)
            local name, rank, icon, count, duration, timeLeft =
                originalUnitBuff(unit, index, filter)

            local mountData = name and auraNameToMount[name]

            if mountData then
                return mountData.buffName, rank, mountData.icon, count, duration, timeLeft
            end

            return name, rank, icon, count, duration, timeLeft
        end
    end

    -- TargetFrameBuff buttons repeatedly call SetUnitBuff while hovered.
    -- Reapply the Bartcraft tooltip after the stock tooltip is populated.
    if GameTooltip and GameTooltip.SetUnitBuff then
        originalSetUnitBuff = GameTooltip.SetUnitBuff

        GameTooltip.SetUnitBuff = function(self, unit, index, filter)
            local result = originalSetUnitBuff(self, unit, index, filter)
            RewriteUnitBuffTooltip(self, unit, index, filter)
            return result
        end
    end

    BartcraftMountUnitAuraApiOverrideInstalled = true

    -- Refresh an already-selected target immediately after /reload.
    if UnitExists and UnitExists("target") and TargetDebuffButton_Update then
        TargetDebuffButton_Update()
    end
end

-- ---------------------------------------------------------------------------
-- BartcraftMounts custom Mount Collection overrides
-- ---------------------------------------------------------------------------

local function GetMountFromCollectionButton(button)
    if not button or not button.spellBookIndex then return nil, nil end

    return GetMountFromSpellBookIndex(
        button.spellBookIndex,
        BOOKTYPE_SPELL or "spell"
    )
end

local function ApplyCollectionButtonTooltip(button)
    local mountData = GetMountFromCollectionButton(button)
    if not mountData then return end

    SetMountTooltip(button, mountData, false)
end

local function HookCollectionButton(button)
    if not button or hookedCollectionButtons[button] then return end

    hookedCollectionButtons[button] = true

    if button.HookScript then
        local hookedButton = button

        -- BartcraftMounts first displays GameTooltip:SetSpell(). This post-hook
        -- replaces those stock pet-spell lines with the mount presentation.
        button:HookScript("OnEnter", function()
            ApplyCollectionButtonTooltip(hookedButton)
        end)
    end
end

local function ApplyMountCollectionOverrides()
    for i = 1, 12 do
        local button = G("BartcraftMountsSecureButtonV9_" .. i)

        if button then
            HookCollectionButton(button)

            local mountData, spellId = GetMountFromCollectionButton(button)

            if mountData then
                -- Visual fields only. Do not change mountName, spellBookIndex,
                -- secure action attributes, click scripts, or drag scripts.
                if button.icon then
                    button.icon:SetTexture(mountData.icon)
                end

                if button.nameText then
                    button.nameText:SetText(mountData.spellBookName)
                end

                button.BartcraftMountOverrideSpellId = spellId

                if GameTooltip and GameTooltip:IsOwned(button) then
                    ApplyCollectionButtonTooltip(button)
                end
            else
                button.BartcraftMountOverrideSpellId = nil
            end
        end
    end
end

local function InstallMountCollectionHook()
    if mountCollectionHookInstalled then
        ApplyMountCollectionOverrides()
        return true
    end

    if not hooksecurefunc or not BartcraftMounts_Update then
        return false
    end

    hooksecurefunc("BartcraftMounts_Update", function()
        ApplyMountCollectionOverrides()
    end)

    mountCollectionHookInstalled = true
    BartcraftMountCollectionHookInstalled = true

    -- Apply immediately in case the Mount Collection is already open.
    ApplyMountCollectionOverrides()
    return true
end

-- ---------------------------------------------------------------------------
-- Mount item inventory icon overrides
--
-- The 2.4.3 client normally obtains bag-item icons from its client-side item
-- data. These wrappers change presentation only and leave the real item,
-- stack count, lock state, quality, and all server behavior untouched.
-- ---------------------------------------------------------------------------

local BartcraftMountItemIcons = {
    [1029] = "Interface\\Icons\\INV_Misc_Head_Dragon_01",
    [823]  = "Interface\\Icons\\INV_Misc_Head_Dragon_Bronze",
    [1030] = "Interface\\Icons\\INV_Misc_Head_Dragon_Red",
    [842]  = "Interface\\Icons\\INV_Misc_Head_Dragon_Blue",
}

local originalGetContainerItemInfo = nil
local originalGetItemIcon = nil
local itemIconOverridesInstalled = false

local function ExtractItemId(link)
    if not link then return nil end

    local _, _, itemId = string.find(link, "item:(%d+)")
    return tonumber(itemId)
end

local function GetCustomItemIcon(itemId)
    itemId = tonumber(itemId)

    if not itemId then
        return nil
    end

    return BartcraftMountItemIcons[itemId]
end

local function InstallItemIconOverrides()
    if itemIconOverridesInstalled then return end
    itemIconOverridesInstalled = true

    -- Bags, backpack, bank containers, and compatible bag addons.
    if GetContainerItemInfo and GetContainerItemLink then
        originalGetContainerItemInfo = GetContainerItemInfo

        GetContainerItemInfo = function(bag, slot)
            local texture, count, locked, quality, readable =
                originalGetContainerItemInfo(bag, slot)

            local itemLink = GetContainerItemLink(bag, slot)
            local itemId = ExtractItemId(itemLink)
            local customIcon = GetCustomItemIcon(itemId)

            if customIcon then
                texture = customIcon
            end

            return texture, count, locked, quality, readable
        end
    end

    -- Other UI elements or addons that ask directly for an item's icon.
    if GetItemIcon then
        originalGetItemIcon = GetItemIcon

        GetItemIcon = function(item)
            local itemId = tonumber(item)

            if not itemId and type(item) == "string" then
                itemId = ExtractItemId(item)
            end

            local customIcon = GetCustomItemIcon(itemId)

            if customIcon then
                return customIcon
            end

            return originalGetItemIcon(item)
        end
    end

    BartcraftMountItemIconOverridesInstalled = true
end
-- ---------------------------------------------------------------------------
-- Initialization
-- ---------------------------------------------------------------------------

BuildAuraNameLookup()
InstallItemIconOverrides()
InstallNativeSpellbookHooks()
InstallActionBarHooks()
InstallBuffHooks()
InstallUnitAuraApiOverrides()
InstallMountCollectionHook()

-- BartcraftMounts may load before or after BartcraftTooltips. ADDON_LOADED
-- covers the latter case; the immediate call above covers the former.
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("SPELLS_CHANGED")
eventFrame:RegisterEvent("LEARNED_SPELL_IN_TAB")
eventFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")

eventFrame:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" then
        if arg1 == "BartcraftMounts" then
            InstallMountCollectionHook()
        end
    elseif event == "PLAYER_LOGIN" then
        InstallItemIconOverrides()
        InstallActionBarHooks()
        InstallMountCollectionHook()
    elseif event == "SPELLS_CHANGED" or event == "LEARNED_SPELL_IN_TAB" then
        BuildAuraNameLookup()
        InstallActionBarHooks()
        InstallMountCollectionHook()
        RefreshKnownActionButtons()
        ApplyMountCollectionOverrides()
    elseif event == "ACTIONBAR_SLOT_CHANGED" then
        RefreshKnownActionButtons()
    end
end)
