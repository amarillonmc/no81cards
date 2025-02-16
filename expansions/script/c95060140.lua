local s, id = GetID()

function s.initial_effect(c)
	-- 场地魔法基本设置
  --  c:EnableReviveLimit()
  --  c:SetType(TYPE_SPELL+TYPE_FIELD)
   -- c:SetCode(TYPE_FIELD)
	
	-- 激活处理
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e0)
	
	-- ===== 效果①：幻龙族怪兽攻守提升 =====
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE) -- 全场幻龙族生效
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WYRM) )
	e1:SetValue(300)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	
	-- ===== 效果②：光属性幻龙族抗破坏 =====
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0) -- 仅己方怪兽
	e3:SetTarget(s.tt)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	
	-- ===== 效果③：主要阶段特召 =====
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end

-- ===== 效果③处理函数 =====

function s.tt(e,c) 
		return c:IsRace(RACE_WYRM) and c:IsAttribute(ATTRIBUTE_LIGHT)
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x956) 
		and c:IsLevelBelow(4)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end