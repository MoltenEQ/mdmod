local mod = RegisterMod("MdMod", 1)
local sfxManager = SFXManager()
local game = Game()

-- Maybe Uzi character mod coming up? :D

local absoluteSolver = Isaac.GetItemIdByName("Absolute Solver")
local absoluteSolverDamage = 0.5

function mod:EvaluateCache(player, cacheFlags)
    if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        local itemCount = player:GetCollectibleNum(absoluteSolver)
        local dmgToAdd = absoluteSolverDamage * itemCount
        player.Damage = player.Damage + dmgToAdd
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)

function mod:EvaluateActive(collectibleID, rngObj, playerWhoUsedItem, useFlags, activeSlot, varData)
    local laserChargeSound = Isaac.GetSoundIdByName("LaserCharge")
    sfxManager:Play(laserChargeSound)
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.EvaluateActive, CollectibleType.COLLECTIBLE_SHOOP_DA_WHOOP)


-- Some stuff
-- Generated with ddeeddii.github.io/ezitems-web/
-- To make my life easier. THANKS A LOT <3


-- {itemId, 'name', 'desc'}
local items = {
    --$$$ITEMS-START$$$
    { 49, "Uzi's Railgun", "BITE ME!" },

}

local trinkets = {
    --$$$TRINKETS-START$$$

}

local game = Game()
if EID then
    -- Adds trinkets defined in trinkets
    for _, trinket in ipairs(trinkets) do
        local EIDdescription = EID:getDescriptionData(5, 350, trinket[1])[3]
        EID:addTrinket(trinket[1], EIDdescription, trinket[2], "en_us")
    end

    -- Adds items defined in items
    for _, item in ipairs(items) do
        local EIDdescription = EID:getDescriptionData(5, 100, item[1])[3]
        EID:addCollectible(item[1], EIDdescription, item[2], "en_us")
    end
end

if Encyclopedia then
    -- Adds trinkets defined in trinkets
    for _, trinket in ipairs(trinkets) do
        Encyclopedia.UpdateTrinket(trinket[1], {
            Name = trinket[2],
            Description = trinket[3],
        })
    end

    -- Adds items defined in items
    for _, item in ipairs(items) do
        Encyclopedia.UpdateItem(item[1], {
            Name = item[2],
            Description = item[3],
        })
    end
end

-- Handle displaying trinket names

if #trinkets ~= 0 then
    local t_queueLastFrame
    local t_queueNow
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
        t_queueNow = player.QueuedItem.Item
        if (t_queueNow ~= nil) then
            for _, trinket in ipairs(trinkets) do
                if (t_queueNow.ID == trinket[1] and t_queueNow:IsTrinket() and t_queueLastFrame == nil) then
                    game:GetHUD():ShowItemText(trinket[2], trinket[3])
                end
            end
        end
        t_queueLastFrame = t_queueNow
    end)
end

-- Handle displaying item names

if #items ~= 0 then
    local i_queueLastFrame
    local i_queueNow
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
        i_queueNow = player.QueuedItem.Item
        if (i_queueNow ~= nil) then
            for _, item in ipairs(items) do
                if (i_queueNow.ID == item[1] and i_queueNow:IsCollectible() and i_queueLastFrame == nil) then
                    game:GetHUD():ShowItemText(item[2], item[3])
                end
            end
        end
        i_queueLastFrame = i_queueNow
    end)
end
