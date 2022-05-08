local m=25000074
local cm=_G["c"..m]
cm.name="XXXG-00W0 零式飞翼EW"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1,1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(
		function (e,tp,eg,ep,ev,re,r,rp)
			if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
			local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
			if g and g:IsContains(e:GetHandler()) then
				Duel.NegateEffect(ev)
			end
		end
	)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(cm.descost)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local flag=e:GetHandler():GetFlagEffect(m)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if chk==0 then return flag>0 or Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,ct,e:GetHandler()) end
	if flag==0 then Duel.DiscardHand(tp,Card.IsDiscardable,ct,ct,REASON_COST+REASON_DISCARD) end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=ct then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end
end
