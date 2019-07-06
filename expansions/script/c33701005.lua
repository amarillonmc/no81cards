--那残星倩影正颂巧器迷人心
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33701005
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsss.TargetFunction(c)
	local e1=rsef.ACT(c)
	local e2=rsss.ActFieldFunction(c,m)
	local e3=rsef.FV_IMMUNE_EFFECT(c,cm.val,aux.TargetBoolFunction(Card.IsSetCard,0x144d),{LOCATION_ONFIELD,LOCATION_ONFIELD })
end
function cm.val(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if not te:IsHasType(EFFECT_TYPE_ACTIONS) or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return tg and #tg>=2
end
