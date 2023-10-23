local m=53796145
local cm=_G["c"..m]
cm.name="问答无用！"
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e2:SetCondition(cm.excon)
	e2:SetCost(cm.excost)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(cm.hdcon)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(m)
	e4:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ACTIVATE_COST)
	e5:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetTarget(cm.actarget)
	e5:SetOperation(cm.acop)
	c:RegisterEffect(e5)
	if not cm.global_check then
		cm.global_check=true
		Duel.RegisterFlagEffect(rp,m,0,0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.count)
		Duel.RegisterEffect(ge1,0)
	end
end
cm.group_0={}
cm.group_1={}
cm.code_check={22022060,22022580,15000604,60002364}
function cm.count(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc and SNNM.IsInTable(rc:GetOriginalCodeRule(),cm.code_check) then
		table.insert(cm["group_"..rp],re)
		local e1=Effect.CreateEffect(e:GetOwner())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_NEGATED)
		e1:SetOperation(cm.reset(re,rp))
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,0)
	end
end
function cm.reset(ae,ap)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				for k,v in pairs(cm["group_"..rp]) do if v==e:GetLabelObject() then table.remove(cm["group_"..rp],k) break end end
			end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ((Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_HAND and re:IsActiveType(TYPE_MONSTER)) or (re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsStatus(STATUS_ACT_FROM_HAND))) and Duel.IsChainNegatable(ev) and rp~=tp
end
function cm.excon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(m) and cm.condition(e,tp,eg,ep,ev,re,r,rp)
end
function cm.cfilter(c)
	return c:IsCode(m) and c:IsAbleToRemoveAsCost()
end
function cm.costop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.actlimit)
	Duel.RegisterEffect(e1,tp)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if not e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then return end
	cm.costop(e,tp)
end
function cm.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	cm.costop(e,tp)
end
function cm.actlimit(e,re,rp)
	local rc=re:GetHandler()
	return rc and SNNM.IsInTable(rc:GetOriginalCodeRule(),cm.code_check)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.hdcon(e)
	local tp=e:GetHandlerPlayer()
	local ct=Duel.GetCurrentChain()
	if ct==0 then return false end
	local rc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT):GetHandler()
	local t=cm["group_"..tp]
	return rc and SNNM.IsInTable(rc:GetOriginalCodeRule(),cm.code_check) and #t==0 and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,2,e:GetHandler())
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	e:GetHandler():CreateEffectRelation(te)
	local c=e:GetHandler()
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
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
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
