--机械加工 陨星
function c40009849.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x5f1d),2)
	c:EnableReviveLimit()	
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c40009849.atkval)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c40009849.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009849,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,40009849)
	e3:SetCondition(c40009849.atkcon)
	e3:SetTarget(c40009849.atktg)
	e3:SetOperation(c40009849.atkop)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(1)
	e4:SetCondition(c40009849.actcon)
	c:RegisterEffect(e4)
end
function c40009849.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x5f1d)
end
function c40009849.nrfilter(c,s,tp)
	local seq=c:GetSequence()
	return seq<5 and math.abs(seq-s)==1 and c:IsControler(tp) and c:IsSetCard(0x5f1d) and c:IsFaceup() 
end
function c40009849.atkval(e,c)
	local tp=c:GetControler()
	local seq=e:GetHandler():GetSequence()
	local g=Duel.GetMatchingGroup(c40009849.nrfilter,tp,LOCATION_MZONE,0,nil,seq,tp)
	return g:GetSum(Card.GetBaseAttack)
end
function c40009849.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c40009849.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5f1d) and not c:IsCode(40009849)
end
function c40009849.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009849.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c40009849.ftarget)
	e1:SetLabel(e:GetHandler():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c40009849.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c40009849.atkfilter,tp,LOCATION_MZONE,0,nil)
		local atk=g:GetSum(Card.GetAttack)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
	end
end
function c40009849.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c40009849.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
