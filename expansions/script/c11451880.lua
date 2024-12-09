--以眼还眼
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	e2:SetDescription(aux.Stringid(m,0))
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		cm.activate_sequence={}
		local _GetActivateLocation=Effect.GetActivateLocation
		local _GetActivateSequence=Effect.GetActivateSequence
		local _NegateActivation=Duel.NegateActivation
		function Effect.GetActivateLocation(e)
			if e:GetDescription()>=aux.Stringid(m,1) and e:GetDescription()<=aux.Stringid(m,7) then
				return _GetActivateLocation(e)
			end
			return _GetActivateLocation(e)
		end
		function Effect.GetActivateSequence(e)
			if e:GetDescription()>=aux.Stringid(m,1) and e:GetDescription()<=aux.Stringid(m,7) then
				return cm.activate_sequence[e]
			end
			return _GetActivateSequence(e)
		end
		function Duel.NegateActivation(ev)
			local re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			local res=_NegateActivation(ev)
			if res and aux.GetValueType(re)=="Effect" then
				local rc=re:GetHandler()
				if rc and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) and (re:GetDescription()>=aux.Stringid(m,1) and re:GetDescription()<=aux.Stringid(m,7)) then
					rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
				end
			end
			return res
		end
		local _GetActivateLocation=Effect.GetActivateLocation
		local _GetActivateSequence=Effect.GetActivateSequence
		function Effect.GetActivateLocation(e)
			if e:GetDescription()>=aux.Stringid(m,1) and e:GetDescription()<=aux.Stringid(m,7) then
				return _GetActivateLocation(e)
			end
			return _GetActivateLocation(e)
		end
		function Effect.GetActivateSequence(e)
			if e:GetDescription()>=aux.Stringid(m,1) and e:GetDescription()<=aux.Stringid(m,7) then
				return cm.activate_sequence[e]
			end
			return _GetActivateSequence(e)
		end
	end
end
function cm.handcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lab=e:GetLabel()
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_NEGATE)
	local b1=ex and (tg~=nil or tc>0)
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DISABLE)
	local b2=ex and (tg~=nil or tc>0)
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	local b3=ex and (tg~=nil or tc>0)
	local sg=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local sg2=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then
		if lab==0 then return b1 or b2 or b3 end
		local a1=lab&0x1==0 or Duel.IsChainNegatable(ev)
		local a2=lab&0x2==0 or #sg>0
		local a3=lab&0x4==0 or #sg2>0
		return a1 and a2 and a3
	end
	if lab~=0 then
		Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	end
	if lab&0x1>0 then Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0) end
	if lab&0x2>0 then Duel.SetOperationInfo(0,CATEGORY_DISABLE,sg,1,0,0) end
	if lab&0x4>0 then Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg2,1,0,0) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=re:IsHasCategory(CATEGORY_NEGATE)
	local b2=re:IsHasCategory(CATEGORY_DISABLE)
	local sp=re:IsHasCategory(CATEGORY_NEGATE) and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	local b3=ex and (tg~=nil or tc>0) and not sp
	local lab=0
	if b1 then lab=lab+1 end
	if b2 then lab=lab+2 end
	if b3 then lab=lab+4 end
	local lab0=e:GetLabel()
	local res=0
	if lab0&0x1>0 then res=Duel.NegateActivation(ev) end
	if lab0&0x2>0 then
		local sg=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local tg=sg:Select(tp,1,1,nil)
		if #tg>0 then
			if res~=0 then Duel.BreakEffect() end
			Duel.HintSelection(tg)
			local sc=tg:GetFirst()
			Duel.NegateRelatedChain(sc,RESET_TURN_SET)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			sc:RegisterEffect(e3)
			if sc:IsType(TYPE_TRAPMONSTER) then
				local e4=e2:Clone()
				e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				sc:RegisterEffect(e4)
			end
		end
		res=#tg
	end
	if lab0&0x4>0 then
		local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tg=sg:Select(tp,1,1,nil)
		if #tg>0 then
			if res~=0 then Duel.BreakEffect() end
			Duel.HintSelection(tg)
			Duel.Destroy(tg,REASON_EFFECT)
		end
	end
	if lab>0 then
		--adjust
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetOperation(cm.adjustop)
		Duel.RegisterEffect(e1,tp)
		local eid=e1:GetFieldID()
		--Debug.Message(eid)
		e1:SetLabel(lab,eid)
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,lab))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,lab))
	end
end
function cm.nfilter(c,eid)
	return c:GetFlagEffect(m+0xffffff+eid)==0 and c:IsCode(m) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local lab,eid=e:GetLabel()
	if lab==100 then return end
	local g=Duel.GetMatchingGroup(cm.nfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,eid)
	if g and #g>0 then
		for tc in aux.Next(g) do
			tc:RegisterFlagEffect(m+0xffffff+eid,0,0,1)
			--Activate
			local te=tc:GetActivateEffect()
			local cost=te:GetCost() or aux.TRUE
			local e1=te:Clone()
			e1:SetDescription(aux.Stringid(m,lab))
			if lab&0x1>0 then e1:SetCategory(e1:GetCategory()|CATEGORY_NEGATE) end
			if lab&0x2>0 then e1:SetCategory(e1:GetCategory()|CATEGORY_DISABLE) end
			if lab&0x4>0 then e1:SetCategory(e1:GetCategory()|CATEGORY_DESTROY) end
			e1:SetCode(EVENT_CHAINING)
			e1:SetProperty(0)
			e1:SetLabel(lab)
			e1:SetLabelObject(e)
			e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
			e1:SetCost(cm.adcost(cost))
			tc:RegisterEffect(e1)
			local e4=Effect.CreateEffect(tc)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_ACTIVATE_COST)
			e4:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e4:SetTargetRange(1,0)
			e4:SetTarget(cm.actarget)
			e4:SetOperation(cm.costop)
			tc:RegisterEffect(e4)
		end
	end
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	cm.activate_sequence[te]=e:GetHandler():GetSequence()
	e:GetHandler():CreateEffectRelation(te)
	local c=e:GetHandler()
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
function cm.adcost(cost)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
				local se=e:GetLabelObject()
				if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and se and aux.GetValueType(se)=="Effect" and se:GetLabel()~=100 and cost(e,tp,eg,ep,ev,re,r,rp,0) end
				se:SetLabel(100)
				cost(e,tp,eg,ep,ev,re,r,rp,1)
			end
end