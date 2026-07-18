local ADDON_NAME = "BartcraftTooltips"
local itemToSet, equippedCounts = {}, {}
local initialized, processingTooltip = false, false
local pendingTooltips = {}

local GREEN = {0.10, 1.00, 0.10}
local GRAY  = {0.50, 0.50, 0.50}
local GOLD  = {1.00, 0.82, 0.00}

local function ExtractItemId(link)
    if not link then return nil end
    local _, _, id = string.find(link, "item:(%d+)")
    return tonumber(id)
end

local function Trim(text)
    if not text then return nil end
    text = string.gsub(text, "^%s+", "")
    text = string.gsub(text, "%s+$", "")
    return text
end

local function AddMemberLookupName(setData, name, member)
    name = Trim(name)
    if name and name ~= "" then
        setData.memberLookup[name] = member
    end
end

local function BuildIndexes()
    itemToSet = {}

    for _, setData in ipairs(BartcraftTooltipSets or {}) do
        setData.itemLookup = {}
        setData.memberLookup = {}

        for index, itemId in ipairs(setData.items or {}) do
            setData.itemLookup[itemId] = true
            itemToSet[itemId] = setData

            local displayName = setData.itemNames and setData.itemNames[index]
            local member = {
                itemId = itemId,
                displayName = displayName or ("Item " .. tostring(itemId)),
            }

            -- Match the desired name too, because the 2.4.3 client sometimes
            -- builds equipped set lines from the current item-template names.
            AddMemberLookupName(setData, member.displayName, member)

            -- Match every original DBC member name so it can never leak into
            -- a tooltip, whether the custom pieces are equipped or not.
            local stockNames = setData.stockItemNames and setData.stockItemNames[index]
            if type(stockNames) == "table" then
                for _, stockName in ipairs(stockNames) do
                    AddMemberLookupName(setData, stockName, member)
                end
            else
                AddMemberLookupName(setData, stockNames, member)
            end
        end
    end
end

local function IsItemEquipped(itemId)
    if not itemId then return false end

    for slot = 1, 19 do
        if ExtractItemId(GetInventoryItemLink("player", slot)) == itemId then
            return true
        end
    end

    return false
end

local function CountEquippedPieces(setData)
    local count = 0

    for slot = 1, 19 do
        local id = ExtractItemId(GetInventoryItemLink("player", slot))
        if id and setData.itemLookup[id] then
            count = count + 1
        end
    end

    return count
end

local function RefreshEquippedCounts()
    equippedCounts = {}

    for _, setData in ipairs(BartcraftTooltipSets or {}) do
        equippedCounts[setData.key] = CountEquippedPieces(setData)
    end
end

local function BonusText(bonus)
    if bonus.text then return bonus.text end

    local spellName
    if bonus.spellNameId and GetSpellInfo then
        spellName = GetSpellInfo(bonus.spellNameId)
    end

    if not spellName or spellName == "" then
        spellName = bonus.fallbackName or ("spell " .. tostring(bonus.spellNameId or "?"))
    end

    return (bonus.textPrefix or "") .. spellName .. (bonus.textSuffix or "")
end

local function IsStockBonusLine(text)
    if not text or text == "" then return false end

    return string.find(text, "^Set:")
        or string.find(text, "^%(%d+%) Set:")
        or string.find(text, "^%(%d+%) ")
end

local function IsSetHeader(text, setData)
    if not text then return false end

    return string.find(text, setData.originalName, 1, true)
        or string.find(text, setData.displayName, 1, true)
end

local function ReplaceSetBlock(tooltip, setData)
    if processingTooltip then return false end
    processingTooltip = true

    local tooltipName = tooltip:GetName()
    if not tooltipName then
        processingTooltip = false
        return false
    end

    local headerLine, headerIndex = nil, nil

    -- First locate the set header. This prevents the item's main title from
    -- being mistaken for a member line when it has the same custom name.
    for i = 1, tooltip:NumLines() do
        local left = getglobal(tooltipName .. "TextLeft" .. i)
        local text = left and Trim(left:GetText())

        if left and IsSetHeader(text, setData) then
            headerLine = left
            headerIndex = i
            break
        end
    end

    -- OnTooltipSetItem can fire before the stock set block is complete.
    -- A queued retry will process it on the following rendered frames.
    if not headerLine then
        processingTooltip = false
        return false
    end

    local equipped = equippedCounts[setData.key] or CountEquippedPieces(setData)
    local maxPieces = table.getn(setData.items or {})
    local bonusLines = {}

    headerLine:SetText(setData.displayName .. " (" .. equipped .. "/" .. maxPieces .. ")")
    headerLine:SetTextColor(unpack(GOLD))

    -- Only inspect lines below the set header. Every old DBC member name is
    -- replaced even when neither custom item is equipped.
    for i = headerIndex + 1, tooltip:NumLines() do
        local left = getglobal(tooltipName .. "TextLeft" .. i)
        if left then
            local text = Trim(left:GetText())
            local member = text and setData.memberLookup[text]

            if member then
                -- Change only the member name. Preserve Blizzard's existing
                -- set-member color: pale gold when equipped, gray when missing.
                left:SetText(member.displayName)
            elseif IsStockBonusLine(text) then
                table.insert(bonusLines, left)
            end
        end
    end

    local bonuses = setData.bonuses or {}

    for index, fontString in ipairs(bonusLines) do
        local bonus = bonuses[index]

        if bonus then
            local c = equipped >= bonus.pieces and GREEN or GRAY
            fontString:SetText("(" .. bonus.pieces .. ") Set: " .. BonusText(bonus))
            fontString:SetTextColor(unpack(c))
        else
            fontString:SetText("")
        end
    end

    for index = table.getn(bonusLines) + 1, table.getn(bonuses) do
        local bonus = bonuses[index]
        local c = equipped >= bonus.pieces and GREEN or GRAY
        tooltip:AddLine("(" .. bonus.pieces .. ") Set: " .. BonusText(bonus), c[1], c[2], c[3], true)
    end

    tooltip:Show()
    processingTooltip = false
    return true
end

local function ProcessTooltip(tooltip)
    if not initialized or processingTooltip or not tooltip then return end

    local _, link = tooltip:GetItem()
    local itemId = ExtractItemId(link)
    local setData = itemId and itemToSet[itemId]

    if setData then
        ReplaceSetBlock(tooltip, setData)
    end
end

-- The 2.4.3 client can append or rebuild set-member lines after
-- OnTooltipSetItem. Reprocess every relevant tooltip for three rendered
-- frames so the final visible tooltip always contains Bartcraft names.
local refreshFrame = CreateFrame("Frame")
refreshFrame:Hide()

local function QueueTooltipRefresh(tooltip)
    if not tooltip then return end
    pendingTooltips[tooltip] = 3
    refreshFrame:Show()
end

refreshFrame:SetScript("OnUpdate", function()
    local stillPending = false

    for tooltip, passes in pairs(pendingTooltips) do
        if tooltip and tooltip:IsShown() and passes > 0 then
            ProcessTooltip(tooltip)
            pendingTooltips[tooltip] = passes - 1

            if passes - 1 > 0 then
                stillPending = true
            else
                pendingTooltips[tooltip] = nil
            end
        else
            pendingTooltips[tooltip] = nil
        end
    end

    if not stillPending then
        this:Hide()
    end
end)

local function HookTooltip(tooltip)
    if not tooltip or tooltip.BartcraftTooltipsHooked then return end
    tooltip.BartcraftTooltipsHooked = true

    local function OnTooltipItemSet()
        ProcessTooltip(this)
        QueueTooltipRefresh(this)
    end

    if tooltip.HookScript then
        tooltip:HookScript("OnTooltipSetItem", OnTooltipItemSet)
    else
        local old = tooltip:GetScript("OnTooltipSetItem")
        tooltip:SetScript("OnTooltipSetItem", function()
            if old then old() end
            OnTooltipItemSet()
        end)
    end
end

local itemRefClickHooked = false

local function HookItemRefClicks()
    if itemRefClickHooked or not hooksecurefunc or not SetItemRef then return end
    itemRefClickHooked = true

    hooksecurefunc("SetItemRef", function(link)
        if link and string.find(link, "^item:") then
            QueueTooltipRefresh(ItemRefTooltip)
        end
    end)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
frame:RegisterEvent("UNIT_INVENTORY_CHANGED")

frame:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        BartcraftTooltipsDB = BartcraftTooltipsDB or {}
        BuildIndexes()
        RefreshEquippedCounts()

        HookTooltip(GameTooltip)
        HookTooltip(ItemRefTooltip)
        HookTooltip(ShoppingTooltip1)
        HookTooltip(ShoppingTooltip2)
        HookItemRefClicks()

        initialized = true
    elseif event == "PLAYER_ENTERING_WORLD"
        or event == "PLAYER_EQUIPMENT_CHANGED"
        or (event == "UNIT_INVENTORY_CHANGED" and arg1 == "player") then
        RefreshEquippedCounts()
    end
end)

SLASH_BARTCRAFTTOOLTIPS1 = "/bctooltips"
SlashCmdList["BARTCRAFTTOOLTIPS"] = function(msg)
    msg = string.lower(msg or "")

    if msg == "reload" then
        BuildIndexes()
        RefreshEquippedCounts()
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Bartcraft Tooltips:|r data reloaded.")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Bartcraft Tooltips|r")
        DEFAULT_CHAT_FRAME:AddMessage("/bctooltips reload")
    end
end
