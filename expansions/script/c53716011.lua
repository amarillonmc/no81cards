if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53716011
local cm=_G["c"..m]
cm.name="断片折光 幻想魔裔"
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
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.op)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(m)
	e4:SetRange(0xff)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_RELEASE)
		ge1:SetOperation(cm.effop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(cm.evchk)
		Duel.RegisterEffect(ge2,0)
	end
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_MONSTER)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cost=Duel.GetMatchingGroup(function(c)return c:IsType(TYPE_CONTINUOUS) and c:IsReleasable()end,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return #cost>2 and not e:GetHandler():IsForbidden() and e:GetHandler():CheckUniqueOnField(tp) and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=cost:Select(tp,3,3,e:GetHandler())
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
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Recover(tp,1800,REASON_EFFECT)
	end
end
function cm.effac(c,g,ct,se,p)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,se+2))
		e1:SetCategory(CATEGORY_TOHAND)
		e1:SetType(EFFECT_TYPE_ACTIVATE)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCode(EVENT_CUSTOM+(m+50*ct))
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
		e1:SetTarget(cm.actg(ct,se,p))
		e1:SetOperation(cm.acop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_ACTIVATE_COST)
		e2:SetRange(LOCATION_REMOVED)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetLabelObject(e1)
		e2:SetTargetRange(1,1)
		e2:SetTarget(cm.actarget)
		e2:SetCost(cm.costchk)
		e2:SetOperation(cm.costop2)
		e2:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(m+50)
		e3:SetTargetRange(1,1)
		e3:SetLabel(ct)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,p)
	end
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(function(c)return c:IsHasEffect(m) and c:IsPreviousLocation(LOCATION_ONFIELD)end,nil)
	if #tg==0 then return end
	if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) then
		local g=Duel.GetMatchingGroup(function(c)return c:GetType()&0x20004~=0 and c:IsFaceupEx()end,p,LOCATION_REMOVED,0,nil)
		for c in aux.Next(tg) do
			local p=c:GetControler()
			local se=c:GetPreviousSequence()
			if c:GetPreviousControler()~=p then se=4-se end
			local ct=Duel.GetFlagEffect(0,m)
			Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
			cm.effac(c,g,ct,se,p)
			Duel.RaiseEvent(g,EVENT_CUSTOM+(m+50*ct),re,r,rp,ep,ev)
		end
	else
		for c in aux.Next(tg) do
			local p=c:GetControler()
			local se=c:GetPreviousSequence()
			if c:GetPreviousControler()~=p then se=4-se end
			local ct=Duel.GetFlagEffect(0,m)
			Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(m)
			e1:SetTargetRange(1,1)
			e1:SetLabel(ct,se,p)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,p)
		end
	end
end
function cm.evchk(e,tp,eg,ep,ev,re,r,rp)
	local le={Duel.IsPlayerAffectedByEffect(0,m)}
	for _,v in pairs(le) do
		local c=v:GetOwner()
		local ct,se,p=v:GetLabel()
		local g=Duel.GetMatchingGroup(function(c)return c:GetType()&0x20004~=0 and c:IsFaceupEx()end,p,LOCATION_REMOVED,0,nil)
		cm.effac(c,g,ct,se,p)
		Duel.RaiseEvent(g,EVENT_CUSTOM+(m+50*ct),re,r,rp,ep,ev)
		v:Reset()
	end
end
function cm.filter(c,e,tp,se,p)
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then seq=aux.MZoneSequence(c:GetSequence()) end
	if c:GetControler()~=tp then seq=math.abs(seq-4) end
	return seq<5 and math.abs(se-seq)==1 and c:IsAbleToHand()
end
function cm.actg(ct,se,p)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.filter(chkc,e,tp,se,p) and chkc:IsOnField() end
	if chk==0 then
		local res=false
		local le={Duel.IsPlayerAffectedByEffect(tp,m+50)}
		for k,v in pairs(le) do if v:GetLabel()==ct then res=true end end
		return res and Duel.IsExistingTarget(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp,se,p)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),e,tp,se,p)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local le={Duel.IsPlayerAffectedByEffect(tp,m+50)}
	for k,v in pairs(le) do
		if v:GetLabel()==ct then
			if v:GetLabelObject() and v:GetLabelObject():GetLabelObject() then v:GetLabelObject():GetLabelObject():Reset() end
			if v:GetLabelObject() then v:GetLabelObject():Reset() end
			v:Reset()
		end
	end
	end
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
end
function cm.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject()
end
function cm.costchk(e,te_or_c,tp)
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
end
