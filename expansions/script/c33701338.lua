--散华·玉玺之殇
local m=33701338
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Effect Draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.pdrcon)
	e2:SetOperation(cm.pdrop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DRAW)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.condition)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	
end
function cm.pdrcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.pdrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetDrawCount(1-tp)
	if Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
		--Effect Draw
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_SZONE)
		e1:SetTargetRange(0,1)
		e1:SetValue(ct+1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW)
		c:RegisterEffect(e1)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local c=e:GetHandler()
	local m1={}
	local n1={}
	local ct=1
	local op=1
	m1[ct]=aux.Stringid(m,0) n1[ct]=1 ct=ct+1
	m1[ct]=aux.Stringid(m,1) n1[ct]=2 ct=ct+1
	local sp=Duel.SelectOption(tp,table.unpack(m1))
	op=n1[sp+1]
	if op==1 then
		local ct=2
		if Duel.GetCurrentPhase()==PHASE_DRAW then ct=5 end
		Duel.DiscardDeck(ep,ct,REASON_EFFECT)
	else
		local ct=2000
		if Duel.GetCurrentPhase()==PHASE_DRAW then ct=5000 end
		Duel.Recover(tp,eg:GetCount()*ct,REASON_EFFECT)
	end
end
