--天空漫步者-空返踢
function c9910214.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c9910214.condition)
	e1:SetTarget(c9910214.target)
	e1:SetOperation(c9910214.activate)
	c:RegisterEffect(e1)
end
function c9910214.cfilter(c)
	return c:GetSequence()<5 and (c:IsFacedown() or not c:IsRace(RACE_PSYCHO))
end
function c9910214.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9910214.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910214.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x6956) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910214.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c9910214.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9910214.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9910214.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9910214.linkfilter(c)
	return c:IsLinkSummonable(nil) and c:IsRace(RACE_PSYCHO)
end
function c9910214.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0
		and e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetCurrentChain()>2 then
		Duel.AdjustAll()
		local g=Duel.GetMatchingGroup(c9910214.linkfilter,tp,LOCATION_EXTRA,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910214,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local lc=g:Select(tp,1,1,nil):GetFirst()
			Duel.LinkSummon(tp,lc,nil)
		end
	end
end
