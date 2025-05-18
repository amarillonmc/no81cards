--投影魔术
function c22023020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,22023020+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22023020.actg) 
	e1:SetOperation(c22023020.acop)
	c:RegisterEffect(e1) 
end
function c22023020.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end 
function c22023020.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xff1) end,tp,LOCATION_DECK,0,nil) 
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
	if spcard:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(spcard,nil,REASON_EFFECT)
		local x=Duel.DiscardDeck(tp,dcount-seq-1,REASON_EFFECT+REASON_REVEAL)  
		Duel.ConfirmCards(1-tp,spcard)
		Duel.ShuffleHand(tp)  
		if x>0 then   
			Duel.BreakEffect()
			Duel.SetLP(tp,Duel.GetLP(tp)-x*500)
		end  
	else 
		local x=Duel.DiscardDeck(tp,dcount-seq,REASON_EFFECT+REASON_REVEAL)  
		if x>0 then   
			Duel.BreakEffect()
			Duel.SetLP(tp,Duel.GetLP(tp)-x*500)
		end  
	end 
end 
