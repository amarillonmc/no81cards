-- 掘墓的指名者（改）
local s, id = GetID()
if not id then id = 89244938 end

function s.initial_effect(c)
	-- ①：效果激活（同名卡1回合只能发动1张）
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- ==================== 发动准备（扫描对方墓地并限选宣告） ====================
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 检查对方墓地是否至少存在1张卡
	if chk==0 then return Duel.IsExistingMatchingCard(nil, tp, 0, LOCATION_GRAVE, 1, nil) end
	
	-- 抓取对方墓地所有卡片，提取出不重复的卡名密码
	local g=Duel.GetMatchingGroup(nil, tp, 0, LOCATION_GRAVE, nil)
	local ag=Group.CreateGroup()
	local codes={}
	for c in aux.Next(g) do
		local code=c:GetCode()
		if not ag:IsExists(Card.IsCode, 1, nil, code) then
			ag:AddCard(c)
			table.insert(codes, code)
		end
	end
	table.sort(codes)
	
	-- 核心：构建卡名宣告限选数组 (Opcode 逻辑过滤器)
	local afilter={codes[1], OPCODE_ISCODE}
	if #codes>1 then
		for i=2, #codes do
			table.insert(afilter, codes[i])
			table.insert(afilter, OPCODE_ISCODE)
			table.insert(afilter, OPCODE_OR)
		end
	end
	
	-- 弹出限选宣告窗口
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp, table.unpack(afilter))
	
	-- 储存数据
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0, CATEGORY_ANNOUNCE, nil, 0, tp, 0)
end

-- ==================== 效果处理（检索 vs 变动抽1） ====================
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0, CHAININFO_TARGET_PARAM)
	
	-- 检测双方卡组中是否均存在能够加入手卡的该同名卡
	local g1=Duel.GetMatchingGroup(function(c) return c:IsCode(ac) and c:IsAbleToHand() end, tp, LOCATION_DECK, 0, nil)
	local g2=Duel.GetMatchingGroup(function(c) return c:IsCode(ac) and c:IsAbleToHand() end, tp, 0, LOCATION_DECK, nil)
	
	-- 条件分支 A：双方卡组里都有这卡 -> 双方各自检索1张
	if #g1>0 and #g2>0 then
		-- 自己选卡
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local sg1=g1:Select(tp, 1, 1, nil)
		-- 对方选卡
		Duel.Hint(HINT_SELECTMSG, 1-tp, HINTMSG_ATOHAND)
		local sg2=g2:Select(1-tp, 1, 1, nil)
		
		-- 执行加入手卡与展示
		if #sg1>0 and Duel.SendtoHand(sg1, nil, REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp, sg1)
		end
		if #sg2>0 and Duel.SendtoHand(sg2, nil, REASON_EFFECT)>0 then
			Duel.ConfirmCards(tp, sg2)
		end
		
	-- 条件分支 B：任意一方不能加入手卡 -> 效果直接转变为【自己抽1张】
	else
		Duel.Draw(tp, 2, REASON_EFFECT) 
	end
end
