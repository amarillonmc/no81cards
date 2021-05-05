--超重型炮塔列车 卡通巨爱
function c40008885.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,3,c40008885.ovfilter,aux.Stringid(40008885,0),3,c40008885.xyzop)
	c:EnableReviveLimit()
	--boost
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008885,1))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1)
	e1:SetCost(c40008885.atkcost)
	e1:SetOperation(c40008885.atkop)
	c:RegisterEffect(e1)
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetValue(c40008885.raval)
	c:RegisterEffect(e2)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c40008885.regcon)
	e4:SetOperation(c40008885.atklimit)
	c:RegisterEffect(e4)
	--direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetCondition(c40008885.dircon)
	c:RegisterEffect(e5)
end
function c40008885.ovfilter(c)
	return c:IsFaceup() and c:GetRank()==10 and c:IsSetCard(0x62)
end
function c40008885.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40008885)==0 end
	Duel.RegisterFlagEffect(tp,40008885,RESET_PHASE+PHASE_END,0,1)
end
function c40008885.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40008885.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(2000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_ONLY_ATTACK_MONSTER)
		e3:SetTargetRange(0,LOCATION_MZONE)
		e3:SetValue(c40008885.atklimit1)
		e3:SetLabel(c:GetRealFieldID())
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_ATTACK)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(c40008885.ftarget)
	e0:SetLabel(c:GetFieldID())
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
end
function c40008885.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c40008885.raval(e,c)
	return e:GetHandler():GetOverlayCount()
end
function c40008885.atklimit1(e,c)
	return c:GetRealFieldID()==e:GetLabel()
end
function c40008885.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c40008885.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c40008885.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c40008885.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c40008885.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c40008885.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c40008885.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end