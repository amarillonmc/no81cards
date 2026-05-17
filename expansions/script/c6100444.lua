--爱丽丝的茶会物语
local s,id,o=GetID()

local CODE_ALICE = 6100440

function s.initial_effect(c)
	-- 记述卡名
	aux.AddCodeList(c,CODE_ALICE)
	
	-- 场地魔法发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	-- ①：墓地永续魔陷改名
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	e1:SetCondition(s.namecon)
	e1:SetTarget(s.nametg)
	e1:SetValue(id) -- 当作「爱丽丝的茶会物语」
	c:RegisterEffect(e1)
	
	-- ②：手卡/墓地效果发动后诱发
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- === 效果①：改名光环 ===
function s.alicefilter(c)
	return c:IsOriginalCodeRule(CODE_ALICE) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end

function s.namecon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.alicefilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end

function s.nametg(e,c)
	-- 同样使用原本类型检查，避免卡片属性被覆盖后导致判定失败
	local otype = c:GetOriginalType()
	return (otype & TYPE_CONTINUOUS) ~= 0 and (otype & (TYPE_SPELL+TYPE_TRAP)) ~= 0
end

-- === 效果②：效果处理逻辑 ===

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	-- 手卡·墓地的卡的效果发动的场合
	return (re:GetActivateLocation() & (LOCATION_HAND+LOCATION_GRAVE)) ~= 0
end

function s.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 预测结算时的有效回合玩家
	local turn_p = Duel.GetTurnPlayer()
	if Duel.GetFlagEffect(tp, 6100446) > 0 then
		turn_p = 1 - turn_p
	end
	
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,turn_p,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE)
end

function s.spfilter(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	-- 【核心机制：获取真实视角的“回合玩家”】
	local turn_p = Duel.GetTurnPlayer()
	if Duel.GetFlagEffect(tp, 6100446) > 0 then
		turn_p = 1 - turn_p
		Duel.ResetFlagEffect(tp, 6100446)
		Duel.ResetFlagEffect(1-tp, 6100446)
		Duel.Hint(HINT_CARD, 0, 6100446)
	end
	
	local opp = 1 - turn_p
	
	-- 1. 回合玩家选自身墓地1张魔法·陷阱卡加入手卡
	Duel.Hint(HINT_SELECTMSG, turn_p, HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(turn_p, aux.NecroValleyFilter(s.thfilter), turn_p, LOCATION_GRAVE, 0, 1, 1, nil)
	
	if #g>0 and Duel.SendtoHand(g, turn_p, REASON_EFFECT)>0 then
		Duel.ConfirmCards(opp, g)
		
		-- 2. 那之后，以那玩家来看的对方可以特召怪兽
		-- 【修复关键】：手动通过数学映射精准计算特召格子，彻底屏蔽API控制者歧义
		local final_zone = 0
		local mg = Duel.GetMatchingGroup(Card.IsType, opp, LOCATION_MZONE, LOCATION_MZONE, nil, TYPE_MONSTER)
		
		for tc in aux.Next(mg) do
			local seq = tc:GetSequence()
			local c_p = tc:GetControler()
			local opp_seq = -1
			
			-- 计算对于 opp 玩家来说的同一列格子序列
			if seq <= 4 then
				-- 主怪兽区，如果是对面控制的怪兽，格子序列= 4-seq
				opp_seq = (c_p == opp) and seq or (4 - seq)
			elseif seq == 5 then
				-- 左侧额外区 (对立面的1号主怪兽区)
				opp_seq = (c_p == opp) and 1 or 3
			elseif seq == 6 then
				-- 右侧额外区 (对立面的3号主怪兽区)
				opp_seq = (c_p == opp) and 3 or 1
			end
			
			-- 验证 opp 玩家在这个格子(opp_seq)上是否还能放置怪兽(未被占用)
			if opp_seq >= 0 and Duel.CheckLocation(opp, LOCATION_MZONE, opp_seq) then
				final_zone = bit.bor(final_zone, 1 << opp_seq)
			end
		end
		
		local spg = Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter), opp, LOCATION_HAND+LOCATION_GRAVE, 0, nil, e, opp, final_zone)
		
		if final_zone ~= 0 and #spg > 0 and Duel.SelectYesNo(opp, aux.Stringid(id, 2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG, opp, HINTMSG_SPSUMMON)
			local tc = spg:Select(opp, 1, 1, nil):GetFirst()
			if tc then
				if Duel.SpecialSummonStep(tc, 0, opp, opp, false, false, POS_FACEUP, final_zone) then
					-- 效果无效
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
				end
				Duel.SpecialSummonComplete()
			end
		end
	end
end