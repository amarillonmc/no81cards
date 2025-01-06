--长夜降临
function c22021450.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22021450+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22021450.cost)
	e1:SetTarget(c22021450.target)
	e1:SetOperation(c22021450.activate)
	c:RegisterEffect(e1)
end
c22021450.effect_with_altria=true
function c22021450.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22021450,1))
	Duel.SelectOption(tp,aux.Stringid(22021450,2))
end
function c22021450.filter(c)
	return c:IsSetCard(0x6ff1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c22021450.cfilter(c,e,tp)
	return c:IsSetCard(0x3ff1) and c:IsFaceup()
end
function c22021450.spfilter(c,e,tp)
	return c:IsSetCard(0xff9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22021450.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22021450.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if Duel.IsExistingMatchingCard(c22021450.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	end
end
function c22021450.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22021450.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local g=Duel.GetMatchingGroup(c22021450.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		if #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22021450.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22021450,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SelectOption(tp,aux.Stringid(22021450,3))
			Duel.SelectOption(tp,aux.Stringid(22021450,4))
			Duel.SelectOption(tp,aux.Stringid(22021450,5))
			Duel.SelectOption(tp,aux.Stringid(22021450,6))
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
