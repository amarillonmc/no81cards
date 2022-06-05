local m=53728021
local cm=_G["c"..m]
cm.name="大征啼鸟 歼星激流"
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2)
	SNNM.AnouguryLink(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTarget(cm.atktg)
	e1:SetValue(function(e,c)return Duel.GetMatchingGroupCount(function(c)return (c:IsFaceup() or c:GetEquipTarget()) and c:IsType(TYPE_EQUIP)end,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)*300 end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.negcost)
	e2:SetCondition(cm.negcon)
	e2:SetTarget(cm.negtg)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
end
function cm.atktg(e,c)
	local lg1=c:GetLinkedGroup()
	local lg2=e:GetHandler():GetLinkedGroup()
	return (c:IsFaceup() and c:IsRace(RACE_MACHINE) and (lg1 and lg1:IsContains(e:GetHandler()) or lg2 and lg2:IsContains(c))) or c==e:GetHandler()
end
function cm.rlfilter(c)
	return c:IsReleasable() and c:GetOriginalType()&TYPE_UNION~=0
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rlfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.rlfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if not (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) then return false end
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp==1-tp
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0) end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then Duel.Destroy(eg,REASON_EFFECT) end
end
