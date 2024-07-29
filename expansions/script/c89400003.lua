--花水木之芬芳
local m=89400003
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddCodeList(c,89400000)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
    e1:SetCost(cm.cost)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,m+10000)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
end
function cm.filter(c)
    return (c:IsType(TYPE_MONSTER) and c:IsAttack(0) and c:IsDefense(1800) or aux.IsCodeListed(c,89400000) and c:IsType(TYPE_SPELL+TYPE_TRAP))
end
function cm.cfilter(c)
    return c:IsDiscardable() and cm.filter(c)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,cm.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
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
function cm.splimit(e,c)
    return not c:IsAttack(0)
end
function cm.spfilter(c,ft,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsAttack(0) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,ft,e,tp)
    end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,ft,e,tp)
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
            Duel.Recover(1-tp,tc:GetBaseDefense(),REASON_EFFECT)
        else
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
            Duel.Recover(1-tp,tc:GetBaseDefense(),REASON_EFFECT)
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
