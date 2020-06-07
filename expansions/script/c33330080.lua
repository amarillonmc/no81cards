--CRuritor FluWers
local m=33330080
local cm=_G["c"..m]
function c33330080.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,10)
	if chk==0 then
		if c:IsLocation(LOCATION_HAND) then
			return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA,0,5,c) and g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==10
		else
			return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==10
		end
	end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA,0,5,99,c)
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return g:IsExists(Card.IsFaceup,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,nil,0,0)
end
function cm.tdfil(c)
	return c:IsFaceup() and not c:IsType(TYPE_LINK) and not (c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_SPELL)) and not c:IsType(TYPE_TOKEN)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(33330080,0))
	if not Duel.IsPlayerCanRemove(1-tp) and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_MSET) and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_SSET) then return end
	local g=Duel.GetMatchingGroup(cm.tdfil,1-tp,LOCATION_ONFIELD,0,nil)
	local gc=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)//10
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
		local sg=g:FilterSelect(1-tp,cm.tdfil,gc,gc,nil,1-tp,POS_FACEDOWN,REASON_RULE)
		Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
		Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
		local rg=Duel.GetMatchingGroup(Card.IsFacedown,1-tp,LOCATION_ONFIELD,0,nil)
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	end
end
