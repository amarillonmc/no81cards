-- 破晓信使 小枝
local s, id = GetID()
s.dawn_set = 0x696d  -- 破晓字段代码

function s.initial_effect(c)
	-- 效果①：丢弃自身，从手卡·墓地把1只「破晓」怪兽特殊召唤至对方场上
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost1)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)

	-- 效果②：墓地存在时，以对方场上1只「破晓」怪兽为对象，自身特殊召唤并获得控制权
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
end

-- 效果①代价：丢弃自身
function s.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

-- 效果①目标筛选：可特殊召唤到对方场上的破晓怪兽（除自身外）
function s.spfilter1(c,e,tp)
	return c:IsSetCard(s.dawn_set) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and not c:IsCode(id)
end

function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 判断对方场上是否有怪兽
	local opp_has_monster = Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0) > 0
	-- 判断对方场上是否有空位
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp) <= 0 then return false end

	-- 根据情况决定可选区域
	local loc = LOCATION_HAND + LOCATION_GRAVE
	if not opp_has_monster then
		loc = loc + LOCATION_DECK
	end

	-- 记录可用区域到效果标签
	e:SetLabel(loc)

	if chk==0 then
		return Duel.IsExistingMatchingCard(s.spfilter1, tp, loc, 0, 1, nil, e, tp)
	end

	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, loc)
end

function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local loc = e:GetLabel()
   -- if Duel.GetLocationCount(1-tp, LOCATION_MZONE, tp) <= 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.spfilter1, tp, loc, 0, 1, 1, nil, e, tp)
	if #g > 0 then
		Duel.SpecialSummon(g, 0, tp, 1-tp, false, false, POS_FACEUP)
	end
end

-- 效果②目标：对方场上1只「破晓」怪兽
function s.spfilter2(c,e,tp)
	return c:IsSetCard(s.dawn_set) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsControler(1-tp)
end

function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.spfilter2(chkc,e,tp) end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(s.spfilter2, tp, 0, LOCATION_MZONE, 1, nil, e, tp)
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	local g = Duel.SelectTarget(tp, s.spfilter2, tp, 0, LOCATION_MZONE, 1, 1, nil, e, tp)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_CONTROL, g, 1, 0, 0)
end

function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) == 0 then return end
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.GetControl(tc, tp)
	end
	-- 离场时除外
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT + RESETS_REDIRECT)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1, true)
end