--物欲探测器
local m=33701343
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetCounterLimit(0x1443,3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.thcon1)
	e2:SetOperation(cm.thop1)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCondition(cm.rccon)
	e3:SetCost(cm.rccost)
	e3:SetOperation(cm.rcop)
	c:RegisterEffect(e3)
	--self destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(cm.descon)
	c:RegisterEffect(e4)
	
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1200) end
	local lp=Duel.GetLP(tp)
	local m=math.floor(math.min(lp,3600)/1200)
	local t={}
	for i=1,m do
		t[i]=i*1200
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac)
	e:SetLabel(m)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanAddCounter(tp,0x1443,e:GetLabel(),c) end
	c:AddCounter(0x1443,e:GetLabel())
end
function cm.cfilter(c,tp)
	return c:IsControler(1-tp) and not c:IsReason(REASON_DRAW) and c:IsPreviousLocation(LOCATION_DECK)
end
function cm.thfilter(c,tpe)
	return c:IsType(tpe) and c:IsAbleToHand()
end
function cm.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and eg:GetCount()==1
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function cm.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	if Duel.SelectYesNo(aux.Stringid(m,1)) then
		local rtype=bit.band(eg:GetFirst():GetType(),0x7)
		local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,rtype)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoHand(sg,tp,REASON_EFFECT)>0 then
			e:GetHandler():RemoveCounter(tp,0x1443,1,REASON_EFFECT)
		end
	end
end
function cm.rccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOwner()~=tp
end
function cm.rccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	local lp=Duel.GetLP(tp)
	local m=e:GetHandler():GetCounter(0x1443)
	local t={}
	for i=1,m do
		t[i]=i*1000
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac)
	e:SetLabel(m)
end
function cm.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RemoveCounter(tp,0x1443,e:GetLabel(),REASON_EFFECT)
	end
end
function cm.descon(e)
	return e:GetHandler():GetCounter(0x1443)==0
end
