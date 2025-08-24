-- 灵龙星-睚眦
local s, id = GetID()

function s.initial_effect(c)
	-- Special Summon limit
	c:SetSPSummonOnce(id)
	
	-- Special Summon procedure (取对象效果)
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- Control change effect (不取对象效果)
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.ctcost)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
end

function s.filter(c)
	return (c:IsSetCard(0xb5) or c:IsSetCard(0x9e)) and (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED))
end

-- ①效果的目标处理
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and s.filter(chkc) end
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false)
			and Duel.IsExistingTarget(s.filter, tp, LOCATION_GRAVE+LOCATION_REMOVED, 0, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	local g = Duel.SelectTarget(tp, s.filter, tp, LOCATION_GRAVE+LOCATION_REMOVED, 0, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, 0, 0)
end

-- ①效果的操作处理
function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) ~= 0 then
			Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
		end
	end
end

-- ②效果的成本处理
function s.costfilter(c)
	return (c:IsSetCard(0xb5) or c:IsSetCard(0x9e)) and c:IsAbleToRemove() and not c:IsCode(id) and Duel.IsExistingMatchingCard(s.lwfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function s.lwfilter(c,atk)
	return c:IsAttackBelow(atk) and c:IsFaceup() and c:IsControlerCanBeChanged()
end
function s.ctcost(e, tp, eg, ep, ev, re, r, rp, chk)
	e:SetLabel(100)
	return true
end

-- ②效果的目标处理（不取对象，仅检查条件）
function s.cttg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c98920928.costfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c98920928.costfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetAttack())
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end

-- ②效果的操作处理
function s.ctop(e, tp, eg, ep, ev, re, r, rp)
	local atk = e:GetLabel()
	if not atk then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONTROL)
	local g = Duel.SelectMatchingCard(tp, function(c) return c:IsControlerCanBeChanged() and c:GetAttack() <= atk end, tp, 0, LOCATION_MZONE, 1, 1, nil)
	if #g > 0 then
		Duel.HintSelection(g)
		Duel.GetControl(g:GetFirst(), tp, PHASE_END, 1)
	end
end

