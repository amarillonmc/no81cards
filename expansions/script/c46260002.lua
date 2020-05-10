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
function c46260002.spfilter(c,e,tp,mc)
    return bit.band(c:GetOriginalType(),0x81)==0x81 and (not c.mat_filter or c.mat_filter(mc,tp)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and mc:IsCanBeRitualMaterial(c)
end
function c46260002.rfilter(c,mc)
    local mlv=mc:GetRitualLevel(c)
    if mlv==mc:GetLevel() then return false end
    local lv=c:GetLevel()
    return lv==bit.band(mlv,0xffff) or lv==bit.rshift(mlv,16)
end
function c46260002.rfilter2(c,mc,n)
    if not n then n=0 end
    return mc:GetRitualLevel(c)-n>=c:GetLevel()
end
function c46260002.filter(c,e,tp)
    local sg=Duel.GetMatchingGroup(c46260002.spfilter,tp,LOCATION_HAND+LOCATION_PZONE,0,c,e,tp,c)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if c:IsLocation(LOCATION_MZONE) then ft=ft+1 end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end 
    return sg:IsExists(c46260002.rfilter,1,nil,c) or sg:IsExists(c46260002.rfilter2,1,nil,c)
end
function c46260002.mfilter(c,tp)
    return c:GetLevel()>0 and c:IsReleasable()
end
function c46260002.mzfilter(c)
    return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:GetSequence()<5
end
function c46260002.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        if ft<0 then return false end
        local mg=Duel.GetRitualMaterial(tp)
        if ft>0 then
            local mg2=Duel.GetMatchingGroup(c46260002.mfilter,tp,LOCATION_EXTRA,0,nil)
            mg:Merge(mg2)
        else
            mg=mg:Filter(c46260002.mzfilter,nil,tp)
        end
        return mg:IsExists(c46260002.filter,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_PZONE)
end
function c46260002.rop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<0 then return end
    local mg=Duel.GetRitualMaterial(tp)
    if ft>0 then
        local mg2=Duel.GetMatchingGroup(c46260002.mfilter,tp,LOCATION_EXTRA,0,nil)
        mg:Merge(mg2)
    else
        mg=mg:Filter(c46260002.mzfilter,nil,LOCATION_MZONE)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local mat=mg:FilterSelect(tp,c46260002.filter,1,1,nil,e,tp)
    local mc=mat:GetFirst()
    if not mc then return end
    local sg=Duel.GetMatchingGroup(c46260002.spfilter,tp,LOCATION_HAND+LOCATION_PZONE,0,mc,e,tp,mc)
    if mc:IsLocation(LOCATION_MZONE) then ft=ft+1 end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    local b1=sg:IsExists(c46260002.rfilter,1,nil,mc)
    local b2=sg:IsExists(c46260002.rfilter2,1,nil,mc)
    if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(46260002,2))) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:FilterSelect(tp,c46260002.rfilter,1,1,nil,mc)
        local tc=tg:GetFirst()
        tc:SetMaterial(mat)
        Duel.ReleaseRitualMaterial(mat)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    else
        local tg=Group.CreateGroup()
        local n=0
        while n<mc:GetLevel() and tg:GetCount()<ft and (n==0 or sg:IsExists(c46260002.rfilter2,1,nil,mc,n) and Duel.SelectYesNo(tp,210)) do
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local rc=sg:FilterSelect(tp,c46260002.rfilter2,1,1,nil,mc,n):GetFirst()
            tg:AddCard(rc)
            n=n+rc:GetLevel()
            sg:RemoveCard(rc)
        end
        local tc=tg:GetFirst()
        for tc in aux.Next(tg) do
            tc:SetMaterial(mat)
        end
        Duel.SendtoGrave(mat,REASON_RELEASE+REASON_EFFECT+REASON_RITUAL)
        Duel.BreakEffect()
        for tc in aux.Next(tg) do
            Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
            tc:CompleteProcedure()
        end
        Duel.SpecialSummonComplete()
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
