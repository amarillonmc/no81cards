local m=53716015
local cm=_G["c"..m]
cm.name="断片折光 幻想续木"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(SNNM.FanippetTrapSPTarget(m,{0,0,4,RACE_INSECT,ATTRIBUTE_EARTH}))
	e1:SetOperation(SNNM.FanippetTrapSPOperation(500,m,{0,0,4,RACE_INSECT,ATTRIBUTE_EARTH}))
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(0)
	e2:SetCondition(function(e)return false end)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetCost(SNNM.GraveActCostchk)
	e4:SetTarget(SNNM.GraveActCostTarget)
	e4:SetOperation(SNNM.GraveActCostOp)
	c:RegisterEffect(e4)
end
function cm.cfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsReleasable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and not e:GetHandler():IsLocation(LOCATION_ONFIELD) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
