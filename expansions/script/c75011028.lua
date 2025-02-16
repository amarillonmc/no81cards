--炼金工房夏日大冒险
function c75011028.initial_effect(c)
	aux.AddCodeList(c,46130346,5318639,12580477)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,75011028)
	e1:SetTarget(c75011028.target)
	e1:SetOperation(c75011028.activate)
	c:RegisterEffect(e1)
	--spsummon-self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1190)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,75011029)
	e2:SetCondition(c75011028.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c75011028.thtg)
	e2:SetOperation(c75011028.thop)
	c:RegisterEffect(e2)
end
function c75011028.cfilter(c)
	return c:IsSetCard(0x75e) and (c:IsType(TYPE_XYZ) or c:IsAbleToGrave()) and c:IsFaceup()
end
function c75011028.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c75011028.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75011028.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c75011028.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c75011028.thfilter(c,tc)
	return aux.IsCodeListed(tc,c:GetCode()) and c:IsAbleToHand()
end
function c75011028.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	if tc:IsType(TYPE_XYZ) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(75011028,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c75011028.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	else
		if Duel.SendtoGrave(tc,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_GRAVE) then return end
		if Duel.Damage(1-tp,600,REASON_EFFECT)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c75011028.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,tc)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c75011028.efilter(e,te)
	return te:IsActivated() and te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c75011028.chkfilter(c,tp,rp)
	return c:IsPreviousControler(1-tp) and rp==tp
end
function c75011028.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75011028.chkfilter,1,nil,tp,rp)
end
function c75011028.tfilter(c,tp)
	return c:IsCode(46130346,5318639,12580477)
		and Duel.IsExistingMatchingCard(c75011028.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c)
end
function c75011028.sfilter(c,tc)
	return aux.IsCodeListed(c,tc:GetCode()) and c:IsSetCard(0x75e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c75011028.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x10) and chkc:IsControler(tp) and c75011028.tfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c75011028.tfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c75011028.tfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c75011028.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75011028.sfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
