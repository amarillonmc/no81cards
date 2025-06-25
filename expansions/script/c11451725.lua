--血雳强袭·缭乱盛典
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	e1:SetValue(cm.zones)
	c:RegisterEffect(e1)
	local e5=e1:Clone()
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e5:SetCost(cm.cost)
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
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.mcon)
	e2:SetTarget(cm.mtg)
	e2:SetOperation(cm.mop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(cm.actarget1)
		ge0:SetOperation(cm.costop1)
		Duel.RegisterEffect(ge0,0)
		cm.activate_sequence={}
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
	local zones=cm.zones(te,tp)
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false,zones)
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
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return ft>0 end
end
function cm.actarget1(e,te,tp)
	e:SetLabelObject(te)
	return true
end
function cm.costop1(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local op=te:GetOperation()
	local res=op==nil
	local tab=getmetatable(te:GetHandler())
	for _,f in pairs(tab) do
		if f==op then res=true end
	end
	if op==cm.mop then res=true end
	if te:GetHandler():IsLocation(LOCATION_MZONE) and not res then
		local eset={te:GetHandler():IsHasEffect(EFFECT_FLAG_EFFECT+m)}
		if #eset==0 then te:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1) end
		eset={te:GetHandler():IsHasEffect(EFFECT_FLAG_EFFECT+m)}
		local flag=eset[1]
		cm[flag]=cm[flag] or {}
		res=false
		for _,te in pairs(cm[flag]) do
			if te:GetOperation()==op then res=true end
		end
		if not res then cm[flag][#cm[flag]+1]=te end
	end
end
function cm.eftg(e,c)
	return e:GetHandler():GetEquipTarget() and math.abs(aux.GetColumn(c)-aux.GetColumn(e:GetHandler()))==1 --and c:GetSequence()<5
end
function cm.xylabel(c,tp)
	local x=c:GetSequence()
	local y=0
	if c:GetControler()==tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then y=0
		else x,y=-1,0.5 end
	elseif c:GetControler()==1-tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then x,y=4-x,4
		else x,y=5,3.5 end
	end
	return x,y
end
function cm.gradient(y,x)
	if y>0 and x==0 then return math.pi/2 end
	if y<0 and x==0 then return math.pi*3/2 end
	if y>=0 and x>0 then return math.atan(y/x) end
	if x<0 then return math.pi+math.atan(y/x) end
	if y<0 and x>0 then return 2*math.pi+math.atan(y/x) end
	return 1000
end
function cm.fieldline(x1,y1,x2,y2,...)
	for _,k in pairs({...}) do
		if cm.gradient(y2-y1,x2-x1)==k then return true end
	end
	return false
end
function cm.willbelinkdir(c,lc,x0,y0,tp,tgp)
	if tp~=tgp then x0,y0=4-x0,4-y0 end
	local x,y=cm.xylabel(c,tgp)
	local list={5/4,3/2,7/4,1,1000,0,3/4,1/2,1/4}
	for i=0,8 do
		if lc:IsLinkMarker(1<<i) and cm.fieldline(x0,y0,x,y,list[i+1]*math.pi) then return true end
	end
	return false
end
function cm.islinkdir(lc,x,y,tp)
	if lc:IsControler(1-tp) then x,y=4-x,4-y end
	local x0,y0=cm.xylabel(lc,lc:GetControler())
	local list={5/4,3/2,7/4,1,1000,0,3/4,1/2,1/4}
	for i=0,8 do
		if lc:IsLinkMarker(1<<i) and cm.fieldline(x0,y0,x,y,list[i+1]*math.pi) then return true end
	end
	return false
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function cm.zones(e,tp,eg,ep,ev,re,r,rp)
	local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local zone=0
	for i=0,4 do
		for lc in aux.Next(lg) do
			if cm.islinkdir(lc,i,0,tp) then zone=zone|(1<<i) end
		end
	end
	return zone
end
function cm.dfilter(lc,x,tp)
	return cm.islinkdir(lc,x,0,tp) and Duel.CheckLocation(tp,LOCATION_SZONE,x)
end
function cm.spfilter(c,e,tp,lk)
	return c:IsType(TYPE_LINK) and c:IsLinkBelow(lk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then
		--if e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(function(c) return c:IsCode(m) and c:IsFaceup() end,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then return false end
		if c:IsLocation(LOCATION_SZONE) then
			local x,y=cm.xylabel(c,tp)
			local g=lg:Filter(cm.islinkdir,nil,x,y,tp)
			return #g>0 and Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,#g)
		else
			for x=0,4 do
				local g=lg:Filter(cm.dfilter,nil,x,tp)
				if #g>0 and Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,#g) then return true end
			end
			return false
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.rffilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local x,y=cm.xylabel(c,tp)
	local g=lg:Filter(cm.islinkdir,nil,x,y,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,#g):GetFirst()
		if not tc then return end
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
			Duel.Equip(tp,c,tc)
			--equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(cm.eqlimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
end
function cm.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function cm.mcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.mtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if c:GetFlagEffect(m-1)>0 then return false end
		local eset={c:IsHasEffect(EFFECT_FLAG_EFFECT+m)}
		if #eset==0 then return false end
		local flag=eset[1]
		local tab=cm[flag]
		--if not tab then return false end
		for _,te in pairs(tab) do
			local tg=te:GetTarget()
			if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then return true end
		end
		return false
	end
	c:RegisterFlagEffect(m-1,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	local eset={c:IsHasEffect(EFFECT_FLAG_EFFECT+m)}
	local flag=eset[1]
	local tab=cm[flag]
	local options={}
	for _,te in ipairs(tab) do
		table.insert(options,te:GetDescription())
	end
	Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,1))
	local op=Duel.SelectOption(tp,table.unpack(options))
	local te=tab[op+1]:Clone()
	local tg=te:GetTarget()
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function cm.mop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end