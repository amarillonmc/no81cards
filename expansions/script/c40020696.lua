--闪电·Z·抽卡
local s, id = GetID()

s.named_with_EmperorBeast = 1
function s.EmperorBeast(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_EmperorBeast
end

s.ZEUS_CODE = 40020683

function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_RELEASE + CATEGORY_DRAW + CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id, EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.excost)
	e2:SetTarget(s.extg)
	e2:SetOperation(s.exop)
	c:RegisterEffect(e2)
end

function s.relfilter(c)
	if not s.EmperorBeast(c) or not c:IsType(TYPE_MONSTER) then return false end
	if c:IsLocation(LOCATION_HAND) then
		return c:IsReleasable()
	elseif c:IsLocation(LOCATION_MZONE) then
		return c:IsFaceup() and c:IsReleasable()
	end
	return false
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.relfilter, tp, LOCATION_HAND + LOCATION_MZONE, 0, 1, nil)
			and Duel.IsPlayerCanDraw(tp, 2)
	end
	Duel.SetOperationInfo(0, CATEGORY_RELEASE, nil, 1, tp, LOCATION_HAND + LOCATION_MZONE)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 2)
end

function s.pzcheck(tp)
	return Duel.IsExistingMatchingCard(function(c) return c:IsCode(s.ZEUS_CODE) end, tp, LOCATION_PZONE, 0, 1, nil)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
	local g = Duel.SelectMatchingCard(tp, s.relfilter, tp, LOCATION_HAND + LOCATION_MZONE, 0, 1, 1, nil)
	if #g == 0 or Duel.Release(g, REASON_EFFECT) == 0 then return end
	
	if Duel.Draw(tp, 2, REASON_EFFECT) > 0 then
		if s.pzcheck(tp) 
		   and Duel.IsExistingMatchingCard(aux.TRUE, tp, 0, LOCATION_MZONE, 1, nil)
		   and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
			local dg = Duel.SelectMatchingCard(tp, aux.TRUE, tp, 0, LOCATION_MZONE, 1, 1, nil)
			if #dg > 0 then
				Duel.Destroy(dg, REASON_EFFECT)
			end
		end
	end
end

function s.excost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_COST)
end

function s.exfilter(c)
	return c:IsCode(s.ZEUS_CODE) and c:IsAbleToExtra()
end

function s.extg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.exfilter(chkc) end
	if chk == 0 then
		return Duel.IsExistingTarget(s.exfilter, tp, LOCATION_GRAVE, 0, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	local g = Duel.SelectTarget(tp, s.exfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_TOEXTRA, g, 1, 0, 0)
end

function s.exop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoExtraP(tc, nil, REASON_EFFECT)
	end
end
