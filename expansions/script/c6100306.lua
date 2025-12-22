--轮回于破碎世界的环状起源
local s,id,o=GetID()
function s.initial_effect(c)
	--①：二选一效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	--手卡发动许可
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end

-- === 手卡发动条件 ===
function s.hfilter(c)
	return c:IsSetCard(0x616) and c:IsType(TYPE_MONSTER) and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK))
end

function s.handcon(e)
	-- 自己的场上·墓地的「破碎世界」光·暗属性怪兽的种类是4种以上
	local g=Duel.GetMatchingGroup(s.hfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=4
end

-- === 效果处理 ===

-- 过滤器定义
-- A组：光属性怪兽 + 魔法
function s.filterA_m(c) return c:IsSetCard(0x616) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() end
function s.filterA_s(c) return c:IsSetCard(0x616) and c:IsType(TYPE_SPELL) and c:IsAbleToDeck() end
function s.filterA_ex(c,e,tp) return c:IsSetCard(0x616) and c:IsType(TYPE_SYNCHRO) and c:IsLevel(9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end

-- B组：暗属性怪兽 + 陷阱
function s.filterB_m(c) return c:IsSetCard(0x616) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() end
function s.filterB_t(c) return c:IsSetCard(0x616) and c:IsType(TYPE_TRAP) and c:IsAbleToDeck() end
function s.filterB_ex(c,e,tp) return c:IsSetCard(0x616) and c:IsType(TYPE_XYZ) and c:IsRank(9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 检查A选项
	local b1 = Duel.IsExistingMatchingCard(s.filterA_m,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingMatchingCard(s.filterA_s,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filterA_ex,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	
	-- 检查B选项
	local b2 = Duel.IsExistingMatchingCard(s.filterB_m,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingMatchingCard(s.filterB_t,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filterB_ex,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	
	if chk==0 then return b1 or b2 end
	
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2)) -- 选项1：同调，选项2：超量
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	end
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	
	if op==0 then
		-- ● A: 光属性怪兽 + 魔法 -> 9星同调 -> 自身变永续
		local g1=Duel.GetMatchingGroup(s.filterA_m,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local g2=Duel.GetMatchingGroup(s.filterA_s,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		if #g1==0 or #g2==0 then return end
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		
		if Duel.SendtoDeck(sg1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(tp,s.filterA_ex,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
			if sc and Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
				sc:CompleteProcedure()
				-- 自身当作永续陷阱卡使用在自己的魔法与陷阱区域表侧表示放置
				if c:IsRelateToEffect(e) then
					c:CancelToGrave()
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					c:RegisterEffect(e1)
				end
			end
		end
		
	else
		-- ● B: 暗属性怪兽 + 陷阱 -> 9阶超量 -> 自身变素材
		local g1=Duel.GetMatchingGroup(s.filterB_m,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local g2=Duel.GetMatchingGroup(s.filterB_t,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		if #g1==0 or #g2==0 then return end
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		
		if Duel.SendtoDeck(sg1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(tp,s.filterB_ex,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
			if sc and Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
				sc:CompleteProcedure()
				-- 自身重叠作为超量素材
				if c:IsRelateToEffect(e) then
					c:CancelToGrave()
					Duel.Overlay(sc,c)
				end
			end
		end
	end
end