--诞地魔物 火焰小鬼
local s,id,o=GetID()
function s.initial_effect(c)
	--pierce
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetCondition(s.atkcon3)
	e1:SetValue(s.atkval3)
	c:RegisterEffect(e1)
	-- 效果②
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id+10000)
	e3:SetCondition(s.reccon)
	e3:SetTarget(s.rectg)
	e3:SetOperation(s.recop)
	c:RegisterEffect(e3)
	-- 效果②
	local e4 = e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e4:SetCondition(s.reccon2)
	c:RegisterEffect(e4)
end
function s.atkcon3(e)
	local ph=Duel.GetCurrentPhase()
	local bc=e:GetHandler():GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
end
function s.atkval3(e,c)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsPosition(POS_ATTACK) then
		return 0
	else
		return e:GetHandler():GetAttack()*2
	end
end

function s.adcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and e:GetHandler():GetBattleTarget():IsPosition(POS_ATTACK)
end
function s.adtg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function s.atkval(e,c)
	return math.ceil(0)
end
function s.atcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and e:GetHandler():GetBattleTarget():IsPosition(POS_ATTACK)
end
function s.atkval2(e,c)
	return math.ceil(c:GetAttack()*2)
end

-- 效果②: 回收条件函数
function s.reccon(e, tp, eg, ep, ev, re, r, rp)
	return not Duel.IsExistingMatchingCard(s.fusfilter, tp, LOCATION_MZONE, 0, 1, nil)
end

function s.reccon2(e, tp, eg, ep, ev, re, r, rp)
	-- 场上有恶魔族融合怪兽
	return Duel.IsExistingMatchingCard(s.fusfilter, tp, LOCATION_MZONE, 0, 1, nil)
end

function s.fusfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsType(TYPE_FUSION)
end

-- 效果②: 目标选择函数
function s.rectg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	local c = e:GetHandler()
	if chk == 0 then
		return c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
			and Duel.IsExistingTarget(Card.IsFaceup, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	Duel.SelectTarget(tp, Card.IsFaceup, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

-- 效果②: 操作函数
function s.recop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then
		if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-600)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end