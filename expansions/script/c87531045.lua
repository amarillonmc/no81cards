--No.41 泥睡魔兽 睡梦貘·微睡
function c87531045.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	c:EnableReviveLimit()
	--maintain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c87531045.mtcon)
	e1:SetOperation(c87531045.mtop)
	c:RegisterEffect(e1)
	--indes/cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c87531045.tgcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--pos
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_POSITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCondition(c87531045.poscon)
	e4:SetTarget(c87531045.postg)
	e4:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c87531045.discon)
	e5:SetOperation(c87531045.disop)
	c:RegisterEffect(e5)
end
aux.xyz_number[87531045]=41
function c87531045.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c87531045.mtop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():CheckRemoveOverlayCard(tp,3,REASON_COST) then
		e:GetHandler():RemoveOverlayCard(tp,3,3,REASON_COST)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
function c87531045.tgcon(e)
	return e:GetHandler():IsAttackPos()
end
function c87531045.poscon(e)
	return e:GetHandler():IsDefensePos()
end
function c87531045.postg(e,c)
	return c:IsFaceup()
end
function c87531045.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc,pos=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_POSITION)
	return e:GetHandler():IsDefensePos()
		and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and bit.band(pos,POS_DEFENSE)~=0
end
function c87531045.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

