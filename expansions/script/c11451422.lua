--anger of dragon palace
local m=11451422
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.hand)
	c:RegisterEffect(e2)
	--act from deck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCost(cm.cost2)
	e3:SetTarget(cm.target2)
	e3:SetOperation(cm.operation2)
	c:RegisterEffect(e3)
end
function cm.filter(c)
	return (c:IsSetCard(0x6978) or c:IsRace(RACE_SEASERPENT)) and not c:IsPublic()
end
function cm.filter2(c)
	return c:IsSetCard(0x6978) and c:IsAbleToDeck() and not c:IsCode(m)
end
function cm.filter3(c,tp)
	return c:IsCode(22702055) and c:IsType(TYPE_FIELD) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.hand(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter,e:GetHandlerPlayer(),LOCATION_HAND,0,1,e:GetHandler())
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetCurrentChain()
	return rp~=tp and Duel.GetChainInfo(n-1,CHAININFO_TRIGGERING_PLAYER)==tp and Duel.IsChainDisablable(ev)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
		local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local g2=g:Select(1-tp,1,1,nil)
			Duel.HintSelection(g2)
			if Duel.SendtoGrave(g2,REASON_EFFECT)==0 then
				local c=e:GetHandler()
				if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
					c:CancelToGrave()
					Duel.ChangePosition(c,POS_FACEDOWN)
					Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
				end
			end
		else
			local c=e:GetHandler()
			if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
				c:CancelToGrave()
				Duel.ChangePosition(c,POS_FACEDOWN)
				Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			end
		end
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	g2:AddCard(e:GetHandler())
	Duel.SendtoDeck(g2,nil,2,REASON_COST)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_DECK,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
	local g=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_DECK,0,nil,tp)
	Duel.ResetFlagEffect(tp,15248873)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		local tc=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end