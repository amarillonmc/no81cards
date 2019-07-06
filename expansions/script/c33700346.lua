--虚拟YouTuber 绊爱
local m=33700346
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsAttackBelow,1500),2,63)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function(e)
		return c:GetLinkedGroupCount()<3 and not c:IsHasEffect(EFFECT_CANNOT_DISABLE)
	end)
	e1:SetValue(-1500)
	c:RegisterEffect(e1)
end
