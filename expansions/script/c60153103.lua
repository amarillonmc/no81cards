--糕点时间 百江渚
Duel.LoadScript("c60152900.lua")
local s,id,o = GetID()
function s.initial_effect(c)
	local e1 = Scl.CreateFieldTriggerOptionalEffect(c, "BeforeDamageCalculation", 
	"GainATK", nil, "GainATK", nil, "Hand,MonsterZone", nil, 
	{"Cost", Card.IsReleasable, "Tribute"}, 
	{"~Target", s.afilter, "GainATK", "MonsterZone"}, s.atkop)
	local e2 = Scl.CreateFieldTriggerOptionalEffect(c, EVENT_LEAVE_FIELD, 
	"Return2Hand", nil, "Return2Hand,Draw", nil, "GY", s.thcon, aux.bfgcost,
	{"~Target", s.thfilter, "Return2Hand", "GY,Banished"}, s.thop)
end
function s.afilter(c,e,tp)
	local c1, c2 = Duel.GetBattleMonster(tp)
	return c:IsFaceup() and c1 and c1 == c and (c1:IsType(TYPE_NORMAL) or (c1:IsType(TYPE_XYZ) and c1:GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_NORMAL))) and c2 and c2:IsFaceup() and c2:IsControler(1-tp)
end
function s.atkop(e,tp)
	local c1, c2 = Duel.GetBattleMonster(tp)
	if not c1 or not c1:IsRelateToBattle() or not c2 or not c2:IsRelateToBattle() or c2:IsControler(tp) then return end
	local e1 = Scl.AddSingleBuff({e:GetHandler(), c1}, "+ATK", c2:GetAttack() + 1800, "Reset", RESETS_EP_SCL)
end
function s.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsControler(tp) and c:GetReasonPlayer() ~= tp and (Scl.IsPreviousType(c, 0, "Normal") or (Scl.IsPreviousType(c, 0, "Xyz") and Scl.GetPreviousXyzMaterials(c):IsExists(Card.IsType, 1, nil, TYPE_NORMAL))) 
end 
function s.thcon(e,tp,eg)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.thfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToHand() and Scl.FaceupOrNotBeBanished(c)
end
function s.thop(e,tp)
	local ct = Duel.GetFieldGroupCount(tp, 0, LOCATION_MZONE) - 1
	if Scl.SelectAndOperateCards("Return2Hand",tp,aux.NecroValleyFilter(s.thfilter),tp,"GY,Banished",0,1,1,nil)() > 0 and Scl.IsCorrectlyOperated("Hand") and Duel.GetFieldGroupCount(tp, LOCATION_MZONE, 0) == 0 and ct > 0 then
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end