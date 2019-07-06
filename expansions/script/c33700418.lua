--Visitor from the Sea
--AlphaKretin
--For Nemoma
local s = c33700418
local id = 33700418
function s.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c, nil, 1, 1, aux.NonTuner(Card.IsType, TYPE_TOKEN), 1, 99)
	--mat check
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.matcheck)
	c:RegisterEffect(e0)
	--draw
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_DRAW + CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(s.drcon)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--token
	local e2 = Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOKEN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O + EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.tktg)
	e2:SetOperation(s.tkop)
	c:RegisterEffect(e2)
end
function s.matcheck(e, c)
	e:SetLabel(c:GetMaterial():FilterCount(Card.IsType, nil, TYPE_TOKEN))
end
function s.drcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.drtg(e, tp, eg, ep, ev, re, r, rp, chk)
	local hg = Duel.GetFieldGroup(tp, LOCATION_HAND, 0)
	local ct = e:GetLabelObject():GetLabel()
	if chk == 0 then
		return #hg > 0 and ct > 0 and Duel.IsPlayerCanDraw(tp, ct)
	end
	Duel.SetOperationInfo(0, CATEGORY_HANDES, hg, #hg, 0, 0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, ct)
end
function s.drop(e, tp, eg, ep, ev, re, r, rp)
	local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
	local hg = Duel.GetFieldGroup(p, LOCATION_HAND, 0)
	if Duel.SendtoGrave(hg, REASON_EFFECT + REASON_DISCARD) > 0 then
		Duel.BreakEffect()
		Duel.Draw(p, d, REASON_EFFECT)
	end
end
function s.tkfilter(c, tp)
	return c:IsType(TYPE_TOKEN) and
		Duel.IsPlayerCanSpecialSummonMonster(
			tp,
			c:GetCode(),
			c:GetSetCard(),
			c:GetType(),
			c:GetAttack(),
			c:GetDefense(),
			c:GetLevel(),
			c:GetRace(),
			c:GetAttribute()
		)
end
function s.tktg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and s.tkfilter(chkc)
	end
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
			Duel.IsExistingTarget(s.tkfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil, tp)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
	local g = Duel.SelectTarget(tp, s.tkfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil, tp)
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
				tc:GetCode(),
				tc:GetSetCard(),
				tc:GetType(),
				tc:GetAttack(),
				tc:GetDefense(),
				tc:GetLevel(),
				tc:GetRace(),
				tc:GetAttribute()
			)
	 then
		local token = Duel.CreateToken(tp, tc:GetCode())
		Duel.SpecialSummon(token, 0, tp, tp, false, false, POS_FACEUP)
	end
end
