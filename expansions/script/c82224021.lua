function c82224021.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_ATKCHANGE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetHintTiming(TIMING_DAMAGE_STEP)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCondition(c82224021.condition)  
	e1:SetTarget(c82224021.target)  
	e1:SetOperation(c82224021.activate)  
	c:RegisterEffect(e1)  
end  
function c82224021.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE)
end
function c82224021.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()  
end  
function c82224021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end  
	if chk==0 then return Duel.IsExistingTarget(c82224021.filter,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,c82224021.filter,tp,LOCATION_MZONE,0,1,1,nil)  
end  
function c82224021.activate(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
		e1:SetValue(1000)  
		tc:RegisterEffect(e1)  
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
		e2:SetRange(LOCATION_MZONE)  
		e2:SetCode(EFFECT_IMMUNE_EFFECT)  
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
		e2:SetValue(c82224021.efilter)  
		e2:SetLabel(tp)
		tc:RegisterEffect(e2)  
	end  
end  
function c82224021.efilter(e,te)
	local p=e:GetLabel()
	return te:GetHandlerPlayer()~=p  
end  