--落徽
function c11561052.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,11561052)
	e1:SetTarget(c11561052.target)
	e1:SetOperation(c11561052.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,11561052)
	e3:SetTarget(c11561052.spstg2)
	e3:SetOperation(c11561052.spsop2)
	--c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1,11561052)
	e4:SetCondition(c11561052.thcon)
	e4:SetTarget(c11561052.thtg)
	e4:SetOperation(c11561052.thop)
	c:RegisterEffect(e4)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11561052,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c11561052.handcon)
	c:RegisterEffect(e2)
	
end
function c11561052.hafilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP)
end
function c11561052.handcon(e)
	return Duel.IsExistingMatchingCard(c11561052.hafilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c11561052.spfilter2(c,e,tp)
	return c:GetOriginalType()&TYPE_MONSTER>0 and c:GetType()&TYPE_CONTINUOUS+TYPE_TRAP==TYPE_CONTINUOUS+TYPE_TRAP and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsAbleToHand() and (c:GetControler()==tp or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function c11561052.spstg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c11561052.spfilter2(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c11561052.spfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11561052.spfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c11561052.spsop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) and c:IsAbleToHand()  then
		Duel.BreakEffect()
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
function c11561052.spfilter(c,e,tp)
	return c:GetOriginalType()&TYPE_MONSTER>0 and c:GetType()&TYPE_CONTINUOUS+TYPE_TRAP==TYPE_CONTINUOUS+TYPE_TRAP and c:IsFaceup() and ((c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or (c:IsAbleToDeck() and e:GetHandler():IsSSetable() and (c:GetControler()==tp or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)))
end
function c11561052.spstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c11561052.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c11561052.spfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11561052.spfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
end
function c11561052.spsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	local off=1
	local ops={}
	local opval={}
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAbleToDeck() then
		ops[off]=aux.Stringid(11561052,0)
		opval[off-1]=1
		off=off+1
	end
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and tc:IsAbleToDeck() and c:IsSSetable() and (c:GetControler()==tp or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
		ops[off]=aux.Stringid(11561052,1)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsAbleToDeck() then
			Duel.BreakEffect()
			Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	elseif opval[op]==2 then
		if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and c:IsSSetable() and (c:GetControler()==tp or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
			Duel.BreakEffect()
			Duel.SSet(tp,c)
		end
	end
end

function c11561052.filter1(c,tp)
	return not c:IsForbidden()
end
function c11561052.filter(c,e,tp,eg)
	return c:IsSummonPlayer(tp) and not c:IsForbidden()
end
function c11561052.mtsfilter(c,eg)
	return c:IsType(TYPE_MONSTER) and not eg:IsContains(c) and not c:IsForbidden()
end
function c11561052.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():IsLocation(LOCATION_HAND) and 1 or 0
	local g=eg:Filter(c11561052.filter1,nil)
	local sg=Duel.GetMatchingGroup(c11561052.filter1,tp,LOCATION_MZONE,0,nil)
	local ct1=g:FilterCount(c11561052.filter,nil,e,tp,eg)
	local ct2=g:FilterCount(c11561052.filter,nil,e,1-tp,eg)
	if chk==0 then return eg:IsExists(c11561052.filter1,1,nil) and Group.__sub(sg,g):GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>ft+ct1+1 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>ct2 end
	Duel.SetTargetCard(g)
end
function c11561052.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local sg=Duel.GetMatchingGroup(c11561052.filter1,tp,LOCATION_MZONE,0,nil)
	local g2=Group.__sub(sg,g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g2=Duel.SelectMatchingCard(tp,c11561052.mtsfilter,tp,LOCATION_MZONE,0,1,1,nil,eg)
	local g=Group.__add(g1,g2)
	local ct1=g:FilterCount(c11561052.filter,nil,e,tp,eg)
	local ct2=g:FilterCount(c11561052.filter,nil,e,1-tp,eg)

	if Duel.GetLocationCount(tp,LOCATION_SZONE)>ct1 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>ct2 then
		for tc in aux.Next(g) do
			if not tc:IsImmuneToEffect(e) then
				Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
				tc:RegisterEffect(e1)
			end
		end
	end
end
function c11561052.thfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP)
end
function c11561052.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11561052.thfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c11561052.tthfilter(c)
	return c:IsAbleToHand() and c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER
end
function c11561052.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c11561052.tthfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c11561052.tthfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Group.AddCard(g,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c11561052.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Group.CreateGroup()
	if tc and tc:IsRelateToEffect(e) then Group.AddCard(g,tc) end
	if c and c:IsRelateToEffect(e) then Group.AddCard(g,c) end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
