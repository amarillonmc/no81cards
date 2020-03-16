--荧惑龙-慰
function c46260002.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c46260002.rtg)
    e1:SetOperation(c46260002.rop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(46260002,0))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_RELEASE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCost(c46260002.cost)
    e2:SetTarget(c46260002.target)
    e2:SetOperation(c46260002.operation)
    c:RegisterEffect(e2)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(46260002,1))
    e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e4:SetCode(EVENT_CHAINING)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e4:SetCountLimit(1,46260002)
    e4:SetCondition(c46260002.negcon)
    e4:SetCost(c46260002.negcost)
    e4:SetTarget(c46260002.negtg)
    e4:SetOperation(c46260002.negop)
    c:RegisterEffect(e4)
end
c46260002.fit_monster={46260003}
function c46260002.mfilter(c,e)
    return c:GetLevel()>0 and not c:IsImmuneToEffect(e) and c:IsReleasable()
end
function c46260002.mfilter2(c,tc)
    return c:GetRitualLevel(tc)>=tc:GetLevel()
end
function c46260002.filter(c,e,tp,m)
    if bit.band(c:GetOriginalType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
    return mg:IsExists(Card.GetRitualLevel,1,nil,c)
end
function c46260002.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
        local mg1=Duel.GetRitualMaterial(tp)
        local mg2=Duel.GetMatchingGroup(c46260002.mfilter,tp,LOCATION_EXTRA,0,nil,e)
        mg1:Merge(mg2)
        return Duel.IsExistingMatchingCard(c46260002.filter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,nil,e,tp,mg1)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_PZONE)
end
function c46260002.rop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local mg1=Duel.GetRitualMaterial(tp)
    Duel.ConfirmCards(tp,Duel.GetFieldGroup(tp,0,LOCATION_HAND))
    local mg2=Duel.GetMatchingGroup(c46260002.mfilter,tp,LOCATION_EXTRA,LOCATION_HAND,nil,e)
    mg1:Merge(mg2)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,c46260002.filter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,1,nil,e,tp,mg1)
    local tc=tg:GetFirst()
    if tc then
        local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc):Filter(c46260002.mfilter2,nil,tc)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local mat=mg:Select(tp,1,1,nil)
        Duel.ShuffleHand(1-tp)
        tc:SetMaterial(mat)
        local mat1=mat:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
        mat:Sub(mat1)
        Duel.SendtoGrave(mat1,REASON_RELEASE+REASON_EFFECT)
        Duel.ReleaseRitualMaterial(mat)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
function c46260002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReleasable() end
    Duel.Release(c,REASON_COST)
end
function c46260002.drfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsReleasableByEffect()
end
function c46260002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
    if chk==0 then return Duel.IsExistingMatchingCard(c46260002.drfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_RELEASE,0,1,tp,LOCATION_HAND)
end
function c46260002.operation(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c46260002.drfilter,tp,LOCATION_HAND,0,1,1,nil)
    if g and Duel.Release(g,REASON_EFFECT)==1 then
        g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
        local tg=g:Filter(Card.IsRelateToEffect,nil,e)
        if tg:GetCount()>0 then
            Duel.Destroy(tg,REASON_EFFECT)
        end
    end
end
function c46260002.negcon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:GetHandler()~=e:GetHandler() and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c46260002.cfilter(c)
    return c:IsType(TYPE_MONSTER) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c46260002.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroupEx(tp,c46260002.cfilter,1,nil) end
    local g=Duel.SelectReleaseGroupEx(tp,c46260002.cfilter,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function c46260002.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    local rc=re:GetHandler()
    if rc:IsDestructable() and rc:IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
    end
end
function c46260002.negop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateActivation(ev)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,POS_FACEUP,REASON_EFFECT)
    end
end
