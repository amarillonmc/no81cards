--灵摆分拣
function c67220004.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67220004+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c67220004.target)
	e1:SetOperation(c67220004.operation)
	c:RegisterEffect(e1)	
end
function c67220004.filter(c)
	return not c:IsType(TYPE_PENDULUM)
end
function c67220004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67220004.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function c67220004.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c67220004.filter,tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 then return end
	if g:GetCount()==0 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=g:GetNext()
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	local gg=Duel.GetDecktopGroup(tp,dcount-seq-1)
	if spcard:IsAbleToGrave() then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(spcard,nil,REASON_EFFECT)
		Group.RemoveCard(gg,spcard)
		Duel.SendtoExtraP(gg,nil,REASON_EFFECT+REASON_REVEAL)
		--Duel.ConfirmCards(1-tp,spcard)
		--Duel.ShuffleHand(tp)
	else Duel.SendtoExtraP(gg,nil,REASON_EFFECT+REASON_REVEAL) end
end



