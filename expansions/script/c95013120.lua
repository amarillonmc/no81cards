-- 信封
local s, id = GetID()
s.dawn_set = 0x696d  -- 破晓字段代码

function s.initial_effect(c)
	-- 效果：从卡组送墓「破晓」怪兽，自身变成怪兽特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 过滤：卡组中的「破晓」怪兽
function s.cfilter(c)
	return c:IsSetCard(s.dawn_set) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end

-- 目标阶段检查
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 需要卡组有「破晓」怪兽，且场上有空位，且玩家能特殊召唤这种怪兽
		return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id,s.dawn_set,TYPE_EFFECT,0,0,3,RACE_WARRIOR,ATTRIBUTE_LIGHT)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

-- 效果处理
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 then return end
	if Duel.SendtoGrave(g,REASON_EFFECT)==0 then return end

	-- 检查特殊召唤条件
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,id,s.dawn_set,TYPE_EFFECT,0,0,3,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end

	-- 将自身变为怪兽并特殊召唤
	c:AddMonsterAttribute(TYPE_EFFECT, ATTRIBUTE_LIGHT, RACE_WARRIOR, 3, 0, 0)
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)~=0 then
		-- 特殊召唤成功，无需额外操作
	end
end