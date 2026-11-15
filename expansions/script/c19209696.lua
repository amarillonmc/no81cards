--乐士洗脑舞台
function c19209696.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19209696,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,19209696)
	e1:SetTarget(c19209696.thtg)
	e1:SetOperation(c19209696.thop)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209696,1))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c19209696.ctcon)
	e2:SetTarget(c19209696.cttg)
	e2:SetOperation(c19209696.ctop)
	c:RegisterEffect(e2)
end
function c19209696.chkfilter(c)
	return c:IsOriginalSetCard(0xb53) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx()
end
function c19209696.thfilter(c)
	return c:IsSetCard(0xb53) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and c:IsFaceupEx() and not c:IsCode(19209696)
end
function c19209696.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209696.chkfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c19209696.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c19209696.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c19209696.chkfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	if #g==0 then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c19209696.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end
function c19209696.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:GetHandler():IsOriginalSetCard(0xb53) and e:GetHandler()~=re:GetHandler()
end
function c19209696.ctfilter(c,tp)
	return c:IsFaceup() and c:IsAttackAbove(c:GetBaseAttack()+2500) and c:IsControlerCanBeChanged()
end
function c19209696.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c19209696.ctfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c19209696.ctfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c19209696.ctfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c19209696.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end
