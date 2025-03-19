--常理溶解的恋慕屋敷
function c9911065.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911065+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9911065.target)
	e1:SetOperation(c9911065.activate)
	e1:SetValue(c9911065.zones)
	c:RegisterEffect(e1)
end
function c9911065.filter(c,b)
	return c:IsSetCard(0x9954) and c:IsType(TYPE_PENDULUM) and ((b and not c:IsForbidden()) or c:IsAbleToHand())
end
function c9911065.spfilter(c,e,tp)
	return c:IsSetCard(0x9954) and c:IsType(TYPE_EFFECT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911065.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local sp=Duel.IsExistingMatchingCard(c9911065.filter,tp,LOCATION_DECK,0,1,nil,false)
		or Duel.IsExistingMatchingCard(c9911065.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	if p0==p1 or sp then return zone end
	if p0 then zone=zone-0x1 end
	if p1 then zone=zone-0x10 end
	return zone
end
function c9911065.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local g1=Duel.GetMatchingGroup(c9911065.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c9911065.filter,tp,LOCATION_DECK,0,nil,b)
	if chk==0 then return #g1+#g2>0 end
	local s=0
	if #g1>0 and #g2==0 then
		s=Duel.SelectOption(tp,aux.Stringid(9911065,0))
	end
	if #g1==0 and #g2>0 then
		s=Duel.SelectOption(tp,aux.Stringid(9911065,1))+1
	end
	if #g1>0 and #g2>0 then
		s=Duel.SelectOption(tp,aux.Stringid(9911065,0),aux.Stringid(9911065,1))
	end
	e:SetLabel(s)
	if s==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	end
end
function c9911065.addfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsLocation(LOCATION_MZONE) and c:IsCanAddCounter(0x1954,2)
end
function c9911065.activate(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local g1=Duel.GetMatchingGroup(c9911065.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c9911065.filter,tp,LOCATION_DECK,0,nil,b)
	if e:GetLabel()==0 and #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g1:Select(tp,1,1,nil):GetFirst()
		if not sc or Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)==0
			or sc:GetLocation()~=LOCATION_MZONE then return end
		local g1=sc:GetColumnGroup()
		g1:AddCard(sc)
		local g2=g1:Filter(c9911065.addfilter,nil)
		for tc in aux.Next(g2) do
			tc:AddCounter(0x1954,2)
		end
	end
	if e:GetLabel()==1 and #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g2:Select(tp,1,1,nil):GetFirst()
		if not tc then return end
		local b1=tc:IsAbleToHand()
		local b2=b and not tc:IsForbidden()
		if b1 and (not b2 or Duel.SelectOption(tp,1190,1160)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
