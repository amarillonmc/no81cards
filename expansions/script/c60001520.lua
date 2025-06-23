--来自异次元的枪击
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK,0x11e0)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	if Duel.GetOperatedGroup():GetFirst():IsSetCard(0x5622) then e:SetLabel(99) end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and e:GetLabel()==99 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,60001504) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,60001505) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,60001504)
		local sg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,60001505)
		g:Merge(sg)
		if g:GetCount()>1 and Duel.SendtoHand(g,nil,REASON_EFFECT)>1 then
			Duel.ConfirmCards(1-tp,g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local tc=Duel.SelectMatchingCard(tp,cm.cfil,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
			tc:AddCounter(0x624,1)
			Duel.RegisterFlagEffect(tp,60002148,0,0,1)
		end
	end
end
function cm.filter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function cm.cfil(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x624) and c:IsType(TYPE_MONSTER)
end