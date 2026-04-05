local cm, m, o = GetID()

function cm.initial_effect(c)
	-- 永续效果：「森久保」怪兽在场上只能有1只表侧表示存在
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x61d),LOCATION_MZONE)

	-- 效果1：反转时盖放墓地的「森久保」卡
	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m, 0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_GRAVE_ACTION)
	e4:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_FLIP)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
	e4:SetTarget(cm.flip_target)
	e4:SetOperation(cm.flip_operation)
	c:RegisterEffect(e4)

	-- 效果2：对方召唤·特殊召唤时变成里侧并选择效果发动
	local e5 = Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m, 1))
	e5:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCondition(cm.summon_condition)
	e5:SetCost(cm.summon_cost)
	e5:SetTarget(cm.summon_target)
	e5:SetOperation(cm.summon_operation)
	c:RegisterEffect(e5)
	local e6 = e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end

function cm.filter(c,e,tp)
	return c:IsSetCard(0x61d) and ((Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsSSetable() and not c:IsType(TYPE_MONSTER)) or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and c:IsType(TYPE_MONSTER)))
end
function cm.filter1(c,e,tp)
	return c:IsSetCard(0x61d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and c:IsType(TYPE_MONSTER)
end
function cm.filter2(c,e,tp)
	return c:IsSetCard(0x61d) and c:IsSSetable() and not c:IsType(TYPE_MONSTER)
end
-- 效果1目标选择
function cm.flip_target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chk == 0 then return Duel.IsExistingMatchingCard(cm.filter, tp, LOCATION_GRAVE, 0, 1, nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

-- 效果1操作
function cm.flip_operation(e, tp, eg, ep, ev, re, r, rp)
	local mft,sft=Duel.GetLocationCount(tp,LOCATION_MZONE),Duel.GetLocationCount(tp,LOCATION_SZONE)
	if mft<=0 and sft<=0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:SelectSubGroup(tp,cm.gcheck,false,1,2,tp)
		local mg=sg:Filter(Card.IsType,nil,TYPE_MONSTER)
		if #mg>0 then
			sg:Sub(mg)
			Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,mg)
		end
		Duel.SSet(tp,sg)
	end
end
function cm.setfilter(c,e,p)
	return c:IsSetCard(0x61d) and (c:IsSSetable() or Duel.GetMZoneCount(p)>0 and c:IsCanBeSpecialSummoned(e,0,p,false,false,POS_FACEDOWN_DEFENSE))
end
function cm.gcheck(g,tp)
	local mt=Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or Duel.GetMZoneCount(tp)
	local st=Duel.GetLocationCount(tp,LOCATION_SZONE)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=mt and g:FilterCount(Card.IsType,nil,TYPE_FIELD)<=1 and g:FilterCount(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)-g:FilterCount(Card.IsType,nil,TYPE_FIELD)<=st
end

function cm.cfilter(c,sp)
	return c:IsSummonPlayer(sp)
end
-- 效果2条件：对方召唤·特殊召唤
function cm.summon_condition(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp)
end

-- 效果2代价：变成里侧守备表示
function cm.summon_cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsCanTurnSet() end
	Duel.ChangePosition(e:GetHandler(), POS_FACEDOWN_DEFENSE)
end

-- 效果2目标选择
function cm.summon_target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	e:SetCategory(CATEGORY_POSITION)
	Duel.SetOperationInfo(0, CATEGORY_POSITION, nil, 1, 0, 0)
end

function cm.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
-- 效果2操作
function cm.summon_operation(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_OPTION)
	local g1 = Duel.GetMatchingGroup(cm.posfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
	local g2 = Duel.GetMatchingGroup(cm.flagfilter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, nil)
	local op = 0
	if g2:GetCount()>0 then
		op = 1
	end
	if g1:GetCount()>0 and g2:GetCount()>0 then
		op = Duel.SelectOption(tp, aux.Stringid(m, 2), aux.Stringid(m, 3))
	end
	if op == 0 then
		-- 选择1只表侧表示怪兽变成里侧守备表示
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_POSCHANGE)
		local g = Duel.SelectMatchingCard(tp, Card.IsFaceup, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
		if g:GetCount() > 0 then
			Duel.ChangePosition(g, POS_FACEDOWN_DEFENSE)
		end
	else
		-- 选择1张表侧表示的永续魔法·永续陷阱·场地魔法变成里侧表示
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_POSCHANGE)
		local g = Duel.SelectMatchingCard(tp, cm.flagfilter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, nil)
		if g:GetCount() > 0 then
			Duel.ChangePosition(g, POS_FACEDOWN)
		end
	end
end

-- 永续魔法·永续陷阱·场地魔法过滤
function cm.flagfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_SPELL + TYPE_TRAP) and (c:IsType(TYPE_CONTINUOUS) or c:IsType(TYPE_FIELD))) and c:GetOriginalType()&TYPE_MONSTER>0 and c:IsCanTurnSet()
end
