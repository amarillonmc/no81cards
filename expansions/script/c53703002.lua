local m=53703002
local cm=_G["c"..m]
cm.name="圆盘生物 布莱克多姆"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.OrganicSaucer(c,2,m)
	SNNM.AllGlobalCheck(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.con)
	e3:SetTarget(SNNM.OSReturnTarget)
	e3:SetOperation(SNNM.OSReturnOperation)
	c:RegisterEffect(e3)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and (LOCATION_HAND+LOCATION_GRAVE)&loc~=0
end
