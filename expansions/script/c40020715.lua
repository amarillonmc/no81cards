--兵虫阳神 圣甲神隼
local s, id = GetID()
s.named_with_WeaponInsect = 1
function s.WeaponInsect(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_WeaponInsect
end
s.RAHERAKHTY_CODE = 40020713
s.OMEGA_CODE = 40020839
function s.initial_effect(c)
	
	c:EnableReviveLimit()
	
	local e0 = Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(function(e, c, og, min, max)
	if c == nil then return true end
	local tp = c:GetControler()
	local mg = Duel.GetFieldGroup(tp, LOCATION_MZONE + LOCATION_SZONE, 0)
	return Duel.CheckXyzMaterial(c, s.xyzfilter, 3, 3, 3, mg)
end)
	e0:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk, c, og, min, max)
	if og and not min then return true end
	local mg = Duel.GetFieldGroup(tp, LOCATION_MZONE + LOCATION_SZONE, 0)
	local g = Duel.SelectXyzMaterial(tp, c, s.xyzfilter, 3, 3, 3, mg)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else 
		return false 
	end
end)
	e0:SetOperation(function(e, tp, eg, ep, ev, re, r, rp, c, og, min, max)
	local sg = Group.CreateGroup()
	if og and not min then
		for tc in aux.Next(og) do
			local sg1 = tc:GetOverlayGroup()
			sg:Merge(sg1)
		end
		Duel.SendtoGrave(sg, REASON_RULE)
		c:SetMaterial(og)
		Duel.Overlay(c, og)
	else
		local mg = e:GetLabelObject()
		for tc in aux.Next(mg) do
			local sg1 = tc:GetOverlayGroup()
			sg:Merge(sg1)
		end
		Duel.SendtoGrave(sg, REASON_RULE)
		c:SetMaterial(mg)
		Duel.Overlay(c, mg)
		mg:DeleteGroup()
	end
end)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)

	local e0b = Effect.CreateEffect(c)
	e0b:SetType(EFFECT_TYPE_FIELD)
	e0b:SetCode(EFFECT_XYZ_LEVEL)
	e0b:SetRange(LOCATION_EXTRA)
	e0b:SetTargetRange(LOCATION_SZONE, 0)
	e0b:SetValue(function(e, c, rc)
	if rc == e:GetHandler() then 
		return c:GetOriginalLevel() 
	else 
		return c:GetLevel() 
	end
end)
	c:RegisterEffect(e0b)
	
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0, TIMING_BATTLE_PHASE)
	e2:SetCountLimit(1, id + 1)
	e2:SetCondition(s.buffcon)
	e2:SetCost(s.buffcost)
	e2:SetOperation(s.buffop)
	c:RegisterEffect(e2)
end
function s.xyzfilter(c)
	return c:IsFaceup() 
		and s.WeaponInsect(c) 
		and (c:GetOriginalType() & TYPE_MONSTER) ~= 0
end
function s.thcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.szfilter(c, e, tp)
	if not c:IsFaceup() or not s.WeaponInsect(c) then return false end
	if c:IsAbleToHand() then return true end
	if (c:GetOriginalType() & TYPE_MONSTER) ~= 0 
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) then 
		return true 
	end
	return false
end
function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.szfilter, tp, LOCATION_SZONE, 0, 1, nil, e, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_SZONE)
end
function s.setfilter(c)
	return s.WeaponInsect(c) and not (c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS))
end
function s.rafilter(c)
	return c:IsCode(s.RAHERAKHTY_CODE) and c:IsFaceup()
end
function s.omegafilter(c)
	return c:IsCode(s.OMEGA_CODE)
end
function s.thop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local g = Duel.GetMatchingGroup(s.szfilter, tp, LOCATION_SZONE, 0, nil, e, tp)
	if #g == 0 then return end
	local count = 0
	local tc = g:GetFirst()
	while tc do
		Duel.HintSelection(Group.FromCards(tc))
		local canth = tc:IsAbleToHand()
		local cansp = (tc:GetOriginalType() & TYPE_MONSTER) ~= 0 
			and tc:IsCanBeSpecialSummoned(e, 0, tp, false, false)
			and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		if canth and cansp then
			if Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
				if Duel.SendtoHand(tc, nil, REASON_EFFECT) > 0 then
					Duel.ConfirmCards(1 - tp, tc)
					count = count + 1
				end
			else
				if Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP) > 0 then
					count = count + 1
				end
			end
		elseif canth then
			if Duel.SendtoHand(tc, nil, REASON_EFFECT) > 0 then
				Duel.ConfirmCards(1 - tp, tc)
				count = count + 1
			end
		elseif cansp then
			if Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP) > 0 then
				count = count + 1
			end
		end
		tc = g:GetNext()
	end
	if count == 0 then return end
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if Duel.IsExistingMatchingCard(s.rafilter, tp, LOCATION_SZONE, 0, 1, nil)
	   and Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then
		local hasOmega = Duel.IsExistingMatchingCard(s.omegafilter, tp, LOCATION_EXTRA, 0, 1, nil)
		if hasOmega and Duel.SelectYesNo(tp, aux.Stringid(40020839, 0)) then

			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
			local rg = Duel.SelectMatchingCard(tp, s.rafilter, tp, LOCATION_SZONE, 0, 1, 1, nil)
			if #rg > 0 then
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
				local og = Duel.SelectMatchingCard(tp, s.omegafilter, tp, LOCATION_EXTRA, 0, 1, 1, nil)
				if #og > 0 then
					local oc = og:GetFirst()
					oc:SetMaterial(rg)
					Duel.Overlay(oc, rg)
					Duel.SpecialSummon(oc, SUMMON_TYPE_XYZ, tp, tp, false, false, POS_FACEUP)
					oc:CompleteProcedure()
				end
			end
		else
			-- Normal: overlay Ra as Xyz material on this card
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
			local rg = Duel.SelectMatchingCard(tp, s.rafilter, tp, LOCATION_SZONE, 0, 1, 1, nil)
			if #rg > 0 then
				Duel.Overlay(c, rg)
			end
		end
		-- Continue: set WeaponInsect cards from deck
		local maxset = math.min(Duel.GetLocationCount(tp, LOCATION_SZONE), 2)
		if maxset > 0 and Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_DECK, 0, 1, nil) then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
			local sg = Duel.SelectMatchingCard(tp, s.setfilter, tp, LOCATION_DECK, 0, 1, maxset, nil)
			if #sg > 0 then
				local stc = sg:GetFirst()
				while stc do
					Duel.MoveToField(stc, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
					local ot = stc:GetOriginalType()
					if (ot & TYPE_MONSTER) ~= 0 then
						local e1 = Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_CHANGE_TYPE)
						e1:SetValue(TYPE_TRAP + TYPE_CONTINUOUS)
						e1:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
						stc:RegisterEffect(e1)
					else
						local e1a = Effect.CreateEffect(c)
						e1a:SetType(EFFECT_TYPE_SINGLE)
						e1a:SetCode(EFFECT_ADD_TYPE)
						e1a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e1a:SetValue(TYPE_TRAP + TYPE_CONTINUOUS)
						e1a:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
						stc:RegisterEffect(e1a, true)
						
						local e1b = Effect.CreateEffect(c)
						e1b:SetType(EFFECT_TYPE_SINGLE)
						e1b:SetCode(EFFECT_REMOVE_TYPE)
						e1b:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e1b:SetValue(ot)
						e1b:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
						stc:RegisterEffect(e1b, true)
					end
					stc = sg:GetNext()
				end
			end
		end
	end
end
function s.buffcon(e, tp, eg, ep, ev, re, r, rp)
	local ph = Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer() == tp and ph >= PHASE_BATTLE_START and ph <= PHASE_BATTLE
end
function s.buffcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():CheckRemoveOverlayCard(tp, 2, REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp, 2, 2, REASON_COST)
end
function s.buffop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(Card.IsRace, tp, LOCATION_MZONE, 0, nil, RACE_INSECT)
	local tc = g:GetFirst()
	while tc do
		local batk = tc:GetBaseAttack()
		if batk >= 1 then
			local e1 = Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(math.floor(batk / 2))
			e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
			tc:RegisterEffect(e1)
		end
		local e2 = Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
		tc:RegisterEffect(e2)
		tc = g:GetNext()
	end
end