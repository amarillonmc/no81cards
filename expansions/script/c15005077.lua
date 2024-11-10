local m=15005077
local cm=_G["c"..m]
cm.name="终结巢歌·三终渊之死"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,15005077)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,15005070,15005072,15005074,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	--activate cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetCondition(cm.costcon)
	e3:SetCost(cm.costchk)
	e3:SetOperation(cm.costop)
	c:RegisterEffect(e3)
	--accumulate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_FLAG_EFFECT+m)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCondition(cm.costcon)
	e4:SetTargetRange(1,1)
	c:RegisterEffect(e4)
	if not cm.gcheck then
		cm.gcheck=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.regacop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_REMOVE)
		ge2:SetOperation(cm.regrmop)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.regacop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,15005079,RESET_PHASE+PHASE_END,0,1)
end
function cm.regrmop(e,tp,eg,ep,ev,re,r,rp)
	local ag=eg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	local tc=ag:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(0,15005078,RESET_PHASE+PHASE_END,0,1)
		tc=ag:GetNext()
	end
end
function cm.costcon(e)
	return Duel.GetFlagEffect(0,15005078)>=6
end
function cm.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,m)
	if Duel.GetFlagEffect(tp,15005079)<=3 then return true end 
	return Duel.CheckLPCost(tp,ct*1800)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,15005079)>3 then
		Duel.PayLPCost(tp,1800)
	end
end