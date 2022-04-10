--神树勇者 结城友奈
function c9910305.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910305)
	e1:SetCost(c9910305.thcost)
	e1:SetTarget(c9910305.thtg)
	e1:SetOperation(c9910305.thop)
	c:RegisterEffect(e1)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c9910305.target)
	e1:SetOperation(c9910305.operation)
	c:RegisterEffect(e1)
end
function c9910305.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c9910305.thfilter(c)
	return c:IsCode(9910307) and c:IsAbleToHand()
end
function c9910305.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910305.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910305.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c9910305.thfilter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c9910305.filter1(c)
	return c:IsSetCard(0x956) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910305.filter2(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_PLANT) and c:IsAbleToHand()
end
function c9910305.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c9910305.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFlagEffect(tp,9910305)==0
	local b2=Duel.IsExistingMatchingCard(c9910305.filter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFlagEffect(tp,9910306)==0
	if chk==0 then return b1 or b2 end
end
function c9910305.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9910305.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local b1=Duel.IsExistingMatchingCard(c9910305.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFlagEffect(tp,9910305)==0
	local b2=Duel.IsExistingMatchingCard(c9910305.filter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFlagEffect(tp,9910306)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(9910305,0),aux.Stringid(9910305,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(9910305,0))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(9910305,1))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9910305.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		Duel.RegisterFlagEffect(tp,9910305,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9910305.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		Duel.RegisterFlagEffect(tp,9910306,RESET_PHASE+PHASE_END,0,1)
	end
end
function c9910305.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_PLANT)) and c:IsLocation(LOCATION_EXTRA)
end
