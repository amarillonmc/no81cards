--将军的无敌铁幕
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65133150)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--Unaffected by effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(s.immcon)
	e2:SetTarget(s.immtg)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--Self destruct
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.descon)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	--Turn counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(s.countop)
	c:RegisterEffect(e4)
end
function s.shogunfilter(c)
	return c:IsCode(65133150) and c:IsFaceup()
end
function s.immcon(e)
	return Duel.IsExistingMatchingCard(s.shogunfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.immtg(e,c)
	return c~=e:GetHandler()
end
function s.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and re:IsActivated() and not e:GetHandler():IsCode(65133150)
end
function s.countop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then
		local c=e:GetHandler()
		local ct=c:GetTurnCounter()
		c:SetTurnCounter(ct+1)
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetTurnCounter()>=3
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
