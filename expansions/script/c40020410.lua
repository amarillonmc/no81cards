--佩涅罗佩[飞行形态]
local s,id=GetID()
s.named_with_Penelope=1
function s.Penelope(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Penelope
end

function s.initial_effect(c)
	aux.AddCodeList(c,40020396)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_POSITION + CATEGORY_HANDES + CATEGORY_TOHAND + CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1, id)
	e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER + TIMING_MAIN_END + TIMING_BATTLE_START)
	e1:SetCost(s.e1cost)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_USE_AS_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0, LOCATION_ONFIELD)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end

function s.e1cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsCanRemoveCounter(tp, 1, 0, 0x1f1e, 2, REASON_COST) end
	Duel.RemoveCounter(tp, 1, 0, 0x1f1e, 2, REASON_COST)
end

function s.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and not c:IsType(TYPE_XYZ + TYPE_LINK)
end

function s.valcheck(g)
	return g:GetSum(Card.GetLevel) <= 5
end

function s.e1tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter(chkc) end
	local g = Duel.GetMatchingGroup(s.filter, tp, 0, LOCATION_MZONE, nil)
	if chk == 0 then return g:CheckSubGroup(s.valcheck, 1, 99) end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_POSCHANGE)
	local sg = g:SelectSubGroup(tp, s.valcheck, 1, 99)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0, CATEGORY_POSITION, sg, sg:GetCount(), 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end

function s.e1op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	
	local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
	local tg = g:Filter(Card.IsRelateToEffect, nil, e)
	
	if tg:GetCount() > 0 then
		Duel.ChangePosition(tg, POS_FACEDOWN_DEFENSE)
	end
	
	local b1 = c:IsRelateToEffect(e) and c:IsLocation(LOCATION_HAND) and c:IsDiscardable(REASON_EFFECT)
	local f2 = function(tc)
		return tc:IsFaceup() and (tc:IsLevelAbove(5) or tc:IsRankAbove(5)) 
		   and aux.IsCodeListed(tc, 40020396) 
		   and not tc:IsCode(id) 
		   and (tc:IsAbleToHand() or tc:IsAbleToExtra())
	end
	
	local b2 = c:IsRelateToEffect(e) and c:IsLocation(LOCATION_HAND) 
		   and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
		   and Duel.IsExistingMatchingCard(f2, tp, LOCATION_MZONE, 0, 1, nil)
		   and Duel.GetMZoneCount(tp, nil) > 0 
	
	if b1 or b2 then
		Duel.BreakEffect()
		local op = 0
		if b1 and b2 then
			op = Duel.SelectOption(tp, aux.Stringid(id, 1), aux.Stringid(id, 2))
		elseif b1 then
			op = 0
		else
			op = 1
		end
		
		if op == 0 then
			Duel.SendtoGrave(c, REASON_EFFECT + REASON_DISCARD)
		else
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RTOHAND)
			local rc = Duel.SelectMatchingCard(tp, f2, tp, LOCATION_MZONE, 0, 1, 1, nil):GetFirst()
			if rc then
				local res = 0
				if rc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) then
					 res = Duel.SendtoDeck(rc, nil, 0, REASON_EFFECT)
				else
					 res = Duel.SendtoHand(rc, nil, REASON_EFFECT)
				end
				
				if res > 0 and (rc:IsLocation(LOCATION_HAND) or rc:IsLocation(LOCATION_EXTRA)) then
					Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
				end
			end
		end
	end
end