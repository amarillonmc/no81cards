--泰拉机圣-护型/歌鸲号
function c82568053.initial_effect(c)
	c:EnableReviveLimit()
	--atklimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	c:RegisterEffect(e1)
	--Code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(82567786)
	c:RegisterEffect(e2)
	--maintain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c82568053.mtcon)
	e3:SetOperation(c82568053.mtop)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c82568053.adcost)
	e4:SetCountLimit(1,82568053)
	e4:SetTarget(c82568053.target)
	e4:SetOperation(c82568053.activate)
	e4:SetValue(c82568053.rdval)
	c:RegisterEffect(e4)
	--sanctuary
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetTarget(aux.TargetBoolFunction(c82568053.imfilter))
	e5:SetValue(c82568053.efilter)
	e5:SetCondition(c82568053.iefcon)
	c:RegisterEffect(e5)
	
end
function c82568053.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c82568053.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_COST) then
	Duel.RemoveCounter(tp,1,0,0x5825,2,REASON_COST)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
function c82568053.imfilter(c)
	return (c:IsSetCard(0x825) or c:IsSetCard(0x828)) and c:IsFaceup()
end
function c82568053.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
		and te:IsActiveType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER)
end
function c82568053.iefcon(e)
	return e:GetHandler():IsFaceup() and e:GetHandler():GetAttack()>=3000
end
function c82568053.filter(c)
	return c:IsFaceup() 
end
function c82568053.rdval(e)
	return e:GetHandler():GetAttack()/2
end
function c82568053.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAttackAbove(600) end 
	if c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-600)
		c:RegisterEffect(e1)
		end
	end
function c82568053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c82568053.filter,tp,LOCATION_MZONE,0,nil)
	local nsg=sg:GetCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c82568053.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,sg,nsg,tp,0)
end
function c82568053.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c82568053.filter,tp,LOCATION_MZONE,0,e:GetHandler())
	local atk=c82568053.rdval(e)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	if not c:IsRelateToEffect(e) then return false end
	Duel.Recover(tp,atk,REASON_EFFECT)
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_CANNOT_DISABLE)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end