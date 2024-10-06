--不明的魔法之元
function c37900017.initial_effect(c)
	aux.AddXyzProcedure(c,nil,6,2,c37900017.ovfilter,aux.Stringid(37900017,0),2,c37900017.xyzop)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e0:SetCountLimit(2)
	e0:SetValue(c37900017.valcon)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(c37900017.mattg)
	e2:SetValue(c37900017.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c37900017.cost)
	e3:SetTarget(c37900017.tg)
	e3:SetOperation(c37900017.op)
	c:RegisterEffect(e3)
end
function c37900017.ovfilter(c)
	return c:IsFaceup() and c:IsCode(37900094)
end
function c37900017.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,37900017)==0 end
	Duel.RegisterFlagEffect(tp,37900017,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c37900017.valcon(e,re,r,rp)
	return r & (REASON_BATTLE + REASON_EFFECT) ~=0
end
function c37900017.mattg(e,c)
	return c:IsSetCard(0x389) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function c37900017.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x389)
end
function c37900017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c37900017.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c37900017.q(c)
	return c:IsFaceup() and c:IsSetCard(0x389)
end
function c37900017.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetTarget(c37900017.ttg)
	e1:SetValue(500)
	Duel.RegisterEffect(e1,tp)	
end
function c37900017.ttg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x389)
end










