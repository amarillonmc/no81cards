local m=53716012
local cm=_G["c"..m]
cm.name="断片折光 幻想弃木"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.FanippetTrap(c,500,m,0,0,RACE_REPTILE,ATTRIBUTE_DARK)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53702500,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetTarget(SNNM.FanippetTrapSPTarget(code,atk,def,rac,att))
	e2:SetOperation(SNNM.FanippetTrapSPOperation(code,atk,def,rac,att,0))
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return bit.band(c:GetType(),0x20004)==0x20004 and c:IsAbleToRemoveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.PayLPCost(tp,500)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
