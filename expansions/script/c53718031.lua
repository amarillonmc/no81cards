local m=53718031
local cm=_G["c"..m]
cm.name="太乙真人"
function cm.initial_effect(c)
	aux.AddCodeList(c,53718001)
	aux.AddCodeList(c,53718002)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		Duel.RegisterFlagEffect(0,m+66,0,0,0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(cm.count)
		Duel.RegisterEffect(ge1,0)
		cm[2]=Card.IsType
		Card.IsType=function(rc,type)
			local res=cm[2](rc,type)
			if type&0x10000~=0 and rc:IsHasEffect(m) then return true else return res end
		end
		cm[3]=Card.GetType
		Card.GetType=function(rc)
			if rc:IsHasEffect(m) then return 0x10002 else return cm[3](rc) end
		end
		cm[4]=Effect.IsHasType
		Effect.IsHasType=function(re,type)
			local res=cm[4](re,type)
			local rc=re:GetHandler()
			local xe={rc:IsHasEffect(m)}
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			if b then
				if type&EFFECT_TYPE_ACTIVATE~=0 then return true else return false end
			else return res end
		end
		cm[5]=Effect.GetType
		Effect.GetType=function(re)
			local rc=re:GetHandler()
			local xe={rc:IsHasEffect(m)}
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			if b then return EFFECT_TYPE_ACTIVATE else return cm[5](re) end
		end
		cm[6]=Effect.IsActiveType
		Effect.IsActiveType=function(re,type)
			local res=cm[6](re,type)
			local rc=re:GetHandler()
			local xe={rc:IsHasEffect(m)}
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			if b then
				if type&0x10000~=0 then return true else return false end
			else return res end
		end
		cm[7]=Effect.GetActiveType
		Effect.GetActiveType=function(re)
			local rc=re:GetHandler()
			local xe={rc:IsHasEffect(m)}
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			if b then return 0x10002 else return cm[7](re) end
		end
		cm[10]=Effect.GetActivateLocation
		Effect.GetActivateLocation=function(re)
			local rc=re:GetHandler()
			local xe={rc:IsHasEffect(m)}
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			if b then return LOCATION_SZONE else return cm[10](re) end
		end
		cm[11]=Effect.GetActivateSequence
		Effect.GetActivateSequence=function(re)
			local rc=re:GetHandler()
			local xe={rc:IsHasEffect(m)}
			local ls=0
			local seq=cm[11](re)
			for _,v in pairs(xe) do
				if re==v:GetLabelObject() then
					ls=v:GetLabel()
					break
				end
			end
			if ls>0 then return ls-1 else return seq end
		end
		cm[12]=Duel.GetChainInfo
		Duel.GetChainInfo=function(chainc,...)
			local re=cm[12](chainc,CHAININFO_TRIGGERING_EFFECT)
			local rc=re:GetHandler()
			local xe={rc:IsHasEffect(m)}
			local b=false
			local ls=0
			for _,v in pairs(xe) do
				if re==v:GetLabelObject() then
					b=true
					ls=v:GetLabel()
					break
				end
			end
			local t={cm[12](chainc,...)}
			if b then
				for k,info in ipairs({...}) do
					if info==CHAININFO_TYPE then t[k]=0x10002 end
					if info==CHAININFO_EXTTYPE then t[k]=0x10002 end
					if info==CHAININFO_TRIGGERING_LOCATION then t[k]=LOCATION_SZONE end
					if info==CHAININFO_TRIGGERING_SEQUENCE and ls>0 then t[k]=ls-1 end
					if info==CHAININFO_TRIGGERING_POSITION then t[k]=POS_FACEUP end
				end
			end
			return table.unpack(t)
		end
	end
end
function cm.count(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_CODE)
	if code~=53718001 and code~=53718002 then return end
	Duel.RegisterFlagEffect(0,m+(code-53718001)*33,RESET_PHASE+PHASE_END,0,1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and not e:GetHandler():IsPublic()
end
function cm.filter(c,tp)
	if not c:IsCode(53718001,53718002) then return false end
	local ae=c:GetActivateEffect()
	if not ae then return false end
	local e1=ae:Clone()
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	local pro1,pro2=ae:GetProperty()
	pro1=pro1|EFFECT_FLAG_DELAY
	pro1=pro1|EFFECT_FLAG_UNCOPYABLE
	e1:SetProperty(pro1,pro2)
	c:RegisterEffect(e1,true)
	local e2=cm.regi(c,e1)
	local res=false
	if e1:IsActivatable(tp) then res=true end
	e2:Reset()
	e1:Reset()
	return res
end
function cm.thfilter(c,code)
	return (c:IsCode(m-8) or aux.IsCodeListed(c,code)) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b=Duel.GetFlagEffect(0,m)>0 and Duel.GetFlagEffect(0,m+33)>0
	if chk==0 then return (cm.GetSZoneCount(tp)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,tp)) or (Duel.GetFlagEffect(0,m)>0 and Duel.GetFlagEffect(0,m+33)>0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetOperation(cm.regop)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	c:RegisterEffect(e2)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(0,m)>0 and Duel.GetFlagEffect(0,m+33)>0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode()) and (not (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,tp)) or Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,c:GetCode())
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
		if not tc then return end
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
		local ct=Duel.GetFlagEffectLabel(0,m+66)
		Duel.SetFlagEffectLabel(0,m+66,ct+1)
		local ae=tc:GetActivateEffect()
		local e1=ae:Clone()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetRange(LOCATION_HAND)
		local pro1,pro2=ae:GetProperty()
		pro1=pro1|EFFECT_FLAG_DELAY
		pro1=pro1|EFFECT_FLAG_UNCOPYABLE
		e1:SetProperty(pro1,pro2)
		e1:SetCode(EVENT_CUSTOM+m)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCountLimit(1)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ct end)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetRange(LOCATION_HAND)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetLabelObject(e1)
		e2:SetOperation(cm.adjustop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(tc)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_ACTIVATE_COST)
		e3:SetRange(LOCATION_HAND)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetTargetRange(1,0)
		e3:SetLabelObject(e1)
		e3:SetTarget(cm.actarget)
		e3:SetCost(cm.costchk)
		e3:SetOperation(cm.costop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3,true)
		Duel.RaiseEvent(Group.FromCards(tc),EVENT_CUSTOM+m,e,0x40,tp,tp,ct)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject() then
		e:Reset()
		return
	end
	if rp==tp then return end
	local ev0=Duel.GetCurrentChain()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:GetLabelObject(e)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(cm.reset)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	c:ResetEffect(EFFECT_PUBLIC,RESET_CODE)
	if e:GetLabelObject() then e:GetLabelObject():Reset() end
	e:Reset()
end
function cm.cfilter(c)
	return c:IsSetCard(0x353c) and c:IsType(TYPE_MONSTER) and c:IsAbleToExtraAsCost()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
function cm.sfilter(c)
	return c:IsStatus(STATUS_LEAVE_CONFIRMED) and c:GetSequence()<5
end
function cm.GetSZoneCount(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	return ft+Duel.GetMatchingGroupCount(cm.sfilter,tp,LOCATION_SZONE,0,nil)
end
function cm.regi(c,e)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(m)
	e1:SetLabelObject(e)
	c:RegisterEffect(e1,true)
	return e1
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=te:GetHandler()
	local xe={c:IsHasEffect(m)}
	for _,v in pairs(xe) do v:Reset() end
	local p=te:GetHandlerPlayer()
	local pe={Duel.IsPlayerAffectedByEffect(p,EFFECT_CANNOT_ACTIVATE)}
	local ae={Duel.IsPlayerAffectedByEffect(p,EFFECT_ACTIVATE_COST)}
	local t1,t2={},{}
	for _,v in pairs(pe) do
		local val=v:GetValue()
		if aux.GetValueType(val)=="number" or val(v,te,p) then
			table.insert(t1,v)
			table.insert(t2,1)
		end
	end
	for _,v in pairs(ae) do
		local cost=v:GetCost()
		if not v:GetLabelObject() and cost and not cost(v,te,p) then
			local tg=v:GetTarget()
			if not tg or tg(v,te,p) then
				table.insert(t1,v)
				table.insert(t2,2)
			end
		end
	end
	local xe1=cm.regi(c,te)
	local t3,t4={},{}
	for _,v in pairs(pe) do
		local val=v:GetValue()
		if aux.GetValueType(val)=="number" or val(v,te,p) then
			table.insert(t3,v)
			table.insert(t4,1)
		end
	end
	for _,v in pairs(ae) do
		local cost=v:GetCost()
		if not v:GetLabelObject() and cost and not cost(v,te,p) then
			local tg=v:GetTarget()
			if not tg or tg(v,te,p) then
				table.insert(t3,v)
				table.insert(t4,2)
			end
		end
	end
	xe1:Reset()
	local ret1,ret2={},{}
	for k,v1 in pairs(t1) do
		local equal=false
		for _,v2 in pairs(t3) do
			if v1==v2 then
				equal=true
				break
			end
		end
		if not equal then
			table.insert(ret1,v1)
			table.insert(ret2,t2[k])
		end
	end
	local ret3,ret4={},{}
	for k,v1 in pairs(t3) do
		local equal=false
		for _,v2 in pairs(t1) do
			if v1==v2 then
				equal=true
				break
			end
		end
		if not equal then
			table.insert(ret3,v1)
			table.insert(ret4,t4[k])
		end
	end
	for k,v in pairs(ret1) do
		if ret2[k]==1 then
			local val=v:GetValue()
			if aux.GetValueType(val)=="number" then val=aux.TRUE end
			if val(v,te,p) then
				v:SetValue(cm.chval(val,false,te))
			end
		end
		if ret2[k]==2 then
			local cost=v:GetCost()
			if not v:GetLabelObject() and cost and not cost(v,te,p) then
				local tg=v:GetTarget()
				if not tg then
					v:SetTarget(cm.chtg(aux.TRUE,false,te))
				elseif tg(v,te,p) then
					v:SetTarget(cm.chtg(tg,false,te))
				end
			end
		end
	end
	local xe1=cm.regi(c,te)
	for k,v in pairs(ret3) do
		if ret4[k]==1 then
			local val=v:GetValue()
			if aux.GetValueType(val)=="number" then val=aux.TRUE end
			if val(v,te,p) then
				v:SetValue(cm.chval(val,true,te))
			end
		end
		if ret4[k]==2 then
			local cost=v:GetCost()
			if not v:GetLabelObject() and cost and not cost(v,te,p) then
				local tg=v:GetTarget()
				if not tg then
					v:SetTarget(cm.chtg(aux.TRUE,true,te))
				elseif tg(v,te,p) then
					v:SetTarget(cm.chtg(tg,true,te))
				end
			end
		end
	end
	xe1:Reset()
end
function cm.bchval(_val,te)
	return function(e,re,...)
				if re==te then return false end
				return _val(e,re,...)
			end
end
function cm.chval(_val,res,te)
	return function(e,re,...)
				if re==te then return res end
				return _val(e,re,...)
			end
end
function cm.chtg(_tg,res,te)
	return function(e,re,...)
				if re==te then return res end
				return _tg(e,re,...)
			end
end
function cm.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject()
end
function cm.costchk(e,te,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=te:GetHandler()
	local xe1=cm.regi(c,te)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_TYPE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(0x10002)
	c:RegisterEffect(e0,true)
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	xe1:SetLabel(c:GetSequence()+1)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
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
		if not rc:IsHasEffect(EFFECT_REMAIN_FIELD) then rc:CancelToGrave(false) end
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
	local xe={rc:IsHasEffect(m)}
	for _,v in pairs(xe) do if v:GetLabelObject()==re then v:Reset() end end
end
