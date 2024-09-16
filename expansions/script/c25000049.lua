--决斗世代
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e2:SetCondition(s.ntcon)
	e2:SetTarget(s.nttg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_TOMAIN_KOISHI)
	e3:SetTargetRange(1,1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetValue(100)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_MUST_USE_MZONE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
	e4:SetTarget(s.tg)
	e4:SetValue(s.frcval)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.mtcon)
	e5:SetOperation(s.mtop)
	c:RegisterEffect(e5)
end
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.nttg(e,c)
	return c:IsLevel(5)
end
function s.actarget(e,te,tp)
	return te:GetHandler():IsType(TYPE_FIELD)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local fg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_FZONE,LOCATION_FZONE,nil)
	Duel.Destroy(fg,REASON_EFFECT+REASON_RULE)
end
function s.rulecon(e,tp,eg,ep,ev,re,r,rp)
	return eg:Filter(Card.IsType,nil,TYPE_FIELD):FilterCount(Card.IsPreviousLocation,nil,LOCATION_FZONE)>0 and bit.band(r,0x41)==0x41
end
function s.ruleop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local dg=eg:Filter(Card.IsType,nil,TYPE_FIELD):Filter(Card.IsPreviousLocation,nil,LOCATION_FZONE)
	Duel.RaiseEvent(dg,EVENT_DESTROYED,e,0,tp,tp,Duel.GetCurrentChain())
end
function s.tg(e,c)
	return c:IsFacedown()
end
function s.frcval(e,c,fp,rp,r)
	return Duel.GetLinkedZone(0)+(Duel.GetLinkedZone(1)<<0x10) | 0x600060
end
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,500) then
		Duel.PayLPCost(tp,500)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end