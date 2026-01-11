--巡猎蜂群 蓄储蜜蜂
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
	-- 检索效果
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 0))
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION) -- 启动效果
	e2:SetRange(LOCATION_SZONE)	  -- 在魔陷区发动（无论是装备状态还是永续魔法状态）
	e2:SetCountLimit(1, id+10000)		  -- 卡名硬限制
	e2:SetCondition(s.thcon1)
	e2:SetTarget(s.thtg1)
	e2:SetOperation(s.thop1)
	c:RegisterEffect(e2)
end


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
function s.thcon1(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	return c:GetEquipTarget() -- 是否有装备对象（即装备状态）
		or (c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)) -- 是否是永续魔法类型
end

-- 过滤：巡猎蜂卡 + 可加入手卡
function s.thfilter(c)
	return c:IsSetCard(SET_PATROL_BEE) and c:IsAbleToHand()
end

function s.thtg1(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.thop1(e, tp, eg, ep, ev, re, r, rp)
	-- 检索逻辑
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
	end
end