local m=15000126
local cm=_G["c"..m]
cm.name="透明的宝玉之树"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.discon)
	e1:SetCost(cm.discost)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
end
function cm.tdfilter(c,tp)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsControler(tp)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and e:GetHandler():GetLinkedGroup():GetCount()>=2
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLinkedGroup():IsExists(cm.tdfilter,1,nil,tp) end
	local g=e:GetHandler():GetLinkedGroup():Filter(cm.tdfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local ag=g:Select(tp,1,1,nil)
	Duel.ConfirmCards(1-tp,ag)
	Duel.SendtoDeck(ag,nil,2,REASON_COST)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end