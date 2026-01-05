--哈迪斯的冥导神殿
local s, id = GetID()
s.named_with_InfernalLord=1
function s.InfernalLord(c)
	local m = _G["c" .. c:GetCode()]
	return m and m.named_with_InfernalLord
end
function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id, EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH + CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1, id + 100)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)

	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE, 0)
	e3:SetTarget(s.indestg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end

function s.filter(c)
	return c:IsCode(40020547) and c:IsAbleToHand()
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g = Duel.GetMatchingGroup(s.filter, tp, LOCATION_DECK, 0, nil)
	if #g > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local sg = g:Select(tp, 1, 1, nil)
		Duel.SendtoHand(sg, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, sg)
	end
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) >= 3 end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, 0, LOCATION_DECK)
	Duel.SetOperationInfo(0, CATEGORY_DECKDES, nil, 0, tp, 2)
end

function s.thfilter(c)
	return s.InfernalLord(c) and not c:IsCode(id) and c:IsAbleToHand()
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) < 3 then return end

	Duel.ConfirmDecktop(tp, 3)
	local g = Duel.GetDecktopGroup(tp, 3)
	
	if #g > 0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(s.thfilter, 1, nil) and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
			local sg = g:FilterSelect(tp, s.thfilter, 1, 1, nil)
			Duel.SendtoHand(sg, nil, REASON_EFFECT)
			Duel.ConfirmCards(1 - tp, sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end

		Duel.SendtoGrave(g, REASON_EFFECT + REASON_REVEAL)
	end
end


function s.indestg(e, c)
	return s.InfernalLord(c) and bit.band(c:GetType(), TYPE_RITUAL + TYPE_MONSTER) == TYPE_RITUAL + TYPE_MONSTER
end
