--Lycoris-出击
function c12852008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12852008+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c12852008.target)
	e1:SetOperation(c12852008.activate)
	c:RegisterEffect(e1)	
end
function c12852008.filter(c)
	return c:IsCode(12852001,12852002) and c:IsAbleToHand()
end
function c12852008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12852008.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12852008.filter1(c,tp)
	return c:IsCode(12852009) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c12852008.filter2(c,tp)
	return c:IsCode(12852009) and c:IsFaceup()
end
function c12852008.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12852008.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if not Duel.IsExistingMatchingCard(c12852008.filter2,tp,LOCATION_FZONE,0,1,nil,tp) and Duel.IsExistingMatchingCard(c12852008.filter1,tp,LOCATION_DECK,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(12852008,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12852008,1))
			local tc=Duel.SelectMatchingCard(tp,c12852008.filter1,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
			if tc then
				local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
					Duel.BreakEffect()
				end
				Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
				local te=tc:GetActivateEffect()
				te:UseCountLimit(tp,1,true)
				local tep=tc:GetControler()
				local cost=te:GetCost()
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
			end
		end
	end
end