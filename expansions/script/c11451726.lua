--血雳强袭·玉响舞散
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e5=e1:Clone()
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e5)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cm.actarget)
	e4:SetOperation(cm.costop)
	c:RegisterEffect(e4)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetValue(cm.efilter)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(cm.eop)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(cm.eftg)
	e5:SetLabelObject(e6)
	c:RegisterEffect(e5)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_CHAIN_SOLVING)
	e9:SetRange(LOCATION_MZONE)
	e9:SetOperation(cm.desop)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetTarget(cm.eftg)
	e7:SetLabelObject(e9)
	c:RegisterEffect(e7)
	--become effect
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_ADD_TYPE)
	e8:SetValue(TYPE_EFFECT)
	e8:SetRange(LOCATION_SZONE)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetTarget(cm.eftg)
	c:RegisterEffect(e8)
	if not cm.global_check then
		cm.global_check=true
		cm.activate_sequence={}
		--hint
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetOperation(cm.adop)
		Duel.RegisterEffect(ge0,0)
		local _GetActivateLocation=Effect.GetActivateLocation
		local _GetActivateSequence=Effect.GetActivateSequence
		local _NegateActivation=Duel.NegateActivation
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
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
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
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return ft>0 or c:IsLocation(LOCATION_SZONE) end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMAIN_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_DISABLED)
	e2:SetOperation(cm.tgop)
	e2:SetLabel(cid)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if cid~=e:GetLabel() then return end
	if e:GetOwner():IsRelateToChain(ev) then
		e:GetOwner():CancelToGrave(false)
	end
end
function cm.eftg(e,c)
	return e:GetHandler():GetEquipTarget() and c:GetSequence()<5 and math.abs(aux.GetColumn(c)-aux.GetColumn(e:GetHandler()))==1
end
function cm.cfilter(c)
	return (c:IsFaceup() or c:GetEquipTarget()) and c:IsType(TYPE_EQUIP) and c:IsAbleToDeck()
end
function cm.dfilter(c,tp)
	return c:IsRace(RACE_PYRO) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local lg2=Duel.GetMatchingGroup(cm.dfilter,tp,LOCATION_DECK,0,nil,tp)
	if chk==0 then
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(function(c) return c:IsCode(m) and c:IsFaceup() end,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then return false end
		return #lg>0 and #lg2>0
	end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst():GetEquipTarget()
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_LEAVE_CONFIRMED) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=Duel.SelectMatchingCard(tp,cm.dfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
		local ec=sg:GetFirst()
		if ec then
			Duel.Equip(tp,c,tc,true,true)
			Duel.Equip(tp,ec,tc,true,true)
			--equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(cm.eqlimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			ec:RegisterEffect(e2)
			Duel.EquipComplete()
		end
	end
end
function cm.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function cm.efilter(e,te)
	if te:IsActivated() then
		local ct=Duel.GetCurrentChain()
		local c=e:GetHandler()
		local eset={c:IsHasEffect(EFFECT_FLAG_EFFECT+m)}
		if #eset==0 then return true end
		local flag=eset[1]
		local tab=cm[flag]
		return not tab[ct] or tab[ct]~=e:GetHandler():GetSequence()
	end
	return false
end
function cm.eop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	local c=e:GetHandler()
	local eset={c:IsHasEffect(EFFECT_FLAG_EFFECT+m)}
	if #eset==0 then c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1) end
	eset={c:IsHasEffect(EFFECT_FLAG_EFFECT+m)}
	local flag=eset[1]
	cm[flag]=cm[flag] or {}
	local tab=cm[flag]
	tab[ct]=e:GetHandler():GetSequence()
end
function cm.imfilter(c)
	local eset={c:IsHasEffect(EFFECT_IMMUNE_EFFECT)}
	for _,te in pairs(eset) do
		if te:GetValue()==cm.efilter then return true end
	end
	return false
end
function Group.ForEach(group,func,...)
	if aux.GetValueType(group)=="Group" and group:GetCount()>0 then
		local d_group=group:Clone()
		for tc in aux.Next(d_group) do
			func(tc,...)
		end
	end
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ig=g:Filter(cm.imfilter,nil)
	g:Sub(ig)
	g:ForEach(Card.ResetFlagEffect,m+1)
	ig:ForEach(Card.RegisterFlagEffect,m+1,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local bool=false
	local ct=Duel.GetCurrentChain()
	local c=e:GetHandler()
	local eset={c:IsHasEffect(EFFECT_FLAG_EFFECT+m)}
	if #eset==0 then
		bool=true
	else
		local flag=eset[1]
		local tab=cm[flag]
		if not tab[ct] or tab[ct]~=e:GetHandler():GetSequence() then bool=true end
	end
	if bool then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Destroy(c:GetColumnGroup():Filter(Card.IsControler,nil,1-c:GetControler()),REASON_EFFECT)
	end
end