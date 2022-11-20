--咒文记忆
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl.CreateActivateEffect(c, nil, nil, nil, nil, "Target", nil, nil,
		{"Target", s.filter, "Target", "Field,GY", "Field,GY"}, s.act)
end
function s.filter(c)
	return Scl.IsType(c, 0, "QuickPlay,Spell", "NormalTrap") and not c:IsCode(id) and Scl.FaceupOrNotOnField(c)
end
function s.act(e,tp)
	local _, c = Scl.GetFaceupActivateCard()
	if not c then return end
	c:CancelToGrave()
	Duel.ChangePosition(c,POS_FACEDOWN)
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	local _, tc = Scl.GetTargetsReleate2Chain()
	if not tc then return end
	local code = tc:GetOriginalCodeRule()
	c:ReplaceEffect(code, RESETS_SCL)
	Scl.AddSingleBuff2Self(c, "=Code", code)
end