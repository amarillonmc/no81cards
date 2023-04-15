--为少女们献上的垂怜经
function c72421540.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c72421540.target)
	e1:SetOperation(c72421540.activate)
	c:RegisterEffect(e1)
end
function c72421540.filter(c)
	return c:IsFaceup() and c:GetFlagEffect(72421540)==0
end
function c72421540.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c72421540.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c72421540.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c72421540.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c72421540.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_MONSTER) and tc:GetFlagEffect(72421540)==0 then
		tc:RegisterFlagEffect(72421540,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c72421540.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ATTACK_ALL)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_SET_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetCondition(c72421540.atkcon)
		e3:SetValue(c72421540.atkval)
		tc:RegisterEffect(e3)
	end
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetReset(RESET_PHASE+PHASE_END)
	e5:SetOperation(c72421540.checkop)
	Duel.RegisterEffect(e5,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetCondition(c72421540.atkcon2)
	e4:SetTarget(c72421540.atktg)
	e5:SetLabelObject(e4)
	Duel.RegisterEffect(e4,tp)
end
function c72421540.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c72421540.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local bc=e:GetHandler():GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and bc and bc:GetControler()~=e:GetHandler():GetControler()
end
function c72421540.atkval(e,c)
	local ec=e:GetHandler()
	local tc=ec:GetBattleTarget()
	return math.max(tc:GetAttack()+100,tc:GetDefense()+100)
end
function c72421540.atkcon2(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),72421541)>0
end
function c72421540.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c72421540.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,72421541)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	Duel.RegisterFlagEffect(tp,72421541,RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end