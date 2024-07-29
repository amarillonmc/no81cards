--屋敷童之馆
local m=89400005
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddCodeList(c,89400000)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DEFENSE_ATTACK)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(cm.atktg)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_CHAIN_SOLVING)
    e5:SetRange(LOCATION_FZONE)
    e5:SetCondition(cm.discon)
    e5:SetOperation(cm.disop)
    c:RegisterEffect(e5)
end
function cm.spfilter2(c,ft,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsAttack(0) and c:IsDefense(1800) and (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        return Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,ft,e,tp)
    end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,ft,e,tp)
    if g:GetCount()>0 then
        local th=g:GetFirst():IsAbleToHand() and g:GetFirst():IsLocation(LOCATION_GRAVE)
        local sp=ft>0 and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false)
        local op=0
        if th and sp then op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
        elseif th then op=0
        else op=1 end
        local tc=g:GetFirst()
        if op==0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        else
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
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
function cm.splimit(e,c)
    return not c:IsAttack(0)
end
function cm.atktg(e,c)
    return c:IsAttack(0)
end
function cm.disfilter(c)
    return c:IsAttack(0) and c:IsDefense(1800) and c:IsFaceup()
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    return Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_MZONE,0,1,nil) and re:IsActiveType(TYPE_MONSTER) and not (rc:IsAttack(0) or rc:IsDefenseBelow(1800))
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end
