--Hyperactive Multitasker Ikamusume
--AlphaKretin
--For Nemoma
local s = c33700419
local id = 33700419
function s.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c, nil, 1, 1, aux.NonTuner(Card.IsType, TYPE_TOKEN), 1, 99)
	--gain atk
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCost(s.atkcost)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	--summon token
	local e2 = Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOKEN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.tktg)
	e2:SetOperation(s.tkop)
	c:RegisterEffect(e2)
end
function s.atkcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.CheckReleaseGroupCost(
			tp,
			aux.FilterBoolFunction(Card.IsType, TYPE_TOKEN),
			1,
			false,
			nil,
			nil
		)
	end
	local g =
		Duel.SelectReleaseGroupCost(
		tp,
		aux.FilterBoolFunction(Card.IsType, TYPE_TOKEN),
		1,
		1,
		false,
		nil,
		nil
	)
	local tc = g:GetFirst()
	local atk = tc:GetTextAttack()
	local def = tc:GetTextDefense()
	e:SetLabel(atk * 1000 + def)
	Duel.Release(g, REASON_COST)
end
function s.atkop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local lb = e:GetLabel()
	local atk = lb // 1000
	local def = lb % 1000
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD_DISABLE + RESET_PHASE + PHASE_END)
		c:RegisterEffect(e1)
		local e2 = e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(def)
		c:RegisterEffect(e2)
	end
end
function s.tkfilter(c, tp)
	return c:IsFaceup() and
		Duel.IsPlayerCanSpecialSummonMonster(
			tp,
			id + 1,
			0,
			0x4011,
			c:GetAttack(),
			c:GetDefense(),
			4,
			c:GetRace(),
			c:GetAttribute()
		)
end
function s.tktg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc, tp)
	end
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
			Duel.IsExistingTarget(s.tkfilter, tp, LOCATION_GRAVE, LOCATION_GRAVE, 1, nil, tp)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
	local g = Duel.SelectTarget(tp, s.tkfilter, tp, LOCATION_GRAVE, LOCATION_GRAVE, 1, 1, nil, tp)
	Duel.SetOperationInfo(0, CATEGORY_TOKEN, nil, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, 0)
end
function s.tkop(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then
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
				4,
				tc:GetRace(),
				tc:GetAttribute()
			)
	 then
		local token = Duel.CreateToken(tp, id + 1)
		Duel.SpecialSummonStep(token, 0, tp, tp, false, false, POS_FACEUP)
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
		e3:SetCode(EFFECT_CHANGE_RACE)
		e3:SetValue(tc:GetRace())
		token:RegisterEffect(e3)
		local e4 = e1:Clone()
		e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e4:SetValue(tc:GetAttribute())
		token:RegisterEffect(e4)
		Duel.SpecialSummonComplete()
	end
end
