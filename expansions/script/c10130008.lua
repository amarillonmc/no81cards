--量子驱动-广防力场
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl.CreateActivateEffect(c)
	local e2 = Scl.CreateFieldBuffEffect(c, "UnaffectedByOpponentsActivatedEffects", 1, s.tg, { "MonsterZone", 0 }, "Spell&TrapZone",nil , nil, nil, nil, "SetAvailable")
	local e3 = Scl.CreateFieldTriggerMandatoryEffect(c, "AtStartOfBP", "ChangePosition", 1, "ChangePosition", nil, "Spell&TrapZone", scl.cond_check_tp(1), nil, { "~Target", "ChangePosition", s.pfilter, "MonsterZone", 0, true }, s.cpop)
	local e4,e5 = Scl.CreateFieldTriggerContinousEffect(c, "BeSet,BeFlippedFaceup", nil, nil, nil, "Spell&TrapZone", s.acon, s.aop)
end
function s.tg(e,c)
	return c:IsSetCard(0xa336) or c:IsFacedown()
end
function s.pfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsSetCard(0xa336)
end
function s.cpop(e,tp)
	local g = Duel.GetMatchingGroup(s.pfilter,tp,LOCATION_MZONE,0,nil)
	if #g > 0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
function s.acfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function s.acon(e,tp,eg)
	return eg:IsExists(s.acfilter, 1, nil,tp)
end
function s.aop(e,tp)
	--Scl_Quantadrive.Shuffle(tp)
	local c = e:GetHandler()
	Scl.HintCard(id)
	if not s.buff then
		s.buff = 1
		Scl.CreateFieldBuffEffect({c,tp},"+DEF",s.val,aux.TargetBoolFunction(Card.IsSetCard,0xa336),{"MonsterZone",0})
	else
		s.buff = s.buff + 1
	end
	c:SetHint(CHINT_NUMBER, s.buff)
end
function s.val(e,c)
	return s.buff * 200
end 