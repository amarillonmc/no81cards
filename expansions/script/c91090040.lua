--相剑·干将
function c91090040.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91090040,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,91090040)
	e1:SetTarget(c91090040.target)
	e1:SetOperation(c91090040.activate)
	c:RegisterEffect(e1)
	--fusion summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,91090041)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c91090040.target2)
	e2:SetOperation(c91090040.activate2)
	c:RegisterEffect(e2)
end
function c91090040.spfilter(c,e,tp)
	return  c:IsSetCard(0x16b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c91090040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c91090040.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c91090040.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c91090040.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c91090040.thfilter(c)
	return  c:IsAbleToHand()
		and (c:IsSetCard(0x16b))
end
function c91090040.thfilter2(c)
	return  c:IsAbleToGrave() and c:IsType(TYPE_SPELL+TYPE_TRAP) 
		and (c:IsSetCard(0x16b))
end
function c91090040.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c91090040.thfilter,tp,LOCATION_DECK,0,1,nil) and  Duel.IsExistingMatchingCard(c91090040.thfilter2,tp,LOCATION_DECK,0,1,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c91090040.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c91090040.thfilter,tp,LOCATION_DECK,0,1,1,nil,check)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then  
		Duel.ConfirmCards(1-tp,g)
		end
	end
end