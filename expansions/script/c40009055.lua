--绝海之零点龙 梅吉德
function c40009055.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009055,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40009055)
	e1:SetCondition(c40009055.spcon1)
	e1:SetCost(c40009055.drcost)
	e1:SetTarget(c40009055.sptg2)
	e1:SetOperation(c40009055.spop2)
	c:RegisterEffect(e1)	
end
function c40009055.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c40009055.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c40009055.relfilter(c,tp)
	return c:IsReleasableByEffect() and Duel.GetMZoneCount(tp,c)>0 and c:IsLevelAbove(1)
end
function c40009055.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c40009055.relfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,e:GetHandler())
	if chk==0 then return  g:CheckWithSumEqual(Card.GetLevel,12,5,5)
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c40009055.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c40009055.relfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectWithSumEqual(tp,Card.GetLevel,12,5,5)
	if sg and sg:GetCount()>0 then
	if Duel.Release(sg,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
end
end
function c40009055.mat_group_check(g)
	return #g==5 and g:GetCount()==5
end