local m=53799146
local cm=_G["c"..m]
cm.name="春画要求"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_BOTH_SIDE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.mmtg)
	e2:SetOperation(cm.mmop)
	c:RegisterEffect(e2)
end
function cm.filter(c,e)
	return c:IsFaceup() and not e:GetHandler():IsHasCardTarget(c)
end
function cm.mmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc,e) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e)
	e:GetHandler():SetCardTarget(g:GetFirst())
end
function cm.mmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local opt=0
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then opt=opt+1 end
		if Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then opt=opt+1 end
		if opt==2 then Duel.SendtoHand(tc,nil,REASON_RULE) end
	end
end
