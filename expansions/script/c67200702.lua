--枪塔的炉精
function c67200702.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c67200702.negcon)
	e3:SetOperation(c67200702.negop)
	c:RegisterEffect(e3)	
end
--
function c67200702.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and Duel.IsChainDisablable(ev)
end
function c67200702.pcfilter(c)
	return c:IsSetCard(0x67f) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c67200702.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(67200702,1)) then
		Duel.Hint(HINT_CARD,0,67200702)
		if Duel.NegateEffect(ev)~=0 then
			Duel.BreakEffect()
			if e:GetHandler():IsAbleToHand() then 
				Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
				if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local g=Duel.SelectMatchingCard(tp,c67200702.pcfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
				end
			end
		end
	end
end

