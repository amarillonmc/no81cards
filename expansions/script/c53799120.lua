local m=53799120
local cm=_G["c"..m]
cm.name="双魂共斗"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.filter(c)
	return c:IsSSetable() and c:IsCode(m-1,m+1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and g:CheckSubGroup(aux.gfcheck,2,2,Card.IsCode,m-1,m+1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<2 then return end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsCode,m-1,m+1)
	if #sg==2 and Duel.SSet(tp,sg)==2 then
		for tc in aux.Next(sg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		sg:KeepAlive()
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_ACTIVATE_COST)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetLabelObject(sg)
		e2:SetTarget(cm.actarget)
		e2:SetOperation(cm.costop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.actarget(e,te,tp)
	return e:GetLabelObject():IsContains(te:GetHandler()) and te:GetHandler():GetFlagEffect(m)>0
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	for tc in aux.Next(g) do
		tc:ResetEffect(EFFECT_TRAP_ACT_IN_SET_TURN,RESET_CODE)
		tc:ResetFlagEffect(m)
	end
	e:Reset()
end
