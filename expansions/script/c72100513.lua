--王权继承者 崔斯坦
local m=72100513
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,3,4)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabel(2)
	e2:SetCondition(cm.lpcon)
	e2:SetOperation(cm.lpop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabel(2)
	e3:SetCondition(cm.lpcon1)
	e3:SetOperation(cm.lpop1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetLabel(2)
	e4:SetCondition(cm.regcon)
	e4:SetOperation(cm.regop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(cm.lpcon2)
	e5:SetOperation(cm.lpop2)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_SZONE)
	e6:SetLabel(4)
	e6:SetCondition(cm.discon)
	e6:SetOperation(cm.disop)
	c:RegisterEffect(e6)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ACTIVATE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetTargetRange(0,1)
	e8:SetCondition(cm.rmcon)
	e8:SetValue(cm.aclimit)
	c:RegisterEffect(e8)
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(m,0))
	e13:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e13:SetType(EFFECT_TYPE_QUICK_O)
	e13:SetCode(EVENT_CHAINING)
	e13:SetCountLimit(1,m)
	e13:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCondition(cm.discon)
	e13:SetTarget(cm.distg)
	e13:SetOperation(cm.disop)
	c:RegisterEffect(e13)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
-----
function cm.rmcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)==6
end
function cm.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function cm.matfilter(c)
	return c:IsLinkSetCard(0x9a2)
end
----------
function cm.filter(c)
	return c:IsFaceup() and c:IsLinkSetCard(0x9a2)
end
function cm.cfilter(c,sp)
	return c:GetSummonPlayer()==sp and c:IsFaceup()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,nil)
	local ct=e:GetLabel()
	return ct and g:GetClassCount(Card.GetCode)>=ct
end
function cm.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return cm.condition(e,tp,eg,ep,ev,re,r,rp)
		and eg:IsExists(cm.cfilter,1,nil,1-tp)
end
function cm.lpcon1(e,tp,eg,ep,ev,re,r,rp)
	return cm.lpcon(e,tp,eg,ep,ev,re,r,rp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function cm.lpop1(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(cm.cfilter,nil,1-tp)
	local rnum=lg:GetSum(Card.GetAttack)
	Duel.Recover(tp,rnum,REASON_EFFECT)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return cm.lpcon(e,tp,eg,ep,ev,re,r,rp)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(cm.cfilter,nil,1-tp)
	local g=e:GetLabelObject()
	if g==nil or #g==0 then
		lg:KeepAlive()
		e:SetLabelObject(lg)
	else
		g:Merge(lg)
	end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
end
function cm.lpcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.lpop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(m)
	local lg=e:GetLabelObject():GetLabelObject()
	local rnum=lg:GetSum(Card.GetAttack)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e:GetLabelObject():SetLabelObject(g)
	lg:DeleteGroup()
	Duel.Recover(tp,rnum,REASON_EFFECT)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return cm.condition(e,tp,eg,ep,ev,re,r,rp)
		and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and rp==1-tp
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end