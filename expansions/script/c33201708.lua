--圣兽战队-五圣帝王
local cm, m, o = GetID()
function cm.initial_effect(c)
	aux.AddFusionProcMix(c, false, false, 33201705, 33201704, 33201703, 33201702, 33201701)
	aux.AddContactFusionProcedure(c, Card.IsAbleToRemoveAsCost, LOCATION_ONFIELD + LOCATION_GRAVE + LOCATION_HAND, 0,
		Duel.Remove,
		POS_FACEUP, REASON_COST)
	-- Link/XYZ/Synchro attributes (assuming it's an extra deck monster, common settings)
	c:EnableReviveLimit()

	-- ① effect: Unaffected by opponent's card effects during the turn it's Special Summoned from Extra Deck
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.e1con)
	e1:SetOperation(cm.e1op)
	c:RegisterEffect(e1)

	-- ② effect: Send up to 3 cards on opponent's field to GY (1 turn restriction)
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m, 0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, m)
	-- e2:SetCost(cm.e2cost)
	e2:SetTarget(cm.e2tg)
	e2:SetOperation(cm.e2op)
	c:RegisterEffect(e2)

	-- ③ effect: Return to Extra Deck, Special Summon 3 banished "圣兽战队" monsters, then equip up to 2 banished ones (1 turn restriction)
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m, 1))
	e3:SetCategory(CATEGORY_TOEXTRA + CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1, m + 10000)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(cm.e3con)
	e3:SetTarget(cm.e3tg)
	e3:SetOperation(cm.e3op)
	c:RegisterEffect(e3)
end

-- ① effect functions
function cm.e1con(e)
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA)
end

function cm.e1op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(cm.efilter)
	e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
	c:RegisterEffect(e1)
end

function cm.efilter(e, te)
	return te:GetOwnerPlayer() ~= e:GetHandlerPlayer()
end

-- ② effect functions
function cm.e2cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, nil) end
	Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_COST + REASON_DISCARD)
end

function cm.e2tg(e, tp, eg, ep, ev, re, r, rp, chk)
	local g = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_ONFIELD, nil)
	if chk == 0 then return #g > 0 end
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, 1 - tp, LOCATION_ONFIELD)
end

function cm.e2op(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_ONFIELD, nil)
	if #g == 0 then return end
	local sg = g:FilterSelect(tp, aux.TRUE, 1, 3, nil)
	if sg then
		Duel.SendtoGrave(sg, REASON_EFFECT)
	end
end

-- ③ effect functions
function cm.e3con(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetTurnPlayer() == 1 - tp
end

function cm.filter(c)
	return c:IsSetCard(0x6327) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end

function cm.e3tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk == 0 then
		return e:GetHandler():IsAbleToExtra()
			and Duel.IsExistingTarget(cm.filter, tp, LOCATION_REMOVED, 0, 3, nil)
			and Duel.GetLocationCount(tp, LOCATION_MZONE) >= 2
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	local g = Duel.SelectTarget(tp, cm.filter, tp, LOCATION_REMOVED, 0, 3, 3, nil)
	Duel.SetOperationInfo(0, CATEGORY_TOEXTRA, e:GetHandler(), 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 3, 0, 0)
end

function cm.e3op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect, nil, e)
	if #tg == 3 and c:IsRelateToEffect(e) and Duel.SendtoDeck(c, nil, 2, REASON_EFFECT) ~= 0 then
		local sg = tg:Filter(aux.NecroValleyFilter(cm.filter), nil)
		if #sg > 0 then
			for tc in aux.Next(sg) do
				if Duel.SpecialSummonStep(tc, 0, tp, tp, false, false, POS_FACEUP)
					and tc:IsSetCard(0x6327) then
					-- Optional equip effect after Special Summon
				end
			end
			Duel.SpecialSummonComplete()

			-- Then, optional equip part
			if Duel.IsExistingMatchingCard(cm.filter, tp, LOCATION_REMOVED, 0, 1, nil) and Duel.SelectYesNo(tp, aux.Stringid(m, 2)) then
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
				local ecg = Duel.SelectMatchingCard(tp, cm.filter, tp, LOCATION_REMOVED, 0, 1, 2, nil)
				if #ecg > 0 then
					Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
					local mc = Duel.SelectMatchingCard(tp, Card.IsFaceup, tp, LOCATION_MZONE, 0, 1, 1, nil):GetFirst()
					if mc then
						for ec in aux.Next(ecg) do
							if Duel.Equip(tp, ec, mc, false) then
								-- Equip limit and type change
								local e1 = Effect.CreateEffect(mc)
								e1:SetType(EFFECT_TYPE_SINGLE)
								e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
								e1:SetCode(EFFECT_EQUIP_LIMIT)
								e1:SetValue(cm.eqlimit)
								e1:SetLabelObject(mc)
								e1:SetReset(RESET_EVENT + RESETS_STANDARD)
								ec:RegisterEffect(e1)

								local e2 = Effect.CreateEffect(mc)
								e2:SetType(EFFECT_TYPE_SINGLE)
								e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
								e2:SetCode(EFFECT_CHANGE_TYPE)
								e2:SetValue(TYPE_SPELL + TYPE_EQUIP)
								e2:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TOFIELD)
								ec:RegisterEffect(e2)
							end
						end
					end
				end
			end
		end
	end
end

function cm.eqlimit(e, c)
	return c == e:GetLabelObject()
end
