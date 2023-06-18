--恶念体 神智摧毁者
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = GetID()
function s.initial_effect(c)
	Scl.SetSummonCondition(c, false, aux.FALSE)
	local e0 = Scl.AddNormalSummonProcedure(c, false, s.sumcon, nil,
		s.sumop, nil, nil, "TributeSummon")
	--[[local e1 = Scl.CreateFieldBuffEffect(c, "NegateEffect", 1, 
		aux.TargetBoolFunction(s.cfilter), 
		{"MonsterZone","MonsterZone"}, "MonsterZone", s.con)--]]
	local e1 = Scl.CreateFieldBuffEffect(c, "UnaffectedByOpponentsCardEffects", 
		s.val, nil, 
		{"OnField",0}, "MonsterZone", s.con, nil, nil, nil, "SetAvailable,IgnoreUnaffected")
	local e2 = Scl.CreateSingleBuffEffect(c, "+ATK", s.val, "MonsterZone", s.con)
end
function s.ecfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3338)
end
function s.otfilter(c,tp)
	return c:GetEquipGroup():IsExists(s.ecfilter,1,nil)
end
function s.sumcon(e,c,tp,minc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(s.otfilter))
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)
	local mg=Duel.GetMatchingGroup(s.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local res = c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
	e1:Reset()  
	return res
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(s.otfilter))
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)
	local mg=Duel.GetMatchingGroup(s.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	e1:Reset()
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function s.con(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function s.cfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.cfilter, e:GetHandlerPlayer(), 0, LOCATION_MZONE, nil) * 800
end