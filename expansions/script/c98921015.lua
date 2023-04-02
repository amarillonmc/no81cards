--天底的神影
function c98921015.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98921015+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c98921015.target)
	e1:SetOperation(c98921015.activate)
	c:RegisterEffect(e1)
end
function c98921015.tgfilter(c,tp)
	return c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c98921015.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel())
end
function c98921015.thfilter(c,lv)
	return (c:IsSetCard(0xb4) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL)) and c:IsLevel(lv) and c:IsAbleToHand()
end
function c98921015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921015.tgfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98921015.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98921015.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		local lv=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98921015.thfilter),tp,LOCATION_DECK,0,1,1,nil,lv)
		local hc=hg:GetFirst()
		if hc then
			Duel.BreakEffect()
			Duel.SendtoHand(hc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hc)
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c98921015.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c98921015.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end