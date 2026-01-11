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

	-- 炸卡效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_ACTIVATE_CONDITION)
	e2:SetCountLimit(1)	   
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
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


-- 发动条件：这张卡装备中 或 已是当作永续魔法卡使用
function s.descon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	return c:GetEquipTarget() -- 装备状态
		or (c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)) -- 永续魔法状态
end

function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
	-- 必须对方场上有可以被破坏的卡
	if chk == 0 then return Duel.IsExistingMatchingCard(nil, tp, 0, LOCATION_ONFIELD, 1, nil) end
	
	local c = e:GetHandler()
	-- 设置操作信息：破坏对象包括自身和对方场上的卡
	local g = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_ONFIELD, nil)
	g:AddCard(c)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 2, 0, 0)
end

function s.desop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	
	-- 效果处理时，首先这张卡必须还在场上（且与效果相关）
	if not c:IsRelateToEffect(e) then return end

	-- 选对方场上1张卡
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectMatchingCard(tp, nil, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
	
	if #g > 0 then
		Duel.HintSelection(g)
		-- 将自身加入要破坏的组中
		g:AddCard(c)
		-- 同时破坏
		Duel.Destroy(g, REASON_EFFECT)
	end
end