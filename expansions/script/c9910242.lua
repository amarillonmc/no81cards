--生命摇篮
function c9910242.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetCountLimit(1,9910242+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910242.target)
	e1:SetOperation(c9910242.activate)
	e1:SetValue(c9910242.zones)
	c:RegisterEffect(e1)
end
function c9910242.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local ft=0
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if p0 then ft=ft+1 end
	if p1 then ft=ft+1 end
	local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE)
	local st=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local b1=not b and ft>0
	local b2=b and ft==1 and st-ft>0
	local b3=b and ft==2
	if b1 or b3 then return zone end
	if b2 and p0 then zone=zone-0x1 end
	if b2 and p1 then zone=zone-0x10 end
	return zone
end
function c9910242.filter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c9910242.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910242.filter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.drccheck,4,4)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c9910242.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910242.filter,tp,LOCATION_DECK,0,nil)
	if not g:CheckSubGroup(aux.drccheck,4,4) or (not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.drccheck,false,4,4)
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
			sg:RemoveCard(tc)
		end
		if #sg>0 then
			Duel.SendtoExtraP(sg,nil,REASON_EFFECT)
		end
		Duel.ShuffleDeck(tp)
	end
end
function c9910242.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
