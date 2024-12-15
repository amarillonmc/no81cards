--闪刀启动 着装
function c11513056.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	--e1:SetCountLimit(1,11513056+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11513056.condition)
	e1:SetTarget(c11513056.target)
	e1:SetOperation(c11513056.activate)
	c:RegisterEffect(e1)
end
function c11513056.cfilter(c)
	return c:GetSequence()<5
end
function c11513056.spfilter(c,e,tp)
	return c:IsSetCard(0x1115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11513056.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c11513056.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11513056.filter(c)
	return c:IsSetCard(0x115) and c:IsAbleToGrave()
end
function c11513056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11513056.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c11513056.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c11513056.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~-0 then
		if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c11513056.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(11513056,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11513056.spfilter),tp,0x12,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

