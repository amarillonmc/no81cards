local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65814999)
	-- ①
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(TIMING_DESTROY,TIMINGS_CHECK_MONSTER)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	-- ②
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter1,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter1,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.costfilter1(c)
	return aux.IsCodeListed(c,65814999) and c:IsAbleToGraveAsCost()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local optA=Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		local optB=c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(s.retfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		return optA or optB
	end
	local off={}
	local opt={}
	if Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		off[#off+1]=aux.Stringid(id,1)
		opt[#opt+1]=0
	end
	if c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(s.retfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then
		off[#off+1]=aux.Stringid(id,2)
		opt[#opt+1]=1
	end
	if #off==1 then
		e:SetLabel(opt[1])
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local op=Duel.SelectOption(tp,table.unpack(off))
		e:SetLabel(opt[op+1])
	end
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then 
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
		e:SetCategory(CATEGORY_SSET)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
	else
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		e:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	end
end
function s.rmfilter(c)
	return c:IsSetCard(0x6a31) and c:IsAbleToRemoveAsCost()
end
function s.retfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x6a31) or aux.IsCodeListed(c,65814999)) and c:IsAbleToDeck()
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.SSet(tp,c)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.retfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()==0 then return end
		local tc=g:GetFirst()
		Duel.HintSelection(g)
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then return end
		local code=tc:GetCode()
		if not Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,3)) then return end
		local mg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,code,e,tp)
		if mg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=mg:Select(tp,1,1,nil)
			if sg:GetCount()>0 then
				Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
			end
		end
	end
end
function s.spfilter(c,code,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
