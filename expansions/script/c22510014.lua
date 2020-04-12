--机械放电
function c22510014.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(22510014,0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e2:SetCondition(c22510014.discon)
    e2:SetTarget(c22510014.distg)
    e2:SetOperation(c22510014.disop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetDescription(aux.Stringid(22510014,1))
    e3:SetType(EFFECT_TYPE_ACTIVATE)
    c:RegisterEffect(e3)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e6:SetCondition(c22510014.handcon)
    c:RegisterEffect(e6)
end
function c22510014.discon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsChainDisablable(ev) and rp~=tp
end
function c22510014.filter(c,e,tp)
    return c:IsSetCard(0xec0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22510014.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22510014.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c22510014.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c22510014.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c22510014.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
        Duel.NegateEffect(ev)
    end
end
function c22510014.handcon(e)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==5
end
