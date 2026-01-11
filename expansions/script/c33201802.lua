--巡猎蜂群 秩序工蜂
local s, id = GetID()
local SET_PATROL_BEE = 0xc328

function s.initial_effect(c)
	-- ①：翻卡组放置并回卡组
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	-- ②：特召自身和卡组怪兽
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1, id + 10000)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

-- ===========================
-- 效果①：翻卡放置
-- ===========================

function s.thcost(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then return not c:IsPublic() end
	Duel.ConfirmCards(1-tp, c)
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) >= 5
			and Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
	end
	-- 由于不确定翻到什么，这里主要检查卡组数量和魔陷格子
end

-- 过滤可以放置的卡：「巡猎蜂」且是 (永续魔/陷 或 怪兽)
function s.placefilter(c)
	return c:IsSetCard(SET_PATROL_BEE) 
		and (c:IsType(TYPE_CONTINUOUS) or c:IsType(TYPE_MONSTER)) 
		and not c:IsForbidden()
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	
	-- 再次确认卡组数量
	if Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) < 5 then return end
	
	Duel.ConfirmDecktop(tp, 5)
	local g = Duel.GetDecktopGroup(tp, 5)
	
	local placed_card = nil
	
	-- 如果有符合条件的卡，且魔陷区有空位，让玩家选择是否放置
	if #g > 0 and Duel.GetLocationCount(tp, LOCATION_SZONE) > 0 
		and g:IsExists(s.placefilter, 1, nil) 
		and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
		
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
		local sg = g:FilterSelect(tp, s.placefilter, 1, 1, nil)
		local tc = sg:GetFirst()
		
		if tc then
			-- 执行放置逻辑
			local move_success = false
			if tc:IsType(TYPE_MONSTER) then
				-- 怪兽当作永续魔法放置
				if Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true) then
					local e1 = Effect.CreateEffect(c)
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
					e1:SetValue(TYPE_SPELL + TYPE_CONTINUOUS)
					tc:RegisterEffect(e1)
					move_success = true
				end
			else
				-- 永续魔陷直接放置
				if Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true) then
					move_success = true
				end
			end
			
			if move_success then
				placed_card = tc
				g:RemoveCard(tc) -- 从即将回卡组的组中移除
			end
		end
	end
	
	-- 将手卡的这张卡 和 剩下的翻开的卡 一起回到卡组
	-- 必须保证这张卡还在手卡（因为是RelateToEffect）
	if c:IsRelateToEffect(e) then
		g:AddCard(c)
	end
	
	if #g > 0 then
		Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
	end
end

-- ===========================
-- 效果②：特召
-- ===========================

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	-- 判定条件：装备中 或 当作永续魔法卡使用
	-- 1. GetEquipTarget() 判断是否装备
	-- 2. IsType(TYPE_CONTINUOUS) and IsType(TYPE_SPELL) 判断是否是永续魔法状态
	return c:GetEquipTarget() or (c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS))
end

-- 过滤卡组里的其他「巡猎蜂」
function s.spfilter2(c, e, tp)
	return c:IsSetCard(SET_PATROL_BEE) 
		and not c:IsCode(id) -- 排除同名卡（秩序工蜂）
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then 
		return Duel.GetLocationCount(tp, LOCATION_MZONE) >= 2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
			and Duel.IsExistingMatchingCard(s.spfilter2, tp, LOCATION_DECK, 0, 1, nil, e, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 2, tp, LOCATION_DECK)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()

	-- 特召处理
	if Duel.GetLocationCount(tp, LOCATION_MZONE) < 2 or Duel.IsPlayerAffectedByEffect(tp,59822133)then return end
	if not c:IsRelateToEffect(e) then return end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.spfilter2, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
	if #g > 0 then
		g:AddCard(c)
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
	-- 限制：自己不是超量怪兽不能从额外卡组特殊召唤
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1, 0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e1, tp)
end

function s.splimit(e, c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_XYZ)
end