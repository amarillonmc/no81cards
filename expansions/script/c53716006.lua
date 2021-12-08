local m=53716006
local cm=_G["c"..m]
cm.name="断片折光 幻想愚间"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.FanippetTrap(c,800,m,1400,1500,RACE_FIEND,ATTRIBUTE_EARTH)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
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
function cm.cfilter(c)
	return c:IsFaceup() and bit.band(c:GetType(),0x20004)==0x20004 and not c:IsCode(m)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
