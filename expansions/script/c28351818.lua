--渐开的六出花 梦想进化论
function c28351818.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c28351818.matfilter,nil,nil,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),1,1)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c28351818.recon)
	e1:SetTarget(c28351818.retg)
	e1:SetOperation(c28351818.reop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c28351818.thtg)
	e2:SetOperation(c28351818.thop)
	c:RegisterEffect(e2)
end
function c28351818.matfilter(c,syncard)
	return c:IsTuner(syncard) or Duel.GetLP(c:GetControler())>=9000
end
function c28351818.recon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c28351818.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c28351818.cfilter(c,tp)
	return c:IsAbleToHand() and c:IsLocation(LOCATION_GRAVE)
end
function c28351818.reop(e,tp,eg,ep,ev,re,r,rp)
	local mg=e:GetHandler():GetMaterial()
	Duel.Recover(tp,1000,REASON_EFFECT)
	if Duel.GetLP(tp)>=10000 and mg:IsExists(c28351818.cfilter,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(28351818,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=mg:Filter(c28351818.cfilter,nil,tp):Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1,true)
	end
end
function c28351818.thfilter(c)
	return c:IsSetCard(0x287) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or c:IsSSetable())
end
function c28351818.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c28351818.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28351818.tgfilter(c)
	return c:IsSetCard(0x287) and c:IsAbleToGrave()
end
function c28351818.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c28351818.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SSet(tp,tc)
	end
	if Duel.GetLP(tp)>=10000 and Duel.IsExistingMatchingCard(c28351818.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28351818,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local gg=Duel.SelectMatchingCard(tp,c28351818.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(gg,REASON_EFFECT)
	end
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1,true)
	end
end
