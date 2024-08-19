--艾妮丝王女
function c12852102.initial_effect(c)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12852102,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,12852103)
	e2:SetCondition(c12852102.sscon)
	e2:SetTarget(c12852102.sstg)
	e2:SetOperation(c12852102.ssop)
	c:RegisterEffect(e2)   
	--search
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(12852102,2))
	e12:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1,12852104)
	e12:SetTarget(c12852102.thtg)
	e12:SetOperation(c12852102.thop)
	c:RegisterEffect(e12) 
end
function c12852102.filter(c)
	return c:IsSetCard(0x3a78) and c:IsAbleToHand()
end
function c12852102.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c12852102.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c12852102.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12852102.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tg=Duel.SelectMatchingCard(tp,c12852102.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
		if tg:GetCount()>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function c12852102.thfilter1(c)
	return (c:IsSetCard(0x3a78) or c:IsCode(12852101)) and c:IsAbleToHand()
end
function c12852102.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12852102.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12852102.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12852102.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():IsCode(12852101) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(12852102,0))
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
			e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
			e1:SetTarget(c12852102.estg)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,12931061,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c12852102.estg(e,c)
	return c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)
end