--山铜诅咒
local m=22348006
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetRange(LOCATION_DECK)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetHintTiming(TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1,22348006+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c22348006.condition)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c22348006.target)
	e1:SetOperation(c22348006.operation)
	c:RegisterEffect(e1)
end
function c22348006.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==1 and Duel.GetTurnPlayer()~=tp
end
function c22348006.filter(c)
	return c:IsCode(22348006) and c:IsAbleToRemove()
end
function c22348006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348006.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c22348006.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c22348006.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,2,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<5 and Duel.SelectYesNo(tp,aux.Stringid(22348006,1)) then
		Duel.BreakEffect() 
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
