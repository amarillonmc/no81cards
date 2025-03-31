local s,id=GetID()

function s.initial_effect(c)
	   
	-- 效果处理
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 发动条件：
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp 
end

-- 目标处理：手卡特召+无效效果
function s.filter(c,e,tp)
	return c:IsSetCard(0x3962) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,e,tp)
			and Duel.IsChainNegatable(ev)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

-- 效果处理：特召+无效
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 特召手卡「嗡嗡军团」怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		-- 无效对方效果
		Duel.NegateActivation(ev)
	end
end