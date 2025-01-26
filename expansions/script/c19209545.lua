--大众的集合 ES
function c19209545.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xb50),2,2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,19209545)
	e1:SetCondition(c19209545.thcon)
	e1:SetTarget(c19209545.thtg)
	e1:SetOperation(c19209545.thop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(TIMING_MAIN_END)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19209546)
	e2:SetCondition(c19209545.setcon)
	e2:SetTarget(c19209545.settg)
	e2:SetOperation(c19209545.setop)
	c:RegisterEffect(e2)
end
function c19209545.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c19209545.thfilter(c)
	return c:IsCode(19209547,19209548) and c:IsAbleToHand()
end
function c19209545.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209545.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c19209545.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c19209545.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c19209545.setcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c19209545.cfilter(c)
	return c:IsSetCard(0x3b50) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and (c:IsAbleToRemove() or not c:IsForbidden())
end
function c19209545.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c:IsControler(tp) and c19209545.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19209545.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c19209545.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c19209545.pfilter(c,code)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xb50) and not c:IsCode(code) and not c:IsForbidden() and aux.NecroValleyFilter()(c)
end
function c19209545.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local check=false
	if tc:IsAbleToRemove() and (tc:IsForbidden() or Duel.SelectOption(tp,1192,aux.Stringid(19209545,0))==0) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		if tc:IsLocation(LOCATION_REMOVED) then check=true end
	else
		Duel.SendtoExtraP(tc,nil,REASON_EFFECT)
		if tc:IsLocation(LOCATION_EXTRA) then check=true end
	end
	if check and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c19209545.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tc:GetCode()) and Duel.SelectYesNo(tp,aux.Stringid(19209545,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local pc=Duel.SelectMatchingCard(tp,c19209545.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc:GetCode()):GetFirst()
		if pc then Duel.MoveToField(pc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) end
	end
end
