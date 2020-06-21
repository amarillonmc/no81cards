--トリシューラの影霊衣
function c115206843.initial_effect(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.ritlimit)
    c:RegisterEffect(e1)
    --negate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(115206843,0))
    e2:SetCategory(CATEGORY_NEGATE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,115206843)
    e2:SetCondition(c115206843.negcon)
    e2:SetCost(c115206843.negcost)
    e2:SetTarget(c115206843.negtg)
    e2:SetOperation(c115206843.negop)
    c:RegisterEffect(e2)
    --remove
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(115206843,1))
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCountLimit(1,520684321)
    e3:SetCondition(c115206843.remcon)
    e3:SetTarget(c115206843.remtg)
    e3:SetOperation(c115206843.remop)
    c:RegisterEffect(e3)
    --special summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(115206843,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e4:SetCountLimit(1,115206843)
    e4:SetCost(c115206843.hspcost)
    e4:SetTarget(c115206843.hsptg)
    e4:SetOperation(c115206843.hspop)
    c:RegisterEffect(e4)
    --return
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(115206843,3))
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,115206843)
    e5:SetCode(EVENT_PHASE+PHASE_END)
    e5:SetCondition(c115206843.retcon)
    e5:SetTarget(c115206843.rettg)
    e5:SetOperation(c115206843.retop)
    c:RegisterEffect(e5)
    --search
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(115206843,4))
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_REMOVE)
    e6:SetCountLimit(1,115206843)
    e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e6:SetTarget(c115206843.thtg)
    e6:SetOperation(c115206843.thop)
    c:RegisterEffect(e6)
end
function c115206843.mat_filter(c)
    return c:GetLevel()~=9
end
function c115206843.tfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x10b4) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c115206843.negcon(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(c115206843.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c115206843.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c115206843.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c115206843.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
        Duel.SendtoGrave(eg,REASON_EFFECT)
    end
end
function c115206843.remcon(e,tp,eg,ep,ev,re,r,rp)
    return true
end
function c115206843.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil)
        and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
        and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND)
end
function c115206843.remop(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
    local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
    local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
    if g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg1=g1:RandomSelect(tp,1)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg2=g2:Select(tp,1,1,nil)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg3=g3:Select(tp,1,1,nil)
        sg1:Merge(sg2)
        sg1:Merge(sg3)
        Duel.HintSelection(sg1)
        Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
    end
end

function c115206843.rfilter(c)
    return c:IsSetCard(0x10b4) and c:IsAbleToRemoveAsCost()
end
function c115206843.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c115206843.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c115206843.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c115206843.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c115206843.hspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
end
function c115206843.retcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
        and e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) and not e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c115206843.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c115206843.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end
function c115206843.thfilter(c)
    return c:IsSetCard(0x10b4) and c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function c115206843.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c115206843.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c115206843.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c115206843.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end