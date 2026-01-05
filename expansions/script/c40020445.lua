--冰杰之霸皇 霸王·璃冰

local s, id = GetID()

function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.pspcon)
	e1:SetTarget(s.psptg)
	e1:SetOperation(s.pspop)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1, id + 100)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)

	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)

	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id, 2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1, id + 200)
	e4:SetCondition(s.spcon_ed)
	e4:SetTarget(s.sptg_ed)
	e4:SetOperation(s.spop_ed)
	c:RegisterEffect(e4)
end

function s.pspcon(e, tp, eg, ep, ev, re, r, rp)
	return  bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end

function s.psptg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.pspop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
	end
end


function s.tdtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck, tp, 0, LOCATION_ONFIELD, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, 1 - tp, LOCATION_ONFIELD)
end

function s.tdop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g = Duel.SelectMatchingCard(tp, Card.IsAbleToDeck, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
	if #g > 0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g, nil, SEQ_DECKBOTTOM, REASON_EFFECT)
	end
end


function s.typefilter(c, type)
	return c:IsFaceup() and c:IsType(type)
end

function s.efilter(e, te)
	local tp = e:GetHandlerPlayer()
	if te:GetOwnerPlayer() == tp then return false end
	
	local check_type = 0
	if te:IsActiveType(TYPE_MONSTER) then check_type = TYPE_MONSTER
	elseif te:IsActiveType(TYPE_SPELL) then check_type = TYPE_SPELL
	elseif te:IsActiveType(TYPE_TRAP) then check_type = TYPE_TRAP end
	
	if check_type == 0 then return false end
	
	return Duel.IsExistingMatchingCard(s.typefilter, tp, 0, LOCATION_ONFIELD, 1, nil, check_type)
end


function s.cfilter(c, tp)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) and c:IsControler(tp)
end

function s.spcon_ed(e, tp, eg, ep, ev, re, r, rp)

	return eg:IsExists(s.cfilter, 1, nil, tp) 
	   and Duel.GetMatchingGroupCount(Card.IsFaceup, tp, LOCATION_EXTRA, 0, nil) >= 4
end

function s.sptg_ed(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then return Duel.GetLocationCountFromEx(tp, tp, nil, c) > 0
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.spop_ed(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCountFromEx(tp, tp, nil, c) > 0 then
		Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
	end
end