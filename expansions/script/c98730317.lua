--SDR-テンペスト
function c98730317.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(c98730317.sfilter),1)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,98730317)
    e1:SetCondition(c98730317.descon)
    e1:SetTarget(c98730317.destg)
    e1:SetOperation(c98730317.desop)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,98730317)
    e2:SetCondition(c98730317.spcon)
    e2:SetTarget(c98730317.sptg)
    e2:SetOperation(c98730317.spop)
    c:RegisterEffect(e2)
    --to hand
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,98730317)
    e3:SetTarget(c98730317.thtg)
    e3:SetOperation(c98730317.thop)
    c:RegisterEffect(e3)
    --attribute
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_PZONE)
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e4:SetValue(ATTRIBUTE_WIND)
    c:RegisterEffect(e4)
    --race
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetRange(LOCATION_PZONE)
    e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e5:SetCode(EFFECT_CHANGE_RACE)
    e5:SetValue(RACE_DRAGON)
    c:RegisterEffect(e5)
    --level&rank
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetRange(LOCATION_PZONE)
    e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e6:SetCode(EFFECT_CHANGE_LEVEL)
    e6:SetValue(7)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_CHANGE_RANK)
    c:RegisterEffect(e7)
    --xyz summon
    local e8=Effect.CreateEffect(c)
    e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e8:SetType(EFFECT_TYPE_QUICK_O)
    e8:SetCode(EVENT_FREE_CHAIN)
    e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e8:SetRange(LOCATION_PZONE)
    e8:SetCountLimit(1,98730318)
    e8:SetCondition(c98730317.lvcon)
    e8:SetTarget(c98730317.lvtg)
    e8:SetOperation(c98730317.lvop)
    c:RegisterEffect(e8)
end

--synchro material
function c98730317.sfilter(c)
    return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WIND))
end

--search
function c98730317.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA
end
function c98730317.desfilter(c)
    return c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function c98730317.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c98730317.desfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98730317.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c98730317.desfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

--spsummon
function c98730317.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
        and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c98730317.spfilter(c,e,tp)
    return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_PENDULUM)
        and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c98730317.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c98730317.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98730317.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        if not Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c98730317.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
        local tc=g:GetFirst()
        if g:GetCount()>0 then
            Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CHANGE_LEVEL)
            e1:SetValue(7)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            tc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE)
            e2:SetReset(RESET_EVENT+0x1fe0000)
            tc:RegisterEffect(e2)
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_DISABLE_EFFECT)
            e3:SetReset(RESET_EVENT+0x1fe0000)
            tc:RegisterEffect(e3)
            Duel.SpecialSummonComplete()
        end
    end
end

--to pzone
function c98730317.thfilter(c)
    return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WIND)) and c:IsType(TYPE_PENDULUM)
        and c:IsFaceup() and not c:IsForbidden()
end
function c98730317.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return e:GetHandler():IsAbleToExtra() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
        and Duel.IsExistingTarget(c10388.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c98730317.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 then
        if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,c98730317.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
        end
    end
end

--xyz summon
function c98730317.lvcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c98730317.lvfilter(c,e,tp,mc)
    return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_WIND)
        and Duel.IsExistingMatchingCard(c98730317.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,c,mc)
end
function c98730313.xyzfilter(c,tc,mc)
    local mg=Group.FromCards(tc,mc)
    return c:IsXyzSummonable(mg,2,2) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c98730317.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98730317.lvfilter(chkc,e,tp,c) end
    if chk==0 then
        if ft>0 then
            return Duel.IsExistingTarget(c98730317.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,c)
        else
            return Duel.IsExistingTarget(c98730317.lvfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,c)
        end
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    if ft>0 then
        local g=Duel.SelectTarget(tp,c98730317.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,c)
    else
        local g=Duel.SelectTarget(tp,c98730317.lvfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,c)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98730317.lvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 and tc:IsControler(1-tp) then return end
    local mg=Group.FromCards(c,tc)
    local g=Duel.GetMatchingGroup(c98730317.xyzfilter,tp,LOCATION_EXTRA,0,nil,tc,c)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local xyz=g:Select(tp,1,1,nil):GetFirst()
        Duel.XyzSummon(tp,xyz,mg)
    end
end
