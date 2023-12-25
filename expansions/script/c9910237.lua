--天空漫步者-易位
function c9910237.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910237.target)
	e1:SetOperation(c9910237.activate)
	c:RegisterEffect(e1)
end
function c9910237.dcfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsDiscardable(REASON_EFFECT)
end
function c9910237.spfilter1(c,e,tp)
	return c:IsLink(1) and c:IsSetCard(0x955)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9910237.tdfilter(c)
	return c:IsFaceupEx() and c:IsRace(RACE_PSYCHO) and c:IsAbleToDeck()
end
function c9910237.spfilter2(c,e,tp)
	return c:IsSetCard(0x955) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910237.tgfilter(c)
	return c:IsSetCard(0x955) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c9910237.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc,exc)
	if chkc then
		if e:GetLabel()==1 then
			return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9910237.tdfilter(chkc)
		elseif e:GetLabel()==2 then
			return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c9910237.tdfilter(chkc)
		end
	end
	local b1=Duel.IsExistingMatchingCard(c9910237.dcfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c9910237.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c9910237.tdfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c9910237.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b3=Duel.IsExistingTarget(c9910237.tdfilter,tp,LOCATION_GRAVE,0,1,exc)
		and Duel.IsExistingMatchingCard(c9910237.tgfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(9910237,0)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(9910237,1)
		opval[off]=1
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(9910237,2)
		opval[off]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(0)
		e:SetOperation(c9910237.activate)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	elseif sel==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c9910237.tdfilter,tp,LOCATION_MZONE,0,1,1,nil)
		e:SetOperation(c9910237.activate2)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c9910237.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		e:SetOperation(c9910237.activate3)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
end
function c9910237.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,c9910237.dcfilter,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910237.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c9910237.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910237.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) then
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
end
function c9910237.activate3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910237.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local gc=g:GetFirst()
		if Duel.SendtoGrave(gc,REASON_EFFECT)~=0 and gc:IsLocation(LOCATION_GRAVE) and tc:IsRelateToEffect(e) then
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
end
