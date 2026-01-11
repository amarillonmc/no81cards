--芳香法师-黑莲花
local s,id,o=GetID()
function s.initial_effect(c)
	--effect draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(3)
	e2:SetCondition(s.drcon)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_RECOVER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.limcon)
	e3:SetOperation(s.limop)
	c:RegisterEffect(e3)
	
end
function s.drcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function s.limcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function s.limop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=1
	if Duel.GetTurnPlayer()==tp then
		ct=2
	end
	--effect count
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(s.scount)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,ct)
	Duel.RegisterEffect(e1,tp)
	local e4=e1:Clone()
	e4:SetOperation(s.ocount)
	Duel.RegisterEffect(e4,tp)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(s.econ1)
	e3:SetValue(s.elimit)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,ct)
	Duel.RegisterEffect(e3,tp)
	local e6=e3:Clone()
	e6:SetCondition(s.econ2)
	e6:SetTargetRange(0,1)
	Duel.RegisterEffect(e6,tp)
end
function s.scount(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsActiveType(TYPE_MONSTER) or (re:GetHandler() and not re:GetHandler():IsSetCard(0xc9)) then return end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.econ1(e)
	return Duel.GetFlagEffect(tp,id)>2
end
function s.ocount(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsActiveType(TYPE_MONSTER) or (re:GetHandler() and not re:GetHandler():IsSetCard(0xc9)) then return end
	Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
end
function s.econ2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,id+o)>2
end
function s.elimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsSetCard(0xc9)
end
