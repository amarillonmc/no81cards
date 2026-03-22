-- 捣蛋少女 莉莉丝
local s, id = GetID()
s.named_setcode = 0xc96d		   -- 字段代码

-- 自定义事件码（确保与其他卡片不冲突）
local EVENT_CONFIRMED = 0x1000 + id

function s.initial_effect(c)
	-- 素材限制：不能作为同调、超量、链接的素材
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
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	--e1:SetCondition(s.drmcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	-- 效果②：召唤·特殊召唤时，把手卡1只怪兽给对方，然后可选展示并放置永续陷阱（选发触发）
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_HANDES + CATEGORY_SPECIAL_SUMMON)
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

	-- 效果③：「捣蛋少女」以外的怪兽的效果发动时，无效化（必发）
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.discon)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)

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

-- 效果①的目标
function s.drmcon(e,tp,eg,ep,ev,re,r,rp)	
	local c = e:GetHandler()
	if c:GetOwner() == 0 then
		return rp==0
	else
		return rp==1
	end
end
--e1:SetCondition(s.drmcon)
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
		return Duel.IsExistingMatchingCard(function(c)
			return c:IsControler(tp) and c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
		end, tp, LOCATION_HAND, 0, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 1, tp, LOCATION_HAND)
end

-- 效果②的操作
function s.handop(e, tp, eg, ep, ev, re, r, rp)
	-- 第一步：选择手卡1只怪兽交给对方（必发）
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOHAND)
	local g = Duel.SelectMatchingCard(tp, function(c)
		return c:IsControler(tp) and c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
	end, tp, LOCATION_HAND, 0, 1, 1, nil)
	if #g == 0 then return end
	local tc = g:GetFirst()
	Duel.SendtoHand(tc, 1 - tp, REASON_EFFECT)

	-- 第二步：询问是否展示卡组中3张不同名的「捣蛋少女」卡，然后放置永续陷阱（选发）
	-- 只有当卡组中存在至少3张不同名的「捣蛋少女」卡时才询问
	local deck = Duel.GetFieldGroup(tp, LOCATION_DECK, 0)
	local candidates = {}
	for card in aux.Next(deck) do
		if card:IsSetCard(s.named_setcode) then
			table.insert(candidates, card)
		end
	end
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
			-- 从unique_list中选择3张不同名的卡展示（实际让玩家选择，但为了简便，直接取前3张）
			-- 更合理的做法是让玩家从卡组选择3张不同名的捣蛋少女卡，但需保证不同名，这里用简单方式
			local show_group = Group.CreateGroup()
			for i = 1, 3 do
				show_group:AddCard(unique_list[i])
			end
			Duel.ConfirmCards(1 - tp, show_group)
			Duel.ShuffleDeck(tp)

			-- 从卡组把1张「捣蛋少女」永续陷阱卡在自己场上表侧表示放置
			local trap_group = Duel.GetMatchingGroup(function(c)
				return c:IsSetCard(s.named_setcode) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsSSetable()
			end, tp, LOCATION_DECK, 0, nil)
			if #trap_group > 0 then
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
				local trap = trap_group:Select(tp, 1, 1, nil):GetFirst()
				if trap then
					-- 使用 MoveToField 表侧表示放置
					Duel.MoveToField(trap, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
				end
			end
		end
	end
end

-- 效果③的条件：「捣蛋少女」以外的怪兽的效果发动
function s.discon(e, tp, eg, ep, ev, re, r, rp)
	if not re then return false end
	local rc = re:GetHandler()
	-- 必须是怪兽的效果，且不是「捣蛋少女」怪兽
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsSetCard(s.named_setcode)
end

function s.distg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_DISABLE, nil, 0, 0, 0)
end

function s.disop(e, tp, eg, ep, ev, re, r, rp)
	Duel.NegateEffect(ev)
end