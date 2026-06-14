--耀炎之永恒流星
local s, id = GetID()
function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1, id + 1)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)

end

function s.tgfilter(c)
	return c:IsSetCard(0x6f8) and not c:IsCode(id) and (c:IsAbleToHand() or c:IsAbleToGrave())
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local g = Duel.GetMatchingGroup(s.tgfilter, tp, LOCATION_DECK, 0, nil)
		return g:CheckSubGroup(aux.dncheck, 2, 2) and Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, tp, LOCATION_DECK)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
	if #g<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:Select(tp,2,2,nil)
	if #sg<2 then return end
	local tc1,tc2=sg:GetFirst(),sg:GetNext()
	if tc1:GetCode()==tc2:GetCode() then
		local g2=g:Filter(Card.IsNotCode,nil,tc1:GetCode())
		if #g2>=1 then
			sg=g2:Select(tp,1,1,nil)
			if #sg==1 then
				sg:Merge(Group.FromCards(tc1))
				tc1,tc2=sg:GetFirst(),sg:GetNext()
			else
				return
			end
		else
			return
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local th=sg:Select(tp,1,1,nil):GetFirst()
	local sd=sg:GetFirst()
	if sd==th then sd=sg:GetNext() end
	Duel.SendtoHand(th,nil,REASON_EFFECT)
	Duel.ConfirmCards(1 - tp, th)
	
	Duel.SendtoGrave(sd,REASON_EFFECT)
	local e1 = Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetTargetRange(LOCATION_MZONE, 0)
    e1:SetTarget(s.kaiserfilter)
    e1:SetValue(1000)
    Duel.RegisterEffect(e1, tp)
end

function s.kaiserfilter(e, c)
	return c:IsCode(46046112)
end

function s.thcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_COST)
end

function s.thfilter2(c, e)
	return c:IsSetCard(0x6f8) and c:IsAbleToHand() and c ~= e:GetHandler()
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter2(chkc, e) end
	if chk == 0 then
		return Duel.IsExistingTarget(s.thfilter2, tp, LOCATION_GRAVE, 0, 1, nil, e)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectTarget(tp, s.thfilter2, tp, LOCATION_GRAVE, 0, 1, 1, nil, e)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, g, 1, 0, 0)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc, nil, REASON_EFFECT)
	end
end