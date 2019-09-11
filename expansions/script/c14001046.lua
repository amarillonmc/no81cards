--罔骸神 复骸星
local m=14001046
local cm=_G["c"..m]
cm.named_with_Goned=1
xpcall(function() require("expansions/script/c14001041") end,function() require("script/c14001041") end)
function cm.initial_effect(c)
	--goeffects
	go.effect(c)
end
