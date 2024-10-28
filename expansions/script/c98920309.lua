--闪刀姬-旭曦
function c98920309.initial_effect(c)
	 c:SetSPSummonOnce(98920309)
	 --xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1115),4,2,c98920309.ovfilter,aux.Stringid(98920309,1))
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920309,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c98920309.cost)
	e1:SetTarget(c98920309.target)
	e1:SetOperation(c98920309.operation)
	c:RegisterEffect(e1)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c98920309.effcon)
	e3:SetOperation(c98920309.effop)
	c:RegisterEffect(e3)
end
function c98920309.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x115) and c:IsType(TYPE_LINK) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c98920309.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920309.cfilter(c)
	return c:IsSetCard(0x115)
end
function c98920309.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,53054164)==0  end
end
function c98920309.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetTarget(c98920309.damtg)
	e1:SetTargetRange(0,1)
	e1:SetValue(DOUBLE_DAMAGE)
	e1:SetCondition(c98920309.damcon)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c98920309.atktg)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c98920309.damcon(e)
	local tp=e:GetHandlerPlayer()
	local a,d=Duel.GetBattleMonster(tp)
	if a and d and a:IsControler(tp) and a:IsSetCard(0x1115) and a:IsStatus(STATUS_OPPO_BATTLE)
		then
		return true
	end
	return false
end
function c98920309.damtg(e,c)
	return c:IsSetCard(0x1115) and c:GetBattleTarget()~=nil 
end
function c98920309.atktg(e,c)
	return c:IsSetCard(0x1115)
end
function c98920309.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK and e:GetHandler():GetReasonCard():IsSetCard(0x1115)
end
function c98920309.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920309,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetOwnerPlayer(ep)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end