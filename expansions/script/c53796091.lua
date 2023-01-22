local m=53796091
local cm=_G["c"..m]
cm.name="灰流景"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetLabel(1)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_REMOVE)
		ge2:SetLabel(2)
		ge2:SetLabelObject(ge1)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAINING)
		ge3:SetLabelObject(ge1)
		ge3:SetCondition(cm.trcon)
		ge3:SetOperation(cm.trop)
		Duel.RegisterEffect(ge3,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(function(c,re)return c:IsReason(REASON_COST) and re and re:IsActivated()end,1,nil,re) then Duel.RegisterFlagEffect(0,m,0,0,0) end
end
function cm.trcon(e,tp,eg,ep,ev,re,r,rp)
	local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	local ex3,g3,gc3,dp3,dv3=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	local ex4=re:IsHasCategory(CATEGORY_DRAW)
	local ex5=re:IsHasCategory(CATEGORY_SEARCH)
	local ex6=re:IsHasCategory(CATEGORY_DECKDES)
	return ((ex2 and bit.band(dv2,LOCATION_DECK)==LOCATION_DECK)
		or (ex3 and bit.band(dv3,LOCATION_DECK)==LOCATION_DECK)
		or ex4 or ex5 or ex6)
end
function cm.trop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,m)>0 then
		Duel.ResetFlagEffect(0,m)
		return
	end
	local e1=Effect.CreateEffect(e:GetOwner())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetLabelObject(re)
	e1:SetCondition(cm.discon)
	e1:SetOperation(cm.disop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,e:GetOwner():GetControler())
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(0,m+1000)<1 end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then e:SetLabel(2) else e:SetLabel(1) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,m+1000)>0 then return end
	Duel.RegisterFlagEffect(0,m+1000,RESET_PHASE+PHASE_END,0,e:GetLabel())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev) and re==e:GetLabelObject() and Duel.GetFlagEffect(0,m+500)<1 and Duel.GetFlagEffect(0,m+1000)>0
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) then
		Duel.Destroy(rc,REASON_EFFECT)
		Duel.RegisterFlagEffect(0,m+500,RESET_PHASE+PHASE_END,0,1)
	end
end
