--残星倩影 知地利
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33701001
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x144d),aux.NonTuner(nil),1)
	local e1=rsef.SV_INDESTRUCTABLE(c,"effect")
end
