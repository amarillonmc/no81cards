--魔导空港 迦南
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--act
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetCondition(function() return not pnfl_adjusting end)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(cm.efop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(m)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.con)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetCost(cm.costchk)
	e4:SetTarget(cm.actarget)
	e4:SetOperation(cm.costop)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE) --+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_SZONE,0)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCondition(cm.con)
	e6:SetCost(cm.costt)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetTargetRange(LOCATION_SZONE,0)
	--e7:SetTarget(function(e,c) return c:IsType(TYPE_SPELL) and c:IsImmuneToEffect(e) and not c:IsImmuneToEffect(e) end)
	--c:RegisterEffect(e7)
	--replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetTarget(cm.reptg)
	e5:SetValue(function(e,c) return e:GetLabelObject()==c end)
	c:RegisterEffect(e5)
end
function cm.filter(c)
	return c:IsType(TYPE_SPELL) and not c:IsType(TYPE_QUICKPLAY) and c:IsFacedown() and c:GetFlagEffect(m)==0
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_SZONE,0,nil)
	for oc in aux.Next(og) do
		oc:RegisterFlagEffect(m,0,0,1)
		local teset={oc:GetActivateEffect()}
		for _,te in pairs(teset) do
			local prop1,prop2=te:GetProperty()
			if not prop2 or prop2&EFFECT_FLAG2_COF==0 then
				local cost=te:GetCost() or aux.TRUE
				local cost1=function(e,tp,eg,ep,ev,re,r,rp,chk)
								if chk==0 then return Duel.IsPlayerAffectedByEffect(tp,m) and Duel.GetCurrentChain()==0 and cost(e,tp,eg,ep,ev,re,r,rp,0) end
								cost(e,tp,eg,ep,ev,re,r,rp,1)
							end
				local e1=te:Clone()
				e1:SetDescription(aux.Stringid(m,0))
				e1:SetProperty(prop1,prop2|EFFECT_FLAG2_COF)
				e1:SetRange(LOCATION_SZONE)
				e1:SetCost(cost1)
				oc:RegisterEffect(e1,true)
			end
		end
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetFlagEffect(m+1)==0
end
function cm.costt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m+1)==0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	local ph=Duel.GetCurrentPhase()
	if ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then ph=PHASE_BATTLE end
	e:GetHandler():RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+ph,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,15))
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)~=0 and e:GetHandler():GetFlagEffect(m+2)==0 then
		local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			g=g:Select(tp,1,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
			e:GetHandler():RegisterFlagEffect(m+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
		end
	end
end
function cm.costchk(e,te,tp)
	local tc=te:GetHandler()
	local prop1,prop2=te:GetProperty()
	local eset={Duel.IsPlayerAffectedByEffect(tp,m)}
	if te:IsHasType(EFFECT_TYPE_ACTIVATE) and ((tc:GetFlagEffect(m)>0 and prop2 and prop2&EFFECT_FLAG2_COF>0)) then -- or (tc:IsLocation(LOCATION_SZONE) and tc:IsType(TYPE_QUICKPLAY) and #eset>0 and tc:IsStatus(STATUS_SET_TURN) and tc:GetEffectCount(EFFECT_QP_ACT_IN_SET_TURN)<=#eset)) then
		return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
	else return true end
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return true
end
function cm.thfilter(c)
	return c:IsSetCard(0x6e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local prop1,prop2=te:GetProperty()
	local eset={Duel.IsPlayerAffectedByEffect(tp,m)}
	if te:IsHasType(EFFECT_TYPE_ACTIVATE) and ((tc:GetFlagEffect(m)>0 and prop2 and prop2&EFFECT_FLAG2_COF>0) or (tc:IsLocation(LOCATION_SZONE) and tc:IsType(TYPE_QUICKPLAY) and not tc:IsStatus(STATUS_SET_TURN) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and tc:IsFacedown() and Duel.SelectYesNo(tp,aux.Stringid(m,3)))) then
		local ph=Duel.GetCurrentPhase()
		if ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then ph=PHASE_BATTLE end
		e:GetHandler():RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+ph,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,15))
		if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)~=0 and e:GetHandler():GetFlagEffect(m+2)==0 then
			local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
			if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				g=g:Select(tp,1,1,nil)
				if #g>0 then
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
				e:GetHandler():RegisterFlagEffect(m+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
			end
		end
	end
end
function cm.sfilter(c,e,tp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE+LOCATION_HAND) and c:IsAbleToRemove() and not c:IsHasEffect(EFFECT_TO_DECK_REDIRECT) and c:GetLeaveFieldDest()==0 and c:GetDestination()==LOCATION_DECK
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return eg:IsExists(cm.sfilter,1,c,e,tp)
	end
	local g=eg:Filter(cm.sfilter,c,e,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		local flag=c:GetFlagEffectLabel(m+3)
		if not flag or flag<=0 then
			flag=1
			c:RegisterFlagEffect(m+3,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(m,5))
		else
			flag=flag+1
			c:ResetFlagEffect(m+3)
			c:RegisterFlagEffect(m+3,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(m,math.min(14,4+flag)))
		end
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			g=g:Select(tp,1,1,nil)
		end
		local sc=g:GetFirst()
		e:SetLabelObject(sc)
		local ct=0
		if sc:IsOnField() then
			ct=Duel.Remove(sc,nil,REASON_EFFECT+REASON_TEMPORARY)
		else
			ct=Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
		end
		if ct~=0 and sc:IsLocation(LOCATION_REMOVED) and not sc:IsReason(REASON_REDIRECT) then
			local cid=11451859
			if c:IsPreviousLocation(LOCATION_ONFIELD) then cid=11451718 end
			sc:RegisterFlagEffect(m+4,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1010-flag*3,aux.Stringid(cid,math.max(0,8-flag)))
			local rc=c
			if re and re:GetHandler() then rc=re:GetHandler() end
			local e1=Effect.CreateEffect(rc)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetLabel(sc:GetFieldID())
			e1:SetLabelObject(sc)
			e1:SetCondition(cm.retcon)
			e1:SetOperation(cm.retop)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EVENT_CHAIN_NEGATED)
			Duel.RegisterEffect(e2,tp)
		end
		return true
	else return false end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	c:SetReason(c:GetReason()|REASON_TEMPORARY)
	local flag=c:GetFlagEffectLabel(m+4)
	if not flag or e:GetLabel()~=c:GetFieldID() then
		e:Reset()
	elseif flag>=1009 then
		c:ResetFlagEffect(m+4)
		if c:IsPreviousLocation(LOCATION_ONFIELD) then
			--Duel.MoveToField(c,tp,c:GetPreviousControler(),c:GetPreviousLocation(),c:GetPreviousPosition(),true)
			--if c:IsFacedown() then Duel.RaiseEvent(c,EVENT_MSET,e,REASON_EFFECT,tp,tp,0) end
			Duel.ReturnToField(c)
		else
			Duel.SendtoHand(c,c:GetPreviousControler(),REASON_EFFECT)
		end
		e:Reset()
	else
		--Duel.Remove(c,nil,REASON_EFFECT+REASON_TEMPORARY)
		flag=flag+1
		c:ResetFlagEffect(m+4)
		local cid=11451859
		if c:IsPreviousLocation(LOCATION_ONFIELD) then cid=11451718 end
		c:RegisterFlagEffect(m+4,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(cid,math.max(0,flag-1000)))
	end
end