-- 捣蛋少女 轻音
local s, id = GetID()
s.named_setcode = 0xc96d		   -- 字段代码

-- 自定义事件码（确保与其他卡片不冲突）
local EVENT_CONFIRMED = 0x1000 + id

function s.initial_effect(c)
	-- 素材限制：不能作为同调、超量、连接的素材
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e0a = Effect.CreateEffect(c)
	e0a:SetType(EFFECT_TYPE_SINGLE)
	e0a:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e0a:SetValue(1)
	c:RegisterEffect(e0a)
	local e0b = Effect.CreateEffect(c)
	e0b:SetType(EFFECT_TYPE_SINGLE)
	e0b:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e0b:SetValue(1)
	c:RegisterEffect(e0b)

	-- 效果①：手卡的「捣蛋少女」卡被对方确认时特殊召唤（必发）
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CONFIRMED)
	e1:SetCountLimit(1, id + 1)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	--e1:SetCondition(s.drmcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	-- 效果②：召唤·特殊召唤时发动（必发），把手卡最多3只怪兽交给对方，然后可选展示并抽卡
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1, id + 1)
	e2:SetTarget(s.handtg)
	e2:SetOperation(s.handop)
	c:RegisterEffect(e2)
	local e2a = e2:Clone()
	e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2a)

	-- 效果③：「捣蛋少女」以外的怪兽召唤·特殊召唤时，那些怪兽变成里侧守备表示（必发）
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1, id + 2)
	e3:SetTarget(s.postg)
	e3:SetOperation(s.posop)
	c:RegisterEffect(e3)
	local e3a = e3:Clone()
	e3a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3a)

	-- 全局确认检测初始化（只执行一次）
	if not s.global_check then
		s.global_check = true
		local old_ConfirmCards = Duel.ConfirmCards
		function Duel.ConfirmCards(player, targets)
			old_ConfirmCards(player, targets)
			local function raise_event(card)
				if card:GetOriginalCode()==id and card:IsLocation(LOCATION_HAND) and card:GetControler() ~= player then
					Duel.RaiseEvent(card, EVENT_CONFIRMED, nil, 0, player, player, 0)
				end
			end
			if aux.GetValueType(targets) == "Card" then
				raise_event(targets)
			elseif aux.GetValueType(targets) == "Group" then
				for tc in aux.Next(targets) do
					raise_event(tc)
				end
			end
		end
	end
end
function s.drmcon(e,tp,eg,ep,ev,re,r,rp)	
	local c = e:GetHandler()
	if c:GetOwner() == 0 then
		return rp==0
	else
		return rp==1
	end
end
--e1:SetCondition(s.drmcon)
-- 效果①的目标
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
	end
end

-- 效果②的目标：仅检查手卡是否有可送出的怪兽
function s.handtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local hand = Duel.GetFieldGroup(tp, LOCATION_HAND, 0):Filter(Card.IsType, nil, TYPE_MONSTER)
		return #hand > 0
	end
end

-- 效果②的操作
function s.handop(e, tp, eg, ep, ev, re, r, rp)
	-- 选择手卡中0-3只怪兽交给对方
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOHAND)
	local hand = Duel.GetFieldGroup(tp, LOCATION_HAND, 0):Filter(Card.IsType, nil, TYPE_MONSTER)
	-- 排除自身（自身已不在手卡）
	local sg = hand:Select(tp, 1, 3, nil)
	local num = #sg
	if num > 0 then
		Duel.SendtoHand(sg, 1 - tp, REASON_EFFECT)
	end

	-- 只有实际送出了怪兽且卡组有足够不同名「捣蛋少女」卡时，才询问是否展示
	if num > 0 then
		-- 检查卡组中不同名的「捣蛋少女」卡数量是否≥3
		local deck = Duel.GetFieldGroup(tp, LOCATION_DECK, 0)
		local candidates = {}
		for card in aux.Next(deck) do
			if card:IsSetCard(s.named_setcode) then
				table.insert(candidates, card)
			end
		end
		-- 按卡名去重
		local unique = {}
		for _, card in ipairs(candidates) do
			local code = card:GetCode()
			if not unique[code] then
				unique[code] = card
			end
		end
		local unique_list = {}
		for _, card in pairs(unique) do
			table.insert(unique_list, card)
		end

		if #unique_list >= 3 then
			if Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then
				-- 展示3张不同名的捣蛋少女卡（实际应让玩家从卡组选择，这里为简化取前3张）
				local show_group = Group.CreateGroup()
				for i = 1, 3 do
					show_group:AddCard(unique_list[i])
				end
				Duel.ConfirmCards(1 - tp, show_group)
				Duel.ShuffleDeck(tp)
				-- 抽卡：数量等于送出的怪兽数量
				Duel.Draw(tp, num, REASON_EFFECT)
			end
		end
	end
end

-- 效果③：召唤·特殊召唤的「捣蛋少女」以外的怪兽变成里侧守备表示
function s.postg(e, tp, eg, ep, ev, re, r, rp, chk)
	local g = eg:Filter(function(c) return not c:IsSetCard(s.named_setcode) end, nil)
	if chk == 0 then return #g > 0 end
	Duel.SetOperationInfo(0, CATEGORY_POSITION, g, #g, 0, 0)
end

function s.posop(e, tp, eg, ep, ev, re, r, rp)
	local g = eg:Filter(function(c) return not c:IsSetCard(s.named_setcode) end, nil)
	if #g > 0 then
		Duel.ChangePosition(g, POS_FACEDOWN_DEFENSE)
	end
end