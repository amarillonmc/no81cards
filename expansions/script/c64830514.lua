--「02的反击」
local m=64830514
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,64830500)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)	
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:IsFacedown() or not c:IsCode(64830500)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) and rp~=tp
end
function cm.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	if Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_MZONE,0,1,nil) and not Duel.IsExistingMatchingCard(cm.cfilter2,tp,0,LOCATION_MZONE,1,nil) then
		Duel.SetChainLimit(cm.chainlimit)
	end
end
function cm.chainlimit(e,rp,tp)
	return tp==rp or not e:IsHasType(EFFECT_TYPE_ACTIVATE) or not e:IsActiveType(TYPE_TRAP)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local f=function(c)
		return c:IsAbleToGrave() and c:IsCode(64830500)
	end 
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		re:GetHandler():CancelToGrave()
		if Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(f,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,f,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
