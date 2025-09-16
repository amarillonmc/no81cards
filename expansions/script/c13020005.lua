--白露为霜
local cm, m, ofs = GetID()
local yr = 13020010
function cm.initial_effect(c)
	aux.AddCodeList(c, yr)
	c:SetSPSummonOnce(m)
	--fusion material
	c:EnableReviveLimit()
	--aux.AddFusionProcCodeFunRep(c, 13020000, aux.FilterBoolFunction(Card.IsType, TYPE_EFFECT), 1, 127, true, true)
	aux.AddFusionProcFun2(c, cm.filter66, aux.FilterBoolFunction(Card.IsType, TYPE_EFFECT), true)
	local e1 = cm.AddContactFusionProcedure(c, cm.ffilter, LOCATION_ONFIELD + LOCATION_HAND, 0, Duel.Remove, POS_FACEUP,
		REASON_COST + REASON_MATERIAL):SetValue(SUMMON_VALUE_SELF)

	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)

	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m, 1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCondition(cm.descon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.desop2)
	c:RegisterEffect(e3)
end

function cm.filter66(c)
	return aux.IsCodeListed(c, yr)
end

function cm.ffilter(c, fc, sub, mg, sg)
	return c:IsAbleToRemoveAsCost() and (c:GetOriginalType() & TYPE_UNION ~= 0 or c:GetOriginalType() & TYPE_EQUIP ~= 0)
end

function cm.filter(c, c2)
	return c:IsType(TYPE_EQUIP) and not c:IsForbidden() and aux.IsCodeListed(c, yr) and c:CheckEquipTarget(c2)
end

function cm.AddContactFusionProcedure(c, filter, self_location, opponent_location, mat_operation, ...)
	self_location = self_location or 0
	opponent_location = opponent_location or 0
	local operation_params = { ... }
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.ContactFusionCondition(filter, self_location, opponent_location))
	e2:SetOperation(cm.ContactFusionOperation(filter, self_location, opponent_location, mat_operation, operation_params))
	c:RegisterEffect(e2)
	return e2
end

function cm.ContactFusionMaterialFilter(c, fc, filter)
	return c:IsCanBeFusionMaterial(fc, SUMMON_TYPE_SPECIAL) and (not filter or filter(c, fc))
end

function cm.ContactFusionCondition(filter, self_location, opponent_location)
	return function(e, c)
		if c == nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp = c:GetControler()
		local mg = Duel.GetMatchingGroup(cm.ContactFusionMaterialFilter, tp, self_location, opponent_location, c, c,
			filter)
		return #mg >= 2
	end
end

function cm.ContactFusionOperation(filter, self_location, opponent_location, mat_operation, operation_params)
	return function(e, tp, eg, ep, ev, re, r, rp, c)
		local mg = Duel.GetMatchingGroup(cm.ContactFusionMaterialFilter, tp, self_location, opponent_location, c, c,
			filter)
		local g = mg:Select(tp, 2, 2, nil)
		c:SetMaterial(g)
		mat_operation(g, table.unpack(operation_params))
	end
end

function cm.desop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
	local g = Duel.SelectMatchingCard(tp, cm.filter, tp, LOCATION_GRAVE + LOCATION_DECK, 0, 1, 1, nil, c)
	if g:GetCount() > 0 then
		g = g:GetFirst()
		local mg = Group.CreateGroup()
		mg:AddCard(c)
		local g2 = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_MZONE, nil)
		mg:Merge(g2)
		local tc = c
		if g:IsLocation(LOCATION_GRAVE) and #mg > 1 then
			tc = mg:Select(tp, 1, 1, nil):GetFirst()
			Duel.Equip(tp, g, tc, true)
		else
			Duel.Equip(tp, g, tc, true)
		end
		Duel.BreakEffect()
		Duel.Remove(c, POS_FACEUP, REASON_EFFECT)
	end
end

function cm.cfilter(c, tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:GetReasonPlayer() == 1 - tp
end

function cm.descon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(cm.cfilter, 1, nil, tp) and not eg:IsContains(e:GetHandler())
end

function cm.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
			c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function cm.desop2(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
end
