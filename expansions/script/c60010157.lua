--鼹鼠党欢迎你
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x629,LOCATION_ONFIELD)
	--Activate
	local e1=Effect.CreateEffect(c)
	--e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(m)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--destory
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x629,1)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x629,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x629,1,REASON_COST)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1000,REASON_EFFECT)
end
