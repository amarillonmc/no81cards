--Lily White，季节之外的春告精
local m=33701414
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x234)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_LIGHT),1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(cm.lpcon1)
	e1:SetOperation(cm.lpop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--sp_summon effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(cm.regcon)
	e3:SetOperation(cm.regop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCondition(cm.lpcon2)
	e5:SetOperation(cm.lpop2)
	e5:SetLabelObject(e2)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(cm.atcon)
	e6:SetOperation(cm.atop)
	c:RegisterEffect(e6)

	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_DRAW)
	e7:SetCondition(cm.ctcon)
	e7:SetOperation(cm.ctop)
	c:RegisterEffect(e7)
	--spsummon
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(cm.ctop1)
	c:RegisterEffect(e8)
	--indes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(cm.idcon)
	e9:SetValue(1)
	c:RegisterEffect(e9)
	--atkchange
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_RECOVER)
	e10:SetDescription(aux.Stringid(m,0))
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCost(cm.rccost)
	e10:SetTarget(cm.rctg)
	e10:SetOperation(cm.rcop)
	c:RegisterEffect(e10)
	--pendulum
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_LEAVE_FIELD)
	e11:SetCondition(cm.pencon)
	e11:SetOperation(cm.penop)
	c:RegisterEffect(e11)
	
end
function cm.cfilter(c,sp)
	return c:IsSummonPlayer(sp) and c:IsFaceup()
end
function cm.lpcon1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(cm.cfilter,1,nil,1-tp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function cm.lpop1(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(cm.cfilter,nil,1-tp)
	local rnum=lg:GetSum(Card.GetAttack)
	if Duel.Recover(tp,rnum,REASON_EFFECT)<1 then return end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(cm.cfilter,1,nil,1-tp)
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
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.lpcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.lpop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,m)
	local lg=e:GetLabelObject():GetLabelObject()
	local rnum=lg:GetSum(Card.GetAttack)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e:GetLabelObject():SetLabelObject(g)
	lg:DeleteGroup()
	if Duel.Recover(tp,rnum,REASON_EFFECT)<1 then return end
end
function cm.atcon(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp then return false end
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	if ex then return true end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if not ex then return false end
	if cp~=PLAYER_ALL then return Duel.IsPlayerAffectedByEffect(cp,EFFECT_REVERSE_DAMAGE)
	else return Duel.IsPlayerAffectedByEffect(0,EFFECT_REVERSE_DAMAGE)
		or Duel.IsPlayerAffectedByEffect(1,EFFECT_REVERSE_DAMAGE)
	end
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	local ex,cg,ct,cp,cv,tg1,ct1,tp1,ev1=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	if ex then v=v+ev1 end
	ex,cg,ct,cp,cv,tg1,ct1,tp1,ev1=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if not ex then return end
	if cp~=PLAYER_ALL then 
		if Duel.IsPlayerAffectedByEffect(cp,EFFECT_REVERSE_DAMAGE) then v=v+ev1 end
	elseif Duel.IsPlayerAffectedByEffect(0,EFFECT_REVERSE_DAMAGE) or Duel.IsPlayerAffectedByEffect(1,EFFECT_REVERSE_DAMAGE) then v+ev1 end
	end
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.atop1(v))
end
function cm.atop1(v)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(v)
		Duel.RegisterEffect(e1,tp)
		end
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	e:GetHandler():AddCounter(0x234,1)
end
function cm.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function cm.ctop1(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.cfilter,1,nil,1-tp) then
		e:GetHandler():AddCounter(0x234,1)
	end
end
function cm.idcon(e)
	return e:GetHandler():GetCounter(0x234)>0
end
function cm.rccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetCounter(0x234)
	if chk==0 then return ct>0 and e:GetHandler():IsCanRemoveCounter(tp,0x234,ct,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x234,ct,REASON_COST)
	e:SetLabel(ct)
end
function cm.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*2000)
end
function cm.rcop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
