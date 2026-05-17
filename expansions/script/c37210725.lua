--大幻魔眼 真窗之心
function c11210725.initial_effect(c)
	aux.AddCodeList(c,11210685)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11210725.target)
	e1:SetOperation(c11210725.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c11210725.reptg)
	e2:SetValue(c11210725.repval)
	e2:SetOperation(c11210725.repop)
	c:RegisterEffect(e2)
end
function c11210725.thfilter(c,check)
	return (c:IsCode(11210685) or check and c:IsRace(RACE_ILLUSION) and c:IsAttribute(ATTRIBUTE_DARK)) and c:IsAbleToHand()
end
function c11210725.checkfilter(c)
	return c:IsCode(11210685) and c:IsFaceup()
end
function c11210725.setfilter(c,check)
	return c:IsCode(11210690,23446369) and c:IsSSetable()
end
function c11210725.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.IsExistingMatchingCard(c11210725.checkfilter,tp,LOCATION_ONFIELD,0,1,nil)
	local b1=Duel.IsExistingMatchingCard(c11210725.thfilter,tp,LOCATION_DECK,0,1,nil,check) and Duel.GetFlagEffect(tp,11210725)==0
	local b2=Duel.IsExistingMatchingCard(c11210725.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,11210726)==0
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(11210725,0)},
		{b2,aux.Stringid(11210725,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.RegisterFlagEffect(tp,11210725,RESET_PHASE+PHASE_END,0,1)
	elseif op==2 then
		e:SetCategory(CATEGORY_SSET)
		Duel.RegisterFlagEffect(tp,11210726,RESET_PHASE+PHASE_END,0,1)
	end
end
function c11210725.cfilter(c)
	return c:IsRace(RACE_ILLUSION) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelAbove(6) and c:IsFaceup()
end
function c11210725.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local check=Duel.IsExistingMatchingCard(c11210725.checkfilter,tp,LOCATION_ONFIELD,0,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c11210725.thfilter,tp,LOCATION_DECK,0,1,1,nil,check):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=Duel.SelectMatchingCard(tp,c11210725.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if not tc or Duel.SSet(tp,tc)==0 or not Duel.IsExistingMatchingCard(c11210725.cfilter,tp,LOCATION_MZONE,0,1,nil) then return end
		local code=tc:IsType(TYPE_TRAP) and EFFECT_TRAP_ACT_IN_SET_TURN or EFFECT_QP_ACT_IN_SET_TURN 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(11210725,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(code)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c11210725.repfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_ILLUSION) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c11210725.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c11210725.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c11210725.repval(e,c)
	return c11210725.repfilter(c,e:GetHandlerPlayer())
end
function c11210725.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
