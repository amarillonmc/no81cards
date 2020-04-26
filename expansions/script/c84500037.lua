--觉醒魔法阵
local m=84500037
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCondition(cm.limcon)
    e3:SetOperation(cm.limop)
    c:RegisterEffect(e3)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetRange(LOCATION_FZONE)
    e5:SetCode(EVENT_CHAIN_END)
    e5:SetOperation(cm.limop2)
    c:RegisterEffect(e5)
end
function cm.thfilter(c,e,tp)
    return c:IsCode(84500026) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,e,tp)
    if g:GetCount()>0 and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:GetFirst()
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.limfilter(c,tp)
    return c:GetSummonPlayer()==tp and c:IsType(TYPE_RITUAL)
end
function cm.limcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.limfilter,1,nil,tp)
end
function cm.limop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetCurrentChain()==0 then
        Duel.SetChainLimitTillChainEnd(cm.chainlm)
    elseif Duel.GetCurrentChain()==1 then
        e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
    end
end
function cm.limop2(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():GetFlagEffect(m)~=0 then
        Duel.SetChainLimitTillChainEnd(cm.chainlm)
    end
    e:GetHandler():ResetFlagEffect(m)
end
function cm.chainlm(e,rp,tp)
    return tp==rp
end