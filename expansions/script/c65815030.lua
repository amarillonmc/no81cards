-- 任务：T7-王牌
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65814999,65814998)
	-- ①：把对方场上的卡任意数量送去墓地，从自己的手卡·卡组·墓地把送去墓地的卡数量的「主宰之怒」怪兽在对方场上特殊召唤。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)

	-- ②：把墓地的这张卡除外才能发动。选自己手卡·墓地·除外的1只「起义呐喊」怪兽特殊召唤。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

-- 字段号定义
local SETCODE_ZZZN = 0x9a31 -- 主宰之怒
local SETCODE_QYNH = 0x6a31 -- 起义呐喊

---------------- ①效果：送墓并特召 ----------------
function s.spfilter_zzzn(c,e,tp)
	-- 可以特殊召唤到对方场上的主宰之怒
	return c:IsSetCard(SETCODE_ZZZN) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end

function s.tgfilter(c)
	return c:IsAbleToGrave()
end

-- 动态计算组判定：检测当前这组将要送墓的卡(sg)，送墓后对方场上是否有足够的格子容纳 #sg 只怪兽
function s.check_group(sg,e,tp,mg)
	local max_sp_count = Duel.GetMatchingGroupCount(s.spfilter_zzzn,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	-- 裁定：选的数量不能超过你能特召的最大数量
	if #sg > max_sp_count then return false end
	
	-- 模拟这些卡如果离开场上，对方能多出几个怪兽格子
	local ft = Duel.GetMZoneCount(1-tp, sg, tp)
	return ft >= #sg
end

function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local tg = Duel.GetMatchingGroup(s.tgfilter,tp,0,LOCATION_ONFIELD,nil)
		local max_sp = Duel.GetMatchingGroupCount(s.spfilter_zzzn,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		return #tg > 0 and max_sp > 0 and tg:CheckSubGroup(s.check_group,1,max_sp,e,tp,tg)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg = Duel.GetMatchingGroup(s.tgfilter,tp,0,LOCATION_ONFIELD,nil)
	local spg = Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter_zzzn),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local max_sp = #spg

	if #tg == 0 or max_sp == 0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	-- 让玩家选择数量（满足裁定条件的合法数量组合）
	local sg = tg:SelectSubGroup(tp,s.check_group,false,1,max_sp,e,tp,tg)

	if sg and #sg > 0 then
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		local ct = sg:FilterCount(Card.IsLocation, nil, LOCATION_GRAVE)
		if ct > 0 then
			local spg_after = Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter_zzzn),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
			local ft_after = Duel.GetLocationCount(1-tp,LOCATION_MZONE)

			if #spg_after >= ct and ft_after >= ct then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sp_targets = spg_after:Select(tp, ct, ct, nil)
				if #sp_targets == ct then
					for tc in aux.Next(sp_targets) do
						Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP)
					end
					Duel.SpecialSummonComplete()
				end
			end
		end
	end
end

---------------- ②效果：墓地除外特召 ----------------
function s.spfilter_qynh(c,e,tp)
	return c:IsSetCard(SETCODE_QYNH) and c:IsFaceupEx()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter_qynh,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter_qynh),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end