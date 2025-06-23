-- 策略 过剩处理
local s, id = GetID()
function s.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
    --remove
    local e1 = Effect.CreateEffect(c)
  local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(s.rmcon)
    e1:SetOperation(s.rmop)
    c:RegisterEffect(e1)
    --search
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 0))
    e3:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1)
    e3:SetCost(s.thcost)
    e3:SetTarget(s.thtg)
    e3:SetOperation(s.thop)
    c:RegisterEffect(e3)
end
function s.rmfilter(c, tp)
    return c:GetPreviousControler() == tp  
        and c:GetOwner() ~= tp           
        and c:IsPreviousLocation(LOCATION_HAND) 
end
function s.rmcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(s.rmfilter, 1, nil, tp)
end
function s.rmop(e, tp, eg, ep, ev, re, r, rp)
    local g = eg:Filter(s.rmfilter, nil, tp)
    if #g > 0 then
        for tc in aux.Next(g) do
            Duel.SendtoGrave(tc, REASON_RULE, rp)
            Duel.Remove(tc, POS_FACEDOWN, REASON_EFFECT + REASON_REPLACE)
        end
    end
end
--
function s.thcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, nil) end
    Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_COST + REASON_DISCARD)
end
function s.thfilter(c)
    return c:IsSetCard(0xaa30) and c:IsAbleToHand()
end
function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil) end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end
function s.thop(e, tp, eg, ep, ev, re, r, rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
end