--照亮生命的清幽之光
local m=40011124
local cm=_G["c"..m]
cm.named_with_FoxArt=1
function cm.Tamayura(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Tamayura
end

function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end

function cm.conafilter(c)
    return c:IsFaceup() and cm.Tamayura(c)
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.conafilter,tp,0x04,0,1,nil)
end

function cm.costafilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToGraveAsCost()
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costafilter,tp,0x40,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.costafilter,tp,0x40,0,2,2,nil)
    Duel.SendtoGrave(g,REASON_COST)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,0x04)
    e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(-2000)
	Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetCondition(cm.discon)
    e2:SetOperation(cm.disop)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end

function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc,cp=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_PLAYER)
	return re:IsActiveType(TYPE_MONSTER) and loc==0x04 and cp==1-tp and re:GetHandler():GetAttack()==0
end

function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end