--术结天缘 彷徨降神
function c67200431.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,67200431+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c67200431.target)
	e1:SetOperation(c67200431.operation)
	c:RegisterEffect(e1)	
end
function c67200431.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x5671)
end
function c67200431.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c67200431.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c67200431.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,67200431) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c67200431.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c67200431.filter(c,seq)
	return c:GetSequence()==seq
end
function c67200431.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,67200431)
	local rk=tc:GetRank()
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local dg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local seq=-1
	local ttc=g:GetFirst()
	local spcard=nil
	while ttc do
		if ttc:GetSequence()>seq then
			seq=ttc:GetSequence()
			for i=seq,0,-1 do
				local mg=dg:Filter(c67200431.filter,nil,i)
				Duel.MoveSequence(mg:GetFirst(),0)
			end
			spcard=ttc
		end
		ttc=g:GetNext()
	end
	if seq==-1 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	Duel.ConfirmDecktop(tp,seq+1)
	if spcard:IsCode(67200431) then
		Duel.DisableShuffleCheck()
		if dcount-seq==1 then Duel.Overlay(tc,spcard)
		else
			local gg=Duel.GetDecktopGroup(tp,seq+1)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200431,4))
			local ggg=gg:Select(tp,1,rk,nil)
			Duel.Overlay(tc,ggg)
			Group.Sub(gg,ggg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local gggg=gg:Select(tp,1,ggg:GetCount(),nil)
			Duel.SendtoGrave(gggg,REASON_EFFECT)
		end
	end
	Duel.BreakEffect()
	e:GetHandler():CancelToGrave()
	Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT)
end

