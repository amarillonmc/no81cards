--终末之剑士 末影
function c21079001.initial_effect(c)
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21079001,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c21079001.target)
	e1:SetCountLimit(2,21079001)
	e1:SetOperation(c21079001.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(2,21079001)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c21079001.thtg)
	e4:SetOperation(c21079001.thop)
	c:RegisterEffect(e4)
end
function c21079001.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToGrave() and c:IsLevelBelow(4)
end
function c21079001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21079001.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c21079001.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21079001.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c21079001.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c21079001.splimit(e,c)
	return (not (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_DRAGON) or c:IsRace(RACE_SPELLCASTER))) or not c:IsAttribute(ATTRIBUTE_DARK)
end
function c21079001.thfilter(c)
	return (c:IsSetCard(0x8ee) or c:IsCode(28985331)) and c:IsAbleToHand()
end
function c21079001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21079001.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21079001.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsAttribute(ATTRIBUTE_DARK) and (not c:IsRace(RACE_WARRIOR))
end
function c21079001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21079001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c21079001.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(21079001,2)) then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,c21079001.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
			if sg:GetCount()>0 then
				Duel.Summon(tp,sg:GetFirst(),true,nil)
			end
		end
	end
end