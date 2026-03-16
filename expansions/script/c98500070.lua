--混沌的招来神
function c98500070.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c98500070.mfilter,1,1)
	--tograve and spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98500070,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98500070)
	e2:SetTarget(c98500070.tgtg)
	e2:SetOperation(c98500070.tgop)
	c:RegisterEffect(e2)
end
function c98500070.mfilter(c)
	return c:IsAttack(0) and c:IsRace(RACE_FIEND)
end
function c98500070.tgfilter(c,e,tp)
	return (c:IsAttack(0) or c:IsDefense(0)) and c:IsRace(RACE_FIEND) and c:IsAbleToGrave()
end
function c98500070.spfilter(c,e,tp)
	return c:IsAttack(0) and c:IsDefense(0) and c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c98500070.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(c98500070.tgfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetMZoneCount(tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c98500070.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c98500070.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c98500070.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(98500070,0)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c98500070.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)		
	end
end