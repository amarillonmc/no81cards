local m=25000114
local cm=_G["c"..m]
cm.name="失落的记忆"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(function(e)return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_MONSTER)==0 end)
	c:RegisterEffect(e2)
end
function cm.drfilter(c)
	return (c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP) and c:IsAbleToDeck()
end
function cm.fzfilter(c)
	return c:IsCode(25000106) and c:IsFaceup()
end
function cm.filter(c,tp)
	return c:IsCode(25000109,25000110) and c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp) and Duel.IsExistingMatchingCard(cm.drfilter,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp)
	if chk==0 then return b1 or b2 end
	local sel=0
	local ac=0
	if b1 then sel=sel+1 end
	if b2 then sel=sel+2 end
	if sel==1 then
		ac=Duel.SelectOption(tp,aux.Stringid(m,0))
	elseif sel==2 then
		ac=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	elseif Duel.IsExistingMatchingCard(cm.fzfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) then
		ac=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2))
	else
		ac=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	end
	if ac~=1 then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		if ac==0 then
			e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			Duel.SetTargetPlayer(tp)
		end
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	else
		e:SetCategory(0)
		e:SetProperty(0)
	end
	e:SetLabel(ac)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op~=1 then
		local p=tp
		if op==0 then p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER) end
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(p,aux.NecroValleyFilter(cm.drfilter),p,LOCATION_GRAVE,0,1,math.min(3,Duel.GetFieldGroupCount(p,LOCATION_DECK,0)),nil)
		if #g>0 then
			Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
			if ct>0 then
				Duel.SortDecktop(p,p,ct)
				for i=1,ct do
					local mg=Duel.GetDecktopGroup(p,1)
					Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
				end
				Duel.Draw(p,ct,REASON_EFFECT)
			end
		end
	end
	if op~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
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
