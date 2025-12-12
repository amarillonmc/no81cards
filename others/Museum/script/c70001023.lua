--档案陷阱
local m=70001023
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetCountLimit(1,m)
		ge1:SetCondition(cm.checkcon)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
	function cm.ddfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
	function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.ddfilter,nil,tp)
	return g:GetCount()>0
end
	function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
end
	function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,m)>0
end
	function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,13,REASON_EFFECT)
end