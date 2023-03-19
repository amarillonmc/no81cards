local m=15000820
local cm=_G["c"..m]
cm.name="垄上碟"
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,15000820)
	e1:SetCondition(cm.discon)
	e1:SetCost(cm.discost)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	e:SetLabel(e:GetHandler():GetControler())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetLabel()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.negcon)
	e1:SetOperation(cm.negop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabel(tp)
	Duel.RegisterEffect(e1,tp)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetLabel()
	return rp==1-tp and re:IsActivated()
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetLabel()
	local c=e:GetHandler()
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.dis2op)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.dis2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,15000820)
	Duel.NegateEffect(ev)
end