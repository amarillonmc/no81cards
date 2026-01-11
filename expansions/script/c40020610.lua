--鸟兽气兵 真神
local s, id = GetID()
s.named_with_ForceFighter=1
function s.ForceFighter(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ForceFighter
end

function s.initial_effect(c)

	c:EnableReviveLimit()
	
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0, TIMING_END_PHASE + TIMING_MAIN_END)
	e1:SetCost(s.tdcost)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0, 1)
	e2:SetCondition(s.actcon)
	e2:SetValue(s.aclimit)
	c:RegisterEffect(e2)
end

function s.splimit(e, se, sp, st)
	if (st & SUMMON_TYPE_XYZ) == SUMMON_TYPE_XYZ then return false end
	if e:GetHandler():IsLocation(LOCATION_EXTRA) then
		return se and s.ForceFighter(se:GetHandler())
	end
	return true
end

function s.tdcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end

function s.tdtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetFieldGroupCount(tp, 0, LOCATION_GRAVE) > 0 end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CARDTYPE)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, 1-tp, LOCATION_GRAVE)
end

function s.tdop(e, tp, eg, ep, ev, re, r, rp)
	local opt = Duel.AnnounceType(tp)
	local type_val = 0
	if opt == 0 then type_val = TYPE_MONSTER
	elseif opt == 1 then type_val = TYPE_SPELL
	else type_val = TYPE_TRAP end
	
	local g = Duel.GetMatchingGroup(Card.IsType, tp, 0, LOCATION_GRAVE, nil, type_val)
	if g:GetCount() > 0 then
		Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
	end
end

function s.actcon(e)
	local a = Duel.GetAttacker()
	return a and a:IsControler(e:GetHandlerPlayer()) and s.ForceFighter(a)
end

function s.aclimit(e, re, tp)
	return re:IsActiveType(TYPE_SPELL + TYPE_TRAP)
end
