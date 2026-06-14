--闪电·Z·烈焰
local s, id = GetID()
s.named_with_EmperorBeast = 1
function s.EmperorBeast(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_EmperorBeast
end


s.ZEUS_CODE = 40020683


function s.initial_effect(c)
	aux.AddCodeList(c,40020683)
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_DESTROY + CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id, EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TODECK + CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.drcon)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsControler(1 - tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk == 0 then
		return Duel.IsExistingTarget(aux.TRUE, tp, 0, LOCATION_MZONE, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectTarget(tp, aux.TRUE, tp, 0, LOCATION_MZONE, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end


function s.zeusfilter(c)
	return c:IsCode(s.ZEUS_CODE) and c:IsAbleToExtra()
end

function s.stfilter(c)
	return c:IsType(TYPE_SPELL + TYPE_TRAP)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	

	if Duel.Destroy(tc, REASON_EFFECT) > 0 then

		local b1 = Duel.IsExistingMatchingCard(s.zeusfilter, tp, LOCATION_GRAVE, 0, 1, nil)
		local b2 = Duel.IsExistingMatchingCard(s.stfilter, tp, LOCATION_SZONE, LOCATION_SZONE, 1, nil)
		
		if b1 and b2 and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then

			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOEXTRA)
			local g1 = Duel.SelectMatchingCard(tp, s.zeusfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
			if #g1 > 0 then
				Duel.SendtoExtraP(g1, nil, REASON_EFFECT)
			end

			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
			local g2 = Duel.SelectMatchingCard(tp, s.stfilter, tp, LOCATION_SZONE, LOCATION_SZONE, 1, 1, nil)
			if #g2 > 0 then
				Duel.Destroy(g2, REASON_EFFECT)
			end
		end
	end
end


function s.ritfilter(c, tp)
	return c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_RITUAL) and s.EmperorBeast(c)
end

function s.drcon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(s.ritfilter, 1, nil, tp)
end

function s.drtg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
		return c:IsAbleToDeck()
	end
	Duel.SetOperationInfo(0, CATEGORY_TODECK, c, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function s.drop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) then

		if Duel.SendtoDeck(c, nil, SEQ_DECKBOTTOM, REASON_EFFECT) > 0 then

			Duel.Draw(tp, 1, REASON_EFFECT)
		end
	end
end