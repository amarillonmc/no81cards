--永夏的篝火
function c9910962.initial_effect(c)
	--flag
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetOperation(c9910962.flag)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910962.target)
	e1:SetOperation(c9910962.activate)
	c:RegisterEffect(e1)
end
function c9910962.flag(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_EFFECT) then
		c:RegisterFlagEffect(9910963,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910963,3))
	end
end
function c9910962.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x5954) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c9910962.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9910962.filter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil,tp,POS_FACEDOWN) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c9910962.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local res=g1:GetFirst():IsType(TYPE_SYNCHRO)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,2,nil,tp,POS_FACEDOWN)
	g1:Merge(g2)
	local tep=nil
	if Duel.GetCurrentChain()>1 then tep=Duel.GetChainInfo(Duel.GetCurrentChain()-1,CHAININFO_TRIGGERING_PLAYER) end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and res and tep and tep==1-tp then
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_REMOVE)
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
end
function c9910962.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)~=0 and e:GetLabel()==1 then
		local ct=Duel.GetCurrentChain()
		if ct<2 then return end
		local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tep==1-tp and Duel.IsChainDisablable(ct-1) and Duel.SelectYesNo(tp,aux.Stringid(9910962,0)) then
			Duel.BreakEffect()
			Duel.NegateEffect(ct-1)
		end
	end
end
