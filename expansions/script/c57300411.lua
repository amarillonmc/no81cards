--pvz bt z 狂暴读报僵尸
Duel.LoadScript("c57300400.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedure(c,nil,5,2,s.ovfilter,aux.Stringid(id,0),3,nil)
	c:EnableReviveLimit()
	Zombie_Characteristics(c,500)
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsCode(57300410) and c:IsDefenseBelow(1000)
end