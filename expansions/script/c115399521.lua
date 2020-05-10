function c115399521.initial_effect(c)
    c:EnableReviveLimit()
    aux.EnablePendulumAttribute(c,false)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(115399521,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c115399521.pctg)
    e1:SetOperation(c115399521.pcop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(115399521,1))
    e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c115399521.sptg)
    e2:SetOperation(c115399521.spop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BECOME_TARGET)
    e3:SetRange(LOCATION_EXTRA)
    e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e3:SetCondition(c115399521.syncon1)
    e3:SetOperation(c115399521.synop1)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(115399521,3))
    e4:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCountLimit(1)
    e4:SetTarget(c115399521.eqtg)
    e4:SetOperation(c115399521.eqop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(115399521,4))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetCountLimit(1)
    e5:SetTarget(c115399521.sptg2)
    e5:SetOperation(c115399521.spop2)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(115399521,5))
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCategory(CATEGORY_CONTROL)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetTarget(c115399521.cttar)
    e6:SetOperation(c115399521.ctop)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCondition(c115399521.pencon)
    e7:SetTarget(c115399521.pentg)
    e7:SetOperation(c115399521.penop)
    c:RegisterEffect(e7)
end
function c115399521.pcfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsSetCard(0x1066) and not c:IsForbidden()
end
function c115399521.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
        and Duel.IsExistingMatchingCard(c115399521.pcfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c115399521.pcop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c115399521.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
end
function c115399521.sptgfilter(c,e,tp)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c115399521.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c115399521.spfilter(c,e,tp,tc)
    return c:IsAttribute(tc:GetAttribute()) and c:IsRace(tc:GetRace()) and c:GetLevel()==tc:GetLevel()+1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c115399521.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c115399521.sptgfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c115399521.sptgfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectTarget(tp,c115399521.sptgfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,tp,LOCATION_REMOVED)
end
function c115399521.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    local c=e:GetHandler()
    if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)>0 then
        local g=Duel.SelectMatchingCard(tp,c115399521.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
        if g:GetCount()>0 then
            local sc=g:GetFirst()
            if Duel.SpecialSummonStep(sc,nil,tp,tp,false,false,POS_FACEUP) then
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
                e1:SetCode(EFFECT_DISABLE)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                sc:RegisterEffect(e1,true)
                local e2=Effect.CreateEffect(c)
                e2:SetType(EFFECT_TYPE_SINGLE)
                e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
                e2:SetCode(EFFECT_DISABLE_EFFECT)
                e2:SetReset(RESET_EVENT+RESETS_STANDARD)
                sc:RegisterEffect(e2,true)
                sc:RegisterFlagEffect(115399521,RESET_EVENT+RESETS_STANDARD,0,1)
                local e3=Effect.CreateEffect(e:GetHandler())
                e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
                e3:SetCode(EVENT_PHASE+PHASE_END)
                e3:SetCountLimit(1)
                e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
                e3:SetLabelObject(sc)
                e3:SetCondition(c115399521.descon)
                e3:SetOperation(c115399521.desop)
                Duel.RegisterEffect(e3,tp)
            end
        end
    end
end
function c115399521.descon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:GetFlagEffect(115399521)~=0 then
        return true
    else
        e:Reset()
        return false
    end
end
function c115399521.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.Destroy(tc,REASON_EFFECT)
end
function c115399521.mfilter1(c,tp,tc)
    return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsType(TYPE_TUNER) and Duel.GetLocationCountFromEx(tp,tp,c,tc)>0 and c:IsDestructable()
end
function c115399521.mfilter2(c,e,tp)
    return c:IsSetCard(0x1066) and not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,nil,tp,false,false)
end
function c115399521.syncon1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsFacedown() and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,false) and eg:IsExists(c115399521.mfilter1,1,nil,tp,c) and Duel.IsExistingMatchingCard(c115399521.mfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE+LOCATION_SZONE,0,1,nil,115399521) and re:GetHandler():IsSetCard(0x1066) and re:GetHandler():IsType(TYPE_MONSTER)
end
function c115399521.synop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetFlagEffect(tp,115399521)==0 and Duel.SelectYesNo(tp,aux.Stringid(115399521,2)) then
        Duel.RegisterFlagEffect(tp,115399521,RESET_CHAIN,0,1)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c115399521.mfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        if g:GetCount()>0 and Duel.SpecialSummon(g,nil,tp,tp,false,false,POS_FACEUP)>0 then
            local lv=g:GetFirst():GetLevel()+eg:GetFirst():GetLevel()
            g:Merge(eg)
            if Duel.Destroy(g,REASON_COST)<=0 then return end
            local e0=Effect.CreateEffect(c)
            e0:SetType(EFFECT_TYPE_FIELD)
            e0:SetCode(EFFECT_SPSUMMON_PROC)
            e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
            e0:SetRange(LOCATION_EXTRA)
            e0:SetValue(SUMMON_TYPE_SYNCHRO)
            c:RegisterEffect(e0)
            Duel.SynchroSummon(tp,c,nil)
            e0:Reset()
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CHANGE_LEVEL)
            e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
            e1:SetRange(LOCATION_MZONE)
            e1:SetValue(lv)
            e1:SetReset(RESET_EVENT+0xff0000)
            c:RegisterEffect(e1)
            Duel.BreakEffect()
            Duel.ChangeTargetCard(ev,Group.FromCards(c))
        end
    end
end
function c115399521.eqfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1066) and not c:IsForbidden()
end
function c115399521.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c115399521.eqfilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c115399521.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c115399521.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c115399521.eqop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
        if not Duel.Equip(tp,tc,c,false) then return end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(c115399521.eqlimit)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_EQUIP)
        e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
        e2:SetCode(EFFECT_UPDATE_ATTACK)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        e2:SetValue(tc:GetTextAttack())
        tc:RegisterEffect(e2)
    end
end
function c115399521.eqlimit(e,c)
    return e:GetOwner()==c
end
function c115399521.spfilter2(c,e,tp,ec)
    return c:IsSetCard(0x1066) and c:GetEquipTarget()==ec and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c115399521.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c115399521.spfilter2(chkc,e,tp,e:GetHandler()) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c115399521.spfilter2,tp,LOCATION_SZONE,0,1,nil,e,tp,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c115399521.spfilter2,tp,LOCATION_SZONE,0,1,1,nil,e,tp,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c115399521.spop2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c115399521.ctffilter(c,att,rc,lv)
    return c:IsControlerCanBeChanged() and c:IsFaceup() and c:IsAttribute(att) and c:IsRace(rc) and (c:GetLevel()==lv or c:GetRank()==lv)
end
function c115399521.ctfilter(c,tp)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1066) and c:IsReleasable()
        and Duel.IsExistingTarget(c115399521.ctffilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttribute(),c:GetRace(),c:GetLevel())
end
function c115399521.cttar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingMatchingCard(c115399521.ctfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local sg=Duel.SelectMatchingCard(tp,c115399521.ctfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
    local sc=sg:GetFirst()
    local att=sc:GetAttribute()
    local rc=sc:GetRace()
    local lv=sc:GetLevel()
    Duel.Release(sg,REASON_COST)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,c115399521.ctffilter,tp,0,LOCATION_MZONE,1,1,nil,att,rc,lv)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c115399521.ctop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.GetControl(tc,tp)
    end
end
function c115399521.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c115399521.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c115399521.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
end