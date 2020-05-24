--世纪末-萨拉赛妮亚
local m=114620007
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetSPSummonOnce(m)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetCondition(cm.imcon)
    e1:SetValue(cm.efilter)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DISABLE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_HAND)
    e3:SetCode(EVENT_BECOME_TARGET)
    e3:SetCondition(cm.con)
    e3:SetTarget(cm.tg)
    e3:SetOperation(cm.op)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_BE_BATTLE_TARGET)
    e4:SetCondition(cm.con2)
    e4:SetTarget(cm.tg2)
    e4:SetOperation(cm.op2)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetCondition(cm.remcon)
    e5:SetTargetRange(1,1)
    e5:SetTarget(cm.sumlimit)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CANNOT_TRIGGER)
    e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(cm.remcon)
    e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e6:SetTarget(cm.distg)
    c:RegisterEffect(e6)
end
function cm.imcon(e)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.efilter(e,te)
    return te:IsActiveType(TYPE_TRAP)
end
function cm.spfilter(c,e,tp)
    return c:IsSetCard(0xe6f) and c:IsLevelBelow(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.filter(c)
    return c:IsSetCard(0xe6f) and c:IsLevelBelow(7) and c:IsLocation(LOCATION_MZONE)
end
function cm.tgfilter(c,tp)
    return c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsChainDisablable(ev) and eg:IsExists(cm.filter,1,nil)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g=eg:Clone()
    g:AddCard(re:GetHandler())
    if chk==0 then return g:IsExists(cm.tgfilter,1,nil,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetFlagEffect(m+1000)==0 end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    c:RegisterFlagEffect(m+1000,RESET_CHAIN,0,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local g=eg:Clone()
    g:AddCard(re:GetHandler())
    if g:IsExists(cm.tgfilter,1,nil,tp) then
        Duel.NegateEffect(ev)
        if Duel.SendtoGrave(g,REASON_EFFECT)>0 and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
            c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
            c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
        end
        Duel.SpecialSummonComplete()
    end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.filter,1,nil)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g=eg:Clone()
    g:AddCard(Duel.GetAttacker())
    if chk==0 then return g:IsExists(cm.tgfilter,1,nil,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetFlagEffect(m+1000)==0 end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    c:RegisterFlagEffect(m+1000,RESET_CHAIN,0,1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local g=eg:Clone()
    g:AddCard(Duel.GetAttacker())
    if g:IsExists(cm.tgfilter,1,nil,tp) then
        Duel.NegateAttack()
        if Duel.SendtoGrave(g,REASON_EFFECT)>0 and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
            c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
            c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
        end
        Duel.SpecialSummonComplete()
    end
end
function cm.remcon(e)
    return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsSetCard(0xe6f)
end
function cm.distg(e,c)
    return not c:IsSetCard(0xe6f)
end
