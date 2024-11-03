--神相剑·破晓
local m=91090049
local cm=c91090049
function c91090049.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)
	if chk==0 then return Duel.CheckLPCost(tp,lp-1) end
	Duel.PayLPCost(tp,lp-1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil,POS_FACEDOWN)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil,Card.IsAbleToRemove)
	if chk==0 then return true end
		Duel.SetChainLimit(cm.chainlm)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,0)
end
function cm.chainlm(e,ep,tp)
	return tp==ep
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
		local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil,POS_FACEDOWN)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil,Card.IsAbleToRemove)
	local b3=aux.TRUE
	local op=0
	if b1 and b2 and b3 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
	elseif b1 and b3 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,3))
	elseif b2 and b3 then op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))+1
	else op=2 end
	if op==0 then
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil,POS_FACEDOWN)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	elseif op==1 then
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil,POS_FACEDOWN)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	else 
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	end
end