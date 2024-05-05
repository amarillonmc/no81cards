--银河列车·花火
function c78313975.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,4,c78313975.lcheck)
	c:EnableReviveLimit()
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78313975,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,78313975)
	e1:SetCondition(c78313975.setcon)
	e1:SetTarget(c78313975.settg)
	e1:SetOperation(c78313975.setop)
	c:RegisterEffect(e1)
	--terrora of the overroot
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,88313975)
	e2:SetTarget(c78313975.target)
	e2:SetOperation(c78313975.activate)
	c:RegisterEffect(e2)
end
function c78313975.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x746)
end
function c78313975.setcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c78313975.sfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c78313975.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c78313975.sfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c78313975.sfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c78313975.sfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c78313975.lvfilter(c)
	return c:IsFaceup() and not c:IsLevel(1)
end
function c78313975.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 and Duel.IsExistingMatchingCard(c78313975.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(78313975,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local lc=Duel.SelectMatchingCard(tp,c78313975.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		lc:RegisterEffect(e1)
	end
end
function c78313975.tgfilter(c,e,tp)
	return c:IsAbleToGrave() and Duel.IsExistingTarget(c78313975.setfilter,tp,LOCATION_GRAVE,0,1,nil,c,e,tp)
end
function c78313975.setfilter(c,cc,e,tp)
	local b1=Duel.GetMZoneCount(1-tp,cc,tp)>0
	local st=Duel.GetLocationCount(tp,LOCATION_SZONE,tp)
	local b2=st>0 or cc:IsLocation(LOCATION_SZONE) and cc:GetSequence()<5 and st>-1
	return b1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp)
		or (b2 or c:IsType(TYPE_FIELD)) and c:IsSSetable(true)
end
function c78313975.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c78313975.tgfilter,tp,0,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c78313975.tgfilter,tp,0,LOCATION_ONFIELD,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g2=Duel.SelectTarget(tp,c78313975.setfilter,tp,LOCATION_GRAVE,0,1,1,nil,g1:GetFirst(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	if g2:GetFirst():IsType(TYPE_MONSTER) then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
	else
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g2,1,0,0)
	end
end
function c78313975.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=tg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD):GetFirst()
	local tc2=tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetFirst()
	if tc1 and tc1:IsRelateToEffect(e) and Duel.SendtoGrave(tc1,REASON_EFFECT)~=0 and tc1:IsLocation(LOCATION_GRAVE)
		and tc2 and tc2:IsRelateToEffect(e) then
		if tc2:IsType(TYPE_MONSTER) then
			Duel.SpecialSummon(tc2,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
		else
			Duel.SSet(tp,tc2,1-tp)
		end
	end
end
