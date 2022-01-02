--大庭院的纯白
function c72404107.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TTIMING_END_PHASE)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c72404107.target)
	e1:SetOperation(c72404107.activate)
	c:RegisterEffect(e1)
end
function c72404107.filter(c)
	return  c:IsRace(RACE_PLANT) and c:IsReleasableByEffect()
end
function c72404107.filter1(c)
	return  c:IsRace(RACE_PLANT) and c:IsAbleToDeck()
end
function c72404107.filter2(c)
	return  c:IsSetCard(0x720) and c:IsAbleToHand()
end
function c72404107.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c72404107.filter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c72404107.filter,tp,LOCATION_HAND,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(c72404107.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c72404107.filter2,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil)
	local b4=Duel.IsExistingMatchingCard(c72404107.filter1,tp,LOCATION_GRAVE,0,5,nil)
	if chk==0 then return b1 or b2 or b3 or b4 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(72404107,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(72404107,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(72404107,2)
		opval[off-1]=3
		off=off+1
	end
	if b4 then
		ops[off]=aux.Stringid(72404107,3)
		opval[off-1]=4
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1  then
		e:SetCategory(CATEGORY_RECOVER+CATEGORY_RELEASE)
	elseif sel==2 then
		e:SetCategory(CATEGORY_RELEASE)
	elseif sel==3 then
		e:SetCategory(CATEGORY_RELEASE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	elseif sel==4 then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	end
end
function c72404107.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,c72404107.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		   if Duel.SendtoGrave(g,REASON_RELEASE+REASON_EFFECT)~=0 then
				Duel.Recover(tp,500,REASON_EFFECT)
			end
		end
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,c72404107.filter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
		   if Duel.SendtoGrave(g,REASON_RELEASE+REASON_EFFECT)~=0 then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_FIELD)
						e1:SetCode(EFFECT_CANNOT_DISEFFECT)
						e1:SetValue(c72404107.effectfilter)
						e1:SetReset(RESET_PHASE+PHASE_END)
						Duel.RegisterEffect(e1,tp)
						Duel.RegisterFlagEffect(tp,72404107,RESET_PHASE+PHASE_END,0,1)
		   end
		end
	elseif sel==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,c72404107.filter1,tp,LOCATION_GRAVE,0,5,5,nil)
			if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==5 then
				  Duel.Draw(tp,1,REASON_EFFECT)
			end
		
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,c72404107.filter,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
		   if Duel.SendtoGrave(g,REASON_RELEASE+REASON_EFFECT)~=0 then
				local xg=Duel.SelectMatchingCard(tp,c72404107.filter2,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
						if g:GetCount()>0 then
						Duel.SendtoHand(xg,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,xg)
						end
		   end
		end
	end

	if c:IsRelateToEffect(e) and c:IsCanTurnSet() and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function c72404107.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return tc:IsSetCard(0x720)
end
