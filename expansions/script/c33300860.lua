local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	-- 特殊召唤限制：融合召唤或解放召唤
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	-- 融合召唤
	aux.AddFusionProcMix(c, true, true,s.matfilter1, s.matfilter2)
	-- 解放
	aux.AddContactFusionProcedure(c, aux.FilterBoolFunction(Card.IsReleasable, REASON_SPSUMMON),LOCATION_MZONE,0,Duel.Release,REASON_SPSUMMON + REASON_MATERIAL)
	-- 效果①
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id) 
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	-- 效果②
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_ATKCHANGE + CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)  
	e2:SetCondition(s.atkcon)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end
-- 特殊召唤限制函数
function s.splimit(e, se, sp, st)
	return bit.band(st, SUMMON_TYPE_FUSION) == SUMMON_TYPE_FUSION or se:GetHandler() == e:GetHandler()
end
-- 融合素材过滤器
function s.matfilter1(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_FIEND) and c:IsSetCard(0x569)
end
function s.matfilter2(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
-- 效果①：特殊召唤成功条件
function s.thcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) or e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
-- 效果①：回收目标
function s.thfilter(c, e, tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_FIEND) 
		and not c:IsCode(id) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e, 0, tp, false, false))
end
-- 效果①：目标选择
function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_GRAVE)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_GRAVE)
end
-- 效果①：操作处理
function s.thop(e, tp, eg, ep, ev, re, r, rp)
	if not Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp) then return end
	local tc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc then
		if aux.NecroValleyNegateCheck(tc) then return end
		if not aux.NecroValleyFilter()(tc) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
-- 效果②：发动条件（对方发动怪兽效果）
function s.atkcon(e, tp, eg, ep, ev, re, r, rp)
	return rp == 1 - tp and re:IsActiveType(TYPE_MONSTER)
end
-- 效果②：目标选择
function s.atktg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_NEGATE, eg, 1, 0, 0)
end
-- 效果②：操作处理
function s.atkop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	-- 恶魔族以外怪兽攻击力下降600
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(s.downfilter))
	e1:SetValue(-600)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	-- 检查发动效果的怪兽是否仍在场上
	local rc = re:GetHandler()
	if Duel.IsExistingMatchingCard(s.exfilter,tp, LOCATION_FZONE, 0, 1, nil) and rc:IsRelateToEffect(re) and rc:GetAttack()~=rc:GetBaseAttack() and rc:GetAttack()==0 then
		Duel.Destroy(rc,REASON_EFFECT)
		Duel.Damage(1-tp,600,REASON_EFFECT)
	end
	if not rc:IsRelateToEffect(re) or not rc:IsLocation(LOCATION_MZONE) then
		Duel.NegateActivation(ev)  -- 无效效果发动
	end
end
function s.exfilter(c)
	return c:IsCode(33300850) and c:IsFaceup() and not c:IsDisabled()
end
function s.downfilter(c)
	return not c:IsRace(RACE_FIEND)
end