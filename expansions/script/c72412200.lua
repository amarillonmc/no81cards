--星宫守护者·室女
function c72412200.initial_effect(c)
	aux.AddCodeList(c,724121210)
		--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72412200,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,72412200)
	e1:SetTarget(c72412200.sptg)
	e1:SetOperation(c72412200.spop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
			--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,72412201)
	e2:SetOperation(c72412200.regop)
	c:RegisterEffect(e2)
end
function c72412200.tgfilter(c)
	return c:IsSetCard(0x9728) and c:IsAbleToGrave()
end
function c72412200.spfilter(c,e,tp)
	return c:IsSetCard(0x9728) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72412200.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72412200.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c72412200.tgfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c72412200.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c72412200.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		local sg=Duel.SelectMatchingCard(tp,c72412200.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c72412200.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c72412200.thcon)
	e1:SetOperation(c72412200.thop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,tp)
end
function c72412200.thfilter(c,tp)
	local res=Duel.IsPlayerAffectedByEffect(tp,9911020) and c:IsSetCard(0x9728) and c:IsType(TYPE_MONSTER)
	local res2=Duel.GetFlagEffect(tp,72421261)<=0 and c:IsCode(72421260)
	return (c:IsCode(72412210) or res or res2) and c:IsAbleToHand()
end
function c72412200.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.IsExistingMatchingCard(c72412200.thfilter,tp,LOCATION_DECK,0,1,nil,tp)
end
function c72412200.thop(e,tp,eg,ep,ev,re,r,rp)
	Effect.Reset(e)
	Duel.Hint(HINT_CARD,0,72412200)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c72412200.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():GetCode()==72412160 and not Duel.IsPlayerAffectedByEffect(tp,9911020) then
		   Duel.RegisterFlagEffect(tp,72421261,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
