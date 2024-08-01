--迷托邦的昨日再演
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	--e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetRange(LOCATION_DECK)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(cm.cost)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetDescription(0)
	e5:SetCode(EVENT_CUSTOM+11451902)
	e5:SetCondition(aux.TRUE)
	e5:SetCost(aux.TRUE)
	e5:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
						Duel.RegisterFlagEffect(0,11451901,RESET_CHAIN,0,1)
						--e:GetLabelObject():SetLabel(0)
						return false end)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CUSTOM+11451902)
	e6:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,chk)
						--local flag=Duel.RegisterFlagEffect(0,11451901,0,0,1)
						e:SetLabel(100)
						local lab=2
						if (Duel.GetCurrentChain()==0 or (Duel.GetCurrentChain()==1 and (Duel.CheckEvent(EVENT_CHAIN_SOLVED) or Duel.CheckEvent(EVENT_CHAIN_NEGATED)))) then lab=1 end
						if Duel.GetCurrentChain()~=0 then
							local ge2=e:Clone()
							ge2:SetCode(EVENT_ADJUST)
							ge2:SetOperation(function() if Duel.GetCurrentChain()==0 then Duel.RaiseEvent(c,EVENT_CUSTOM+11451902,e,0,0,0,0) e:Reset() end end)
							Duel.RegisterEffect(ge2,0)
						end
					end)
	Duel.RegisterEffect(e6,0)
	e2:SetLabelObject(e6)
	e5:SetLabelObject(e6)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_DECK)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cm.actarget)
	e4:SetOperation(cm.costop)
	c:RegisterEffect(e4)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	e0:SetDescription(aux.Stringid(m,3))
	c:RegisterEffect(e0)
	--psummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC_G)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(cm.spcon)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		cm.activate_sequence={}
		local _GetActivateLocation=Effect.GetActivateLocation
		local _GetActivateSequence=Effect.GetActivateSequence
		local _NegateActivation=Duel.NegateActivation
		function Effect.GetActivateLocation(e)
			if e:GetDescription()==aux.Stringid(m,0) then
				if e:GetHandler():IsType(TYPE_FIELD) then return _GetActivateLocation(e) end
				return _GetActivateLocation(e)
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
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then
			tc:RegisterFlagEffect(m,RESET_EVENT+0x1f20000,0,1,Duel.GetTurnCount())
		elseif tc:IsLocation(LOCATION_EXTRA) then
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,Duel.GetTurnCount())
		end
		tc=eg:GetNext()
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then
		--if e:GetLabelObject():GetLabel()==100 then e:GetLabelObject():SetLabel(0) return true end
		--local eset={e:GetHandler():GetActivateEffect()}
		--Debug.Message(eset[3]:IsActivatable(tp,false,true))
		--local se=e:GetHandler():CheckActivateEffect(true,true,true)
		--Debug.Message(Duel.GetFlagEffect(0,11451901))
		return (Duel.GetFlagEffect(0,11451901)>0 or Duel.CheckEvent(EVENT_CUSTOM+11451902)) and ft>0 and Duel.GetFlagEffect(tp,11451902)>0
	end
	Duel.ResetFlagEffect(tp,11451902)
	if Duel.GetFlagEffect(1,11451901)==0 then
		--change code
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CHANGE_CODE)
		e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_OATH)
		e3:SetTargetRange(0xff,0xff)
		e3:SetTarget(function(e,c) return Duel.IsExistingMatchingCard(Card.IsOriginalCodeRule,0,LOCATION_GRAVE,LOCATION_GRAVE,1,c,table.unpack({c:GetOriginalCodeRule()})) end)
		e3:SetValue(function(e,c) return c:GetOriginalCode()+0x527+c:GetFieldID() end)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
	Duel.RegisterFlagEffect(1,11451901,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.nmfilter(c)
	return c:GetFlagEffect(11451908)==0 and Duel.IsExistingMatchingCard(Card.IsOriginalCodeRule,0,LOCATION_GRAVE,LOCATION_GRAVE,1,c,table.unpack({c:GetOriginalCodeRule()}))
end
function cm.chop2(e,tp,eg,ep,ev,re,r,rp)
	local nmg=Duel.GetMatchingGroup(cm.nmfilter,tp,0xff,0xff,nil)
	if #nmg>0 then
		for sc in aux.Next(nmg) do
			sc:RegisterFlagEffect(11451908,0,0,0)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetRange(0xff)
			--e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetCondition(function(e) local c=e:GetHandler() return Duel.GetFlagEffect(1,11451901)>0 and Duel.IsExistingMatchingCard(Card.IsOriginalCodeRule,0,LOCATION_GRAVE,LOCATION_GRAVE,1,c,table.unpack({c:GetOriginalCodeRule()})) end)
			e1:SetValue(function(e) local c=e:GetHandler() return c:GetOriginalCode()+0xffffff+c:GetFieldID() end)
			sc:RegisterEffect(e1,true)
		end
	end
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
function cm.handcon(e)
	return Duel.GetTurnPlayer()==1-e:GetHandlerPlayer()
end
function cm.cfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsReason(REASON_DRAW) and (c:IsPublic() or (not c:IsStatus(STATUS_TO_HAND_WITHOUT_CONFIRM) and (c:IsPreviousLocation(LOCATION_DECK) or c:IsPreviousPosition(POS_FACEUP))))
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc976)
end
function cm.desfilter(c)
	return aux.NegateAnyFilter(c) and (cm.sfilter(c) or c:GetColumnGroup():IsExists(cm.sfilter,1,nil))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local sp=false
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(1-tp,cm.spfilter,1-tp,LOCATION_HAND,0,1,1,nil,e,1-tp)
		local tc=g:GetFirst()
		if tc then sp=true Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP) end
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then sp=true Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) end
	end
	if not sp then return end
	Duel.SpecialSummonComplete()
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if #g>0 then
		Duel.BreakEffect()
		for tc in aux.Next(g) do
			if tc:IsCanBeDisabledByEffect(e) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				Duel.AdjustInstantly()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			else
				g:RemoveCard(tc)
			end
		end
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function cm.spcfilter(c,e,tp)
	return c:GetFlagEffect(m)>0 and c:GetFlagEffectLabel(m)==Duel.GetTurnCount()-1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local bg=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,c,e,tp)
	return #bg>0 and c:IsAbleToRemoveAsCost()
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local bg=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,c,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local bc=bg:Select(tp,0,1,nil):GetFirst()
	if bc then
		sg:AddCard(bc)
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	end
end