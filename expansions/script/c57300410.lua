--pvz bt z 读报僵尸
Duel.LoadScript("c57300400.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	Zombie_Characteristics(c,500)
end