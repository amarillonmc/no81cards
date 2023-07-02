--连锁束缚
function c60159912.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60159912+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c60159912.target)
	e1:SetOperation(c60159912.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(c60159912.handcon)
	c:RegisterEffect(e2)
end
function c60159912.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c60159912.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c60159912.chainop)
	Duel.RegisterEffect(e1,tp)
end
function c60159912.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(aux.FALSE)
end
function c60159912.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1
end