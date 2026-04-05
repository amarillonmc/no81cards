-- 逆轨的沉狱-麦克斯韦尔
local s,id,o=GetID()
function s.initial_effect(c)
	-- 必须作为超量怪兽的通用设定
	c:EnableReviveLimit()
	
	-- 自己对「逆轨的沉狱-麦克斯韦尔」1回合只能有1次特殊召唤
	c:SetSPSummonOnce(id)

	-- 自定义超量召唤手续 (突破同星级限制 + 允许使用除外区)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165) -- "超量召唤"
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.xyzcon)
	e1:SetTarget(s.xyztg)
	e1:SetOperation(s.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	
	-- ①：这张卡超量召唤的场合，对方从以下效果选择1个发动
	-- (拦截超量召唤成功事件)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(s.chcon)
	e0:SetOperation(s.chop)
	c:RegisterEffect(e0)

	-- 对方强制选择并支付cost的伪诱发
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0)) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_EVENT_PLAYER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.efftg)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)
end

-- 验证怪兽能否作为这只怪兽的超量素材
function s.matfilter(c,tp,xyzc)
	if c:IsType(TYPE_TOKEN) then return false end
	if not c:IsHasLevel() then return false end
	if c:GetLevel() <= 0 then return false end
	-- 必须是自己的怪兽
	if not c:IsControler(tp) then return false end
	
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsFaceup() and c:IsCanBeXyzMaterial(xyzc)
	elseif c:IsLocation(LOCATION_REMOVED) then
		-- 【核心点】：被对方除外的自己怪兽（底层通过 ReasonPlayer 判定是最准的）
		-- 面向上要求表侧表示（里侧除外通常无法直接识别等级，除非文本特殊声明）
		return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetReasonPlayer()==1-tp and c:IsCanBeXyzMaterial(xyzc)
	end
	return false
end

-- 检查当前选出的一组素材是否合法（等级不同）
function s.CheckGroup(sg, tp, xyzc)
	if sg:GetCount() < 2 then return false end
	local lvs = {}
	for c in aux.Next(sg) do
		local lv = c:GetLevel()
		-- 如果这个等级已经存在，说明不是“等级不同”，返回不合法
		if lvs[lv] then return false end
		lvs[lv] = true
	end
	if not aux.MustMaterialCheck(sg, tp, EFFECT_MUST_BE_XMATERIAL) then return false end
	if Duel.GetLocationCountFromEx(tp, tp, sg, xyzc) <= 0 then return false end
	return true
end

-- 递归查找组合
function s.CheckRecursive(mg, sg, cards, idx, tp, xyzc, minc, maxc)
	if sg:GetCount() >= minc and sg:GetCount() <= maxc then
		if s.CheckGroup(sg, tp, xyzc) then return true end
	end
	if sg:GetCount() >= maxc then return false end
	if idx > #cards then return false end
	
	for i = idx, #cards do
		local c = cards[i]
		if not sg:IsContains(c) then
			sg:AddCard(c)
			if s.CheckRecursive(mg, sg, cards, i + 1, tp, xyzc, minc, maxc) then
				sg:RemoveCard(c)
				return true
			end
			sg:RemoveCard(c)
		end
	end
	return false
end

-- 超量条件
function s.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local minc = 2
	local maxc = 99
	if min then minc = math.max(minc, min) end
	if max then maxc = math.min(maxc, max) end
	
	local mg = Duel.GetMatchingGroup(s.matfilter, tp, LOCATION_MZONE+LOCATION_REMOVED, 0, nil, tp, c)
	if og then mg:Merge(og) end
	
	local cards = {}
	for tc in aux.Next(mg) do table.insert(cards, tc) end
	return s.CheckRecursive(mg, Group.CreateGroup(), cards, 1, tp, c, minc, maxc)
end

-- 超量素材选择
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local minc = 2
	local maxc = 99
	if min then minc = math.max(minc, min) end
	if max then maxc = math.min(maxc, max) end
	
	local mg = Duel.GetMatchingGroup(s.matfilter, tp, LOCATION_MZONE+LOCATION_REMOVED, 0, nil, tp, c)
	if og then mg:Merge(og) end
	
	local cards = {}
	for tc in aux.Next(mg) do table.insert(cards, tc) end
	
	local sg = Group.CreateGroup()
	local cancel = Duel.IsSummonCancelable()
	
	while true do
		local cancelable = (sg:GetCount() == 0 and cancel)
		local finishable = (sg:GetCount() >= minc and sg:GetCount() <= maxc) and s.CheckGroup(sg, tp, c)
		
		if sg:GetCount() >= maxc then
			if finishable then break end
			return false
		end
		
		local valid_additions = Group.CreateGroup()
		for i = 1, #cards do
			local tc = cards[i]
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
				if s.CheckRecursive(mg, sg, cards, 1, tp, c, minc, maxc) then
					valid_additions:AddCard(tc)
				end
				sg:RemoveCard(tc)
			end
		end
		
		if valid_additions:GetCount() == 0 then
			if finishable then break else return false end
		end
		
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
		local tc = Group.SelectUnselect(valid_additions, sg, tp, finishable, cancelable, 1, 1)
		if not tc then
			if finishable then break else return false end
		end
		if sg:IsContains(tc) then
			sg:RemoveCard(tc)
		else
			sg:AddCard(tc)
		end
	end
	
	if sg:GetCount() > 0 then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	end
	return false
end

-- 超量操作执行 (底层 Duel.Overlay 完美支持把除外区的卡变成素材，不用担心报错)
function s.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.Overlay(c,g)
	g:DeleteGroup()
end

-- =========================================================
-- 以下为对方强制作出选择与代价的处理逻辑
-- =========================================================

function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 给对方玩家发起邀请函！
	Duel.RaiseSingleEvent(c,EVENT_CUSTOM+id,re,r,1-tp,1-tp,0)
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c = e:GetHandler()
	local cp = 1-tp -- 这里的 tp 是发动者（游戏对手），cp 才是这张卡的控制者（即你说的“对方”）
	local mg = c:GetOverlayGroup()
	local mat_ct = mg:GetCount()
	
	-- ================= 发动条件判定 =================
	local cost1 = (mat_ct > 0) and (mg:FilterCount(Card.IsAbleToHandAsCost, nil) == mat_ct)
	local cond1_hand = Duel.GetFieldGroupCount(cp, LOCATION_HAND, 0) >= mat_ct
	local cond1_mzone = Duel.GetLocationCount(cp, LOCATION_MZONE) >= mat_ct
	local cond1_ss = Duel.IsPlayerCanSpecialSummon(cp) and not Duel.IsPlayerAffectedByEffect(cp,63060238)
	
	local b1 = cost1 and cond1_hand and cond1_mzone and cond1_ss
	
	local cost2 = c:IsAbleToGraveAsCost() and (mat_ct == 0 or mg:FilterCount(Card.IsAbleToGraveAsCost, nil) == mat_ct)
	local b2 = cost2 and Duel.IsPlayerCanDiscardDeck(cp, mat_ct + 1)
	
	if chk==0 then return true end

	-- ================= 效果选择与 Cost 支付 =================
	local op = 0
	if b1 and b2 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EFFECT)
		op = Duel.SelectOption(tp, aux.Stringid(id, 0), aux.Stringid(id, 1))
	elseif b1 then
		op = Duel.SelectOption(tp, aux.Stringid(id, 0))
	elseif b2 then
		op = Duel.SelectOption(tp, aux.Stringid(id, 1)) + 1
	else
		op = Duel.SelectOption(tp, aux.Stringid(id, 2)) + 2
	end
	
	if op == 0 then
		-- 选项目1：素材回手/额外，并设置对应的 Category 和 OperationInfo
		local ct = Duel.SendtoHand(mg, nil, REASON_COST)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		-- 注意：特召的是 cp 的手卡
		Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, ct, cp, LOCATION_HAND)
		e:SetLabel(op + (ct << 4))
	elseif op == 1 then
		-- 选项目2：连卡带素材一起送墓，设置 Category 和 OperationInfo
		local g = Group.FromCards(c)
		g:Merge(mg)
		local ct = Duel.SendtoGrave(g, REASON_COST)
		e:SetCategory(CATEGORY_DECKDES)
		-- 注意：堆的是 cp 的卡组
		Duel.SetOperationInfo(0, CATEGORY_DECKDES, nil, 0, cp, ct)
		e:SetLabel(op + (ct << 4))
	else
		e:SetCategory(0)
		e:SetLabel(-1)
	end
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local op_val = e:GetLabel()
	if op_val == -1 then return end
	local cp = 1-tp -- 这里的 tp 是发动者（游戏对手），cp 才是这张卡的控制者（即你说的“对方”）
	
	local op = op_val & 0xf
	local ct = op_val >> 4
	
	if op == 0 then
		-- 此时 tp 是对方。对方把那个数量（ct）的怪兽从对方的手卡特殊召唤
		if ct > 0 then
			local hg = Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned, cp, LOCATION_HAND, 0, nil, e, 0, cp, false, false)
			-- 如果空位不够或手卡不够，特召最高可能的数量（防止卡死）
			local max_sp = math.min(ct, Duel.GetLocationCount(cp, LOCATION_MZONE))
			if max_sp >= ct then
				Duel.Hint(HINT_SELECTMSG, cp, HINTMSG_SPSUMMON)
				local sg = hg:Select(cp, max_sp, max_sp, nil)
				Duel.SpecialSummon(sg, 0, cp, cp, false, false, POS_FACEUP)
			end
		end
	else
		-- 送tp（也就是对方）卡组顶的卡去墓地
		if ct > 0 then
			Duel.DiscardDeck(cp, ct, REASON_EFFECT)
		end
	end
end