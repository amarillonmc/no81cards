function c98730313.initial_effect(c)
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(c98730313.synfilter),1)
    c:EnableReviveLimit()
    aux.EnablePendulumAttribute(c,false)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,98731313)
    e1:SetCondition(c98730313.effcon)
    e1:SetTarget(c98730313.efftg)
    e1:SetOperation(c98730313.effop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,98731313)
    e2:SetCondition(c98730313.spcon)
    e2:SetTarget(c98730313.sptg)
    e2:SetOperation(c98730313.spop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOEXTRA)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,98731313)
    e3:SetTarget(c98730313.mvtg)
    e3:SetOperation(c98730313.mvop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_PZONE)
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e4:SetCode(EFFECT_CHANGE_RACE)
    e4:SetValue(RACE_DRAGON)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetRange(LOCATION_PZONE)
    e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e5:SetValue(ATTRIBUTE_FIRE)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetRange(LOCATION_PZONE)
    e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e6:SetCode(EFFECT_CHANGE_LEVEL)
    e6:SetValue(7)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetRange(LOCATION_PZONE)
    e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e7:SetCode(EFFECT_CHANGE_RANK)
    e7:SetValue(7)
    c:RegisterEffect(e7)
    local e8=Effect.CreateEffect(c)
    e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e8:SetType(EFFECT_TYPE_QUICK_O)
    e8:SetRange(LOCATION_PZONE)
    e8:SetCode(EVENT_FREE_CHAIN)
    e8:SetCountLimit(1,98730313)
    e8:SetCondition(c98730313.xyzcon)
    e8:SetTarget(c98730313.xyztg)
    e8:SetOperation(c98730313.xyzop)
    c:RegisterEffect(e8)
end
function c98730313.synfilter(c)
    return c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_FIRE)
end
function c98730313.effcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c98730313.efffilter(c)
    return c:IsDestructable()
end
function c98730313.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsOnField() and c98730313.efffilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c98730313.efffilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c98730313.efffilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98730313.effop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c98730313.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
        and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c98730313.spfilter(c,e,tp)
    return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,nil,tp,false,false) and c:GetOriginalLevel()>0 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c98730313.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c98730313.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98730313.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c98730313.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g:GetCount()>0 and Duel.SpecialSummon(g,nil,tp,tp,false,false,POS_FACEUP)==1 then
        local tc=g:GetFirst()
        local e1=Effect.CreateEffect(tc)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(tc)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2,true)
        local e3=Effect.CreateEffect(tc)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CHANGE_LEVEL)
        e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e3:SetValue(7)
        e3:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e3,true)
    end
end
function c98730313.mvfilter(c)
    return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_FIRE)) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c98730313.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and c:IsAbleToExtra() and Duel.IsExistingMatchingCard(c98730313.mvfilter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
end
function c98730313.mvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.SendtoDeck(c,nil,nil,REASON_EFFECT)==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,c98730313.mvfilter,tp,LOCATION_REMOVED,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,REASON_EFFECT)
        end
    end
end
function c98730313.xyzcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c98730313.xyzfilter(c,tp,tc)
    return Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,Group.FromCards(c,tc))
end
function c98730313.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsOnField() and c98730313.xyzfilter(chkc,tp,e:GetHandler()) end
    if chk==0 then return Duel.IsExistingTarget(c98730313.xyzfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectTarget(tp,c98730313.xyzfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98730313.xyzop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local mg=Group.FromCards(c,tc)
        local g=Duel.SelectMatchingCard(tp,Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,1,nil,mg)
        if g:GetCount()>0 then
            Duel.XyzSummon(tp,g:GetFirst(),mg)
        end
    end
end