--心像晕眩 / Cardiogiro
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCondition(s.ctcon)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(s.tg)
	c:RegisterEffect(e3)
	local e3x=Effect.CreateEffect(c)
	e3x:SetType(EFFECT_TYPE_FIELD)
	e3x:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3x:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3x:SetRange(LOCATION_SZONE)
	e3x:SetTargetRange(1,1)
	e3x:SetValue(s.aclimit)
	c:RegisterEffect(e3x)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==1
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c and c:IsRelateToEffect(e) then
		if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) and c:IsLocation(LOCATION_SZONE) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_SKIP_DP)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
			Duel.RegisterEffect(e1,tp)
		end
	end
end

function s.tg(e,c)
	return c:IsStatus(STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN+STATUS_FLIP_SUMMON_TURN)
end
function s.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc and rc:IsOnField()
		and rc:IsStatus(STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN+STATUS_FLIP_SUMMON_TURN)
end