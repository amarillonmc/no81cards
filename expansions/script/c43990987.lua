--雨中行者
function c43990987.initial_effect(c)
	aux.AddCodeList(c,43990987)
	--link summon
	aux.AddLinkProcedure(c,c43990987.matfilter,1,1)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,43990987)
	e1:SetTarget(c43990987.target)
	e1:SetOperation(c43990987.operation)
	c:RegisterEffect(e1)
end
function c43990987.matfilter(c)
	return (c:GetOriginalType()&TYPE_TRAP)~=0
end
function c43990987.cfilter(c,e,tp)
	return aux.IsCodeListed(c,43990987)
		and (c:IsAbleToGrave() or Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c43990987.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990987.cfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c43990987.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c43990987.cfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc then
		if tc:IsAbleToGrave() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetMZoneCount(tp)<=0 or Duel.SelectOption(tp,1191,1152)==0) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
