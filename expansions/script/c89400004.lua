--小夜时雨之月
local m=89400004
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddCodeList(c,89400000)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
    e1:SetCost(cm.cost)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,m+10000)
    e2:SetCost(cm.tkcost2)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
end
function cm.filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAttack(0) and c:IsDefense(1800) or aux.IsCodeListed(c,89400000) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.cfilter(c,e,tp)
    return c:IsAbleToRemoveAsCost() and cm.filter(c) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.spfilter(c,e,tp)
    return c:IsAttack(0) and c:IsDefense(1800) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        local fid=e:GetHandler():GetFieldID()
        tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetLabel(fid)
        e1:SetLabelObject(tc)
        e1:SetCondition(cm.thcon)
        e1:SetOperation(cm.thop)
        Duel.RegisterEffect(e1,tp)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_SUMMON)
    Duel.RegisterEffect(e2,tp)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:GetFlagEffectLabel(m)~=e:GetLabel() then
        e:Reset()
        return false
    else return true end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end
function cm.splimit(e,c)
    return not c:IsAttack(0)
end
function cm.tkcsfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAttack(0) and c:IsAbleToRemoveAsCost()
end
function cm.tkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tkcsfilter,tp,LOCATION_HAND,0,1,nil) and c:IsAbleToRemoveAsCost() end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.tkcsfilter,tp,LOCATION_HAND,0,1,1,nil)
    g:AddCard(c)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.spfilter2(c,ft,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsAttack(0) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        return Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_DECK,0,1,nil,ft,e,tp)
    end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_DECK,0,1,1,nil,ft,e,tp)
    if g:GetCount()>0 then
        local th=g:GetFirst():IsAbleToHand()
        local sp=ft>0 and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false)
        local op=0
        if th and sp then op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
        elseif th then op=0
        else op=1 end
        local tc=g:GetFirst()
        if op==0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
            Duel.Damage(tp,tc:GetBaseDefense(),REASON_EFFECT)
        else
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
            Duel.Damage(tp,tc:GetBaseDefense(),REASON_EFFECT)
            local fid=e:GetHandler():GetFieldID()
            tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(EVENT_PHASE+PHASE_END)
            e1:SetCountLimit(1)
            e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
            e1:SetLabel(fid)
            e1:SetLabelObject(tc)
            e1:SetCondition(cm.thcon)
            e1:SetOperation(cm.thop)
            Duel.RegisterEffect(e1,tp)
        end
    end
end
