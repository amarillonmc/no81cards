--ブリューナクの影霊衣
function c126674724.initial_effect(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.ritlimit)
    c:RegisterEffect(e1)
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(126674724,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,126674724)
    e2:SetCost(c126674724.thcost)
    e2:SetTarget(c126674724.thtg)
    e2:SetOperation(c126674724.thop)
    c:RegisterEffect(e2)
    --todeck
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(126674724,1))
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,266747241)
    e3:SetTarget(c126674724.tdtg)
    e3:SetOperation(c126674724.tdop)
    c:RegisterEffect(e3)
    --special summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(126674724,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e4:SetCountLimit(1,126674724)
    e4:SetCost(c126674724.hspcost)
    e4:SetTarget(c126674724.hsptg)
    e4:SetOperation(c126674724.hspop)
    c:RegisterEffect(e4)
    --return
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(126674724,3))
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,126674724)
    e5:SetCode(EVENT_PHASE+PHASE_END)
    e5:SetCondition(c126674724.retcon)
    e5:SetTarget(c126674724.rettg)
    e5:SetOperation(c126674724.retop)
    c:RegisterEffect(e5)
    --search
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(126674724,4))
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_REMOVE)
    e6:SetCountLimit(1,126674724)
    e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e6:SetTarget(c126674724.exthtg)
    e6:SetOperation(c126674724.exthop)
    c:RegisterEffect(e6)
end
function c126674724.mat_filter(c)
    return not c:IsCode(126674724)
end
function c126674724.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c126674724.thfilter(c)
    return c:IsSetCard(0xb4) and not c:IsCode(126674724) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c126674724.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c126674724.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c126674724.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c126674724.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c126674724.tdfilter(c)
    return c:GetSummonLocation()==LOCATION_EXTRA and c:IsAbleToDeck()
end
function c126674724.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c126674724.tdfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c126674724.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c126674724.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c126674724.tdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if g:GetCount()>0 then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
end

function c126674724.rfilter(c)
    return c:IsSetCard(0x10b4) and c:IsAbleToRemoveAsCost()
end
function c126674724.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c126674724.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c126674724.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c126674724.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c126674724.hspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
end
function c126674724.retcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
        and e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) and not e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c126674724.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c126674724.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end
function c126674724.exthfilter(c)
    return c:IsSetCard(0x10b4) and c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function c126674724.exthtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c126674724.exthfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c126674724.exthop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c126674724.exthfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end