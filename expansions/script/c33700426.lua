--True Form Revealed!
--AlphaKretin
--For Nemoma
local s = c33700426
local id = 33700426
function s.initial_effect(c)
    --Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE + CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0, 0x1c0)
    e1:SetTarget(s.negtg)
    e1:SetOperation(s.negop)
    c:RegisterEffect(e1)
end
function s.negtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingTarget(aux.TRUE, tp, 0, LOCATION_MZONE, 1, nil)
    end
    if Duel.GetFieldGroupCount(tp, 0, LOCATION_MZONE) > Duel.GetFieldGroupCount(tp, LOCATION_MZONE, 0) then
        e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_CANNOT_NEGATE)
    else
        e:SetProperty(0)
    end
    Duel.SetOperationInfo(0, CATEGORY_DISABLE, nil, 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_ATKCHANGE, nil, 1, 0, 0)
end
function s.lkfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function s.nlkfilter(c)
    return c:IsFaceup() and not c:IsType(TYPE_LINK)
end
function s.lvval(c)
    return math.max(c:GetLevel(), c:GetRank())
end
function s.negop(e, tp, eg, ep, ev, re, r, rp)
    local lg = Duel.GetMatchingGroup(s.lkfilter, tp, 0, LOCATION_MZONE, nil)
    local og = Duel.GetMatchingGroup(s.nlkfilter, tp, 0, LOCATION_MZONE, nil)
    local tc
    if #lg > 0 then
        tc = lg:GetMaxGroup(Card.GetLink):Select(1 - tp, 1, 1, nil):GetFirst()
    else
        tc = Duel.GetMaxGroup(s.lvval):Select(1 - tp, 1, 1, nil):GetFirst()
    end
    if tc then
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2 = e1:Clone()
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        tc:RegisterEffect(e2)
        if tc:IsType(TYPE_TRAPMONSTER) then
            local e3 = e1:Clone()
            e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
            tc:RegisterEffect(e3)
        end
        local e4 = e1:Clone()
        e4:SetCode(EFFECT_SET_ATTACK_FINAL)
        e4:SetValue(0)
        tc:RegisterEffect(e4)
        local e5 = e4:Clone()
        e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
        tc:RegisterEffect(e5)
        e:SetLabelObject(tc)
        local e6 = Effect.CreateEffect(c)
        e6:SetType(EFFECT_TYPE_IGNITION + EFFECT_TYPE_CONTINUOUS)
        e6:SetRange(LOCATION_MZONE)
        e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e6:SetTarget(s.eftg)
        e6:SetOperation(s.efop)
        e6:SetReset(RESET_EVENT + RESETS_STANDARD)
        tc:RegisterEffect(e6)
    end
end

function s.effilter(c, oc)
    local lv = math.max(oc:GetLevel(), oc:GetRank(), oc:GetLink())
    return c:IsRace(oc:GetRace()) and c:IsAttribute(oc:GetAttribute()) and c:IsLevelBelow(lv - 1) and c:IsAbleToRemove()
end

function s.eftg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if ckh == 0 then
        return Duel.IsExistingMatchingCard(s.effilter, tp, LOCATION_DECK, 0, 1, nil, c)
    end
end

function s.efop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectMatchingCard(tp, s.effilter, tp, LOCATION_DECK, 0, 1, nil, c)
    if #g > 0 and Duel.Remove(g, POS_FACEUP, REASON_EFFECT) ~= 0 then
    end
end
