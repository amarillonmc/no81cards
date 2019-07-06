--Ego-Doxxing
--AlphaKretin
--For Nemoma
local card = c33700404
local code = 33700404
function card.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(card.cost)
	e1:SetTarget(card.target)
	e1:SetOperation(card.activate)
	c:RegisterEffect(e1)
	if not AshBlossomTable then AshBlossomTable = {} end
	table.insert(AshBlossomTable, e1)
end

function card.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(aux.NOT(Card.IsPublic), tp, LOCATION_HAND, 0, 1, nil) end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():GetOwner() == tp then
		e:GetHandler():CancelToGrave()
	end
	local tc = Duel.SelectMatchingCard(tp, aux.NOT(Card.IsPublic), tp, LOCATION_HAND, 0, 1, 1, nil):GetFirst()
	Duel.ConfirmCards(1 - tp, tc)
	e:SetLabelObject(tc)
end

function card.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetFieldGroupCount(1 - tp, LOCATION_DECK, 0) > 0 end
end

function card.activate(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
    if not e:GetLabelObject() then return end
	if Duel.IsChainDisablable(0) and Duel.SelectYesNo(1 - tp, aux.Stringid(code, 0)) then
		Duel.Recover(tp, 4000, REASON_EFFECT)
		Duel.NegateEffect(0)
		return
	end
	local dg = Duel.GetFieldGroup(tp, 0, LOCATION_DECK)
	Duel.ConfirmCards(tp, dg)
	local mg = dg:Filter(Card.IsCode, nil, e:GetLabelObject():GetCode())
	local ct = mg:GetCount()
	if ct == 0 then
		Duel.Damage(tp, 2000, REASON_EFFECT)
	elseif ct == 1 then
		Duel.SendtoGrave(mg, REASON_EFFECT)
	elseif ct == 2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local rc = mg:Select(tp, 1, 1, nil):GetFirst()
		if rc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and rc:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEDOWN_DEFENSE) then
			Duel.SpecialSummon(rc, 0, tp, tp, false, false, POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1 - tp, rc)
		elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp, LOCATION_SZONE) > 0) and rc:IsSSetable() then
			Duel.SSet(tp, rc)
			Duel.ConfirmCards(1 - tp, rc)
		end
	elseif ct >= 3 then
		Duel.Draw(tp, 2, REASON_EFFECT)
	end
	if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
	if c:IsCanTurnSet() and e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetLocationCount(1 - tp, LOCATION_SZONE, tp) > 0 then
		Duel.BreakEffect()
		Duel.MoveToField(c, tp, 1 - tp, LOCATION_SZONE, POS_FACEDOWN, true)
		Duel.RaiseEvent(c, EVENT_SSET, e, REASON_EFFECT, tp, tp, 0)
	else
		c:CancelToGrave(false)
	end
end