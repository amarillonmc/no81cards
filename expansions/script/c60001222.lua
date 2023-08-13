--黄金首饰
local m=60001222
local cm=_G["c"..m]
cm.name="黄金首饰"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter2(c,e,tp)
	return c.named_with_treasure and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil)
	local tg=g:GetFirst()
	if tg==nil then return end
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,60001211,RESET_PHASE+PHASE_END,0,1000)
	if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():IsPreviousLocation(LOCATION_HAND) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.Remove(c,POS_FACEUP,REASON_RULE)
	else
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.SendtoDeck(c,tp,2,REASON_RULE)
	end
end