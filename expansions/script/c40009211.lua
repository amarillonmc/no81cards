--SOPHIE-一人千面
function c40009211.initial_effect(c)
	c:SetUniqueOnField(1,0,40009211)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009211,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCountLimit(1,40009211)
	e2:SetCost(c40009211.cost)
	e2:SetCondition(c40009211.condition)
	e2:SetTarget(c40009211.target)
	e2:SetOperation(c40009211.activate)
	c:RegisterEffect(e2) 
	c40009211.discard_effect=e2   
end
function c40009211.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	if c:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,c)
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c40009211.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xdf1d)
end
function c40009211.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c40009211.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c40009211.filter(c)
	return (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup())) and c:IsAbleToDeck()
end
function c40009211.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) and c40009211.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40009211.filter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c40009211.filter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,1-tp,LOCATION_GRAVE+LOCATION_ONFIELD)
end
function c40009211.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c40009211.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c40009211.discon)
		e2:SetOperation(c40009211.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
	end
end
function c40009211.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c40009211.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c40009211.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
