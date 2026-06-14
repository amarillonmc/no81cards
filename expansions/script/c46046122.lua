--永恒流星之爆炎 凯撒·双剑
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c, s.matfilter, 1, 1)
	c:SetSPSummonOnce(id)

	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)

	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(46046112)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(s.immval)
	c:RegisterEffect(e2)

	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 0))
	e3:SetCategory(CATEGORY_TODECK + CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end

function s.matfilter(c)
	return c:IsCode(46046112) and c:GetAttack() >= 4000
end

function s.immval(e, re)
	if not re:IsActiveType(TYPE_MONSTER) then return false end
	local rc = re:GetHandler()
	if not rc then return false end
	local atk = rc:GetAttack()
	if atk < 0 then atk = 0 end
	return atk < e:GetHandler():GetAttack()
end

function s.tdfilter(c)
	return c:IsSetCard(0x6f8) and c:IsAbleToDeck()
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE + LOCATION_REMOVED) and chkc:IsControler(tp) and s.tdfilter(chkc) end
	if chk == 0 then
		local g = Duel.GetMatchingGroup(s.tdfilter, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, nil)
		return #g > 0
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g = Duel.SelectTarget(tp, s.tdfilter, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, 3, nil)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, g, #g, 0, 0)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
	if not g then return end
	local tg = g:Filter(Card.IsRelateToEffect, nil, e)
	if tg:GetCount() == 0 then return end
	local deckg = tg:Filter(Card.IsLocation, nil, LOCATION_GRAVE + LOCATION_REMOVED)
	if deckg:GetCount() > 0 then
		Duel.SendtoDeck(deckg, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end

	local chain = Duel.GetCurrentChain()
	if chain == 0 then return end
	for i = chain, 1, -1 do
		local ce = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT)
		if ce and ce:GetOwnerPlayer() ~= tp then
			if Duel.NegateEffect(i) then
				local rc = ce:GetHandler()
				if rc and rc:IsOnField() and rc:IsRelateToEffect(ce) then
					Duel.Destroy(rc, REASON_EFFECT)
				end
			end
		end
	end
end