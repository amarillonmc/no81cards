-- 卡片密码请将 s, id 替换为你的实际卡号，例如 c12345678
local s, id = GetID()

function s.initial_effect(c)
	-- 必须正规出场
	c:EnableReviveLimit()
	
	-- 手动注册动态融合条件
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(s.fuscon)
	e0:SetOperation(s.fusop)
	c:RegisterEffect(e0)

	-- ①：融合召唤的场合发动。除外的卡全部回到卡组，攻击力上升。
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK + CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.efcon)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)

	-- ②：可以直接攻击
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)

	-- 全局“除外次数”记录器（使用 FlagEffect 记录事件次数，极其稳定）
	if not s.global_check then
		s.global_check = true
		local ge1 = Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1, 0)
	end
end

---------------------------
-- 【除外次数统计机制】
---------------------------
function s.checkop(e, tp, eg, ep, ev, re, r, rp)
	-- 按“事件次数”计算：只要这波除外的卡里有玩家 0 的卡，玩家 0 的专属 Flag 就 +1
	if eg:IsExists(Card.IsPreviousControler, 1, nil, 0) then
		Duel.RegisterFlagEffect(0, id, RESET_PHASE + PHASE_END, 0, 1)
	end
	-- 只要有玩家 1 的卡，玩家 1 的专属 Flag 就 +1
	if eg:IsExists(Card.IsPreviousControler, 1, nil, 1) then
		Duel.RegisterFlagEffect(1, id, RESET_PHASE + PHASE_END, 0, 1)
	end
end

-- 动态计算所需的最少素材数
function s.get_min_req(tp)
	local count = Duel.GetFlagEffect(tp, id)
	return math.max(1, 11 - count)
end

---------------------------
-- 【纯手写底层融合逻辑：彻底解决报错】
---------------------------
-- 动态融合条件
function s.fuscon(e, g, gc, chkf)
	if g == nil then return true end
	local tp = e:GetHandlerPlayer()
	local minc = s.get_min_req(tp)
	-- 过滤出能用的素材（必须在场上）
	local mg = g:Filter(Card.IsOnField, nil)
	
	-- 如果有预选卡 (gc)
	if gc then
		if not gc:IsOnField() then return false end
		return mg:GetCount() >= minc - 1
	end
	
	-- 系统 chkf 规则：如果要求必须包含某个玩家场上的卡才能解放格子
	if chkf ~= PLAYER_NONE and not mg:IsExists(Card.IsControler, 1, nil, chkf) then
		return false
	end
	
	-- 核心判断：场上怪兽数量是否大于等于当前所需的最小数量
	return mg:GetCount() >= minc
end

-- 动态融合操作
function s.fusop(e, tp, eg, ep, ev, re, r, rp, gc, chkf)
	local minc = s.get_min_req(tp)
	local mg = eg:Filter(Card.IsOnField, nil)
	local sg = Group.CreateGroup()
	
	if gc then
		sg:AddCard(gc)
		mg:RemoveCard(gc)
		local req = math.max(0, minc - 1)
		if req > 0 or mg:GetCount() > 0 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FMATERIAL)
			-- 玩家最少需要再选 req 只，最多再选 10 只
			local mat = mg:Select(tp, req, 10, nil)
			sg:Merge(mat)
		end
	else
		-- 处理 chkf 强制选卡
		if chkf ~= PLAYER_NONE then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FMATERIAL)
			local cg = mg:FilterSelect(tp, Card.IsControler, 1, 1, nil, chkf)
			sg:Merge(cg)
			mg:Sub(cg)
			minc = minc - 1
		end
		local req = math.max(0, minc)
		local max_sel = 11 - sg:GetCount()
		if req > 0 or (max_sel > 0 and mg:GetCount() > 0) then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FMATERIAL)
			-- 动态选择区间：最少 req 只，最多 max_sel 只
			local mat = mg:Select(tp, req, max_sel, nil)
			sg:Merge(mat)
		end
	end
	-- 确认融合素材
	Duel.SetFusionMaterial(sg)
end

---------------------------
-- 【效果 ①：回收与攻击力上升】
---------------------------
function s.efcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

function s.eftg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetChainLimit(aux.FALSE)
	local g = Duel.GetFieldGroup(tp, LOCATION_REMOVED, 0)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, g, #g, 0, 0)
end

function s.efop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local g = Duel.GetFieldGroup(tp, LOCATION_REMOVED, 0)
	if #g > 0 then
		Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
		local og = Duel.GetOperatedGroup()
		local ct = og:FilterCount(Card.IsLocation, nil, LOCATION_DECK + LOCATION_EXTRA)
		
		if ct > 0 and c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct * 1100)
			e1:SetReset(RESET_EVENT + RESETS_STANDARD_DISABLE)
			c:RegisterEffect(e1)
		end
	end
end