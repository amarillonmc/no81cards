--魔法钟爱
function c1000414.initial_effect(c)
	c:SetUniqueOnField(1,0,1000414)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(c1000414.discon2)
	e2:SetTarget(c1000414.sfilter)
	e2:SetValue(c1000414.efilter)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,1000414)
	e3:SetCost(c1000414.setcost)
	e3:SetCondition(c1000414.setcon)
	e3:SetTarget(c1000414.settg)
	e3:SetOperation(c1000414.setop)
	c:RegisterEffect(e3)
end
function c1000414.sfilter(e,c)
	return c:IsFaceup() and c:IsSetCard(0xa201) and c:IsType(TYPE_MONSTER)
end
function c1000414.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa201) and c:IsType(TYPE_MONSTER)
end
function c1000414.discon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1000414.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c1000414.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL) then return true end
end
function c1000414.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xa201) and c:IsAbleToDeckAsCost()
end
function c1000414.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c1000414.filter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c1000414.filter2,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c1000414.filter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c1000414.setcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c1000414.filter1,tp,LOCATION_GRAVE,0,1,nil)
end
function c1000414.setfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function c1000414.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c1000414.setfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c1000414.setfilter,tp,0,LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c1000414.setfilter,tp,0,LOCATION_GRAVE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c1000414.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
	end
end