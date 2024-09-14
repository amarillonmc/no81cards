--迷托邦的今日同焚
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetRange(LOCATION_DECK)
	e2:SetCode(EVENT_CUSTOM+11451902)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(cm.cost)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(m,1))
	--e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(cm.cpcost2)
	e3:SetTarget(cm.cptg)
	e3:SetOperation(cm.cpop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_DECK)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cm.actarget)
	e4:SetOperation(cm.costop)
	c:RegisterEffect(e4)
	--copy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetCost(cm.cpcost)
	e5:SetTarget(cm.cptg)
	e5:SetOperation(cm.cpop)
	c:RegisterEffect(e5)
	--Destroy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetRange(LOCATION_SZONE+LOCATION_HAND)
	e6:SetCondition(cm.condition2)
	e6:SetOperation(cm.operation2)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_CHAIN_NEGATED)
	c:RegisterEffect(e7)
	--hint
	local e8=Effect.CreateEffect(c)
	--e8:SetDescription(aux.Stringid(m,7))
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(EVENT_ADJUST)
	e8:SetRange(LOCATION_SZONE+LOCATION_HAND)
	e8:SetCondition(function() return not pnfl_adjusting end)
	e8:SetOperation(function(e)
						local c=e:GetHandler()
						if Duel.GetFlagEffect(0,m)>0 and c:GetFlagEffect(m-1)==0 then
							--Debug.Message("r"..c:GetLocation())
							c:RegisterFlagEffect(m-1,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,7))
						elseif c:GetFlagEffect(m+1)==0 or (Duel.GetFlagEffect(0,m)==0 and c:GetFlagEffect(m-1)>0) then
							--Debug.Message("l"..c:GetLocation())
							c:ResetFlagEffect(m-1)
						end
					end)
	c:RegisterEffect(e8)
	if not cm.global_check then
		cm.global_check=true
		cm.activate_sequence={}
		local _GetActivateLocation=Effect.GetActivateLocation
		local _GetActivateSequence=Effect.GetActivateSequence
		local _NegateActivation=Duel.NegateActivation
		function Effect.GetActivateLocation(e)
			if e:GetDescription()==aux.Stringid(m,0) or e:GetDescription()==aux.Stringid(m,1) then
				if e:GetHandler():IsType(TYPE_FIELD) then return _GetActivateLocation(e) end
				return _GetActivateLocation(e)
			end
			return _GetActivateLocation(e)
		end
		function Effect.GetActivateSequence(e)
			if e:GetDescription()==aux.Stringid(m,0) or e:GetDescription()==aux.Stringid(m,1) then
				return cm.activate_sequence[e]
			end
			return _GetActivateSequence(e)
		end
		function Duel.NegateActivation(ev)
			local re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			local res=_NegateActivation(ev)
			if res and aux.GetValueType(re)=="Effect" then
				local rc=re:GetHandler()
				if rc and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) and (re:GetDescription()==aux.Stringid(m,0) or re:GetDescription()==aux.Stringid(m,1)) then
					rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
				end
			end
			return res
		end
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge5:SetCode(EVENT_LEAVE_FIELD)
		ge5:SetCondition(cm.con)
		ge5:SetOperation(cm.reg)
		Duel.RegisterEffect(ge5,0)
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge6:SetCode(EVENT_CHAIN_END)
		ge6:SetOperation(cm.clear)
		Duel.RegisterEffect(ge6,0)
	end
	if not PTFL_SUMMONRULE_CHECK then
		PTFL_SUMMONRULE_CHECK=true
		local summon_set={"Summon","MSet","SpecialSummonRule","SynchroSummon","XyzSummon","XyzSummonByRose","LinkSummon"}
		for i,fname in pairs(summon_set) do
			local temp_f=Duel[fname]
			Duel[fname]=function(p,c,...)
				temp_f(p,c,...)
				if Duel.GetCurrentChain()==1 then c:RegisterFlagEffect(11451905,RESET_CHAIN,0,1) end
			end
		end
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return ft>0 and Duel.GetFlagEffect(tp,11451902)>0 end
	Duel.ResetFlagEffect(tp,11451902)
	--change code
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetProperty(EFFECT_FLAG_OATH)
	e3:SetTargetRange(0xff,0xff)
	e3:SetTarget(function(e,c) return Duel.IsExistingMatchingCard(Card.IsOriginalCodeRule,0,LOCATION_GRAVE,LOCATION_GRAVE,1,c,table.unpack({c:GetOriginalCodeRule()})) end)
	e3:SetValue(function(e,c) return c:GetSequence()*0xfff+c:GetTurnID()*0xff+c:GetFieldID()*0xf+c:GetOriginalCode()+c:GetRealFieldID() end)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.cpcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return ft>0 and Duel.GetFlagEffect(tp,11451902)>0 and e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
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
function cm.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.cpfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE)
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.cpfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(cm.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.cpfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SelectTarget(tp,cm.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc1=g:Filter(Card.IsLocation,nil,LOCATION_MZONE):GetFirst()
	local tc2=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetFirst()
	if c:IsRelateToEffect(e) and tc1 and tc1:IsFaceup() and tc2 then
		local code=tc2:GetOriginalCodeRule()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		if code>=11451900 and code<=11451905 then
			e1:SetDescription(aux.Stringid(code,5))
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		end
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetValue(code)
		tc1:RegisterEffect(e1)
		--local c1,c2=tc1:GetCode() Debug.Message(c2)
		if tc1:GetFlagEffect(0xffffff+code+m)==0 then
			tc1:CopyEffect(code,RESET_EVENT+RESETS_STANDARD)
			tc1:RegisterFlagEffect(0xffffff+code+m,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end
function cm.mfilter(c)
	return c:IsStatus(STATUS_SPSUMMON_TURN)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.mfilter,1,nil)
end
function cm.reg(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,m,0,0,1)
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	--Duel.ResetFlagEffect(0,m)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,m)>0 and Duel.GetCurrentChain()==1 and e:GetHandler():GetFlagEffect(m+1)==0
end
function cm.filter11(c)
	return c:IsSetCard(0xc976) and c:GetFlagEffect(11451905)==0
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(0,m)
	local c=e:GetHandler()
	local hg=Duel.GetMatchingGroup(cm.filter11,tp,LOCATION_HAND,0,nil)
	if c:IsLocation(LOCATION_HAND) then
		local op=not cm[tp] and Duel.SelectYesNo(tp,aux.Stringid(m,6))
		if not op and cm[tp]==nil then cm[tp]=Duel.SelectYesNo(tp,aux.Stringid(m,9)) end
		if not op then return end
		Duel.Hint(HINT_CARD,0,m)
		Duel.Destroy(c,REASON_EFFECT)
		--Destroy
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_CHAIN_SOLVED)
		e6:SetCondition(function() return Duel.GetCurrentChain()==1 end)
		e6:SetOperation(cm.operation3)
		Duel.RegisterEffect(e6,tp)
		local e7=e6:Clone()
		e7:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(e7,tp)
		e6:SetLabelObject(e7)
		e7:SetLabelObject(e6)
	elseif c:IsLocation(LOCATION_SZONE) and #hg>0 then
		local op=not cm[tp] and Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,5))
		if not op and cm[tp]==nil then cm[tp]=Duel.SelectYesNo(tp,aux.Stringid(m,9)) end
		if not op then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=hg:Select(tp,1,1,nil)
		Duel.Hint(HINT_CARD,0,m)
		Duel.Destroy(dg,REASON_EFFECT)
		c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,0,1,c:GetFieldID())
		--Destroy
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_CHAIN_SOLVED)
		e6:SetLabel(c:GetFieldID())
		e6:SetCondition(function(e) return Duel.GetCurrentChain()==1 end)
		e6:SetOperation(cm.operation4)
		Duel.RegisterEffect(e6,tp)
		local e7=e6:Clone()
		e7:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(e7,tp)
		e6:SetLabelObject(e7)
		e7:SetLabelObject(e6)
	end 
end
function cm.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local te=e:GetLabelObject()
	te:Reset()
	e:Reset()
	local c=e:GetHandler()
	local hg=Duel.GetMatchingGroup(cm.filter11,tp,LOCATION_ONFIELD,0,nil):Filter(Card.IsFaceup,nil)
	if #hg>0 then
		local op=not cm[tp] and Duel.SelectYesNo(tp,aux.Stringid(m,2))
		if not op and cm[tp]==nil then cm[tp]=Duel.SelectYesNo(tp,aux.Stringid(m,9)) end
		if not op then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=hg:Select(tp,1,1,nil)
		Duel.Destroy(dg,REASON_EFFECT)
		--Destroy
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_CHAIN_SOLVED)
		e6:SetCondition(function() return Duel.GetCurrentChain()==1 end)
		e6:SetOperation(cm.operation5)
		Duel.RegisterEffect(e6,tp)
		local e7=e6:Clone()
		e7:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(e7,tp)
		e6:SetLabelObject(e7)
		e7:SetLabelObject(e6)
	end
end
function cm.operation4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local te=e:GetLabelObject()
	te:Reset()
	e:Reset()
	local c=e:GetHandler()
	if c:GetFlagEffect(m+1)>0 and c:GetFlagEffectLabel(m+1)==e:GetLabel() then
		local op=not cm[tp] and Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,4))
		if not op and cm[tp]==nil then cm[tp]=Duel.SelectYesNo(tp,aux.Stringid(m,9)) end
		if not op then return end
		if op then
			Duel.Destroy(c,REASON_EFFECT)
			--Destroy
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e6:SetCode(EVENT_CHAIN_SOLVED)
			e6:SetLabel(e:GetLabel())
			e6:SetCondition(function() return Duel.GetCurrentChain()==1 end)
			e6:SetOperation(cm.operation5)
			Duel.RegisterEffect(e6,tp)
			local e7=e6:Clone()
			e7:SetCode(EVENT_CHAIN_NEGATED)
			Duel.RegisterEffect(e7,tp)
			e6:SetLabelObject(e7)
			e7:SetLabelObject(e6)
		end
	end
	c:ResetFlagEffect(m+1)
end
function cm.operation5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local te=e:GetLabelObject()
	te:Reset()
	e:Reset()
	local c=e:GetHandler()
	local hg=Duel.GetMatchingGroup(cm.filter11,tp,LOCATION_DECK,0,nil)
	if c:GetFlagEffect(m+1)>0 and c:GetFlagEffectLabel(m+1)==e:GetLabel() then
		c:ResetFlagEffect(m+1)
	end
	if #hg>0 then
		local op=not cm[tp] and Duel.SelectYesNo(tp,aux.Stringid(m,3))
		if not op and cm[tp]==nil then cm[tp]=Duel.SelectYesNo(tp,aux.Stringid(m,9)) end
		if not op then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=hg:Select(tp,1,1,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end