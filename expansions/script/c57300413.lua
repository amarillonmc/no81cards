--pvz bt z 伴舞僵尸
Duel.LoadScript("c57300400.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	Zombie_Characteristics(c,400)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.natkcon)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker():IsCode(id,id+1) then
		Duel.RegisterFlagEffect(Duel.GetAttacker():GetControler(),id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.natkcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),id)>0
end