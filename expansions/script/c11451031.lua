--镜宙测度 穹顶
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(function(e)
					local c=e:GetHandler()
					if not c:IsLocation(LOCATION_HAND) then return true end
					local eset={c:IsHasEffect(EFFECT_TRAP_ACT_IN_HAND)}
					for _,te in pairs(eset) do if te:GetLabel()~=m then return true end end
					return false
				end)
	--c:RegisterEffect(e1)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ACTIVATE_COST)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetCost(cm.spcost)
	e5:SetTarget(cm.sptg)
	e5:SetOperation(cm.spcop)
	Duel.RegisterEffect(e5,0)
	if not cm.global_check then
		cm.global_check=true
		cm.activate_sequence={}
		local _GetActivateLocation=Effect.GetActivateLocation
		local _GetActivateSequence=Effect.GetActivateSequence
		local _NegateActivation=Duel.NegateActivation
		function Effect.GetActivateLocation(e)
			if e:GetHandler():GetOriginalCode()==m then
				return _GetActivateLocation(e)
			end
			return _GetActivateLocation(e)
		end
		function Effect.GetActivateSequence(e)
			if e:GetHandler():GetOriginalCode()==m then
				return cm.activate_sequence[e]
			end
			return _GetActivateSequence(e)
		end
		function Duel.NegateActivation(ev)
			local re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			local res=_NegateActivation(ev)
			if res and aux.GetValueType(re)=="Effect" then
				local rc=re:GetHandler()
				if rc and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) and re:GetHandler():GetOriginalCode()==m then
					rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
				end
			end
			return res
		end
	end
	if not PNFL_MIRROR_COPY then
		PNFL_MIRROR_COPIED={}
		PNFL_MIRROR_COPIED[0]={}
		PNFL_MIRROR_COPIED[1]={}
		PNFL_MIRROR_COPY={}
		PNFL_MIRROR_COPY[0]={}
		PNFL_MIRROR_COPY[1]={}
		PNFL_MIRROR_ACTIVATED={}
		PNFL_MIRROR_ACTIVATED[0]={}
		PNFL_MIRROR_ACTIVATED[1]={}
		for code=11451031,11451037 do
			PNFL_MIRROR_ACTIVATED[0][code]={}
			PNFL_MIRROR_ACTIVATED[1][code]={}
		end
		PNFL_MIRROR_ACTIVATE={}
		PNFL_MIRROR_ACTIVATE[0]={}
		PNFL_MIRROR_ACTIVATE[1]={}
		PNFL_MIRROR_HINTED={}
		PNFL_MIRROR_CONFIRM={}
		PNFL_MIRROR_CONFIRM[0]={}
		PNFL_MIRROR_CONFIRM[1]={}
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ACTIVATE_COST)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetCondition(cm.costcon)
		e1:SetTarget(cm.actarget)
		e1:SetOperation(cm.costop)
		Duel.RegisterEffect(e1,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(cm.conf)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetOperation(cm.conf2)
		Duel.RegisterEffect(ge2,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.hint)
		--Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.clear)
		--Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAINING)
		ge3:SetCondition(function(e,tp) return Duel.IsExistingMatchingCard(cm.mfilter,tp,0xff,0,1,nil) and not pnfl_adjusting end)
		ge3:SetOperation(cm.adjustop)
		Duel.RegisterEffect(ge3,0)
		local ge31=ge3:Clone()
		Duel.RegisterEffect(ge31,1)
		local ge4=ge3:Clone()
		ge4:SetCode(EVENT_FREE_CHAIN)
		ge4:SetCondition(cm.fccon)
		Duel.RegisterEffect(ge4,0)
		local ge41=ge4:Clone()
		Duel.RegisterEffect(ge41,1)
		local ge5=ge3:Clone()
		ge5:SetCode(EVENT_CHAIN_SOLVED)
		ge5:SetCondition(function(e,tp) return Duel.IsExistingMatchingCard(cm.mfilter,tp,0xff,0,1,nil) and Duel.GetCurrentChain()==1 and not pnfl_adjusting end)
		Duel.RegisterEffect(ge5,0)
		local ge51=ge5:Clone()
		Duel.RegisterEffect(ge51,1)
		local ge6=ge5:Clone()
		ge6:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(ge6,0)
		local ge61=ge6:Clone()
		Duel.RegisterEffect(ge61,1)
	end
end
function cm.fccon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()~=0 or pnfl_adjusting then return false end
	for ce,tc in pairs(PNFL_MIRROR_COPY[tp]) do
		local tg=ce:GetTarget() or aux.TRUE
		if aux.GetValueType(ce)=="Effect" and aux.GetValueType(tc)=="Card" then
			local ccode=tc:GetOriginalCode()
			if Duel.IsExistingMatchingCard(cm.mfilter,tp,0xff,0,1,nil) then return true end --not PNFL_MIRROR_ACTIVATED[tp][ccode] and
		end
	end
	return false
end
function cm.mfilter(c)
	local code=c:GetOriginalCode()
	return code>=11451031 and code<=11451037
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	pnfl_adjusting=true
	local g=Group.CreateGroup()
	for ce,tc in pairs(PNFL_MIRROR_COPY[tp]) do
		local tg=ce:GetTarget() or aux.TRUE
		if aux.GetValueType(ce)=="Effect" and aux.GetValueType(tc)=="Card" then
			local ccode=tc:GetOriginalCode()
			if Duel.IsExistingMatchingCard(cm.mfilter,tp,0xff,0xff,1,nil) then g:AddCard(tc) end --not PNFL_MIRROR_ACTIVATED[tp][ccode] and
		end
	end
	if #g>0 and Duel.IsExistingMatchingCard(cm.mfilter,tp,0xff,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11451031,0)) then
		local tg=g:Filter(function(c) return c:IsFacedown() and c:IsControler(1-tp) end,nil)
		Duel.ConfirmCards(tp,tg)
		Duel.Hint(HINT_SELECTMSG,0,aux.Stringid(11451031,4))
		local sc=g:Select(tp,1,1,nil):GetFirst()
		PNFL_MIRROR_ACTIVATE[tp]={}
		for ce,tc in pairs(PNFL_MIRROR_COPY[tp]) do
			local tg=ce:GetTarget() or aux.TRUE
			if aux.GetValueType(ce)=="Effect" and aux.GetValueType(tc)=="Card" then
				local ccode=tc:GetOriginalCode()
				if tc==sc then PNFL_MIRROR_ACTIVATE[tp][ccode]=true end
			end
		end
	end
	pnfl_adjusting=false
end
function cm.hint(e,tp,eg,ep,ev,re,r,rp)
	local ccode=PNFL_MIRROR_HINTED[re]
	if ccode and not PNFL_MIRROR_HINTED[ccode] then
		PNFL_MIRROR_HINTED[ccode]=true
		Duel.Hint(HINT_CODE,1-tp,ccode)
	end
end
function cm.conf(e,tp,eg,ep,ev,re,r,rp)
	PNFL_MIRROR_CONFIRM[rp][re]=true
end
function cm.conf2(e,tp,eg,ep,ev,re,r,rp)
	if not PNFL_MIRROR_CONFIRM[rp][re] then
		local ce=PNFL_MIRROR_COPIED[rp][re]
		PNFL_MIRROR_COPIED[rp][re]=nil
		PNFL_MIRROR_COPY[1-rp][ce]=nil
	end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	PNFL_MIRROR_ACTIVATED[0]={}
	PNFL_MIRROR_ACTIVATED[1]={}
end
function cm.costcon(e)
	cm[0]=false
	return true
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return true
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	local tp=te:GetHandlerPlayer()
	if cm[0] then return end
	cm[0]=true
	--if te:GetHandler():IsCode(m) then return end
	if not PNFL_MIRROR_COPIED[tp][te] then
		local ce=te:Clone()
		PNFL_MIRROR_COPIED[tp][te]=ce
		local ccode=te:GetHandler():GetOriginalCode()
		PNFL_MIRROR_COPY[1-tp][ce]=te:GetHandler()
		--PNFL_MIRROR_COPY[tp][ce]=te:GetHandler()
		PNFL_MIRROR_HINTED[te]=ccode
		local tg=ce:GetTarget() or aux.TRUE
		local tg2=function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
					local code=e:GetHandler():GetOriginalCode()
					if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,0,1) end
					if chk==0 then
						return tg(e,tp,eg,ep,ev,re,r,rp,0) and PNFL_MIRROR_ACTIVATED[tp][code] and not PNFL_MIRROR_ACTIVATED[tp][code][ccode] and PNFL_MIRROR_ACTIVATE[tp][ccode]
					end
					tg(e,tp,eg,ep,ev,re,r,rp)
					PNFL_MIRROR_ACTIVATED[tp][code][ccode]=true
					Duel.Hint(HINT_CODE,tp,ccode)
					Duel.Hint(HINT_CODE,1-tp,ccode)
				end
		ce:SetTarget(tg2)
		if not te:IsHasType(EFFECT_TYPE_ACTIVATE) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
			e3:SetTargetRange(0xff,0xff)
			e3:SetTarget(function(e,c)
							return cm.mfilter(c)
						end)
			e3:SetLabelObject(ce)
			Duel.RegisterEffect(e3,0)
		else
			local loc=te:GetHandler():GetLocation()
			if te:GetHandler():IsFaceup() and te:GetHandler():IsOnField() then loc=te:GetHandler():GetPreviousLocation() end
			ce:SetDescription(aux.Stringid(11451034,1))
			ce:SetRange(loc|LOCATION_SZONE|LOCATION_HAND)
			local g=Duel.GetMatchingGroup(function(c) return cm.mfilter(c) and c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_PENDULUM) end,0,0xff,0xff,nil)
			local og=Duel.GetOverlayGroup(0,1,1):Filter(function(c) return cm.mfilter(c) and c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_PENDULUM) end,nil)
			g:Merge(og)
			for oc in aux.Next(g) do
				local ce2=ce:Clone()
				oc:RegisterEffect(ce2,true)
				if loc&LOCATION_HAND>0 then
					local e1=Effect.CreateEffect(oc)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
					e1:SetDescription(aux.Stringid(11451031,5))
					e1:SetLabel(11451031)
					oc:RegisterEffect(e1,true)
				elseif loc&LOCATION_SZONE==0 then
					local e2=Effect.CreateEffect(oc)
					e2:SetType(EFFECT_TYPE_FIELD)
					e2:SetCode(EFFECT_ACTIVATE_COST)
					e2:SetRange(loc)
					e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e2:SetTargetRange(1,0)
					e2:SetTarget(cm.actarget2)
					e2:SetOperation(cm.costop2)
					oc:RegisterEffect(e2,true)
				end
			end
		end
	end
end
function cm.actarget2(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler() and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.costop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
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
function cm.spcost(e,c,tp)
	local g=Duel.GetMatchingGroup(cm.sfilter,tp,0xff,0xff,e:GetHandler(),tp)
	return #g>0
end
function cm.sptg(e,te,tp)
	return te:GetHandler()==e:GetHandler()
end
function cm.sfilter(c,tp)
	return c:IsFaceup() or c:IsControler(tp) or c:IsStatus(STATUS_CHAINING)
end
function cm.spcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.sfilter,tp,0xff,0xff,c,tp)
	local tg=g:Filter(function(c) return c:IsFacedown() and c:IsControler(1-tp) end,nil)
	Duel.ConfirmCards(tp,tg)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local sc=g:Select(tp,1,1,nil):GetFirst()
	if not sc then return end
	if c:IsFacedown() then Duel.ConfirmCards(1-tp,Group.FromCards(c)) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,2))
	if not sc:IsOnField() then Duel.ConfirmCards(1-tp,Group.FromCards(sc)) end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetCondition(function(e) if not cm.sfilter(sc,tp) then e:SetProperty(0) e:SetLabel(100) end return e:GetLabel()==0 end)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(e1,true)
end