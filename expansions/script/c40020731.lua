--兵虫 风沙逆转

local s, id = GetID()


s.named_with_WeaponInsect = 1
function s.WeaponInsect(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_WeaponInsect
end


function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1, id + 1)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	

	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetCategory(CATEGORY_HANDES + CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_MOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1, id + 2)
	e3:SetCondition(s.drcon)
	e3:SetTarget(s.drtg)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)
end


function s.setfilter(c)
	return s.WeaponInsect(c) 
		and not (c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)) 
		and not c:IsForbidden()
end


function s.spfilter(c, e, tp)
	return c:IsFaceup() 
		and s.WeaponInsect(c) 
		and (c:GetOriginalType() & TYPE_MONSTER) ~= 0 
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then

		if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return false end

		if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return false end

		if not Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_HAND, 0, 1, e:GetHandler()) then return false end

		if not Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_SZONE, 0, 1, nil, e, tp) then return false end
		return true
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_SZONE)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
	local g = Duel.SelectMatchingCard(tp, s.setfilter, tp, LOCATION_HAND, 0, 1, 1, nil)
	local tc = g:GetFirst()
	if tc then
		Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
		
		local ot = tc:GetOriginalType()
		
		if (ot & TYPE_MONSTER) ~= 0 then

			local e1 = Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetValue(TYPE_TRAP + TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
			tc:RegisterEffect(e1)
		else

			local e1a = Effect.CreateEffect(e:GetHandler())
			e1a:SetType(EFFECT_TYPE_SINGLE)
			e1a:SetCode(EFFECT_ADD_TYPE)
			e1a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1a:SetValue(TYPE_TRAP + TYPE_CONTINUOUS)
			e1a:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
			tc:RegisterEffect(e1a, true)
			
			local e1b = Effect.CreateEffect(e:GetHandler())
			e1b:SetType(EFFECT_TYPE_SINGLE)
			e1b:SetCode(EFFECT_REMOVE_TYPE)
			e1b:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1b:SetValue(ot)
			e1b:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
			tc:RegisterEffect(e1b, true)
		end
		

		if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local sg = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_SZONE, 0, 1, 1, nil, e, tp)
		if #sg > 0 then
			Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
		end
	end
end

function s.settg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
	end
end

function s.setop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
	

	Duel.MoveToField(c, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
	

	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(TYPE_TRAP + TYPE_CONTINUOUS)
	e2:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
	c:RegisterEffect(e2, true)
	
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMOVE_TYPE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(TYPE_SPELL + TYPE_QUICKPLAY)
	e3:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
	c:RegisterEffect(e3, true)
end

function s.drcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	return c:IsLocation(LOCATION_SZONE) 
		and c:IsFaceup() 
		and not c:IsPreviousLocation(LOCATION_SZONE)
end

function s.drtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > 0
	end
	Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, tp, 1)
end

function s.drop(e, tp, eg, ep, ev, re, r, rp)
	local hg = Duel.GetFieldGroup(tp, LOCATION_HAND, 0)
	if #hg == 0 then return end
	
	local ct = Duel.SendtoGrave(hg, REASON_EFFECT + REASON_DISCARD)
	
	if ct > 0 then

		local g = Duel.GetOperatedGroup()
		if g:IsExists(s.WeaponInsect, 1, nil) then

			local op_hand = Duel.GetFieldGroupCount(1 - tp, LOCATION_HAND, 0)
			if op_hand > 0 and Duel.IsPlayerCanDraw(tp, op_hand) then
				Duel.BreakEffect()
				Duel.Draw(tp, op_hand, REASON_EFFECT)
			end
		end
	end
end
