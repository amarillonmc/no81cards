--百变怪检测
local m=16670026
local cm=_G["c"..m]
function cm.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e1)
    --
    local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	c:RegisterEffect(e11)
    --
	local e111=Effect.CreateEffect(c)
	e111:SetType(EFFECT_TYPE_SINGLE)
	e111:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	c:RegisterEffect(e111)
	local e28=Effect.CreateEffect(c)
	e28:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e28:SetType(EFFECT_TYPE_ACTIVATE)
	e28:SetCode(EVENT_FREE_CHAIN)
	e28:SetCost(cm.cost1)
	e28:SetTarget(cm.target)
    e28:SetOperation(cm.backop2)
    c:RegisterEffect(e28)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
        return true
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then
		return true
	end
end
function cm.backop2(e,tp,eg,ep,ev,re,r,rp)
	--
end