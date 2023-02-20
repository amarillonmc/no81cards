--十二獣の相生
function c114606001.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c114606001.target)
    e1:SetOperation(c114606001.operation)
    c:RegisterEffect(e1)
    --material
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(c114606001.matcon)
    e2:SetTarget(c114606001.mattg)
    e2:SetOperation(c114606001.matop)
    c:RegisterEffect(e2)
    --tohand
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCost(c114606001.thcost)
    e3:SetTarget(c114606001.thtg)
    e3:SetOperation(c114606001.thop)
    c:RegisterEffect(e3)
end
function c114606001.filter(c,e,tp)
    return c:IsSetCard(0xf1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c114606001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c114606001.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c114606001.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c114606001.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c114606001.eqlimit(e,c)
    return e:GetOwner()==c
end
function c114606001.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
        if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
        Duel.Equip(tp,c,tc)
        --Add Equip limit
        local e1=Effect.CreateEffect(tc)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(c114606001.eqlimit)
        c:RegisterEffect(e1)
    end
end

function c114606001.matcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=c:GetPreviousEquipTarget()
    return c:IsReason(REASON_LOST_TARGET) and c:IsReason(REASON_DESTROY) and tc:IsLocation(LOCATION_OVERLAY)
end
function c114606001.matfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xf1) and c:IsType(TYPE_XYZ)
end
function c114606001.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c114606001.matfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c114606001.matfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c114606001.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c114606001.matop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
        Duel.Overlay(tc,Group.FromCards(c))
    end
end

function c114606001.cfilter(c)
    return c:IsSetCard(0xf1) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c114606001.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==12 then
        local g=Duel.GetMatchingGroup(c114606001.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
        if chk==0 then return g:GetCount()>0 end
        local tg=g:Select(tp,1,1,nil)
        Duel.SendtoGrave(tg,REASON_COST)
    else
        local g=Duel.GetMatchingGroup(c114606001.cfilter,tp,LOCATION_HAND,0,nil)
        if chk==0 then return g:GetCount()>0 end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local tg=g:Select(tp,1,1,nil)
        Duel.SendtoGrave(tg,REASON_COST)
    end
end
function c114606001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c114606001.thop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
    end
end
