--折纸使-朱雀演舞
function c9910004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c9910004.condition)
	e1:SetCost(c9910004.cost)
	e1:SetTarget(c9910004.target)
	e1:SetOperation(c9910004.activate)
	e1:SetValue(c9910004.zones)
	c:RegisterEffect(e1)
end
function c9910004.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local ft=0
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if p0 then ft=ft+1 end
	if p1 then ft=ft+1 end
	if Duel.CheckLocation(1-tp,LOCATION_PZONE,0) then ft=ft+1 end
	if Duel.CheckLocation(1-tp,LOCATION_PZONE,1) then ft=ft+1 end
	local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE)
	local st=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local b1=not b and ft>0
	local b2=b and ft==1 and st-ft>0
	local b3=b and ft>1
	if b1 or b3 then return zone end
	if b2 and p0 then zone=zone-0x1 end
	if b2 and p1 then zone=zone-0x10 end
	return zone
end
function c9910004.cfilter(c)
	return c:GetSequence()<5 and (c:IsFacedown() or not c:IsType(TYPE_PENDULUM))
end
function c9910004.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9910004.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9910004.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x3950) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c9910004.filter2(c)
	return not c:IsLocation(LOCATION_PZONE) and c:IsAbleToDeck()
end
function c9910004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c9910004.filter1,tp,LOCATION_EXTRA,0,nil)
	local g2=Duel.GetMatchingGroup(c9910004.filter2,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g1>0 and #g2>0
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
		or Duel.CheckLocation(1-tp,LOCATION_PZONE,0) or Duel.CheckLocation(1-tp,LOCATION_PZONE,1)) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,g2:GetCount(),0,0)
end
function c9910004.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c9910004.filter1,tp,LOCATION_EXTRA,0,nil)
	local ft=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ft=ft+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ft=ft+1 end
	if Duel.CheckLocation(1-tp,LOCATION_PZONE,0) then ft=ft+1 end
	if Duel.CheckLocation(1-tp,LOCATION_PZONE,1) then ft=ft+1 end
	if #g1==0 or ft==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tg=g1:Select(tp,1,ft,nil)
	local ct=0
	while #tg>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
		local b2=Duel.CheckLocation(1-tp,LOCATION_PZONE,0) or Duel.CheckLocation(1-tp,LOCATION_PZONE,1)
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(9910004,0),aux.Stringid(9910004,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(9910004,0))
		elseif b2 then
			op=Duel.SelectOption(tp,aux.Stringid(9910004,1))+1
		end
		if (op==0 and Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true))
			or (op==1 and Duel.MoveToField(tc,tp,1-tp,LOCATION_PZONE,POS_FACEUP,true)) then
			ct=ct+1
		end
		tg:RemoveCard(tc)
	end
	local g2=Duel.GetMatchingGroup(c9910004.filter2,tp,0,LOCATION_ONFIELD,nil)
	if #g2==0 or ct==0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g2:Select(tp,1,ct,nil)
	Duel.HintSelection(sg)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
