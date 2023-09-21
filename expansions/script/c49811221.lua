--相剣大卿－干將
function c49811221.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
    c:EnableReviveLimit()
    --immune
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c49811221.imcon)
    e1:SetValue(c49811221.efilter)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_MATERIAL_CHECK)
    e2:SetValue(c49811221.valcheck)
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e2:SetCountLimit(1,49811221)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c49811221.thtg)
    e2:SetOperation(c49811221.thop)
    c:RegisterEffect(e2)
end
function c49811221.valcheck(e,c)
    local g=c:GetMaterial()
    if g:GetClassCount(Card.GetOriginalAttribute)==1 then
        e:GetLabelObject():SetLabel(1)
    else
        e:GetLabelObject():SetLabel(0)
    end
end
function c49811221.imcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function c49811221.efilter(e,re)
    return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function c49811221.thfilter(c)
    return ((c:IsLevelBelow(6) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_WYRM)) or c:IsSetCard(0x16b)) and c:IsAbleToHand()
end
function c49811221.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c49811221.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c49811221.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c49811221.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c49811221.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end