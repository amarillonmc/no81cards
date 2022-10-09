local m=4865010
local cm=_G["c"..m] 
function cm.initial_effect(c)
    --to hand or grave
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,m+1)
    e3:SetTarget(cm.destg)
    e3:SetOperation(cm.desop)
    c:RegisterEffect(e3)
end
function cm.cfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x332b) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
    local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        else
            Duel.SendtoGrave(tc,REASON_EFFECT)
        end
    end
end
function cm.desfilter(c)
    return c:IsFaceup() and c:IsLevelBelow(4) and c:IsSetCard(0x332b)
end
function cm.spfilter(c,e,tp)
    return c:IsSetCard(0x332b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.desfilter(chkc) and chkc~=c end
    if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
        and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            Duel.BreakEffect()
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
        end
    end
end