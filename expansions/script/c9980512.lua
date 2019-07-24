--光之流法—辉彩华刃
function c9980512.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c9980512.condition)
	e1:SetTarget(c9980512.target)
	e1:SetOperation(c9980512.activate)
	c:RegisterEffect(e1)
end
function c9980512.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcbcc)
end
function c9980512.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated() and Duel.IsExistingMatchingCard(c9980512.cfilter,tp,LOCATION_PZONE+LOCATION_MZONE,0,1,nil)
end
function c9980512.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5bcc)
end
function c9980512.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9980512.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980512.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9980512.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetChainLimit(c9980512.chainlm)
end
function c9980512.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetValue(tc:GetDefense()*2)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetCondition(c9980512.rdcon)
		e3:SetOperation(c9980512.rdop)
		tc:RegisterEffect(e3)
	end
end
function c9980512.chainlm(e,rp,tp)
	return tp==rp
end
function c9980512.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c9980512.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
