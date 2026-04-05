local cm, m, o = GetID()

function cm.initial_effect(c)
	-- 永续效果：「森久保」怪兽在场上只能有1只表侧表示存在
	--c:SetSPSummonOnce(21000622)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x61d),LOCATION_MZONE)

	-- 效果1：反转时失去LP并盖放「森久保」卡
	local e5 = Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m, 0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_LEAVE_GRAVE)
	e5:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_FLIP)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
	e5:SetTarget(cm.flip_target)
	e5:SetOperation(cm.flip_operation)
	e5:SetCountLimit(1, m)
	c:RegisterEffect(e5)

	-- 效果2：对方召唤·特殊召唤时变成里侧并恢复LP
	local e6 = Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m, 1))
	e6:SetCategory(CATEGORY_RECOVER + CATEGORY_POSITION)
	e6:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetCondition(cm.summon_condition)
	e6:SetCost(cm.summon_cost)
	e6:SetTarget(cm.summon_target)
	e6:SetOperation(cm.summon_operation)
	c:RegisterEffect(e6)
	local e7 = e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)

	-- 效果3：自己场上里侧「森久保」卡变成表侧时特殊召唤自身
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FLIP)
	e2:SetRange(LOCATION_HAND + LOCATION_GRAVE + LOCATION_REMOVED)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg2)
	e2:SetOperation(cm.spop2)
	e2:SetCountLimit(1, m+o)
	c:RegisterEffect(e2)
end

-- 效果1代价：失去800基本分
function cm.flip_cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLP(tp) >= 800 end
	Duel.SetLP(tp, Duel.GetLP(tp) - 800)
end

-- 效果1目标选择
function cm.flip_target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(cm.setfilter, tp, LOCATION_HAND, 0, 1, nil,e,tp) or
			Duel.IsExistingMatchingCard(cm.setfilter, tp, LOCATION_DECK, 0, 1, nil,e,tp) or
			Duel.IsExistingMatchingCard(cm.setfilter, tp, LOCATION_GRAVE, 0, 1, nil,e,tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON+CATEGORY_LEAVE_GRAVE, nil, 3, 0, LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end

-- 效果1操作
function cm.flip_operation(e, tp, eg, ep, ev, re, r, rp)
	Duel.SetLP(tp, Duel.GetLP(tp) - 800)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:SelectSubGroup(tp,cm.gcheck,false,1,3,tp)
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
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=mt and g:FilterCount(Card.IsType,nil,TYPE_FIELD)<=1 and g:FilterCount(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)-g:FilterCount(Card.IsType,nil,TYPE_FIELD)<=st and g:GetClassCount(Card.GetLocation)==g:GetCount()
end



-- 效果2条件：对方召唤·特殊召唤
function cm.summon_condition(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(cm.cfilter1,1,nil,1-tp)
end
function cm.cfilter1(c,sp)
	return c:IsSummonPlayer(sp)
end

-- 效果2代价：变成里侧守备表示
function cm.summon_cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsCanTurnSet() end
	Duel.ChangePosition(e:GetHandler(), POS_FACEDOWN_DEFENSE)
end

-- 效果2目标选择
function cm.summon_target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_RECOVER, nil, 0, tp, 1500)
end

-- 效果2操作
function cm.summon_operation(e, tp, eg, ep, ev, re, r, rp)
	Duel.Recover(tp, 1500, REASON_EFFECT)
end

function cm.cfilter(c,tp)
	return c:IsSetCard(0x61d) and c:IsControler(tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end

function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end