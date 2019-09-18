--Sepialife
--Scripted by AlphaKretin
--For Nemoma
local s = c33701021
local id = 33701021
function s.initial_effect(c)
    --Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    --Skip phases
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_FIELD)
    e2:SetCode(EVENT_PHASE + PHASE_STANDBY)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1)
    e2:SetOperation(s.skipop)
    c:RegisterEffect(e2)
    --recover
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_PHASE + PHASE_END)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1)
    e3:SetCondition(s.thcon)
    e3:SetTarget(s.thtg)
    e3:SetOperation(s.thop)
    c:RegisterEffect(e3)
end
function s.tgfilter(c)
    return c:IsSetCard(0x144e) and c:IsAbleToGrave()
end
function s.rescon(sg, e, tp, mg)
    return sg:GetClassCount(Card.GetCode) == #sg
end
function s.activate(e, tp, eg, ep, ev, re, r, rp)
    if not e:GetHandler():IsRelateToEffect(e) then
        return
    end
    local g = Duel.GetMatchingGroup(s.tgfilter, tp, LOCATION_DECK, 0, nil)
    if aux.SelectUnselectGroup(g, e, tp, 1, 3, s.rescon, 0) and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
        local dg = aux.SelectUnselectGroup(g, e, tp, 1, 3, s.rescon, 1, tp, HINTMSG_TOGRAVE)
        Duel.SendtoGrave(dg, REASON_EFFECT)
    end
end
function s.skipop(e, tp, eg, ep, ev, re, r, rp)
    if Duel.GetTurnPlayer() ~= tp then
        return
    end
    local c = e:GetHandler()
    local hinted = false
    if Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
        Duel.Hint(HINT_CARD, 0, id)
        hinted = true
        Duel.Hint(HINT_OPSELECTED, 1 - tp, aux.Stringid(id, 1))
        Duel.SkipPhase(tp, PHASE_MAIN1, RESET_PHASE + PHASE_END, 1)
        Duel.SkipPhase(tp, PHASE_MAIN2, RESET_PHASE + PHASE_END, 1)
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_FIELD)
        e1:SetCode(EVENT_PHASE + PHASE_END)
        e1:SetCountLimit(1)
        e1:SetOperation(s.drop)
        e1:SetReset(RESET_PHASE + PHASE_END)
        Duel.RegisterEffect(e1, tp)
    end
    if Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
        if not hinted then
            Duel.Hint(HINT_CARD, 0, id)
        end
        Duel.Hint(HINT_OPSELECTED, 1 - tp, aux.Stringid(id, 2))
        Duel.SkipPhase(tp, PHASE_BATTLE, RESET_PHASE + PHASE_END, 1)
        local e2 = Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_FIELD)
        e2:SetCode(EVENT_PHASE + PHASE_END)
        e2:SetCountLimit(1)
        e2:SetOperation(s.lpop)
        e2:SetReset(RESET_PHASE + PHASE_END)
        Duel.RegisterEffect(e2, tp)
    end
end
function s.drop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_CARD, 0, id)
    Duel.Draw(tp, 2, REASON_EFFECT)
end
function s.lpop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_CARD, 0, id)
    Duel.Recover(tp, 2000, REASON_EFFECT)
end
function s.thcon(e, tp, eg, ep, ev, re, r, rp)
    local ns, ss = Duel.GetActivityCount(tp, ACTIVITY_SUMMON, ACTIVITY_SPSUMMON)
    return ns + ss == 0
end
function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return c:IsAbleToHand()
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, c, 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_LEAVE_GRAVE, c, 1, 0, 0)
end
function s.thop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c, nil, REASON_EFFECT)
    end
end
