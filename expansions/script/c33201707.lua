--圣兽战队超集结！
local cm, m, o = GetID()
function cm.initial_effect(c)
	--① effect
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m, 0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)

	--② effect
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m, 1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(cm.excost)
	e2:SetTarget(cm.extg)
	e2:SetOperation(cm.exop)
	c:RegisterEffect(e2)
end

--① effect functions
function cm.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk == 0 then
		return Duel.IsExistingTarget(nil, tp, LOCATION_MZONE, 0, 1, nil)
			and Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.eqfilter), tp, LOCATION_DECK, 0, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
	local g = Duel.SelectTarget(tp, nil, tp, LOCATION_MZONE, 0, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_EQUIP, g, 1, tp, LOCATION_DECK)
end

function cm.eqfilter(c)
	return c:IsSetCard(0x6327) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end

function cm.operation(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end

	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
	local ec = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(cm.eqfilter), tp, LOCATION_DECK, 0, 1, 1, nil):GetFirst()
	if not ec then return end

	if not Duel.Equip(tp, ec, tc) then return end

	-- Equip limit
	local e1 = Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetLabelObject(tc)
	e1:SetValue(cm.eqlimit)
	e1:SetReset(RESET_EVENT + RESETS_STANDARD)
	ec:RegisterEffect(e1)

	-- Make it treated as Equip Card
	local e2 = Effect.CreateEffect(tc)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_TYPE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(TYPE_SPELL + TYPE_EQUIP)
	e2:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TOFIELD)
	ec:RegisterEffect(e2)
end

function cm.eqlimit(e, c)
	return c == e:GetLabelObject()
end

--② effect functions
function cm.excost(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c, POS_FACEUP, REASON_COST)
end

function cm.extg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(cm.filter, tp, LOCATION_MZONE, 0, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_ATKCHANGE, nil, 1, tp, LOCATION_MZONE)
end

function cm.exop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
	local tc = Duel.SelectMatchingCard(tp, cm.filter, tp, LOCATION_MZONE, 0, 1, 1, nil):GetFirst()
	if tc and tc:IsFaceup() then
		local e1 = Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
		tc:RegisterEffect(e1)
	end
end

function cm.filter(c)
	return c:IsSetCard(0x6327) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
