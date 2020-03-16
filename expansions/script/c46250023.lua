--骸星装-端铠
function c46250023.initial_effect(c)
    c:EnableReviveLimit()
    c:SetUniqueOnField(1,0,46250023,LOCATION_MZONE)
    aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),aux.NOT(aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK)),true)
    aux.AddContactFusionProcedure(c,Card.IsAbleToGrave,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST+REASON_MATERIAL)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,46250023)
    e3:SetTarget(c46250023.sptg)
    e3:SetOperation(c46250023.spop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e4)
    local e5=e3:Clone()
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    e6:SetCountLimit(1,146250023)
    e6:SetTarget(c46250023.tg)
    e6:SetOperation(c46250023.op)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_TOHAND)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetCode(EVENT_FREE_CHAIN)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1,246250023)
    e7:SetCost(c46250023.spcost)
    e7:SetTarget(c46250023.target)
    e7:SetOperation(c46250023.operation)
    c:RegisterEffect(e7)
end
function c46250023.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c46250023.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c46250023.filter(c)
    return c:IsSetCard(0xfc0) and c:IsAbleToHand()
end
function c46250023.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c46250023.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c46250023.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c46250023.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c46250023.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReleasable() and Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,1,1,c)
    g:AddCard(c)
    Duel.Release(g,REASON_COST)
end
function c46250023.tfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS+TYPE_FIELD) and c:IsAbleToHand()
end
function c46250023.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c46250023.tfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c46250023.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tg=Duel.GetMatchingGroup(c46250023.tfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
    if not tg or Duel.SendtoHand(tg,nil,REASON_EFFECT)==0 then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,1)
    e1:SetValue(c46250023.tgval)
    e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
    Duel.RegisterEffect(e1,tp)
end
function c46250023.tgval(e,re,rp)
    return re:IsActiveType(TYPE_CONTINUOUS+TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
