--Sepialife - Empty Aubade
--Scripted by AlphaKretin
--For Nemoma
local s = c33701017
local id = 33701017
function s.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c, nil, 2, 2, s.lcheck)
    --special summon self
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_PHASE + PHASE_END)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCountLimit(1)
    e1:SetCondition(s.spcon)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --negate
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
--	e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
    e2:SetOperation(s.negop)
    c:RegisterEffect(e2)
    --special summon other
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(s.sptg2)
    e3:SetOperation(s.spop2)
    c:RegisterEffect(e3)
end
function s.lcheck(g, lc, tp)
    return g:IsExists(Card.IsLinkSetCard, 1, nil, 0x144e)
end
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    local ns, ss = Duel.GetActivityCount(tp, ACTIVITY_SUMMON, ACTIVITY_SPSUMMON)
    return Duel.GetTurnPlayer() == tp and ns + ss == 0
end
function s.spfilter(c)
    return c:IsSetCard(0x144e) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
--function s.MZFilter(c, tp)
--    return c:IsLocation(LOCATION_MZONE) and c:GetSequence() < 5 and c:IsControler(tp)
--end
--function s.ChkfMMZ(sumcount)
--    return function(sg, e, tp, mg)
--        return sg:FilterCount(s.MZFilter, nil, tp) + Duel.GetLocationCount(tp, LOCATION_MZONE) >= sumcount
--    end
--end
function s.spcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,nil) end
--    if chk == 0 then
--        return Duel.GetLocationCount(tp, LOCATION_MZONE) > -2 and #rg > 1 and
--            rg:CheckSubGroup(s.ChkfMMZ(1), 2, 2, tp) 
--    end
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return c:IsCanBeSpecialSummoned(e, 0, tp, true, true)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 1, tp, tp, true, true, POS_FACEUP) ~= 0 then
        c:CompleteProcedure()
--        c:RegisterFlagEffect(id, RESET_EVENT + RESETS_STANDARD, 0, 0)
    end
end
function s.negop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:GetSummonType()==SUMMON_TYPE_SPECIAL+1 then return end
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0, LOCATION_ONFIELD)
	e1:SetTarget(s.disable)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e1:SetLabel(c:GetFieldID())
	Duel.RegisterEffect(e1, tp)
end
function s.disable(e,c)
    return c:GetFieldID()~=e:GetLabel() and (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))
end
function s.spfilter2(c, e, tp, zone)
    return c:IsSetCard(0x144e) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEUP, tp, zone)
end
function s.sptg2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        local zone = e:GetHandler():GetLinkedZone(tp)
        return zone ~= 0 and Duel.IsExistingMatchingCard(s.spfilter2, tp, LOCATION_REMOVED, 0, 1, nil, e, tp, zone)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_REMOVED)
end
function s.spop2(e, tp, eg, ep, ev, re, r, rp)
    local zone = e:GetHandler():GetLinkedZone(tp)
    if zone == 0 then
        return
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, s.spfilter2, tp, LOCATION_REMOVED, 0, 1, 1, nil, e, tp, zone)
    if #g > 0 then
        Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP, zone)
    end
end
