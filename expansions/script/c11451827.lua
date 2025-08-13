--悠远之扉：因果
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--release
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.condition)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	--c:RegisterEffect(e2)
	--Activate2
	if Card.SetCardData then KOISHI_CHECK=true end
	local e3=Effect.CreateEffect(c)
	if KOISHI_CHECK then
		e3:SetType(EFFECT_TYPE_ACTIVATE)
	else
		e3:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	end
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP,EFFECT_FLAG2_COF)
	e3:SetCondition(cm.condition2)
	e3:SetTarget(cm.target2)
	e3:SetOperation(cm.activate2)
	c:RegisterEffect(e3)
	--release
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(cm.condition2)
	e4:SetCost(cm.cost)
	e4:SetTarget(cm.target2)
	e4:SetOperation(cm.activate2)
	--c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		--immune
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_FIELD)
		ge5:SetCode(EFFECT_IMMUNE_EFFECT)
		ge5:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
		ge5:SetTarget(cm.etg)
		ge5:SetValue(cm.efilter)
		Duel.RegisterEffect(ge5,0)
	end
end
function cm.etg(e,c)
	return c:GetFlagEffect(m-4)>0 --c:GetOriginalCode()==m and c:IsFaceup() and c:IsStatus(STATUS_CHAINING)
end
function cm.efilter(e,te,c)
	return not te:IsActiveType(c:GetType()&0x7)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_SPELL)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.filter(c)
	return c:IsSetCard(0x97d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsForbidden() and c:IsHasEffect(EFFECT_REMAIN_FIELD)
end
function cm.tfilter(c)
	return c:IsType(TYPE_COUNTER) and c:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(cm.tfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return #rg>0 and Duel.IsPlayerCanDiscardDeck(tp,1) end
	e:GetHandler():RegisterFlagEffect(m-4,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_OATH,1)
	--[[local ft=0
	if not c:IsLocation(LOCATION_SZONE) then ft=1 end
	local rg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil) and (Duel.GetLocationCount(tp,LOCATION_SZONE)>ft or e:IsHasType(EFFECT_TYPE_QUICK_O)) end--]]
	if #rg>0 then
		Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_ONFIELD+LOCATION_GRAVE)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetCurrentChain())
	e1:SetCondition(cm.rscon2)
	e1:SetOperation(cm.rsop2)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function cm.rscon2(e,tp,eg,ep,ev,re,r,rp)
	return ev==e:GetLabel()
end
function cm.rsop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(re) and e:GetHandler():IsFaceup() and e:GetHandler():IsSSetable(true) then
		e:GetHandler():CancelToGrave()
		Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN)
	else
		e:GetHandler():CancelToGrave()
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(cm.tfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,aux.ExceptThisCard(e))
	if #rg==0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)*2+#g<#rg then return end
	local t={}
	for ac=math.max(0,math.ceil((#rg-#g)/2)),math.min(#rg,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)),1 do
		table.insert(t,ac)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	ac=Duel.AnnounceNumber(tp,table.unpack(t))
	if Duel.DiscardDeck(tp,ac,REASON_EFFECT) then
		local g=Duel.GetOperatedGroup()
		local ct=#rg-ac --g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
		if ct>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,#rg-ac,#rg-ac,aux.ExceptThisCard(e))
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
	--[[local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if ft>0 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg=g:Select(tp,1,math.min(#g,ft),nil)
			local dr=0
			for tc in aux.Next(sg) do
				if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then dr=dr+1 end
			end
			if dr>0 then
				local rg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
				if #rg>=dr then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
					local dg=rg:Select(tp,dr,dr,nil)
					Duel.SendtoHand(dg,nil,REASON_EFFECT)
				end
			end
		end
	end--]]
	if c:IsRelateToEffect(e) and c:IsSSetable(true) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		c:ResetFlagEffect(m)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
		if not KOISHI_CHECK then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_COUNTER)
			c:RegisterEffect(e1)
			c:SetStatus(STATUS_SET_TURN,true)
		else
			c:SetCardData(CARDDATA_TYPE,TYPE_TRAP+TYPE_COUNTER)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_MOVE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetOperation(function(e)
				if not c:IsLocation(LOCATION_SZONE) or not c:IsControler(tp) then
					c:SetCardData(CARDDATA_TYPE,TYPE_SPELL)
					e:Reset()
				end
			end)
			c:RegisterEffect(e2)
		end
	end
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_TRAP) and rp==tp
end
function cm.filter2(c)
	return c:IsType(TYPE_COUNTER) and c:IsFaceup() and c:IsSSetable(true)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	e:GetHandler():RegisterFlagEffect(m-4,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_OATH,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabel(ev+1)
	e1:SetCondition(cm.rscon)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return ev==e:GetLabel()
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	re:SetOperation(cm.activate2)
	re:SetCategory(0)
	re:SetLabel(0)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,#sg,c)
	local flag=0
	local setg=Group.CreateGroup()
	for tc in aux.Next(g) do
		tc:CancelToGrave()
		--Debug.Message(tc:IsStatus(STATUS_LEAVE_CONFIRMED))
		if (tc:IsType(TYPE_MONSTER) and Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)>0) or Duel.ChangePosition(tc,POS_FACEDOWN)>0 then flag=1 end
		local loc=0
		if tc:IsType(TYPE_FIELD) then loc=LOCATION_FZONE
		elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then loc=LOCATION_SZONE end
		if tc:GetOriginalType()&TYPE_MONSTER==0 and tc:IsLocation(LOCATION_MZONE) then Duel.MoveToField(tc,tp,tp,loc,POS_FACEDOWN,false) end
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) then setg:AddCard(tc) end
	end
	if #setg>0 then
		setg:KeepAlive()
		Duel.RaiseEvent(setg,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		for tc in aux.Next(setg) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			if tc:IsType(TYPE_QUICKPLAY) then e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN) end
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetDescription(aux.Stringid(m,2))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1,true)
		end
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable(true) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		c:ResetFlagEffect(m)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
		if not KOISHI_CHECK then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL)
			c:RegisterEffect(e1)
		else
			c:SetCardData(CARDDATA_TYPE,TYPE_SPELL)
		end
	end
end