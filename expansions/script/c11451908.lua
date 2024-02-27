--迷托邦的明日即想
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetRange(LOCATION_DECK)
	e2:SetCode(EVENT_CUSTOM+11451902)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(cm.cost)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_DECK)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cm.actarget)
	e4:SetOperation(cm.costop)
	c:RegisterEffect(e4)
	--set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_HAND)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(TIMING_END_PHASE)
	e5:SetCost(cm.sccost)
	e5:SetOperation(cm.scop)
	c:RegisterEffect(e5)
	if not cm.global_check then
		cm.global_check=true
		cm.activate_sequence={}
		local _GetActivateLocation=Effect.GetActivateLocation
		local _GetActivateSequence=Effect.GetActivateSequence
		function Effect.GetActivateLocation(e)
			if e:GetDescription()==aux.Stringid(m,0) then
				return LOCATION_SZONE
			end
			return _GetActivateLocation(e)
		end
		function Effect.GetActivateSequence(e)
			if e:GetDescription()==aux.Stringid(m,0) then
				return cm.activate_sequence[e]
			end
			return _GetActivateSequence(e)
		end
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return ft>0 and Duel.GetFlagEffect(tp,11451902)>0 end
	Duel.ResetFlagEffect(tp,11451902)
	if Duel.GetFlagEffect(1,11451901)==0 then
		--change code
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CHANGE_CODE)
		e3:SetProperty(EFFECT_FLAG_OATH)
		e3:SetTargetRange(0xff,0xff)
		e3:SetTarget(function(e,c) return Duel.IsExistingMatchingCard(Card.IsOriginalCodeRule,0,LOCATION_GRAVE,LOCATION_GRAVE,1,c,table.unpack({c:GetOriginalCodeRule()})) end)
		e3:SetValue(function(e,c) return c:GetOriginalCode()+0xffffff+c:GetFieldID() end)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
	Duel.RegisterFlagEffect(1,11451901,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler() and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	Duel.DisableShuffleCheck()
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	cm.activate_sequence[te]=c:GetSequence()
	c:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
function cm.tdfilter(c)
	return c:IsSetCard(0xc976) and (c:IsLocation(LOCATION_DECK) or c:IsAbleToDeck())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.tdfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local ct=math.min(#g1,#g2)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		--aux.GCheckAdditional=aux.dncheck
		local sg2=g2:SelectSubGroup(tp,aux.TRUE,false,1,ct)
		--aux.GCheckAdditional=nil
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
		local sg1=g1:Select(tp,#sg2,#sg2,nil)
		local rg=Group.__add(sg1,sg2:Filter(Card.IsLocation,nil,LOCATION_GRAVE))
		Duel.SendtoDeck(rg,tp,0,REASON_EFFECT)
		local ct2=#Group.__band(Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK),sg1)
		sg1:Merge(sg2)
		sg1=sg1:Filter(Card.IsLocation,nil,LOCATION_DECK)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.ShuffleDeck(tp)
		local tg=sg1:GetMinGroup(Card.GetSequence)
		while tg and #tg>0 do
			local tc=tg:GetFirst()
			Duel.MoveSequence(tc,0)
			sg1:RemoveCard(tc)
			tg=sg1:GetMinGroup(Card.GetSequence)
		end
		Duel.Draw(tp,#sg2,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function cm.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSSetable() end
	Duel.SSet(tp,c,tp,true)
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetTargetRange(0xff,0)
	e3:SetLabel(Duel.GetTurnCount())
	e3:SetCondition(cm.costcon)
	e3:SetCost(cm.costchk)
	e3:SetOperation(cm.costop1)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp)
end
function cm.cfilter(c,tp)
	return (c:IsType(TYPE_FIELD) or ((c:IsType(TYPE_CONTINUOUS) or c:IsHasEffect(EFFECT_REMAIN_FIELD)) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function cm.costcon(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=false
	return Duel.GetTurnCount()==e:GetLabel()+1
end
function cm.costchk(e,te_or_c,tp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil,tp)
end
function cm.costop1(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	if cm[0] then return end
	cm[0]=true
	Duel.Hint(HINT_CARD,0,m)
	local sg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	if sg:GetFirst():IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	else
		Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end