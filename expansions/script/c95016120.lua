-- 魔法卡：暗月仪式
local s, id = GetID()

function s.initial_effect(c)
	-- 卡名一回合只能发动一张
	c:SetUniqueOnField(1,0,id)
	
	-- 效果①：返回暗月怪兽并特殊召唤仪式怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 定义暗月字段
s.darkmoon_setcode = 0x696c

-- 目标设定
function s.tdfilter(c)
	return c:IsSetCard(s.darkmoon_setcode) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(s.darkmoon_setcode) and c:IsType(TYPE_RITUAL) and c:IsLevel(6)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,nil)
		return g:CheckWithSumEqual(Card.GetLevel,6,1,99)
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end

-- 效果处理
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 从场上和除外区选择暗月怪兽返回卡组
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,nil)
	if #g==0 then return end
	
	-- 检查是否有等级合计为6的组合
	if not g:CheckWithSumEqual(Card.GetLevel,6,1,99) then
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(id,1))
		return
	end
	
	-- 让玩家选择等级合计为6的暗月怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectWithSumEqual(tp,Card.GetLevel,6,1,99)
	if #sg==0 then return end
	
	-- 将选择的怪兽返回卡组洗切
	if Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		if og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)>0 then
			Duel.BreakEffect()
			
			-- 从卡组或手卡特殊召唤6星暗月仪式怪兽
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local spg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
			if #spg>0 then
				local tc=spg:GetFirst()
				if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
					tc:CompleteProcedure()
				end
			end
		end
	end
end