--山田组集结
function c88800036.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88800036,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88800036)
	e1:SetTarget(c88800036.target)
	e1:SetOperation(c88800036.activate)
	c:RegisterEffect(e1)
end
function c88800036.thfilter(c,check)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and ((check and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_DARK)) or c:IsSetCard(0xc02))
end
function c88800036.checkfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xc02) and c:IsFaceup()
end
function c88800036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local check=Duel.IsExistingMatchingCard(c88800036.checkfilter,tp,LOCATION_MZONE,0,1,nil)
		return Duel.IsExistingMatchingCard(c88800036.thfilter,tp,LOCATION_DECK,0,1,nil,check)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88800036.activate(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsExistingMatchingCard(c88800036.checkfilter,tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88800036.thfilter,tp,LOCATION_DECK,0,1,1,nil,check)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
