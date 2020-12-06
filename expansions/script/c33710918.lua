--随绊而去的永恒
function c33710918.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c33710918.matfilter,3,3)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(c33710918.actcon)
	c:RegisterEffect(e1) 
	--Remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33710918,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c33710918.rmcon)
	e2:SetTarget(c33710918.rmtg)
	e2:SetOperation(c33710918.rmop)
	c:RegisterEffect(e2)
	--double damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c33710918.damcon)
	e3:SetOperation(c33710918.damop)
	c:RegisterEffect(e3)
end
function c33710918.matfilter(c)
	return c:IsType(TYPE_TOKEN)
end
function c33710918.actcon(e)
	local a=Duel.GetAttacker()
	return a and a:IsControler(e:GetHandlerPlayer()) and a:IsType(TYPE_TOKEN) and e:GetHandler():GetLinkedGroup():IsContains(a)
end
function c33710918.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return tc:IsType(TYPE_TOKEN) and tc:IsRelateToBattle() and e:GetHandler():GetLinkedGroup():IsContains(tc) and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c33710918.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if tc:IsControler(1-tp) then 
		tc=Duel.GetAttackTarget() 
		bc=Duel.GetAttacker()
	end
	if chk==0 then return tc and tc:IsType(TYPE_TOKEN) and bc:IsAbleToRemove() and e:GetHandler():GetLinkedGroup():IsContains(tc) end
	e:SetLabelObject(bc)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
end
function c33710918.rmop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if not bc or not bc:IsAbleToRemove() then return end
	Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
end
function c33710918.damcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep==1-tp and e:GetHandler():GetLinkedGroup():IsContains(tc) and tc:IsType(TYPE_TOKEN) and Duel.GetAttackTarget()==nil
end
function c33710918.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end