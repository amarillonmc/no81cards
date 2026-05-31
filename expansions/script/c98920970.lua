--暗战士 混沌战士
-- 混沌战士 (Custom Card)
local s, id = GetID()
function s.initial_effect(c)
	-- ①：自己的场上或墓地有「混沌战士」仪式怪兽存在的场合，以自己的墓地·除外状态的1只7星以下的战士族怪兽为对象才能发动。那只怪兽和手卡的这张卡特殊召唤。
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	-- ②：这张卡战斗破坏对方怪兽时才能发动。从卡组把光属性和暗属性的怪兽各最多1只送去墓地。
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(s.bdcon)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end

-- 声明关联的系列：混沌战士 (0x10cf)

-- ① 效果的条件：场上或墓地存在「混沌战士」仪式怪兽
function s.cfilter(c)
	return c:IsSetCard(0x10cf) and c:IsType(TYPE_RITUAL) and (c:IsFaceup() or not c:IsOnField())
end
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(s.cfilter, tp, LOCATION_MZONE + LOCATION_GRAVE, 0, 1, nil)
end

-- ① 效果的目标过滤：墓地·除外的7星以下战士族
function s.tgfilter(c, e, tp)
	return c:IsRace(RACE_WARRIOR) and c:IsLevelBelow(7)
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk, chg)
	if chk==0 then
		-- 必须有至少2个怪兽空位（因为要特召2只），且不受“虚无空间”或“白灵龙”等限制单次特召数量的效果影响
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 1
			and not Duel.IsPlayerAffectedByEffect(tp, 59822133) -- 59822133 是白灵龙/限制单次特召数量的卡
			and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false)
			and Duel.IsExistingTarget(s.tgfilter, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, nil, e, tp)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectTarget(tp, s.tgfilter, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, 1, nil, e, tp)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 2, tp, LOCATION_HAND + LOCATION_GRAVE + LOCATION_REMOVED)
end

-- ① 效果的执行：同时特召手卡的这张卡和目标怪兽
function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	-- 必须保证手卡的这张卡和目标怪兽依然存在且符合特召条件
	if not c:IsRelateToEffect(e) or not tc or not tc:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp, LOCATION_MZONE) < 2 or Duel.IsPlayerAffectedByEffect(tp, 59822133) then return end
	
	local g = Group.FromCards(c, tc)
	Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
end

-- ② 效果的条件：战斗破坏对方怪兽
function s.bdcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local bc = c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsControler(1-tp)
end

-- ② 效果的目标过滤：卡组的光属性/暗属性怪兽
function s.tgfilter2(c)
	return (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK)) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end

-- 核心筛选逻辑：所选怪兽的属性种类数量 必须等于 所选怪兽的总数量
-- 这样就自动限制了“不能选择相同属性的两只怪兽”，即只能选：1光、1暗 或 1光1暗
function s.gcheck(sg, e, tp, mg)
	return sg:GetClassCount(Card.GetAttribute) == #sg
end

function s.tgtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.tgfilter2, tp, LOCATION_DECK, 0, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, tp, LOCATION_DECK)
end

function s.tgop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(s.tgfilter2, tp, LOCATION_DECK, 0, nil)
	if #g == 0 then return end
	
	-- 让玩家直接在卡组中挑选 1~2 张卡
	-- aux.SelectUnselectGroup 会在玩家试图点选第2只相同属性怪兽时使其变灰无法选中
	local sg=g:SelectSubGroup(tp,s.gcheck,false,1,2)
	if #sg > 0 then
		Duel.SendtoGrave(sg, REASON_EFFECT)
	end
end