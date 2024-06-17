--回响虚诞之林
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCost(cm.cost)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cm.actarget)
	e4:SetOperation(cm.costop)
	c:RegisterEffect(e4)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(cm.ngop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		cm.activate_sequence={}
		local _GetActivateLocation=Effect.GetActivateLocation
		local _GetActivateSequence=Effect.GetActivateSequence
		local _NegateActivation=Duel.NegateActivation
		function Effect.GetActivateLocation(e)
			if e:GetDescription()==aux.Stringid(m,0) then
				return LOCATION_FZONE+LOCATION_SZONE
			end
			return _GetActivateLocation(e)
		end
		function Effect.GetActivateSequence(e)
			if e:GetDescription()==aux.Stringid(m,0) then
				return cm.activate_sequence[e]
			end
			return _GetActivateSequence(e)
		end
		function Duel.NegateActivation(ev)
			local re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			local res=_NegateActivation(ev)
			if res and aux.GetValueType(re)=="Effect" then
				local rc=re:GetHandler()
				if rc and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) and re:GetDescription()==aux.Stringid(m,0) then
					rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
				end
			end
			return res
		end
	end
end
function cm.rdfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(cm.rdfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if chk==0 then
		return e:GetHandler():IsFaceup() and rg:GetClassCount(Card.GetAttribute)>=6
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	aux.GCheckAdditional=aux.dabcheck
	local g=rg:SelectSubGroup(tp,aux.TRUE,false,6,6)
	aux.GCheckAdditional=nil
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler() and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
	cm.activate_sequence[te]=c:GetSequence()
	c:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
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
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
function cm.ngop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local attr=0
	for tc in aux.Next(eg) do
		if tc:GetSummonPlayer()==tp then attr=attr|tc:GetAttribute() end
	end
	if attr&0x1d==0 then return end
	local off=1
	local ops={}
	local opval={}
	local g1=Duel.GetMatchingGroup(cm.filter1,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(cm.filter2,tp,0,LOCATION_ONFIELD,nil)
	if attr&ATTRIBUTE_WIND>0 and #g1>0 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if attr&ATTRIBUTE_EARTH>0 and #g2>0 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if attr&ATTRIBUTE_FIRE>0 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	if attr&ATTRIBUTE_LIGHT>0 then
		ops[off]=aux.Stringid(m,3)
		opval[off-1]=4
		off=off+1
	end
	if off==1 then return end
	ops[off]=aux.Stringid(m,4)
	opval[off-1]=5
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local g=Duel.GetMatchingGroup(cm.filter1,tp,0,LOCATION_ONFIELD,nil)
		if g and #g>0 then
			Duel.Hint(HINT_CARD,0,m)
			c:RegisterFlagEffect(m-10,RESET_CHAIN,0,1)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.HintSelection(Group.FromCards(tc))
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=e1:Clone()
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				tc:RegisterEffect(e3)
			end
		end
	elseif opval[op]==2 then
		local g=Duel.GetMatchingGroup(cm.filter2,tp,0,LOCATION_ONFIELD,nil)
		if g and #g>0 then
			Duel.Hint(HINT_CARD,0,m)
			c:RegisterFlagEffect(m-10,RESET_CHAIN,0,1)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local tc=g:Select(1-tp,1,1,nil):GetFirst()
			Duel.HintSelection(Group.FromCards(tc))
			Duel.SendtoGrave(tc,REASON_RULE)
		end
	elseif opval[op]==3 then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAIN_SOLVING)
		e0:SetReset(RESET_PHASE+PHASE_END)
		e0:SetOperation(cm.ceop2)
		Duel.RegisterEffect(e0,tp)
	elseif opval[op]==4 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetTargetRange(0x7f,0x7f)
		e1:SetTarget(cm.catg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(cm.caval)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.catg(e,c)
	return c:IsCode(11451461) and c:IsType(TYPE_MONSTER)
end
function cm.caval(e,c)
	if c:IsAttribute(ATTRIBUTE_DEVINE) then return 0x7f end
	return 0x3f
end
function cm.ceop2(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp and re:GetHandler():IsCode(11451461) and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
		Duel.Hint(HINT_CARD,0,m)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,cm.reop)
		e:Reset()
	end
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.Remove(c,POS_FACEUP,REASON_EFFECT) end
end
function cm.filter1(c,tp)
	return c:IsCode(11451461) and aux.disfilter1(c)
end
function cm.filter2(c,tp)
	return c:IsCode(11451461) and c:IsFaceup()
end