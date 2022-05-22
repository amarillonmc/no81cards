--人理之星 罗慕路斯
function c22021380.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xff1),2,2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22021380,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22021380)
	e1:SetTarget(c22021380.target)
	e1:SetOperation(c22021380.activate)
	c:RegisterEffect(e1)
end
function c22021380.spfilter(c,e,tp)
	return c:IsSetCard(0x2ff1) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22021380.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22021380.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22021380.spfilter2(c,e,tp,mc)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22021380.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c22021380.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c22021380.spfilter2),1-tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,1-tp,tc)
		if #g2<=0 or not Duel.SelectYesNo(1-tp,aux.Stringid(22021380,1)) then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local tc2=g2:Select(1-tp,1,1,nil):GetFirst()
		if tc2 and Duel.SpecialSummonStep(tc2,0,1-tp,1-tp,false,false,POS_FACEUP) then
		end
		Duel.SpecialSummonComplete()
	end
end
