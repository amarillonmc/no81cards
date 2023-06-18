--量子驱动-指挥中心
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl.CreateActivateEffect(c)
	local e2 = Scl.CreateQuickOptionalEffect(c, "FreeChain", "ChangePosition", {1, id}, "ChangePosition", nil, "Spell&TrapZone", nil, nil, { "~Target", "ChangePosition", s.pfilter, "MonsterZone" }, s.pop)
	local e3 = Scl.CreateFieldBuffEffect(c, "AttackInDefensePosition", 1, aux.TargetBoolFunction(Card.IsSetCard, 0xa336), {"MonsterZone", 0}, "Spell&TrapZone")
	--local e4 = Scl.CreateFieldTriggerMandatoryEffect(c, "BeFlippedFaceup", nil, "Damage", "PlayerTarget", "Spell&TrapZone", s.damcon, nil, {"PlayerTarget", "Damage", 0, 800}, s.damop)
end
function s.pfilter(c)
	return c:IsSetCard(0xa336) and c:IsCanChangePosition()
end
function s.pop(e,tp)
	local _,tc = Scl.SelectCards("ChangePosition",tp,s.pfilter,tp,"MonsterZone",0,1,1,nil)
	if not tc then return end
	local pos = Duel.SelectPosition(tp,tc,POS_FACEUP+POS_FACEDOWN_DEFENSE - tc:GetPosition())
	Duel.ChangePosition(tc, pos)
end
function s.damcon(e,tp,eg)
	return eg:IsExists(Card.IsControler, 1, nil, tp)
end
function s.damop(e,tp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end