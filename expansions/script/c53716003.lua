local m=53716003
local cm=_G["c"..m]
cm.name="断片折光 幻想识馆"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.FanippetTrap(c,800,m,0,2600,RACE_SPELLCASTER,ATTRIBUTE_DARK)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(53702500,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(cm.spcon)
	e3:SetCost(SNNM.FanippetTrapSPCost(800,code))
	e3:SetTarget(SNNM.FanippetTrapSPTarget(code,atk,def,rac,att))
	e3:SetOperation(SNNM.FanippetTrapSPOperation(code,atk,def,rac,att,0))
	c:RegisterEffect(e3)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and (LOCATION_HAND+LOCATION_GRAVE)&loc~=0
end
