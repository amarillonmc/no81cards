--VLiver Ushimi Ichigo
--AlphaKretin
--For Nemoma
local s = c33700411
local id = 33700411
function s.initial_effect(c)
    c:EnableReviveLimit()
    --special summon condition
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --special summon
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(s.sprcon)
    e2:SetOperation(s.sprop)
    c:RegisterEffect(e2)
    --immune
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(s.efilter)
    c:RegisterEffect(e3)
    --pierce
    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e4)
    --double
    local e5 = Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e5:SetCondition(s.damcon)
    e5:SetOperation(s.damop)
    c:RegisterEffect(e5)
    --shuffle register
    local e6 = Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_BATTLE_DAMAGE)
    e6:SetCondition(s.regcon)
    e6:SetOperation(s.regop)
    c:RegisterEffect(e6)
end
function s.spcfilter(c)
    return c:IsFaceup() and (c:GetAttack() > 2000) and c:IsAbleToGraveAsCost()
end
function s.mzfilter(c)
    return c:GetSequence() < 5
end
function s.sprcon(e, c)
    if c == nil then
        return true
    end
    local tp = c:GetControler()
    local mg = Duel.GetMatchingGroup(s.spcfilter, tp, LOCATION_MZONE, 0, nil)
    local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
    local ct = -ft + 1
    return ft > -2 and mg:GetCount() > 1 and (ft > 0 or mg:IsExists(s.mzfilter, ct, nil))
end
function s.sprop(e, tp, eg, ep, ev, re, r, rp, c)
    local mg = Duel.GetMatchingGroup(s.spcfilter, tp, LOCATION_MZONE, 0, nil)
    local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
    local g = nil
    if ft > 0 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
        g = mg:Select(tp, 2, 2, nil)
    elseif ft > -1 then
        local ct = -ft + 1
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
        g = mg:FilterSelect(tp, s.mzfilter, ct, ct, nil)
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
        local g2 = mg:Select(tp, 2 - ct, 2 - ct, g)
        g:Merge(g2)
    else
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
        g = mg:FilterSelect(tp, s.mzfilter, 2, 2, nil)
    end
    Duel.SendtoGrave(g, REASON_COST)
end
function s.efilter(e, te)
    return te:GetOwner() ~= e:GetOwner()
end
function s.damcon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():GetBattleTarget() ~= nil
end
function s.damop(e, tp, eg, ep, ev, re, r, rp)
    local dam = Duel.GetBattleDamage(ep)
    Duel.ChangeBattleDamage(ep, dam * 2)
end
function s.regcon(e, tp, eg, ep, ev, re, r, rp)
    return ep ~= tp
end
function s.regop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    --shuffle back
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_FIELD)
    e1:SetCode(EVENT_PHASE + PHASE_END)
    e1:SetCountLimit(1)
    e1:SetLabelObject(c)
    e1:SetReset(RESET_PHASE + PHASE_END)
    e1:SetOperation(s.tdop)
    Duel.RegisterEffect(e1, tp)
end
function s.tdop(e, tp, eg, ep, ev, re, r, rp)
    Duel.SendtoDeck(e:GetLabelObject(), nil, 2, REASON_EFFECT)
end
