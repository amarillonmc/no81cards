--CAN:D 安妮噗
function c88888209.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88888209,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,88888209)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c88888209.thtg)
	e1:SetOperation(c88888209.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--szone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88888209,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,18888209)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c88888209.xcon)
	e3:SetTarget(c88888209.xtg)
	e3:SetOperation(c88888209.xop)
	c:RegisterEffect(e3)
end
function c88888209.thfilter(c)
	return c:IsSetCard(0x8908) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(88888209)
end
function c88888209.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88888209.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88888209.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88888209.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c88888209.xcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c88888209.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x8908)
end
function c88888209.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c88888209.xfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c88888209.xfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c88888209.xfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c88888209.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_ONFIELD) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	Duel.Overlay(tc,Group.FromCards(c))
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c88888209.setfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(88888209,1),1},
		{b2,aux.Stringid(88888209,2),2},
		{true,aux.Stringid(88888209,3),3})
	if op==1 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c88888209.setfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
		local sc=g:GetFirst()
		if sc then
			Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			sc:RegisterEffect(e1)
		end
	elseif op==2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c88888209.setfilter(c)
	return c:IsSetCard(0x8908) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end