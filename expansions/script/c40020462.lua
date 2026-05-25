--冥府之霸皇 混暗晴明

local s, id = GetID()

function s.Grandwalker(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end

function s.initial_effect(c)

	c:EnableReviveLimit()
	
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)

	c:RegisterEffect(e0)
	
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TODECK + CATEGORY_TOGRAVE + CATEGORY_DRAW + CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.tgcon)
	e1:SetCost(s.tgcost)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id + 1)
	e2:SetTarget(s.desreptg)
	e2:SetOperation(s.desrepop)
	c:RegisterEffect(e2)
end

function s.splimit(e, se, sp, st)
	return se:GetHandler() == e:GetHandler()
end

function s.monfilter(c, tp)
	return c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP)
		and c:GetReasonPlayer() == 1 - tp
end

function s.tgcon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(s.monfilter, 1, nil, tp)
end

function s.tgcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(), REASON_COST + REASON_DISCARD)
end


function s.tdfilter(c, handler)
	if handler and c == handler then return false end
	return (c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_MONSTER)) or c:IsType(TYPE_TRAP)
end

function s.gwfilter(c)
	return s.Grandwalker(c) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end

function s.tgtg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then

		local b1 = Duel.IsExistingMatchingCard(s.tdfilter, tp, LOCATION_GRAVE, 0, 1, nil, c)
		local b2 = Duel.IsExistingMatchingCard(Card.IsAbleToGrave, tp, 0, LOCATION_ONFIELD, 1, nil) 
				   and Duel.IsPlayerCanDraw(tp, 1)
		local b3 = c:IsCanBeSpecialSummoned(e, 0, tp, true, true) 
				   and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		return b1 or b2 or b3
	end
end

function s.tgop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	
	local hasGW = Duel.IsExistingMatchingCard(s.gwfilter, tp, LOCATION_PZONE, 0, 1, nil)
	

	local b1 = Duel.IsExistingMatchingCard(s.tdfilter, tp, LOCATION_GRAVE, 0, 1, nil, c)
	local b2 = Duel.IsExistingMatchingCard(Card.IsAbleToGrave, tp, 0, LOCATION_ONFIELD, 1, nil) 
			   and Duel.IsPlayerCanDraw(tp, 1)
	local b3 = c:IsRelateToEffect(e) 
			   and c:IsCanBeSpecialSummoned(e, 0, tp, true, true) 
			   and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
	
	if not b1 and not b2 and not b3 then return end
	

	local useEnhanced = false
	if hasGW and Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then

		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RTOHAND)
		local gw = Duel.SelectMatchingCard(tp, s.gwfilter, tp, LOCATION_PZONE, 0, 1, 1, nil)
		if #gw > 0 then
			Duel.SendtoHand(gw, nil, REASON_EFFECT)
			Duel.ConfirmCards(1 - tp, gw)
			useEnhanced = true
		end
	end
	
	if useEnhanced then

		local ops = {}
		if b1 then table.insert(ops, 1) end
		if b2 then table.insert(ops, 2) end
		if b3 then table.insert(ops, 3) end
		
		local first = true
		while #ops > 0 do
			if not first then
				Duel.BreakEffect()
			end
			first = false
			
			local sel
			if #ops == 1 then

				sel = ops[1]
				table.remove(ops, 1)
			else

				local opvals = {}
				for i, v in ipairs(ops) do
					table.insert(opvals, aux.Stringid(id, v + 1))
				end
				local idx = Duel.SelectOption(tp, table.unpack(opvals))
				sel = ops[idx + 1]
				table.remove(ops, idx + 1)
			end
			
			if sel == 1 then
				s.effectA(e, tp, c)
			elseif sel == 2 then
				s.effectB(e, tp)
			elseif sel == 3 then
				s.effectC(e, tp, c)
			end
		end
	else
		local opvals = {}
		local opmap = {}
		if b1 then 
			table.insert(opvals, aux.Stringid(id, 2))
			table.insert(opmap, 1)
		end
		if b2 then 
			table.insert(opvals, aux.Stringid(id, 3))
			table.insert(opmap, 2)
		end
		if b3 then 
			table.insert(opvals, aux.Stringid(id, 4))
			table.insert(opmap, 3)
		end
		
		if #opvals == 0 then return end
		
		local idx = 0
		if #opvals > 1 then
			idx = Duel.SelectOption(tp, table.unpack(opvals))
		end
		local sel = opmap[idx + 1]
		
		if sel == 1 then
			s.effectA(e, tp, c)
		elseif sel == 2 then
			s.effectB(e, tp)
		elseif sel == 3 then
			s.effectC(e, tp, c)
		end
	end
end

function s.effectA(e, tp, c)
	local g = Duel.GetMatchingGroup(s.tdfilter, tp, LOCATION_GRAVE, 0, nil, c)
	if #g == 0 then return end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local sg = g:Select(tp, 1, 5, nil)
	if #sg == 0 then return end
	
	local topg = Group.CreateGroup()
	local botg = Group.CreateGroup()
	
	for tc in aux.Next(sg) do
		if Duel.SelectYesNo(tp, aux.Stringid(id, 5)) then
			topg:AddCard(tc)
		else
			botg:AddCard(tc)
		end
	end
	
	if #topg > 0 then
		Duel.SendtoDeck(topg, nil, SEQ_DECKTOP, REASON_EFFECT)
		if #topg > 1 then
			Duel.SortDecktop(tp, tp, #topg)
		end
	end
	if #botg > 0 then
		Duel.SendtoDeck(botg, nil, SEQ_DECKBOTTOM, REASON_EFFECT)
	end
end

function s.effectB(e, tp)
	if not Duel.IsExistingMatchingCard(Card.IsAbleToGrave, tp, 0, LOCATION_ONFIELD, 1, nil) then return end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local g = Duel.SelectMatchingCard(tp, Card.IsAbleToGrave, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
	if #g > 0 and Duel.SendtoGrave(g, REASON_EFFECT) > 0 then
		Duel.BreakEffect()
		Duel.Draw(tp, 1, REASON_EFFECT)
	end
end

function s.effectC(e, tp, c)
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then
		Duel.SpecialSummon(c, 0, tp, tp, true, true, POS_FACEUP)
	end
end

function s.desreptg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
		if not eg:IsContains(c) then return false end
		if c:IsReason(REASON_BATTLE) then return true end
		if c:IsReason(REASON_EFFECT) and rp == 1 - tp then return true end
		return false
	end
	return Duel.SelectEffectYesNo(tp, c, aux.Stringid(id, 6))
end

function s.desrepop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Damage(1 - tp, 1600, REASON_EFFECT)
end
