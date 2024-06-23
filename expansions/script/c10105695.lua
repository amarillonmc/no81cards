function c10105695.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionCode,13171876),c10105695.ffilter,1,true)
	aux.AddContactFusionProcedure(c,c10105695.cfilter,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,aux.tdcfop(c))
    	--code
	aux.EnableChangeCode(c,13171876,LOCATION_MZONE)
	c:SetSPSummonOnce(10105695)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10105695)
	e1:SetTarget(c10105695.target)
	e1:SetOperation(c10105695.operation)
	c:RegisterEffect(e1)
    end
function c10105695.ffilter(c)
	return c:IsSetCard(0x133)
end
function c10105695.cfilter(c)
	return c:IsType(TYPE_MONSTER)
		 and c:IsAbleToDeckOrExtraAsCost()
end
function c10105695.filter1(c,tp,slv)
	local lv1=c:GetLevel()
	return c:IsFaceup() and c:IsSetCard(0x133) and lv1>0
		and Duel.IsExistingTarget(c10105695.filter2,tp,0,LOCATION_MZONE,1,nil,lv1,slv)
end
function c10105695.filter2(c,lv1,slv)
	local lv2=c:GetLevel()
	return c:IsFaceup() and lv2>0 and lv1+lv2>=slv
end
function c10105695.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x133) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not lv or c:IsLevelBelow(lv))
end
function c10105695.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local sg=Duel.GetMatchingGroup(c10105695.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then
		if sg:GetCount()==0 then return false end
		local mg,mlv=sg:GetMinGroup(Card.GetLevel)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingTarget(c10105695.filter1,tp,LOCATION_MZONE,0,1,nil,tp,mlv)
	end
	local mg,mlv=sg:GetMinGroup(Card.GetLevel)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c10105695.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp,mlv)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,c10105695.filter2,tp,0,LOCATION_MZONE,1,1,nil,g1:GetFirst():GetLevel(),mlv)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10105695.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==0 then return end
	Duel.SendtoGrave(tg,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=tg:GetFirst()
	local lv=0
	if tc:IsLocation(LOCATION_GRAVE) then lv=lv+tc:GetLevel() end
	tc=tg:GetNext()
	if tc and tc:IsLocation(LOCATION_GRAVE) then lv=lv+tc:GetLevel() end
	if lv==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10105695.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.BreakEffect()
		c:SetCardTarget(tc)
	end
	Duel.SpecialSummonComplete()
end