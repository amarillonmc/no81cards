local m=53799112
local cm=_G["c"..m]
cm.name="卸下伪装"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
cm.toss_dice=true
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
	for tc in aux.Next(eg) do
		local ct=Duel.GetFlagEffect(0,m)
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,ct)
	end
	Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then e:SetLabel(1) else e:SetLabel(0) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d1,d2=0,0
	if e:GetLabel()==1 then d1,d2=Duel.TossDice(tp,2) else d1=Duel.TossDice(tp,1) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	e1:SetLabel(d1+d2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	Duel.RegisterEffect(e1,tp)
end
function cm.filter(c,e)
	return c:GetFlagEffectLabel(m)==e:GetLabel() and c:IsLocation(LOCATION_MZONE)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,e)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter,nil,e)
	if g then
		Duel.Hint(HINT_CARD,0,m)
		Duel.SendtoHand(g,1-tp,REASON_EFFECT)
	end
end
