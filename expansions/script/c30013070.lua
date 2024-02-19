--深土的沉封域
local m=30013070
local cm=_G["c"..m]
function cm.initial_effect(c) 
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--Effect 2
	local e15=Effect.CreateEffect(c)
	e15:SetCategory(CATEGORY_TOHAND)
	e15:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e15:SetCode(EVENT_TO_GRAVE)
	e15:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	--e15:SetCondition(cm.spcon)
	e15:SetCountLimit(1,m)
	e15:SetTarget(cm.sptg)
	e15:SetOperation(cm.spop)
	c:RegisterEffect(e15) 
end
--Effect 1
function cm.ctf(c)
	return c:IsFacedown() or (c:IsType(TYPE_FLIP) or c:IsSetCard(0x92c))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc~=c and chkc:IsControler(tp) and cm.ctf(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.ctf,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.ctf,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local ct=Duel.GetCurrentChain()
	if ct<2 then return false end
	local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if tep==1-tp and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.BreakEffect()
		local e11=Effect.CreateEffect(c)
		e11:SetType(EFFECT_TYPE_FIELD)
		e11:SetCode(EFFECT_IMMUNE_EFFECT)
		e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e11:SetTargetRange(LOCATION_ONFIELD,0)
		e11:SetLabelObject(tc)
		e11:SetOwnerPlayer(tp)
		e11:SetTarget(cm.ettg)
		e11:SetValue(cm.etval)
		e11:SetReset(RESET_EVENT+RESET_CHAIN)
		Duel.RegisterEffect(e11,tp)
	end	
end
function cm.ettg(e,c)
	return c==e:GetLabelObject()
end
function cm.etval(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--Effect 2
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():IsPreviousControler(tp)
end
function cm.spfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_FLIP)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)  then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
--Effect 4 
--Effect 5   