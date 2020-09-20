--强制封印·万魔神殿
function c9980710.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c9980710.atktg)
	e2:SetValue(c9980710.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(c9980710.counter)
	c:RegisterEffect(e4)
	--Auto Death
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c9980710.filter)
	e2:SetValue(aux.TRUE)
	c:RegisterEffect(e2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980710,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c9980710.thtg)
	e1:SetOperation(c9980710.thop)
	c:RegisterEffect(e1)
end
c9980710.card_code_list={9980706}
function c9980710.atktg(e,c)
	return not c:IsSetCard(0xbc8) 
end
function c9980710.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x1009)*-200
end
function c9980710.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c9980710.counter(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c9980710.cfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x1009,ct)
	end
end
function c9980710.filter(e,c)
	return (c:IsAttackBelow(500) or c:IsDefenseBelow(500)) and c:IsFaceup() and not c:IsSetCard(0xbc8) and not c:IsImmuneToEffect(e) and c:IsDestructable()
end
function c9980710.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbc8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9980710.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c9980710.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980710.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9980710.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9980710.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end