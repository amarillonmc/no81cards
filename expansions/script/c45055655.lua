--超越星龙 极限红巨星
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	aux.AddXyzProcedure(c, nil, 11, 2)

	local e0 = Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id, 0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.xyzcon)
	e0:SetOperation(s.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE, 0)
	e1:SetTarget(s.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_DISABLE + CATEGORY_ATKCHANGE + CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.negcon)
	e2:SetCost(s.negcost)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
	
	if not s.global_check then
		s.global_check = true
		local ge1 = Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1, 0)
	end
end

function s.regfilter(c, tp)
	return c:IsCode(45055659) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_DECK+LOCATION_HAND) and c:IsPreviousControler(tp)
end

function s.regop(e, tp, eg, ep, ev, re, r, rp)
	for p = 0, 1 do
		if eg:IsExists(s.regfilter, 1, nil, p) then
			Duel.RegisterFlagEffect(p, id, RESET_PHASE+PHASE_END, 0, 1)
		end
	end
end

function s.xyzcon(e, c, og, min, max)
	if c == nil then return true end
	local tp = c:GetControler()
		if Duel.GetFlagEffect(tp, id) == 0 then return false end
	local mg = Duel.GetMatchingGroup(s.xyzfilter, tp, LOCATION_MZONE, 0, nil)
	if #mg == 0 then return false end
		return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, nil)
end

function s.xyzfilter(c,xc)
	return c:IsSetCard(0x6f5) and c:IsFaceup() and c:IsCanBeXyzMaterial(xc)
end

function s.xyzop(e, tp, eg, ep, ev, re, r, rp, c, og, min, max)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
	local g = Duel.SelectMatchingCard(tp, s.xyzfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
	if #g == 0 then return end	
	Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_COST + REASON_DISCARD)	
	c:SetMaterial(g)
	Duel.Overlay(c, g)	
	Duel.ResetFlagEffect(tp, id)
end

function s.indtg(e, c)
	return c:IsSetCard(0x6f5) and c ~= e:GetHandler()
end

function s.negcon(e, tp, eg, ep, ev, re, r, rp)
	return rp == 1 - tp and re:IsActiveType(TYPE_MONSTER) and Duel.GetTurnPlayer() == tp
end

function s.negcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end

function s.negtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_DISABLE, eg, 1, 0, 0)
end

function s.negop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	
	if Duel.NegateEffect(ev) then
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END, 2)
		c:RegisterEffect(e1)
		local e2 = e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end