--黄金之杯
local m=60001223
local cm=_G["c"..m]
cm.name="黄金之杯"
function cm.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.recop)
	c:RegisterEffect(e1)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Recover(tp,1000,REASON_EFFECT)
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