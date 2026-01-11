--银河眼灵魂龙
local s, id = GetID()


function s.initial_effect(c)

	aux.EnableChangeCode(c,93717133,LOCATION_MZONE+LOCATION_GRAVE)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_NEGATE + CATEGORY_SPECIAL_SUMMON + CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND + LOCATION_GRAVE)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.negcon)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)


	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1, id + 100) 
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)

	local e3 = e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end


function s.tgfilter(c, tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x107b)
end

function s.negcon(e, tp, eg, ep, ev, re, r, rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g = Duel.GetChainInfo(ev, CHAININFO_TARGET_CARDS)
	return g and g:IsExists(s.tgfilter, 1, nil, tp) and rp == 1-tp and Duel.IsChainNegatable(ev)
end

function s.negtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then 
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 
			and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false) 
	end
	Duel.SetOperationInfo(0, CATEGORY_NEGATE, eg, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)

	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

function s.xyzfilter(c)
	return c:IsSetCard(0x107b) and c:IsXyzSummonable(nil)
end

function s.negop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if Duel.NegateActivation(ev) and c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then

			local g = Duel.GetMatchingGroup(s.xyzfilter, tp, LOCATION_EXTRA, 0, nil)
			if g:GetCount() > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then 
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
				local sc = g:Select(tp, 1, 1, nil):GetFirst()
				if sc then
					Duel.XyzSummon(tp, sc, nil)
					if sc:IsLocation(LOCATION_MZONE) and sc:IsFaceup() then
						local e1 = Effect.CreateEffect(c)
						e1:SetDescription(aux.Stringid(id, 3))
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_DIRECT_ATTACK)
						e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
						e1:SetReset(RESET_EVENT + RESETS_STANDARD)
						sc:RegisterEffect(e1)
						
						local e2 = Effect.CreateEffect(c)
						e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
						e2:SetCode(EVENT_DAMAGE_STEP_END)
						e2:SetLabelObject(e1)
						e2:SetCondition(function(e) 
							return Duel.GetAttackTarget() == nil 
						end)
						e2:SetOperation(function(e)
							e:GetLabelObject():Reset()
							e:Reset()
						end)
						e2:SetReset(RESET_EVENT + RESETS_STANDARD)
						sc:RegisterEffect(e2)
					end
				end
			end
		end
	end
end


function s.thcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()

	return c:IsReason(REASON_COST) and re:IsActivated() and re:GetHandler():IsType(TYPE_XYZ)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end

function s.searchfilter(c)

	return (c:IsSetCard(0x7b) or c:IsSetCard(0x55)) 
		and c:IsType(TYPE_SPELL + TYPE_TRAP) 
		and c:IsAbleToHand()
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.searchfilter, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, s.searchfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if g:GetCount() > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
	end
end