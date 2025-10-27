--星绘·汐澜
function c11185080.initial_effect(c)
	aux.AddCodeList(c,0x452)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,11185080)
	e1:SetTarget(c11185080.target)
	e1:SetOperation(c11185080.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11185080,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,11185080+1)
	e2:SetTarget(c11185080.sptg)
	e2:SetOperation(c11185080.spop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,11185080+2)
	e3:SetCost(c11185080.thcost)
	e3:SetTarget(c11185080.thtg)
	e3:SetOperation(c11185080.thop)
	c:RegisterEffect(e3)
	local e33=e3:Clone()
	e33:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e33)
	Duel.AddCustomActivityCounter(11185080,ACTIVITY_SUMMON,c11185080.counterfilter)
	Duel.AddCustomActivityCounter(11185080,ACTIVITY_SPSUMMON,c11185080.counterfilter)
end
function c11185080.counterfilter(c)
	return c:IsRace(RACE_FAIRY) or aux.IsCodeListed(c,0x452)
end
function c11185080.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x452,1) and c:IsSetCard(0x452)
end
function c11185080.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c11185080.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11185080.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	Duel.SelectTarget(tp,c11185080.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x452)
end
function c11185080.tfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x452) and not c:IsForbidden()
end
function c11185080.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:AddCounter(0x452,1) then
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
		local g=Duel.GetMatchingGroup(c11185080.tfilter,tp,0x31,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(11185080,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg=g:Select(tp,1,1,nil)
			if sg:GetCount()>0 then
				Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
		end
	end
end
function c11185080.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11185080.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11185080.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(11185080,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(11185080,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11185080.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c11185080.splimit(e,c)
	return not (c:IsRace(RACE_FAIRY) or aux.IsCodeListed(c,0x452))
end
function c11185080.thfilter(c)
	return c:IsSetCard(0x452) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c11185080.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11185080.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11185080.thfilter2(c)
	return c:IsSetCard(0x452) and c:IsAbleToHand()
end
function c11185080.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11185080.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(0x2) then
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c11185080.thfilter2),tp,0x30,0,1,nil)
			and Duel.IsCanRemoveCounter(tp,1,1,0x452,1,REASON_EFFECT)
			and Duel.SelectYesNo(tp,aux.Stringid(11185080,1)) then
			Duel.BreakEffect()
			if not Duel.IsCanRemoveCounter(tp,1,1,0x452,1,REASON_EFFECT) then end
			if not Duel.RemoveCounter(tp,1,1,0x452,1,REASON_EFFECT) then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11185080.thfilter2),tp,0x30,0,1,1,nil)
			Duel.HintSelection(g)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end