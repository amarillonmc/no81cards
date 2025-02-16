local s, id = GetID()

function s.initial_effect(c)
    --activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE + CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1, id)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    --search
    local e2 = Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCountLimit(1, id)
    e2:SetCondition(s.thcon)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)
end

-- 修改后的筛选函数，加入怪兽筛选、相同卡名最多1张的限制
function s.rmfilter(c, g)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf80) and ((not c:IsLocation(LOCATION_MZONE) or c:IsFaceup()) and c:IsAbleToRemove())
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
		local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_GRAVE,0,nil)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.rmfilter, tp, LOCATION_HAND + LOCATION_GRAVE + LOCATION_MZONE, 0, 1, nil, nil)
            and Duel.IsExistingMatchingCard(nil, tp, 0, LOCATION_ONFIELD, 1, nil)
    and g:GetClassCount(Card.GetCode)>=2
    end
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 1, tp, LOCATION_HAND + LOCATION_GRAVE + LOCATION_MZONE)
    local g = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_ONFIELD, nil)
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, g, 1, 0, 0)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
    local dg = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_ONFIELD, nil)
    local ct = dg:GetCount()
    local g = Duel.GetMatchingGroup(s.rmfilter, tp, LOCATION_HAND + LOCATION_GRAVE + LOCATION_MZONE, 0, nil, nil)
    if ct == 0 or g:GetCount() == 0 then
        return
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    aux.GCheckAdditional = aux.dlvcheck
    local rg = g:SelectSubGroup(tp, aux.TRUE, false, 1, ct)
    aux.GCheckAdditional = nil
    local rc = Duel.Remove(rg, POS_FACEUP, REASON_EFFECT)
    if rc > 0 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
        local sg = dg:Select(tp, rc, rc, nil)
        Duel.HintSelection(sg)
        Duel.Remove(sg, POS_FACEUP, REASON_EFFECT)
    end
end

function s.thcon(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    return bit.band(r, REASON_EFFECT) ~= 0
end

function s.thfilter(c)
    return c:IsType(TYPE_SPELL + TYPE_TRAP) and c:IsSetCard(0xf80) and c:IsAbleToHand()
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if g:GetCount() > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
end