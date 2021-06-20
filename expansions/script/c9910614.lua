--双影杀手-破雾者
function c9910614.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9910614.thcon)
	e1:SetOperation(c9910614.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c9910614.spcon)
	e2:SetOperation(c9910614.spop)
	c:RegisterEffect(e2)
end
function c9910614.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK 
end
function c9910614.filter1(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function c9910614.filter2(c,check)
	return check and c:IsFacedown() and c:IsAbleToDeck()
end
function c9910614.cfilter(c,e)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c9910614.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local check=Duel.IsExistingMatchingCard(Card.IsSummonType,tp,0,LOCATION_MZONE,1,nil,SUMMON_TYPE_NORMAL)
	local g1=Duel.GetMatchingGroup(c9910614.filter1,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(c9910614.filter2,tp,0,LOCATION_ONFIELD,nil,check)
	if Duel.IsExistingMatchingCard(c9910614.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,c,e)
		and (g1:GetCount()>0 or g2:GetCount()>0) and Duel.SelectYesNo(tp,aux.Stringid(9910614,0)) then
		Duel.Hint(HINT_CARD,0,9910614)
		if g1:GetCount()>0 and (g2:GetCount()==0 or Duel.SelectOption(tp,1104,1105)==0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local cg=Duel.SelectMatchingCard(tp,c9910614.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,g1:GetCount(),c,e)
			if Duel.SendtoGrave(cg,REASON_EFFECT)==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local sg=g1:Select(tp,cg:GetCount(),cg:GetCount(),nil)
			Duel.HintSelection(sg)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local cg=Duel.SelectMatchingCard(tp,c9910614.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,g2:GetCount(),c,e)
			if Duel.SendtoGrave(cg,REASON_EFFECT)==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=g2:Select(tp,cg:GetCount(),cg:GetCount(),nil)
			Duel.HintSelection(sg)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
end
function c9910614.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9910614.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,1-tp,LOCATION_HAND,0,nil,e,0,1-tp,false,false)
	if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(1-tp,aux.Stringid(9910614,1)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)
	end
end
