--岁星龙-喜
function c46260000.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c46260000.rtg)
    e1:SetOperation(c46260000.rop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(46260000,0))
    e2:SetCategory(CATEGORY_DRAW+CATEGORY_RELEASE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
    e2:SetCost(c46260000.cost)
    e2:SetTarget(c46260000.target)
    e2:SetOperation(c46260000.operation)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(46260000,1))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCost(c46260000.thcost)
    e3:SetTarget(c46260000.thtg)
    e3:SetOperation(c46260000.thop)
    c:RegisterEffect(e3)
end
function c46260000.mfilter(c,e)
    return c:IsFaceup() and c:GetLevel()>0 and not c:IsImmuneToEffect(e) and c:IsReleasable()
end
function c46260000.mfilter2(c,tc,tp)
    if c:IsControler(tp) and c:GetSequence()<5 or Duel.GetMZoneCount(tp)>0 then return c:GetRitualLevel(tc) else return 0 end
end
function c46260000.filter(c,e,tp,m)
    if bit.band(c:GetOriginalType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
    return mg:CheckWithSumGreater(c46260000.mfilter2,c:GetLevel(),c,tp)
end
function c46260000.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg1=Duel.GetRitualMaterial(tp)
        mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
        local mg2=Duel.GetMatchingGroup(c46260000.mfilter,tp,0,LOCATION_MZONE,nil,e)
        mg1:Merge(mg2)
        return Duel.IsExistingMatchingCard(c46260000.filter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,nil,e,tp,mg1)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_PZONE)
end
function c46260000.rop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local mg1=Duel.GetRitualMaterial(tp)
    mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
    local mg2=Duel.GetMatchingGroup(c46260000.mfilter,tp,0,LOCATION_MZONE,nil,e)
    mg1:Merge(mg2)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,c46260000.filter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,1,nil,e,tp,mg1)
    local tc=tg:GetFirst()
    if tc then
        local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local mat=mg:SelectWithSumGreater(tp,c46260000.mfilter2,tc:GetLevel(),tc,tp)
        tc:SetMaterial(mat)
        Duel.ReleaseRitualMaterial(mat)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
function c46260000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReleasable() end
    Duel.Release(c,REASON_COST)
end
function c46260000.drfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsReleasableByEffect()
end
function c46260000.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c46260000.drfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetOperationInfo(0,CATEGORY_RELEASE,0,1,tp,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c46260000.operation(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c46260000.drfilter,tp,LOCATION_HAND,0,1,1,nil)
    if g and Duel.Release(g,REASON_EFFECT)==1 then
        Duel.Draw(tp,2,REASON_EFFECT)
    end
end
function c46260000.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,IsReleasable,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function c46260000.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c46260000.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end
