--【月】追月之梦·银白太阳之城
local m=33701538
local cm=_G["c"..m]
cm.dfc_back_side=m-1
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	Senya.DFCBackSideCommonEffect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetTargetRange(0xff,0xff)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.rccon)
	e3:SetOperation(cm.rcop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetLabel(3)
	e4:SetCondition(cm.accon)
	e4:SetCost(cm.accost)
	e4:SetTarget(cm.actg)
	e4:SetOperation(cm.acop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ATTACK_COST)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetLabel(5)
	e5:SetCondition(cm.atcon)
	e5:SetCost(cm.atcost)
	e5:SetOperation(cm.atop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetLabel(7)
	e6:SetCondition(cm.imcon)
	e6:SetValue(cm.efilter)
	c:RegisterEffect(e6)
	--cannot activate
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(0,1)
	e7:SetLabel(7)
	e7:SetCondition(cm.imcon)
	e7:SetValue(cm.cafilter)
	c:RegisterEffect(e7)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
	end
	
end
function cm.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)<1 and Duel.GetTurnPlayer()~=tp
end
function cm.rcop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)*500
	local ct2=Duel.GetFieldGroupCount(1-tp,LOCATION_REMOVED,0)*500
	local sc=g:GetFirst()
	while sc do
		local ct=0
		if sc:GetControler()==tp then ct=ct1
		else ct=ct2 end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(ct)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		sc:RegisterEffect(e2)
		sc=g:GetNext()
	end
	if cm[0]>0 then
		Duel.BreakEffect()
		Duel.Recover(tp,cm[0]*1000,REASON_EFFECT)
	end
end
function cm.cfilter(c)
	return c:IsSetCard(0xa440) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.accon(e)
	cm[0]=false
	return Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_REMOVED,0,nil)>=e:GetLabel()
end
function cm.acfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function cm.actg(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.accost(e,te,tp)
	return Duel.IsExistingMatchingCard(cm.acfilter,tp,LOCATION_DECK,0,1,nil)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	if cm[0] then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.acfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	cm[0]=true
end
function cm.atcon(e)
	return Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_REMOVED,0,nil)>=e:GetLabel()
end
function cm.atcost(e,c,tp)
	local g=Duel.GetDecktopGroup(tp,2)
	return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==2
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,2)
	Duel.Hint(HINT_CARD,0,m)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.imcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_REMOVED,0,nil)>=e:GetLabel()
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.cafilter(e,re,tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	cm[0]=cm[0]+eg:GetCount()
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
end
