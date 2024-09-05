-- Author      : Will0w7
-- MoneyLooterUtils --

-- https://stackoverflow.com/questions/640642/how-do-you-copy-a-lua-table-by-value
function table.ShallowCopy(t)
    local t2 = {}
    for k, v in pairs(t) do
        t2[k] = v
    end
    return t2
end

function CreateTextureFromItemID(itemId)
    return ("|T%s:0|t"):format(tostring(C_Item.GetItemIconByID(itemId)));
end