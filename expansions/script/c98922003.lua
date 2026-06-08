-- 设定卡片ID（请将此处的 12345678 替换为您实际的卡片数据库ID）
local s, id = GetID()

function s.initial_effect(c)
	-- ①：1回合1次，可以发动。从卡组把1只「恶魂邪苦止」或「黄泉青蛙」送去墓地。
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)

	-- ②：把这张卡解放才能发动。从卡组特殊召唤「青蛙」怪兽。
	-- 这个效果的发动后，直到回合结束时自己不是水族·水属性怪兽不能从额外卡组特殊召唤。
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	-- 2效果与3效果共用1个同名回合1次的计数器
	e2:SetCountLimit(1, id)
	e2:SetCost(s.spcost1)
	e2:SetTarget(s.sptg1)
	e2:SetOperation(s.spop1)
	c:RegisterEffect(e2)

	-- ③：水属性怪兽从自己的墓地特殊召唤的场合，把墓地的这张卡除外才能发动。从额外卡组把1只「三死青蛙」特殊召唤。
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	-- 3效果与2效果共用1个同名回合1次的计数器
	e3:SetCountLimit(1, id)
	e3:SetCondition(s.spcon2)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)
end


-- ==================== ①的效果 ====================

function s.tgfilter(c)
	return (c:IsCode(10456559) or c:IsCode(12538374)) and c:IsAbleToGrave()
end

function s.tgtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.tgfilter, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, tp, LOCATION_DECK)
end

function s.tgop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local g = Duel.SelectMatchingCard(tp, s.tgfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SendtoGrave(g, REASON_EFFECT)
	end
end

-- ==================== ②的效果 ====================

-- 检索墓地中符合条件的水族·水属性·1星且非同名怪兽
function s.gyfilter(c, code)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA) and c:IsLevel(1) and not c:IsCode(code)
end

-- 检索卡组中可以特召的「青蛙」怪兽
function s.spfilter1(c, e, tp)
	return c:IsSetCard(0x12) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.spcost1(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsReleasable() end
	-- 在解放前记录这张卡的密码，防止其在墓地中因其他卡的效果改变卡名
	e:SetLabel(e:GetHandler():GetCode())
	Duel.Release(e:GetHandler(), REASON_COST)
end

function s.sptg1(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		-- 此时cost尚未支付（卡还在场上），使用GetMZoneCount计算解放这张卡后腾出的格子
		local ccode = e:GetHandler():GetCode()
		local gy_count = Duel.GetMatchingGroupCount(s.gyfilter, tp, LOCATION_GRAVE, 0, nil, ccode)
		local ft = Duel.GetMZoneCount(tp, e:GetHandler())
		return gy_count > 0 and ft > 0
			and Duel.IsExistingMatchingCard(s.spfilter1, tp, LOCATION_DECK, 0, 1, nil, e, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end

function s.spop1(e, tp, eg, ep, ev, re, r, rp)
	-- 额外卡组限制：不是 水族·水属性 无法特召
	local e1 = Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(id, 3)) -- 提示：自己不能从额外卡组把水族·水属性以外的怪兽特殊召唤
	e1:SetTargetRange(1, 0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e1, tp)

	-- 计算能召唤的最大数量
	local code = e:GetLabel()
	local gy_count = Duel.GetMatchingGroupCount(s.gyfilter, tp, LOCATION_GRAVE, 0, nil, code)
	local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
	if ft <= 0 or gy_count <= 0 then return end
	
	local max_spawn = math.min(gy_count, ft)
	local g = Duel.GetMatchingGroup(s.spfilter1, tp, LOCATION_DECK, 0, nil, e, tp)
	if #g == 0 then return end
	
	-- 筛选同名卡最多1张的组合
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local sg = g:SelectSubGroup(tp, s.dncon, false, 1, max_spawn)
	if sg and #sg > 0 then
		Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
	end
end

-- 保证选出的怪兽互不重名
function s.dncon(g)
	return g:GetClassCount(Card.GetCode) == #g
end

-- 自定义自锁限制条件
function s.splimit(e, c, sump, sumtype, sumpos, targetp, se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsAttribute(ATTRIBUTE_WATER)
end

-- ==================== ③的效果 ====================

-- 检测是否有水属性怪兽从自己的墓地特殊召唤
function s.cfilter(c, tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:GetPreviousLocation() == LOCATION_GRAVE and c:GetPreviousControler() == tp
end

function s.spcon2(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(s.cfilter, 1, nil, tp)
end

-- 检索额外卡组中的「三死青蛙」
function s.spfilter2(c, e, tp)
	return c:IsCode(9910360) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.sptg2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetLocationCountFromEx(tp) > 0
			and Duel.IsExistingMatchingCard(s.spfilter2, tp, LOCATION_EXTRA, 0, 1, nil, e, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

function s.spop2(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCountFromEx(tp) <= 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.spfilter2, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp)
	if #g > 0 then
		Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
	end
end