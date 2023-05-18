--治安战警队 铂金少女
function c98920439.initial_effect(c)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920439,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,98920439)
	e3:SetTarget(c98920439.thtg)
	e3:SetOperation(c98920439.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--redirect
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e13:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e13:SetRange(LOCATION_MZONE)
	e13:SetTargetRange(0,LOCATION_MZONE)
	e13:SetTarget(c98920439.rmtg)
	e13:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e13)
end
function c98920439.rmfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x156) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c98920439.rmtg(e,c)
	local cg=c:GetColumnGroup()
	return cg:IsExists(c98920439.rmfilter,1,nil,e:GetHandlerPlayer())
end
function c98920439.thfilter(c)
	return c:IsSetCard(0x156) and not c:IsCode(98920439) and c:IsAbleToHand()
end
function c98920439.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98920439.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920439.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c98920439.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c98920439.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end