local m=53716009
local cm=_G["c"..m]
cm.name="断片折光 幻想威仪"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.FanippetTrap(c,800,m,1800,1000,RACE_WINDBEAST,ATTRIBUTE_WIND)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(53702500,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(cm.spcon)
	e3:SetCost(SNNM.FanippetTrapSPCost(800,code))
	e3:SetTarget(SNNM.FanippetTrapSPTarget(code,atk,def,rac,att))
	e3:SetOperation(SNNM.FanippetTrapSPOperation(code,atk,def,rac,att,0))
	c:RegisterEffect(e3)
end
function cm.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp)
end
