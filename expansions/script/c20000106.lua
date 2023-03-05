--剑参的煌印
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000101") end) then require("script/c20000101") end
function cm.initial_effect(c)
	local e1={fu_judg.E(c,1000,0)}
	local e2=e1[2]:Clone()
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.con3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
--e2
function cm.val2(e,c)
	local ph=Duel.GetCurrentPhase()
	if (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) then
		return Duel.GetMatchingGroupCount(Card.IsCode,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil,20000100)*200
	end
	return 0
end
--e3
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsCode,1,nil,20000100)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_BP_TWICE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	if Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(cm.op3con)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function cm.op3con(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end