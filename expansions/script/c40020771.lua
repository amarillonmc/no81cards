--花翼妖蛇 休奇皮里
local s,id=GetID()
function s.DarkSnake(c)
	local m = _G["c"..c:GetCode()]
	if m and m.named_with_DarkSnake then return true end
	if c:GetCode() == 40020764 and c:IsLocation(LOCATION_PZONE) then return true end 
	return false
end
s.named_with_DarkSnake=1
function s.initial_effect(c)
	aux.AddXyzProcedure(c,nil,7,2,s.ovfilter,aux.Stringid(id,0),2,s.xyzop)
	c:EnableReviveLimit()

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 1))
	e1:SetCategory(CATEGORY_TOGRAVE + CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function s.ovfilter(c)
	return c:IsFaceup() and s.DarkSnake(c) and c:IsLevel(7)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function s.condition(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local g = Duel.GetMatchingGroup(Card.IsAbleToGrave, tp, LOCATION_HAND, 0, nil)
		local has = false
		for tc in aux.Next(g) do
			local code = tc:GetCode()
			if g:IsExists(Card.IsCode, 1, tc, code) then
				has = true
				break
			end
		end
		return has
	end
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 2, tp, LOCATION_HAND)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local g = Duel.GetMatchingGroup(Card.IsAbleToGrave, tp, LOCATION_HAND, 0, nil)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local sg1 = g:Select(tp, 1, 1, nil)
	local code = sg1:GetFirst():GetCode()
	local g2 = g:Filter(Card.IsCode, nil, code)
	g2:RemoveCard(sg1:GetFirst())
	local sg2 = g2:Select(tp, 1, 1, nil)
	sg1:Merge(sg2)
	Duel.SendtoGrave(sg1, REASON_EFFECT)
	local thg = Duel.GetMatchingGroup(s.DarkSnake, tp, LOCATION_DECK, 0, nil)
	if #thg > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local tg = thg:SelectSubGroup(tp, aux.dncheck, false, 0, 4)
		if #tg > 0 then
			Duel.SendtoHand(tg, tp, REASON_EFFECT)
			Duel.ConfirmCards(1 - tp, tg)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(tp) 
	e1:SetCondition(s.sendcon)
	e1:SetOperation(s.sendop)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	Duel.RegisterEffect(e1,tp)
end
function s.sendcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetTurnCount() == e:GetLabel()
end
function s.sendfilter(c)
	return c:IsLocation(LOCATION_HAND)
		or c:IsLocation(LOCATION_ONFIELD)
		or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup())
end
function s.sendop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(s.sendfilter, tp, LOCATION_HAND + LOCATION_ONFIELD + LOCATION_EXTRA, 0, nil)
	local ct = #g
	if ct == 0 then return end
	if ct <= 4 then
		Duel.SendtoGrave(g, REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
		local sg = g:Select(tp, 4, 4, nil)
		Duel.SendtoGrave(sg, REASON_EFFECT)
	end
end

