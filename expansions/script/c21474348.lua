--向往精灵之境的精灵（未改
function c21474348.initial_effect(c)
	aux.AddCodeList(c,35563539)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21474348,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,21474348)
	e1:SetTarget(c21474348.thtg)
	e1:SetOperation(c21474348.thop)
	c:RegisterEffect(e1)
end
function c21474348.thfilter(c)
	return aux.IsCodeListed(c,35563539) and not c:IsCode(21474348) and c:IsAbleToHand()
end
function c21474348.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21474348.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,0,0,0)
end
function c21474348.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsRace(RACE_SPELLCASTER) and c:IsAttack(2100) and c:IsDefense(1500)
end
function c21474348.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21474348.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c21474348.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(21474348,0)) then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,c21474348.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
			if sg:GetCount()>0 then
				Duel.Summon(tp,sg:GetFirst(),true,nil)
			end
		end
	end
end