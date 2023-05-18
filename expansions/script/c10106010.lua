--恶念体 大脑掌控者
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = GetID()
function s.initial_effect(c)
	Scl.SetSummonCondition(c, false, aux.FALSE)
	local e0 = Scl.AddNormalSummonProcedure(c, false, s.sumcon, nil,
		s.sumop, nil, nil, "TributeSummon")
	local e1 = Scl.CreateFieldTriggerContinousEffect(c, "BeSpecialSummoned", nil,
		nil, nil, "MonsterZone", s.damcon, s.damop)
	local e2 = Scl.CreateFieldTriggerContinousEffect(c, "ActivateEffect", nil,
		nil, nil, "MonsterZone", s.glpcon, s.glpop)
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
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer, 1, nil, 1 - tp) and s.con(e)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Scl.HintCard(id)
	local ct = eg:FilterCount(Card.IsSummonPlayer, nil, 1 - tp)
	Duel.Damage(1 - tp, ct * 800, REASON_EFFECT, true)
	Duel.Recover(tp, ct * 1000, REASON_EFFECT, true)
	Duel.RDComplete()
end
function s.glpcon(e,tp,eg,ep,ev,re,r,rp)
	local loc = Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_LOCATION)
	return rp ~= tp and re:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) and s.con(e) and loc & LOCATION_MZONE ~= 0
end
function s.glpop(e,tp)
	Scl.HintCard(id)
	Duel.Damage(1 - tp, 800, REASON_EFFECT, true)
	Duel.Recover(tp, 1000, REASON_EFFECT, true)
	Duel.RDComplete()
end