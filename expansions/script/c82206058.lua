local m=82206058
local cm=_G["c"..m]
cm.name="植占阵-调律"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)  
	--tuner  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetCountLimit(1,m)  
	e2:SetTarget(cm.tntg)  
	e2:SetOperation(cm.tnop)  
	c:RegisterEffect(e2) 
	--Negate  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e3:SetCode(EVENT_CHAIN_SOLVING)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCondition(cm.negcon)  
	e3:SetOperation(cm.negop)  
	c:RegisterEffect(e3)  
end
function cm.tnfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x129d) and c:IsLevelAbove(0) and not c:IsType(TYPE_TUNER)
end  
function cm.tntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.tnfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.tnfilter,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,cm.tnfilter,tp,LOCATION_MZONE,0,1,1,nil)  
end  
function cm.tnop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_ADD_TYPE)  
		e1:SetValue(TYPE_TUNER)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)   
	end  
end  
function cm.cfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x129d) 
end  
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetFlagEffect(m)==0 and (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) and rp~=tp and Duel.IsChainDisablable(ev) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end  
function cm.negop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then  
		Duel.Hint(HINT_CARD,0,m)  
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)  
		if Duel.NegateEffect(ev) then  
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)  
		end  
	end  
end 