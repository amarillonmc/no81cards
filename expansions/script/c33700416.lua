--Ikamusume, Friend from the Sea
--AlphaKretin
--For Nemoma
local s = c33700416
local id = 33700416
function s.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c, nil, 1, 1, aux.NonTuner(Card.IsType, TYPE_TOKEN), 1, 99)
	--summon token
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOKEN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.tktg)
	e1:SetOperation(s.tkop)
	c:RegisterEffect(e1)
	--no material
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE, 0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType, TYPE_TOKEN))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3 = e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e3)
	local e4 = e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e4)
	local e5 = e2:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e5)
	--attack directly
	local e6 = e2:Clone()
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e6)
end
function s.tkfilter(c, tp)
	return c:IsFaceup() and c:IsLevelAbove(0) and not c:IsType(TYPE_TOKEN) and
		Duel.IsPlayerCanSpecialSummonMonster(
			tp,
			id + 1,
			0,
			0x4011,
			c:GetAttack(),
			c:GetDefense(),
			c:GetLevel(),
			c:GetRace(),
			c:GetAttribute()
		)
end
function s.tktg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and s.tkfilter(chkc, tp)
	end
	if chk == 0 then
		return (Duel.GetLocationCount(tp, LOCATION_MZONE) + Duel.GetLocationCount(1 - tp, LOCATION_MZONE)) > 0 and
			Duel.IsExistingTarget(s.tkfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil, tp)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
	local g = Duel.SelectTarget(tp, s.tkfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil, tp)
	Duel.SetOperationInfo(0, CATEGORY_TOKEN, nil, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, 0)
end
function s.tkop(e, tp, eg, ep, ev, re, r, rp)
	local ct1 = Duel.GetLocationCount(tp, LOCATION_MZONE)
	local ct2 = Duel.GetLocationCount(1 - tp, LOCATION_MZONE)
	if ct1 + ct2 <= 0 then
		return
	end
	local tc = Duel.GetFirstTarget()
	if
		tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and
			Duel.IsPlayerCanSpecialSummonMonster(
				tp,
				id + 1,
				0,
				0x4011,
				tc:GetAttack(),
				tc:GetDefense(),
				tc:GetLevel(),
				tc:GetRace(),
				tc:GetAttribute()
			)
	 then
		local token = Duel.CreateToken(tp, id + 1)
		if ct2 > 0 and (not (ct1 > 0) or Duel.SelectYesNo(tp, aux.Stringid(61665245, 2))) then
			Duel.SpecialSummonStep(token, 0, tp, 1 - tp, false, false, POS_FACEUP)
		else
			Duel.SpecialSummonStep(token, 0, tp, tp, false, false, POS_FACEUP)
		end
		local e1 = Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(tc:GetAttack())
		e1:SetReset(RESET_EVENT + RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e2 = e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(tc:GetDefense())
		token:RegisterEffect(e2)
		local e3 = e1:Clone()
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(tc:GetLevel())
		token:RegisterEffect(e3)
		local e4 = e1:Clone()
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(tc:GetRace())
		token:RegisterEffect(e4)
		local e5 = e1:Clone()
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(tc:GetAttribute())
		token:RegisterEffect(e5)
		Duel.SpecialSummonComplete()
	end
end
