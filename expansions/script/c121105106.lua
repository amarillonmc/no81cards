--sophiaの影霊衣
function c121105106.initial_effect(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c121105106.splimit)
    c:RegisterEffect(e1)
    --cannot spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(121105106,0))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c121105106.discon)
    e2:SetCost(c121105106.discost)
    e2:SetOperation(c121105106.disop)
    c:RegisterEffect(e2)
    --remove
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(121105106,1))
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCountLimit(1,121105106)
    e3:SetCondition(c121105106.rmcon)
    e3:SetCost(c121105106.rmcost)
    e3:SetTarget(c121105106.rmtg)
    e3:SetOperation(c121105106.rmop)
    c:RegisterEffect(e3)
    --special summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(121105106,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e4:SetCountLimit(1,121105106)
    e4:SetCost(c121105106.hspcost)
    e4:SetTarget(c121105106.hsptg)
    e4:SetOperation(c121105106.hspop)
    c:RegisterEffect(e4)
    --return
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(121105106,3))
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EVENT_PHASE+PHASE_END)
    e5:SetCondition(c121105106.retcon)
    e5:SetTarget(c121105106.rettg)
    e5:SetOperation(c121105106.retop)
    c:RegisterEffect(e5)
    --search
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(121105106,4))
    e6:SetCategory(CATEGORY_REMOVE)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_REMOVE)
    e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e6:SetCountLimit(1,121105106)
    e6:SetTarget(c121105106.thtg)
    e6:SetOperation(c121105106.thop)
    c:RegisterEffect(e6)
end
function c121105106.splimit(e,se,sp,st)
    return e:GetHandler():IsLocation(LOCATION_HAND) and bit.band(st,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c121105106.mat_filter(c,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c121105106.discon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c121105106.cfilter(c)
    return c:IsSetCard(0x10b4) and c:IsDiscardable()
end
function c121105106.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable()
        and Duel.IsExistingMatchingCard(c121105106.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c121105106.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
    g:AddCard(e:GetHandler())
    Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end
function c121105106.disop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_MAIN1)
    e1:SetTargetRange(0,1)
    e1:SetTarget(c121105106.sumlimit)
    Duel.RegisterEffect(e1,tp)
end
function c121105106.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsLocation(LOCATION_EXTRA)
end
function c121105106.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return true
end
function c121105106.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0
        and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==1 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_SUMMON)
    Duel.RegisterEffect(e2,tp)
    local e3=e1:Clone()
    e3:SetCode(EFFECT_CANNOT_MSET)
    Duel.RegisterEffect(e3,tp)
end
function c121105106.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,e:GetHandler()) and not Duel.IsExistingMatchingCard(aux.NOT(Card.IsAbleToRemove),tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,e:GetHandler()) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c121105106.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,aux.ExceptThisCard(e))
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c121105106.mat_group_check(g)
    return #g==3 and g:GetClassCount(Card.GetRace)==3
end

function c121105106.rfilter(c)
    return c:IsSetCard(0x10b4) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c121105106.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(c121105106.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,e:GetHandler())
        return g:GetClassCount(Card.GetRace)>=3
    end
    local g=Duel.GetMatchingGroup(c121105106.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,e:GetHandler())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g1=g:Select(tp,1,1,nil)
    g:Remove(Card.IsRace,nil,g1:GetFirst():GetRace())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g2=g:Select(tp,1,1,nil)
    g:Remove(Card.IsRace,nil,g2:GetFirst():GetRace())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g3=g:Select(tp,1,1,nil)
    g1:Merge(g2)
    g1:Merge(g3)
    Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c121105106.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c121105106.hspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
end
function c121105106.retcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
        and e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) and not e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c121105106.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c121105106.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end
function c121105106.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,1)
end
function c121105106.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if g:GetCount()==0 then return end
    local sg=g:RandomSelect(tp,1)
    Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end