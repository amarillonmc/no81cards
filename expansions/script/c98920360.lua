--海晶少女 海月亮
function c98920360.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_WATER),2,3,c98920360.lcheck)
	c:EnableReviveLimit()
--atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(c98920360.atkvalue)
	c:RegisterEffect(e4)
 --remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920360,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c98920360.rmcon)
	e4:SetTarget(c98920360.rmtg)
	e4:SetOperation(c98920360.rmop)
	c:RegisterEffect(e4)
--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920360,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,98920360)
	e3:SetCondition(c98920360.condition2)
	e3:SetTarget(c98920360.target2)
	e3:SetOperation(c98920360.operation2)
	c:RegisterEffect(e3)
end
function c98920360.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_LINK)
end
function c98920360.rmfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x12b) and c:IsType(TYPE_MONSTER)
end
function c98920360.atkvalue(e,c)
	return Duel.GetMatchingGroupCount(c98920360.rmfilter,c:GetControler(),LOCATION_REMOVED,0,nil)*500
end
function c98920360.rmcfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x12b) and c:IsPreviousControler(tp)
end
function c98920360.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920360.rmcfilter,1,e:GetHandler(),tp)
end
function c98920360.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and c:GetFlagEffect(98920360)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	c:RegisterFlagEffect(98920360,RESET_CHAIN,0,1)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98920360.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c98920360.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function c98920360.tgfilter2(c,check)
	return c:IsSetCard(0x12b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98920360.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c98920360.tgfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920360.tgfilter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c98920360.tgfilter2,tp,LOCATION_REMOVED,0,1,1,nil,check)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c98920360.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsAbleToHand() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end