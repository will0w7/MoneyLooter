-- Author      : Will0w7
-- AutoLoot --

WHEN_LOOT_READY = CreateFrame("Frame")

function WHEN_LOOT_READY_OnEvent()
    if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
        for i = GetNumLootItems(), 1, -1 do
            LootSlot(i)
        end
    end
end

WHEN_LOOT_READY:RegisterEvent("LOOT_READY")
WHEN_LOOT_READY:SetScript("OnEvent", WHEN_LOOT_READY_OnEvent)
