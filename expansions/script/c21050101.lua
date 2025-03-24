-- 鲜花卡通女男爵
function c21050101.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    -- 0
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(21050101,0))
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(c21050101.splimit1)
    c:RegisterEffect(e0)
    -- p1
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(21050101,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCost(c21050101.spcost)
    e1:SetTarget(c21050101.sptg)
    e1:SetOperation(c21050101.spop)
    c:RegisterEffect(e1)
    -- p2
    aux.EnableChangeCode(c,15259703,LOCATION_PZONE)
    -- 1
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(21050101,2))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c21050101.target)
    e2:SetOperation(c21050101.operation)
    c:RegisterEffect(e2)
    -- 2
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(21050101,3))
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,21050101)
    e3:SetCondition(c21050101.discon)
    e3:SetTarget(c21050101.distg)
    e3:SetOperation(c21050101.disop)
    c:RegisterEffect(e3)
    -- 3
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(21050101,4))
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_DIRECT_ATTACK)
    e4:SetCondition(c21050101.dircon1)
    c:RegisterEffect(e4)
end
-- 0
function c21050101.splimit1(e,se,sp,st)
    return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
-- p1
function c21050101.cfilter(c)
    return c:IsSetCard(0x62) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c21050101.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c21050101.cfilter,tp,LOCATION_MZONE,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c21050101.cfilter,tp,LOCATION_MZONE,0,2,2,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c21050101.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21050101.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
-- 1
function c21050101.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) end,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c21050101.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) end,tp,LOCATION_GRAVE,0,1,1,nil)
    local tc=g:GetFirst()
    if tc and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
        if tc:IsType(TYPE_TOON) and Duel.GetMZoneCount(tp)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,true,false)
            and Duel.SelectYesNo(tp,aux.Stringid(21050101,5)) then
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
        end
    end
end
-- 2
function c21050101.discon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c21050101.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(21050101,6))
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c21050101.disop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
-- 3
function c21050101.cfilter1(c)
    return c:IsFaceup() and c:IsCode(15259703)
end
function c21050101.cfilter2(c)
    return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c21050101.dircon1(e)
    local tp=e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(c21050101.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
        and not Duel.IsExistingMatchingCard(c21050101.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end