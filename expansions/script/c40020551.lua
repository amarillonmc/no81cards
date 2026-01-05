--冥导鸟将 纳贝利达斯
local s, id = GetID()
s.named_with_InfernalLord=1
function s.InfernalLord(c)
	local m = _G["c" .. c:GetCode()]
	return m and m.named_with_InfernalLord
end
function s.initial_effect(c)

	aux.EnablePendulumAttribute(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOGRAVE + CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.pencon)
	e1:SetTarget(s.pentg)
	e1:SetOperation(s.penop)
	c:RegisterEffect(e1)
	local e1b = e1:Clone()
	e1b:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e1b)
	local e1c = e1:Clone()
	e1c:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e1c)


	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_HANDES + CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1, id + 100)
	e2:SetCondition(s.hades_cond)
	e2:SetTarget(s.drwtg)
	e2:SetOperation(s.drwop)
	c:RegisterEffect(e2)
	local e3 = e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)

	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id, 2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1, id + 200)
	e4:SetCondition(s.hades_cond)
	e4:SetTarget(s.pztg)
	e4:SetOperation(s.pzop)
	c:RegisterEffect(e4)
end

function s.hades_filter(c)
	return c:IsCode(40020547) and (c:IsFaceup() or c:IsLocation(LOCATION_PZONE))
end

function s.hades_cond(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(s.hades_filter, tp, LOCATION_ONFIELD + LOCATION_EXTRA + LOCATION_PZONE, 0, 1, nil)
end

function s.cfilter(c, tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_DISCARD)
end

function s.pencon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(s.cfilter, 1, nil, tp)
end

function s.tgtfilter(c)
	return s.InfernalLord(c) and not c:IsCode(id) and c:IsAbleToGrave()
end

function s.pentg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.tgtfilter, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, tp, LOCATION_DECK)
end

function s.penop(e, tp, eg, ep, ev, re, r, rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local g = Duel.SelectMatchingCard(tp, s.tgtfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SendtoGrave(g, REASON_EFFECT)
	end
end

function s.drwtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > 0 and Duel.IsPlayerCanDraw(tp, 2) end
	Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 1, tp, 1)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 2)
end

function s.drwop(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) == 0 then return end

	if Duel.DiscardHand(tp, nil, 1, 1, REASON_EFFECT + REASON_DISCARD) > 0 then
		Duel.Draw(tp, 2, REASON_EFFECT)
	end
end

function s.pztg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1) end
end

function s.pzop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and (Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)) then
		Duel.MoveToField(c, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
	end
end
