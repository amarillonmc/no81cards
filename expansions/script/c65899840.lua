--空城计
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--禁止双方攻击宣言
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN, Duel.GetTurnPlayer()==tp and 2 or 1)
	Duel.RegisterEffect(e1,tp)

	--双方出场的卡各自不能超过1张
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MAX_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN, Duel.GetTurnPlayer()==tp and 2 or 1)
	e2:SetValue(s.mvalue)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_MAX_SZONE)
	e3:SetValue(s.svalue)
	Duel.RegisterEffect(e3,tp)

	--防止发动/盖放超出限制的卡
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e4:SetTargetRange(1,1)
	e4:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN, Duel.GetTurnPlayer()==tp and 2 or 1)
	e4:SetValue(s.aclimit)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SSET)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN, Duel.GetTurnPlayer()==tp and 2 or 1)
	e5:SetTarget(s.setlimit)
	Duel.RegisterEffect(e5,tp)

	--ADJUST清理：确保场上卡数量符合限制
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetCode(EVENT_ADJUST)
	e6:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN, Duel.GetTurnPlayer()==tp and 2 or 1)
	e6:SetOperation(s.adjustop)
	Duel.RegisterEffect(e6,tp)
end

function s.mvalue(e,fp,rp,r)
	return 1-Duel.GetFieldGroupCount(fp,LOCATION_SZONE,0)
end
function s.svalue(e,fp,rp,r)
	return 1-Duel.GetFieldGroupCount(fp,LOCATION_MZONE,0)
end

function s.aclimit(e,re,tp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	if re:IsActiveType(TYPE_FIELD) then
		return not Duel.GetFieldCard(tp,LOCATION_FZONE,0) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>=1
	elseif re:IsActiveType(TYPE_PENDULUM) then
		return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>=1
	end
	return false
end

function s.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD) and not Duel.GetFieldCard(tp,LOCATION_FZONE,0) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>=1
end

function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	for p=0,1 do
		local count=Duel.GetFieldGroupCount(p,LOCATION_ONFIELD,0)
		if count>1 then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(p,nil,p,LOCATION_ONFIELD,0,count-1,count-1,nil)
			Duel.SendtoGrave(g,REASON_RULE)
		end
	end
	Duel.Readjust()
end