--六魔冥导 提尔兹·瓦修罗姆
local s, id = GetID()
s.named_with_InfernalLord=1
function s.InfernalLord(c)
	local m = _G["c" .. c:GetCode()]
	return m and m.named_with_InfernalLord
end
function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetOperation(s.regop)
	c:RegisterEffect(e0)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_NEGATE + CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id + 1)
	e2:SetCondition(s.negcon)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)

	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.chgcon)
	e3:SetOperation(s.chgop)
	c:RegisterEffect(e3)
end

function s.InfernalLord(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_InfernalLord
end

function s.cfilter(c, tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) 
		and s.InfernalLord(c) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer() == 1-tp)
end
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(s.cfilter, 1, nil, tp)
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 
		and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false)
		and Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > 0 
		and Duel.GetFieldGroupCount(tp, 0, LOCATION_HAND) > 0 end
	Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, PLAYER_ALL, 1)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > 0 and Duel.GetFieldGroupCount(tp, 0, LOCATION_HAND) > 0 then
		Duel.DiscardHand(tp, nil, 1, 1, REASON_EFFECT + REASON_DISCARD)
		Duel.DiscardHand(1-tp, nil, 1, 1, REASON_EFFECT + REASON_DISCARD)
		
		if c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
		end
	end
end


function s.regop(e, tp, eg, ep, ev, re, r, rp)
	if e:GetHandler():IsPreviousLocation(LOCATION_GRAVE) then
		e:GetHandler():RegisterFlagEffect(id, RESET_EVENT + RESETS_STANDARD, 0, 1)
	end
end


function s.negcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local is_gy_summon = c:GetFlagEffect(id) > 0
	
	if not is_gy_summon and re:IsActiveType(TYPE_MONSTER) then return false end

	return rp == 1-tp and Duel.IsChainNegatable(ev) 
		and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
		and (not re:IsActiveType(TYPE_MONSTER) or is_gy_summon)
end
function s.negtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_NEGATE, eg, 1, 0, 0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0, CATEGORY_DESTROY, eg, 1, 0, 0)
	end
end
function s.negop(e, tp, eg, ep, ev, re, r, rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg, REASON_EFFECT)
	end
end

function s.chgcon(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetFlagEffect(tp, id + 2) ~= 0 then return false end

	if rp == tp then return false end
	
	local ex, g, gc, dp, dv = Duel.GetOperationInfo(ev, CATEGORY_DRAW)
	return ex and (dp == 1-tp or dp == PLAYER_ALL) and dv > 0
end

function s.chgop(e, tp, eg, ep, ev, re, r, rp)
	local ex, g, gc, dp, dv = Duel.GetOperationInfo(ev, CATEGORY_DRAW)
	if not ex then return end

	if Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
		Duel.Hint(HINT_CARD, 0, id)
		Duel.RegisterFlagEffect(tp, id + 2, RESET_PHASE + PHASE_END, 0, 1)
		
		local my_player = tp
		local draw_amount = dv
		
		local op = function(_e, _tp, _eg, _ep, _ev, _re, _r, _rp)

			Duel.Draw(my_player, draw_amount, REASON_EFFECT)
		end
		
		Duel.ChangeChainOperation(ev, op)
	end
end