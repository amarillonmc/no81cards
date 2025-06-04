--雾色弹珠使·泡影
local cm,m=GetID()
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	--e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetLabelObject(e1)
	e3:SetTargetRange(1,0)
	e3:SetTarget(cm.actarget)
	e3:SetOperation(cm.costop)
	c:RegisterEffect(e3)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.spcon)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetRange(LOCATION_PZONE)
	e4:SetValue(1)
	e4:SetCondition(cm.actcon)
	c:RegisterEffect(e4)
	--Destroy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCondition(cm.descon)
	e6:SetOperation(cm.desop)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		cm.activate_sequence={}
		local ge0=Effect.CreateEffect(c)
		ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetOperation(cm.geop)
		Duel.RegisterEffect(ge0,0)
		--disable
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(EFFECT_DISABLE)
		e0:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e0:SetTarget(function(e,c) return c:GetOriginalCode()==m and c:IsType(TYPE_TRAP) and c:IsHasEffect(EFFECT_DISABLE_TRAPMONSTER) and c:IsHasEffect(EFFECT_DISABLE_TRAPMONSTER):GetHandlerPlayer()==e:GetHandlerPlayer() end)
		Duel.RegisterEffect(e0,0)
		local e1=e0:Clone()
		Duel.RegisterEffect(e1,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EFFECT_SEND_REPLACE)
		e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
							local g=eg:Filter(function(c) return c:GetOriginalCode()==m and c:IsStatus(STATUS_ACTIVATE_DISABLED) and c:GetDestination()==LOCATION_GRAVE end,nil)
							if chk==0 then return #g>0 end
							for rc in aux.Next(g) do
								local e1=Effect.CreateEffect(rc)
								e1:SetType(EFFECT_TYPE_SINGLE)
								e1:SetCode(EFFECT_CANNOT_TO_DECK)
								e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
								e1:SetReset(RESET_EVENT+RESETS_STANDARD)
								rc:RegisterEffect(e1)
							end
						end)
		e2:SetValue(aux.FALSE)
		Duel.RegisterEffect(e2,0)
		local _IsActiveType=Effect.IsActiveType
		local _GetActiveType=Effect.GetActiveType
		local _GetActivateLocation=Effect.GetActivateLocation
		local _GetActivateSequence=Effect.GetActivateSequence
		local _GetChainInfo=Duel.GetChainInfo
		local _NegateActivation=Duel.NegateActivation
		local _ChangeChainOperation=Duel.ChangeChainOperation
		function Effect.GetActiveType(e)
			if e:GetDescription()==aux.Stringid(m,0) then
				return TYPE_TRAP
			end
			return _GetActiveType(e)
		end
		function Effect.IsActiveType(e,typ)
			local typ2=e:GetActiveType()
			return typ&typ2~=0
		end
		function Effect.GetActivateLocation(e)
			if e:GetDescription()==aux.Stringid(m,0) then
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
		function Duel.GetChainInfo(ev,...)
			local ext_params={...}
			if #ext_params==0 then return _GetChainInfo(ev,...) end
			local re=_GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			if aux.GetValueType(re)=="Effect" then
				local rc=re:GetHandler()
				if rc and re:GetDescription()==aux.Stringid(m,0) then
					local res={}
					for _,ci in ipairs(ext_params) do
						if ci==CHAININFO_TYPE or ci==CHAININFO_EXTTYPE then
							res[#res+1]=TYPE_TRAP
						else
							res[#res+1]=_GetChainInfo(ev,ci)
						end
					end
					return table.unpack(res)
				end
			end
			return _GetChainInfo(ev,...)
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
		function Duel.ChangeChainOperation(ev,...)
			local re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			if aux.GetValueType(re)=="Effect" then
				local rc=re:GetHandler()
				if rc and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) and re:GetDescription()==aux.Stringid(m,0) then
					rc:CancelToGrave(false)
				end
			end
			return _ChangeChainOperation(ev,...)
		end
	end
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local res=true
		if KOISHI_CHECK and cm[tp] and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			res=cm[tp]:GetActivateEffect():IsActivatable(tp,true)
		else
			res=(c:CheckActivateEffect(false,false,false)~=nil)
		end
		return res and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsLocation(LOCATION_HAND)) or (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLocation(LOCATION_EXTRA)))
	end
end
function cm.ngfilter(c)
	return aux.NegateAnyFilter(c) and c:GetOriginalType()&TYPE_MONSTER>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ngfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and c:GetFlagEffect(m)==0 end
	local fid=c:GetFieldID()
	local e1=Card.RegisterFlagEffect(c,m,RESET_EVENT+0x53e0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_OATH,1,fid,aux.Stringid(m,2))
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetLabel(fid)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.tdop)
	Duel.RegisterEffect(e2,tp)
	local g=Duel.GetMatchingGroup(cm.ngfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.tdfilter,1,nil,e:GetLabel()) then
		e:GetLabelObject():Reset()
		e:Reset()
	end
end
function cm.tdfilter(c,lab)
	local fid=c:GetFlagEffectLabel(m)
	return c:IsLocation(LOCATION_DECK) and fid and fid==lab
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,cm.ngfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	end
	if c:IsRelateToEffect(e) then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_DISABLE)
		e4:SetRange(LOCATION_ONFIELD)
		e4:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetTarget(cm.distg)
		e4:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_CHAIN_SOLVING)
		e5:SetRange(LOCATION_ONFIELD)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetOperation(cm.disop)
		e5:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD)
		e6:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e6:SetRange(LOCATION_ONFIELD)
		e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e6:SetTarget(cm.distg)
		e6:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e6,true)
	end
end
function cm.distg(e,c)
	local tp=e:GetHandlerPlayer()
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.GetColumn(c,tp)==aux.GetColumn(e:GetHandler(),tp) and c~=e:GetHandler()
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_SZONE~=0 and seq<=4 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and seq==aux.GetColumn(e:GetHandler(),rp) and re:GetHandler()~=e:GetHandler() then
		Duel.NegateEffect(ev)
	end
end
function cm.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,false)
	cm.activate_sequence[te]=c:GetSequence()
	c:CreateEffectRelation(te)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_TYPE)
	e0:SetValue(TYPE_TRAP)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(e0,true)
	local te2=te:Clone()
	e:SetLabelObject(te2)
	te:SetType(26)
	c:RegisterEffect(te2,true)
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
	--control
	c:RegisterFlagEffect(m+100,RESET_EVENT+RESETS_WITHOUT_TEMP_REMOVE,0,1,c:GetFieldID())
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_CONTROL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetLabel(c:GetFieldID())
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(function(se,sc) return sc:GetFlagEffect(m+100)>0 and se:GetLabel()==sc:GetFlagEffectLabel(m+100) end)
	e3:SetValue(tp)
	Duel.RegisterEffect(e3,tp)
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
		local e1=Effect.CreateEffect(rc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TO_DECK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1)
	end
	re:Reset()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and c:IsType(TYPE_PENDULUM) end
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function cm.desfilter(c)
	return c:IsSetCard(0x5977) and (c:IsLocation(LOCATION_DECK) or c:IsFaceup())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil)
	if #g>0 then
		if g:IsExists(Card.IsOnField,1,nil) then Duel.HintSelection(g) end
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function cm.tfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsFaceup()
end
function cm.actcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.tfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.GetCurrentChain()==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.tfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and ep~=tp and ev==1
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function cm.geop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	cm[0]=Duel.CreateToken(0,m)
	cm[1]=Duel.CreateToken(1,m)
	if KOISHI_CHECK then
		cm[0]:SetCardData(CARDDATA_TYPE,TYPE_TRAP)
		cm[1]:SetCardData(CARDDATA_TYPE,TYPE_TRAP)
	end
	e:Reset()
end