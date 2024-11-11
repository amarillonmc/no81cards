--鬼王 伊丽莎白·巴托里
function c77096011.initial_effect(c)
	aux.AddCodeList(c,77096005) 
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77096011,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,77096011)
	e1:SetCost(c77096011.cost)
	e1:SetTarget(c77096011.target)
	e1:SetOperation(c77096011.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77096011,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,77096011)
	e2:SetCondition(c77096011.spcon)
	e2:SetTarget(c77096011.sptg)
	e2:SetOperation(c77096011.spop)
	c:RegisterEffect(e2)
end
function c77096011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c77096011.filter(c)
	return (aux.IsCodeListed(c,77096005) or c:IsCode(77096005)) and not c:IsCode(77096011) and c:IsAbleToHand()
end
function c77096011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c77096011.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77096011.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77096011.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c77096011.cfilter(c)
	return c:IsFaceup() and c:IsCode(77096005)
end
function c77096011.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77096011.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c77096011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77096011.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CHANGE_LEVEL) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(4) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1) 
	end
end



