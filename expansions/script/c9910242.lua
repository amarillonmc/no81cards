--生命摇篮
function c9910242.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910242+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910242.target)
	e1:SetOperation(c9910242.activate)
	c:RegisterEffect(e1)
end
function c9910242.filter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c9910242.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910242.filter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.drccheck,3,3)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c9910242.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910242.filter,tp,LOCATION_DECK,0,nil)
	if not g:CheckSubGroup(aux.drccheck,3,3) or (not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.drccheck,false,3,3)
	if #sg>0 then
		Duel.ConfirmCards(1-tp,sg)
		local tc=sg:RandomSelect(1-tp,1):GetFirst()
		Duel.ConfirmCards(tp,tc)
		if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetRange(LOCATION_PZONE)
			e1:SetAbsoluteRange(tp,1,0)
			e1:SetValue(c9910242.aclimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1,true)
		end
		Duel.ShuffleDeck(tp)
	end
end
function c9910242.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
