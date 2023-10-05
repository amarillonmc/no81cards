if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53716004
local cm=_G["c"..m]
cm.name="于断片沉默的处决"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	local e1,e1_1,e2,e3=SNNM.ActivatedAsSpellorTrap(c,0x20004,LOCATION_EXTRA)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)end)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)
	SNNM.ActivatedAsSpellorTrapCheck(c)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_MONSTER)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cost=Duel.GetMatchingGroup(function(c)return c:IsSetCard(0x553b) and c:IsReleasable()end,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return #cost>0 and not e:GetHandler():IsForbidden() and e:GetHandler():CheckUniqueOnField(tp) and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=cost:Select(tp,1,1,e:GetHandler())
	local cg=g:Filter(Card.IsFacedown,nil)
	if #cg>0 then Duel.ConfirmCards(1-tp,cg) end
	Duel.Release(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
	if c:IsFacedown() then return end
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(cm.indtg)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(e6)
end
function cm.indtg(e,c)
	local ct1=aux.GetColumn(e:GetHandler())
	local ct2=aux.GetColumn(c)
	if not ct1 or not ct2 then return false end
	return math.abs(ct1-ct2)==0
end
function cm.setfilter(c)
	return bit.band(c:GetType(),0x20004)==0x20004
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,m)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_DECK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetLabel(ct)
	e1:SetLabelObject(c)
	e1:SetOperation(cm.acfd)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_DECK,0)
	e2:SetTarget(cm.eftg)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(m+ct*50)
	e3:SetTargetRange(1,0)
	e3:SetLabelObject(e2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.eftg(e,c)
	return c:GetType()&0x20004==0x20004 and c:IsSetCard(0x353b)
end
function cm.acfd(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local ae={c:IsHasEffect(m)}
	for _,v in pairs(ae) do
		if v:GetLabelObject() then
			if v:GetLabelObject():GetLabelObject() then v:GetLabelObject():GetLabelObject():Reset() end
			v:GetLabelObject():Reset()
		end
		v:Reset()
	end
	local ec=e:GetLabelObject()
	local le={c:GetActivateEffect()}
	for _,v in pairs(le) do
		if v:GetOwner()==c and v:GetRange()&0x2~=0 then
			local e1=v:Clone()
			e1:SetOwner(ec)
			e1:SetRange(LOCATION_DECK)
			e1:SetReset(RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(ec)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_ACTIVATE_COST)
			e2:SetRange(LOCATION_DECK)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_SET_AVAILABLE)
			e2:SetValue(e:GetLabel())
			e2:SetLabelObject(e1)
			e2:SetTargetRange(1,1)
			e2:SetTarget(cm.actarget2)
			e2:SetCost(cm.costchk2)
			e2:SetOperation(cm.costop2)
			e2:SetReset(RESET_PHASE+PHASE_END)
			c:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(ec)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(m)
			e3:SetLabel(ct)
			e3:SetLabelObject(e2)
			e3:SetReset(RESET_PHASE+PHASE_END)
			c:RegisterEffect(e3,true)
		end
	end
end
function cm.actarget2(e,te,tp)
	return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject()
end
function cm.costchk2(e,te_or_c,tp)
	local fdzone=0
	for i=0,4 do if Duel.CheckLocation(tp,LOCATION_SZONE,i) then fdzone=fdzone|1<<i end end
	if aux.GetValueType(te_or_c)=="Effect" and te_or_c:IsHasProperty(EFFECT_FLAG_LIMIT_ZONE) then
		local zone=te_or_c:GetValue()
		if aux.GetValueType(c)=="function" then
			zone=zone(te_or_c,tp)
		end
		fdzone=fdzone&zone
		e:SetLabel(fdzone)
	end
	return fdzone>0
end
function cm.costop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	local zone=e:GetLabel()
	if zone==0 then Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false) else
		local flag=Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,~zone&0x1f00)
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false,2^(math.log(flag,2)-8))
	end
	e:SetLabel(0)
	c:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(cm.rsop2)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
	local ct=e:GetValue()
	local le={Duel.IsPlayerAffectedByEffect(tp,m+ct*50)}
	for _,v in pairs(le) do
		if v:GetLabelObject() then v:GetLabelObject():Reset() end
		v:Reset()
	end
	local g=Duel.GetMatchingGroup(nil,0,0xff,0xff,c)
	for tc in aux.Next(g) do
		local ae={tc:IsHasEffect(m)}
		for _,v in pairs(ae) do
			if v:GetLabel()==ct then
				if v:GetLabelObject() then
					if v:GetLabelObject():GetLabelObject() then v:GetLabelObject():GetLabelObject():Reset() end
					v:GetLabelObject():Reset()
				end
				v:Reset()
			end
		end
	end
end
function cm.rsop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
	if re:GetLabelObject() then re:GetLabelObject():Reset() end
	re:Reset()
end
