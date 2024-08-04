--[[
消逝的未来
Depleted Future
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[When your opponent declares a direct attack with a monster whose ATK is higher than your LP: You can discard this card;
	inflict X00 damage to your opponent, and if you do, end that Battle Phase, also, if your opponent has taken damage from this card's effect, apply this effect.
	● During the (7-X)th End Phase after this effect resolves, the LP of each player that did not gain LP this turn become 0.
	(X = the number of monsters your opponent controls when this card's effect resolves.)]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetFunctions(s.condition,aux.DiscardSelfCost,s.target,s.operation)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_RECOVER)
		ge:SetOperation(s.regop)
		Duel.RegisterEffect(ge,0)
	end
end

local FLAG_TURN_COUNTER 		= id
local FLAG_GAINED_LP_THIS_TURN	= id+100

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,FLAG_GAINED_LP_THIS_TURN,RESET_PHASE|PHASE_END,0,1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.GetAttackTarget()==nil and Duel.GetAttacker():GetAttack()>Duel.GetLP(tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local X=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if chk==0 then return X>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,X*100)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local X=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if X==0 then return end
	if Duel.Damage(1-tp,X*100,REASON_EFFECT)>0 then
		Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE|PHASE_BATTLE_STEP,1)
		if 6-X>0 then
			Duel.RegisterFlagEffect(tp,FLAG_TURN_COUNTER,RESET_PHASE|PHASE_END,0,6-X)
		end
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE|PHASE_END)
		e1:OPT()
		e1:SetLabel(0)
		e1:SetOperation(s.lpop)
		e1:SetReset(RESET_PHASE|PHASE_END,7-X)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.PlayerHasFlagEffect(tp,FLAG_TURN_COUNTER)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	ct=ct+1
	e:GetHandler():SetTurnCounter(ct)
	e:SetLabel(ct)
	if not Duel.PlayerHasFlagEffect(tp,FLAG_TURN_COUNTER) then
		for p in aux.TurnPlayers() do
			if not Duel.PlayerHasFlagEffect(p,FLAG_GAINED_LP_THIS_TURN) then
				Duel.SetLP(p,0)
			end
		end
	end
end