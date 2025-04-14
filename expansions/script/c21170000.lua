--神启的天启录
function c21170000.initial_effect(c)
	c:SetUniqueOnField(1,0,21170000)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c21170000.con)
	e1:SetValue(c21170000.val)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(5)
	e2:SetCondition(c21170000.con2)
	e2:SetTarget(c21170000.tg2)
	e2:SetOperation(c21170000.op2)
	c:RegisterEffect(e2)
end
function c21170000.q(c,s)
	return c:IsFaceup() and (c:IsSetCard(0x6917) and s==1 or c:IsCode(21170000+1) and s==2)
end
function c21170000.con(e)
	return Duel.IsExistingMatchingCard(c21170000.q,e:GetHandlerPlayer(),4,0,1,nil,1) or Duel.IsExistingMatchingCard(c21170000.q,e:GetHandlerPlayer(),8,0,1,nil,2)
end
function c21170000.val(e,te)
	return te:GetOwner()~=e:GetHandler() and te:IsActivated()
end
function c21170000.w(c)
	return c:IsSetCard(0x6907) and c:GetOriginalType()==TYPE_SPELL and c:IsAbleToHand()
end
function c21170000.con2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c21170000.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21170000.w,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21170000.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21170000.w,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	end
end