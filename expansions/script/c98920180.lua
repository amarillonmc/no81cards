--枪管改造
function c98920180.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98920180+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c98920180.target)
	e1:SetOperation(c98920180.activate)
	c:RegisterEffect(e1)
end
function c98920180.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x102) and Duel.IsExistingMatchingCard(c98920180.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c98920180.filter2(c,e,tp,tc)
	return not c:IsCode(tc:GetCode()) and c:IsAbleToHand() and c:IsSetCard(0x102)
end
function c98920180.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98920180.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c98920180.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c98920180.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920180.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c98920180.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			::cancel::
			local mg=Duel.GetMatchingGroup(c98920180.desfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,e,tp)
			local g1=Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,nil,c98920180.efilter,e,tp,mg,nil,Card.GetLevel,"Greater")
			if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98920180,1)) then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			   local tc1=g1:Select(tp,1,1,nil):GetFirst()
			   mg=mg:Filter(Card.IsCanBeRitualMaterial,tc1,tc1)
			   if tc1.mat_filter then
				  mg=mg:Filter(tc1.mat_filter,tc1,tp)
			   else
				  mg:RemoveCard(tc1)
			   end
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			   aux.GCheckAdditional=aux.RitualCheckAdditional(tc1,tc1:GetLevel(),"Greater")
			   local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc1:GetLevel(),tp,tc1,tc1:GetLevel(),"Greater")
			   aux.GCheckAdditional=nil
			   if not mat then goto cancel end
			   tc1:SetMaterial(mat)
			   Duel.Destroy(mat,REASON_EFFECT)
			   Duel.BreakEffect()
			   Duel.SpecialSummon(tc1,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			   tc1:CompleteProcedure()
			end
		end
	end
end
function c98920180.efilter(c,e,tp)
	return c:IsRace(RACE_DRAGON)
end
function c98920180.desfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK)
end