--人理之基 山鲁佐德
function c22025010.initial_effect(c)
	c:EnableCounterPermit(0xfef)
	--battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c22025010.efilter)
	c:RegisterEffect(e2)
	--Destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c22025010.desreptg)
	e3:SetOperation(c22025010.desrepop)
	c:RegisterEffect(e3)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22025010,0))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_QUICK_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_BECOME_TARGET)
	e4:SetCondition(c22025010.ctcon)
	e4:SetTarget(c22025010.cttg)
	e4:SetOperation(c22025010.ctop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e5)
	--win
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ADJUST)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetOperation(c22025010.winop)
	c:RegisterEffect(e6)
end
function c22025010.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c22025010.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLP(tp)>=1000 and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE) end
	return true
end
function c22025010.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xfef,1,true)
	Duel.SetLP(tp,Duel.GetLP(tp)-1000)
end
function c22025010.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c22025010.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xfef)
end
function c22025010.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0xfef,1)
	end
end
function c22025010.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_DESTINY_LEO=0x11
	local c=e:GetHandler()
	if c:GetCounter(0xfef)>=1001 then
		Duel.SelectOption(tp,aux.Stringid(22025010,1))
		Duel.Win(tp,WIN_REASON_DESTINY_LEO)
	end
end