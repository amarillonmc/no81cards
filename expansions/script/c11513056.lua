--闪刀启动 着装
function c11513056.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,11513056+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11513056.condition)
	e1:SetTarget(c11513056.target)
	e1:SetOperation(c11513056.activate)
	c:RegisterEffect(e1)
end
function c11513056.cfilter(c)
	return c:GetSequence()<5
end
function c11513056.thfilter(c,e,tp,spchk)
	return c:IsSetCard(0x1115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not c:IsLocation(LOCATION_DECK) or spchk)
end
function c11513056.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c11513056.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11513056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local spchk=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c11513056.thfilter,tp,0x13,0,1,nil,e,tp,spchk) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c11513056.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local spchk=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11513056.thfilter),tp,0x13,0,1,1,nil,e,tp,spchk)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end 
