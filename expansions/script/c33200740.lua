--苍岚水师出征
function c33200740.initial_effect(c)
	c:SetUniqueOnField(1,1,33200740)
	c:EnableCounterPermit(0x32a)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200740,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,33200740)
	e2:SetTarget(c33200740.sptg)
	e2:SetOperation(c33200740.spop)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200740,1))
	e3:SetCategory(CATEGORY_COUNTER+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,33200741)
	e3:SetTarget(c33200740.counttg)
	e3:SetOperation(c33200740.counter)
	c:RegisterEffect(e3)
end

--e2
function c33200740.spfilter(c,e,tp)
	local count=c:GetLink()
	return c:IsType(TYPE_LINK) and c:IsSetCard(0xc32a) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x32a,count,REASON_EFFECT)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) 
end
function c33200740.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c33200740.spfilter(chkc,e,tp)  end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33200740.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c33200740.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.ConfirmCards(1-tp,g)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	e:SetLabel(100)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(33200740,0))
end
function c33200740.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()~=100 then return end
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local count=tc:GetLink()
	if tc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,tc)>0 and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x32a,count,REASON_EFFECT) then
		if Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x32a,count,REASON_EFFECT) then
			Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c33200740.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c33200740.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xc32a) and bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK 
end

--e3
function c33200740.counttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c33200740.cfilter(chkc) end
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x32a,2) and Duel.IsExistingTarget(c33200740.cfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c33200740.cfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.HintSelection(g)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetHandler(),0,0x32a)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(33200740,1))
end
function c33200740.cfilter(c)
	return c:IsSetCard(0xc32a) and c:IsAbleToDeck()
end
function c33200740.counter(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==2 then
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==2 and e:GetHandler():IsRelateToEffect(e) then
			e:GetHandler():AddCounter(0x32a,2)
		end 
	end
end