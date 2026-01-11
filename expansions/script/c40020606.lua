--鸟兽气兵武神 大和 -炮击态-

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
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCost(s.effcost)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE, 0)
	e2:SetTarget(aux.TargetBoolFunction(s.ForceFighter))
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
end


function s.splimit(e, se, sp, st)

	if (st & SUMMON_TYPE_XYZ) == SUMMON_TYPE_XYZ then return false end

	if e:GetHandler():IsLocation(LOCATION_EXTRA) then
		return se and s.ForceFighter(se:GetHandler())
	end
	

	return true
end


function s.matfilter(c)
	return c:IsCode(40020585) and c:IsFaceup()
end

function s.effcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.matfilter, tp, LOCATION_PZONE, 0, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
	local g = Duel.SelectMatchingCard(tp, s.matfilter, tp, LOCATION_PZONE, 0, 1, 1, nil)
	if g:GetCount() > 0 then
		Duel.Overlay(e:GetHandler(), g)
	end
end

function s.efftg(e, tp, eg, ep, ev, re, r, rp, chk)
	local g = Duel.GetFieldGroup(tp, 0, LOCATION_ONFIELD)
	if chk == 0 then return g:GetCount() > 0 end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, g, g:GetCount(), 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, 1-tp, LOCATION_HAND)

end

function s.effop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetFieldGroup(tp, 0, LOCATION_ONFIELD)
	if g:GetCount() > 0 then
		if Duel.SendtoHand(g, nil, REASON_EFFECT) > 0 then

			Duel.BreakEffect()
			local hg = Duel.GetFieldGroup(tp, 0, LOCATION_HAND)
			if hg:GetCount() > 3 then
				Duel.Hint(HINT_SELECTMSG, 1 - tp, HINTMSG_ATOHAND) 

				local kg = hg:Select(1 - tp, 3, 3, nil)
				hg:Sub(kg) 
				if hg:GetCount() > 0 then
					Duel.SendtoDeck(hg, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
				end
			end
		end
	end
end

function s.efilter(e, te)
	return te:GetOwnerPlayer() ~= e:GetHandlerPlayer() 
		and (te:IsActiveType(TYPE_MONSTER) or te:IsActiveType(TYPE_SPELL))
end
