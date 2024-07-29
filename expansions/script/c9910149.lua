--战车道的鬼屋
function c9910149.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910149+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9910149.cost)
	e1:SetOperation(c9910149.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910149,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function c9910149.cfilter(c)
	return c:IsRace(RACE_MACHINE) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost()
end
function c9910149.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (not c:IsLocation(LOCATION_HAND)
		or Duel.IsExistingMatchingCard(c9910149.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)) end
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c9910149.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c9910149.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c9910149.thcon)
	e1:SetOperation(c9910149.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910149.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD,nil)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct
end
function c9910149.tofifilter(c)
	return c:IsSetCard(0x9958) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c9910149.thfilter(c,mg)
	local res=mg:IsContains(c)
	for mc in aux.Next(mg) do
		if mc:GetColumnGroup():IsContains(c) then res=true end
	end
	return res and c:IsAbleToHand()
end
function c9910149.thfilter2(g)
	for c in aux.Next(g) do
		local cg=Group.__band(c:GetColumnGroup(),g)
		if cg:GetCount()>0 then return false end
	end
	return true
end
function c9910149.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910149)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD,nil)
	Duel.ConfirmDecktop(tp,ct)
	local dg=Duel.GetDecktopGroup(tp,ct)
	local g=dg:Filter(c9910149.tofifilter,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>2 then ft=2 end
	local og=Group.CreateGroup()
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910149,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:Select(tp,1,ft,nil)
		local fc=sg:GetFirst()
		while fc do
			Duel.MoveToField(fc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			fc:RegisterEffect(e1)
			fc=sg:GetNext()
		end
		og=sg:Filter(Card.IsOnField,nil)
	end
	Duel.ShuffleDeck(tp)
	if og:GetCount()==0 then return end
	local tg=Duel.GetMatchingGroup(c9910149.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,og)
	if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910149,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tsg=tg:SelectSubGroup(tp,c9910149.thfilter2,false,1,#tg)
		Duel.HintSelection(tsg)
		Duel.SendtoHand(tsg,nil,REASON_EFFECT)
	end
end
