--能量体
--rescripted 20230705
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl.CreateSingleBuffEffect(c, "+ATK", s.val, "MonsterZone")
	local e2 = Scl.CreateIgnitionEffect(c, "Destroy", 1, "Destroy", "Target", "MonsterZone", s.descon, 
		{ "PlayerCost", "Discard", 1 },
		{ "Target", "Destroy", aux.TRUE, 0, "OnField" }, s.desop)
	local e4 = Scl.CreateSingleBuffEffect(c, "UnaffectedByOpponentsActivatedEffects", 1, "MonsterZone", s.uecon)
end
function s.val(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_ONFIELD)*1000
end
function s.descon(e,tp)
	return e:GetHandler():IsAttackAbove(2000)
end
function s.desop(e,tp)
	local _, tc = Scl.GetTargetsReleate2Chain()
	if tc then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.uecon(e,tp)
	return e:GetHandler():IsAttackAbove(4000)
end