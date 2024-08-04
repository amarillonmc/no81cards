--pvz bt z 垃圾桶僵尸
Duel.LoadScript("c57300400.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	Zombie_Characteristics(c,400)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.natkcon)
	c:RegisterEffect(e1)
end
function s.natkcon(e)
	local c=e:GetHandler()
	return c:GetDefense()>=1100
end