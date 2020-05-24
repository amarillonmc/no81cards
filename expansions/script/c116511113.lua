function c116511113.initial_effect(c)
    c:SetSPSummonOnce(116511113)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_BECOME_TARGET)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c116511113.xyzcon1)
    e1:SetOperation(c116511113.xyzop1)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BE_BATTLE_TARGET)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c116511113.xyzcon2)
    e2:SetOperation(c116511113.xyzop2)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetCondition(c116511113.imcon)
    e3:SetValue(c116511113.efilter)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SUMMON)
    e4:SetDescription(aux.Stringid(116511113,1))
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetHintTiming(0,TIMING_END_PHASE)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCost(c116511113.cost)
    e4:SetTarget(c116511113.sumtg)
    e4:SetOperation(c116511113.sumop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetDescription(aux.Stringid(116511113,2))
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetHintTiming(0,TIMING_END_PHASE)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCost(c116511113.cost)
    e5:SetTarget(c116511113.sptg)
    e5:SetOperation(c116511113.spop)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CANNOT_TRIGGER)
    e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e6:SetTarget(c116511113.distg)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetTargetRange(1,1)
    e7:SetTarget(c116511113.sumlimit)
    c:RegisterEffect(e7)
end
function c116511113.mfilter1(c,tp,xyzc)
    return c116511113.mfilter3(c,xyzc) and c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsSetCard(0x108a) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_XYZ) and Duel.GetLocationCountFromEx(tp,tp,c,xyzc)>0
end
function c116511113.mfilter3(c,xyzc)
    return c:IsCanBeXyzMaterial(xyzc)
end
function c116511113.xyzcon1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return eg:IsExists(c116511113.mfilter1,1,nil,tp,c) and not eg:IsExists(aux.NOT(c116511113.mfilter3),1,nil,c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.IsChainDisablable(ev)
end
function c116511113.xyzop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetFlagEffect(tp,116511113)==0 and Duel.SelectYesNo(tp,aux.Stringid(116511113,0)) then
        Duel.RegisterFlagEffect(tp,116511113,RESET_CHAIN,0,1)
        local mg=Group.CreateGroup()
        local rc=re:GetHandler()
        if rc:IsDisabled() then return end
        Duel.NegateEffect(ev)
        mg:Merge(eg)
        if not rc:IsType(TYPE_TOKEN) then mg:AddCard(rc) end
        local sg=Group.CreateGroup()
        for tc in aux.Next(mg) do
            tc:CancelToGrave()
            sg:Merge(tc:GetOverlayGroup())
        end
        Duel.SendtoGrave(sg,REASON_RULE)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_SPSUMMON_PROC)
        e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
        e1:SetRange(LOCATION_EXTRA)
        e1:SetValue(SUMMON_TYPE_XYZ)
        c:RegisterEffect(e1)
        c:SetMaterial(mg)
        Duel.Overlay(c,mg)
        Duel.XyzSummon(tp,c,nil)
        e1:Reset()
    end
end
function c116511113.xyzcon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tp=e:GetHandlerPlayer()
    return eg:IsExists(c116511113.mfilter1,1,nil,tp,c) and not eg:IsExists(aux.NOT(c116511113.mfilter3),1,nil,c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false)
end
function c116511113.xyzop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false) then return end
    if Duel.GetFlagEffect(tp,116511113)==0 and Duel.SelectYesNo(tp,aux.Stringid(116511113,0)) then
        Duel.RegisterFlagEffect(tp,116511113,RESET_CHAIN,0,1)
        local mg=Group.CreateGroup()
        local rc=Duel.GetAttacker()
        Duel.NegateAttack()
        mg:Merge(eg)
        if rc:IsCanBeXyzMaterial(c) then mg:AddCard(rc) end
        local sg=Group.CreateGroup()
        for tc in aux.Next(mg) do
            tc:CancelToGrave()
            sg:Merge(tc:GetOverlayGroup())
        end
        Duel.SendtoGrave(sg,REASON_RULE)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_SPSUMMON_PROC)
        e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
        e1:SetRange(LOCATION_EXTRA)
        e1:SetValue(SUMMON_TYPE_XYZ)
        c:RegisterEffect(e1)
        c:SetMaterial(mg)
        Duel.Overlay(c,mg)
        Duel.XyzSummon(tp,c,nil)
        e1:Reset()
    end
end
function c116511113.imcon(e)
    return e:GetHandler():GetOverlayCount()>0
end
function c116511113.efilter(e,te)
    return te:IsActiveType(TYPE_TRAP)
end
function c116511113.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c116511113.sumfilter(c)
    return c:IsSetCard(0x108a) and c:IsSummonable(true,nil)
end
function c116511113.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c116511113.sumfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c116511113.sumop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,c116511113.sumfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Summon(tp,g:GetFirst(),true,nil)
    end
end
function c116511113.spfilter(c,e,tp)
    return c:IsSetCard(0x108a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c116511113.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c116511113.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c116511113.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c116511113.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c116511113.distg(e,c)
    return not c:IsSetCard(0x108a)
end
function c116511113.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsSetCard(0x108a)
end