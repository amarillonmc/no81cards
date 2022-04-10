--村龟
local m=33330175
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(cm.con)
	e3:SetOperation(cm.act)
	c:RegisterEffect(e3)
end
function cm.op(e,tp,eg)
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(m,RESET_CHAIN,0,0)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():GetFlagEffect(m)~=0
end
function cm.act(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeChainOperation(ev,cm.chainop)
end
function cm.chainop(e,tp)
end