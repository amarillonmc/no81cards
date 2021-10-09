--Hyper Rider Kick
function c9980577.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,9980577+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9980577.cost)
	e1:SetTarget(c9980577.target)
	e1:SetOperation(c9980577.activate)
	c:RegisterEffect(e1)
end
function c9980577.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c9980577.costfilter(c)
	return c:IsSetCard(0xcbca) and c:IsAbleToRemoveAsCost()
end
function c9980577.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c9980577.costfilter,tp,LOCATION_GRAVE,0,1,nil)
				and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,e:GetHandler())
		else return false end
	end
	e:SetLabel(0)
	local rt=Duel.GetTargetCount(aux.TRUE,tp,0,LOCATION_ONFIELD,e:GetHandler())
	if rt>2 then rt=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c9980577.costfilter,tp,LOCATION_GRAVE,0,1,rt,nil)
	local ct=cg:GetCount()
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,ct,ct,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9980577.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980577,0))
end
