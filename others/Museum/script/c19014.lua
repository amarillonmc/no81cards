--铭盟军 凯恩狙击兵
function c19014.initial_effect(c)
	 --extra atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19014,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c19014.condition)
	e1:SetCost(c19014.cost)
	e1:SetTarget(c19014.target)
	e1:SetOperation(c19014.operation)
	c:RegisterEffect(e1)
		   --cannot direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	 --chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19014,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c19014.atcon)
	e3:SetOperation(c19014.atop)
	c:RegisterEffect(e3)
end
	function c19014.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
	function c19014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
	function c19014.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x888) and c:GetEffectCount(EFFECT_EXTRA_ATTACK)==0
end
	function c19014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c19014.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19014.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c19014.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c19014.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--extra atk
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c19014.ftarget)
		e2:SetLabel(tc:GetFieldID())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
	function c19014.ftarget(e,c)
	return  e:GetLabel()~=c:GetFieldID()
end
	function c19014.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and c:GetFlagEffect(19014)==0
		and c:IsChainAttackable()
end
	function c19014.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end