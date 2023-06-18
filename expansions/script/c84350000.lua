--魔女工艺·恩底弥翁的珍妮
function c84350000.initial_effect(c)
--Pendulum Summon
    c:EnableCounterPermit(0x1,LOCATION_PZONE+LOCATION_MZONE)
    aux.EnablePendulumAttribute(c)
    c:SetSPSummonOnce(84350000)
    --Add Counter
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e1:SetCode(EVENT_CHAINING)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetOperation(aux.chainreg)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EVENT_CHAIN_SOLVED)
    e2:SetRange(LOCATION_PZONE)
    e2:SetOperation(c84350000.counterop)
    c:RegisterEffect(e2)
    --Special Summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(84350000,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCost(c84350000.spcost)
    e3:SetTarget(c84350000.sptg)
    e3:SetOperation(c84350000.spop)
    c:RegisterEffect(e3)
    --Remove counter replace
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(84350000,0))
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_RCOUNTER_REPLACE+0x1)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c84350000.rcon)
    e4:SetOperation(c84350000.rop)
    c:RegisterEffect(e4)
    --Special Summon2
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(84350000,0))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetHintTiming(0,TIMING_MAIN_END)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,84350000)
    e5:SetCondition(c84350000.sspcon)
    e5:SetCost(c84350000.sspcost)
    e5:SetTarget(c84350000.ssptg)
    e5:SetOperation(c84350000.sspop)
    c:RegisterEffect(e5)
    --move
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetProperty(EFFECT_FLAG_DELAY)
    e6:SetCode(EVENT_BE_MATERIAL)
    e6:SetCountLimit(1,84320000)
    e6:SetCondition(c84350000.pencon)
    e6:SetTarget(c84350000.pentg)
    e6:SetOperation(c84350000.penop)
    c:RegisterEffect(e6)
end
function c84350000.counterop(e,tp,eg,ep,ev,re,r,rp)
    if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
        e:GetHandler():AddCounter(0x1,1)
    end
end
function c84350000.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1,3,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x1,3,REASON_COST)
end
function c84350000.spfilter(c,e,tp)
    return c:IsSetCard(0x128) and not c:IsCode(84350000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84350000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c84350000.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,2,tp,LOCATION_DECK)
end
function c84350000.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c84350000.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        g:AddCard(c)
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c84350000.rcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActivated() and bit.band(r,REASON_COST)~=0 and ep==e:GetOwnerPlayer() and e:GetHandler():GetCounter(0x1)>=ev
end
function c84350000.rop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RemoveCounter(ep,0x1,ev,REASON_EFFECT)
end
function c84350000.sspcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c84350000.costfilter(c,tp)
    if c:IsLocation(LOCATION_HAND) then return c:IsType(TYPE_SPELL) and c:IsDiscardable() end
    return c:IsFaceup() and c:IsAbleToGraveAsCost() and c:IsHasEffect(83289866,tp)
end
function c84350000.sspcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable()
        and Duel.IsExistingMatchingCard(c84350000.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil,tp) end
    local g=Duel.GetMatchingGroup(c84350000.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,nil,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local tc=g:Select(tp,1,1,nil):GetFirst()
    local te=tc:IsHasEffect(83289866,tp)
    if te then
        te:UseCountLimit(tp)
        Duel.Release(e:GetHandler(),REASON_COST)
        Duel.SendtoGrave(tc,REASON_COST)
    else
        Duel.Release(e:GetHandler(),REASON_COST)
        Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
    end
end
function c84350000.sspfilter(c,e,tp)
    return c:IsSetCard(0x128) and not c:IsCode(84350000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84350000.ssptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
        and Duel.IsExistingMatchingCard(c84350000.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c84350000.sspop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c84350000.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c84350000.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()
end
function c84350000.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c84350000.penop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
end