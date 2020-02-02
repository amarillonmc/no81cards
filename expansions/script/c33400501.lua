--命运的相遇
function c33400501.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33400501+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c33400501.target)
	e1:SetOperation(c33400501.activate)
	c:RegisterEffect(e1)
end
function c33400501.filter(c)
	return (c:IsSetCard(0x6341) or  c:IsSetCard(0x3344))  and c:IsAbleToHand() 
end
function c33400501.filter2(c,e,tp)
	return (c:IsSetCard(0x6341) or  c:IsSetCard(0x3344)) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0xc342) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400501.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400501.filter,tp,LOCATION_DECK,0,1,nil) or
	Duel.IsExistingMatchingCard(c33400501.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	end
   if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0xc342) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)   
end
function c33400501.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=0
	if Duel.IsExistingMatchingCard(c33400501.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	   if Duel.SelectYesNo(tp,aux.Stringid(33400501,0)) then 
	   local tc=Duel.SelectMatchingCard(tp,c33400501.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp) 
	   Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	   op=1
	   end
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c33400501.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
