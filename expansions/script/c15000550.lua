local m=15000550
local cm=_G["c"..m]
cm.name="缓行之『蛇』"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chlc:IsPosition(POS_FACEDOWN) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,LOCATION_MZONE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local sc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc):GetFirst()
	if Duel.ChangePosition(sc,POS_FACEDOWN_DEFENSE)~=0 and tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end