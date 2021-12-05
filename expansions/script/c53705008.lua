local m=53705008
local cm=_G["c"..m]
cm.name="幻海袭来之梦"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(cm.handcon)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_HAND)
	e5:SetTarget(cm.reptarget)
	e5:SetOperation(cm.repoperation)
	c:RegisterEffect(e5)
end
function cm.reptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsPublic() and c:GetDestination()==LOCATION_DECK end
	return true
end
function cm.repoperation(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	c:ResetEffect(EFFECT_PUBLIC,RESET_CODE)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		SNNM.SetPublic(tc,3)
	end
end
function cm.handcon(e)
	return e:GetHandler():IsPublic()
end
