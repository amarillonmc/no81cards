--魔犀族武将
function c49811240.initial_effect(c)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,49811240)
	e1:SetCondition(c49811240.ctcon)
	e1:SetCost(c49811240.ctcost)
	e1:SetTarget(c49811240.cttg)
	e1:SetOperation(c49811240.ctop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,49811340)
	e2:SetTarget(c49811240.thtg)
	e2:SetOperation(c49811240.thop)
	c:RegisterEffect(e2)
end
function c49811240.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c49811240.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c49811240.ctfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function c49811240.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c49811240.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c49811240.ctfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c49811240.ctfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c49811240.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local seq=tc:GetSequence()
	if seq==5 then
		seq=1
	elseif seq==6 then
		seq=3
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c49811240.tgtg)
	e1:SetValue(1)
	e1:SetLabel(seq)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c49811240.tgtg(e,c)
	local seq=e:GetLabel()
	local tp=e:GetHandlerPlayer()
	return aux.GetColumn(c,tp)==seq
end
function c49811240.filter(c,e)
	local atk1=e:GetHandler():GetAttack()
	local atk2=c:GetAttack()
	return ((c:IsFaceup() and c:IsLocation(LOCATION_REMOVED)) or c:IsLocation(LOCATION_GRAVE))
		and c:IsRace(RACE_FIEND) and Duel.IsExistingMatchingCard(c49811240.afilter,tp,LOCATION_DECK,0,1,nil,atk1,atk2)
end
function c49811240.afilter(c,atk1,atk2)
	return c:IsRace(RACE_FIEND) and c:IsAbleToHand() and c:IsAttack(math.abs(atk1-atk2))
end
function c49811240.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc~=c and chkc:IsControler(tp)
		and c49811240.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c49811240.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c49811240.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,c,e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c49811240.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local atk1=c:GetAttack()
	local atk2=tc:GetAttack()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c49811240.afilter,tp,LOCATION_DECK,0,1,1,nil,atk1,atk2)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end