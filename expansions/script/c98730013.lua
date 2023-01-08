--焰征龙-爆龙
function c98730013.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(98730013,0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(98730013,3))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_PZONE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1,98730013)
    e3:SetCondition(c98730013.descon)
    e3:SetTarget(c98730013.destg1)
    e3:SetOperation(c98730013.desop1)
    c:RegisterEffect(e3)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(98730013,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,98730014)
    e1:SetCost(c98730013.hspcost)
    e1:SetTarget(c98730013.hsptg)
    e1:SetOperation(c98730013.hspop)
    c:RegisterEffect(e1)
    --return
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(98730013,2))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,98730014)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetCondition(c98730013.retcon)
    e2:SetTarget(c98730013.rettg)
    e2:SetOperation(c98730013.retop)
    c:RegisterEffect(e2)
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(98730013,3))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1,98730014)
    e3:SetCost(c98730013.descost)
    e3:SetTarget(c98730013.destg)
    e3:SetOperation(c98730013.desop)
    c:RegisterEffect(e3)
    --search
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(98730013,4))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_REMOVE)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,98730014)
    e4:SetTarget(c98730013.thtg)
    e4:SetOperation(c98730013.thop)
    c:RegisterEffect(e4)
    --special summon
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(98730013,5))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_PZONE)
    e5:SetCountLimit(1,98730013)
    e5:SetCost(c98730013.pspcost)
    e5:SetTarget(c98730013.psptg)
    e5:SetOperation(c98730013.pspop)
    c:RegisterEffect(e5)
    --return to hand
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(98730013,6))
    e6:SetCategory(CATEGORY_TOHAND)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_PZONE)
    e6:SetCountLimit(1,98730013)
    e6:SetTarget(c98730013.rettg)
    e6:SetOperation(c98730013.retop)
    c:RegisterEffect(e6)
end
function c98730013.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_PZONE,0,1,e:GetHandler(),ATTRIBUTE_FIRE)
end
function c98730013.desfilter1(c,tp)
    return c:IsDestructable() and not (c:IsLocation(LOCATION_PZONE) and c:IsControler(tp))
end
function c98730013.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and c98730013.desfilter1(chkc,tp) end
    if chk==0 then return Duel.IsExistingTarget(c98730013.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c98730013.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98730013.desop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local pc=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_PZONE,0,e:GetHandler(),ATTRIBUTE_FIRE):GetFirst()
    if not pc then return end
    local dg=Group.FromCards(c,pc)
    if Duel.Destroy(dg,REASON_EFFECT)~=2 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c98730013.rfilter(c)
    return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_FIRE)) and c:IsAbleToRemoveAsCost()
end
function c98730013.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c98730013.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c98730013.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c98730013.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98730013.hspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c98730013.retcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
        and bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c98730013.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c98730013.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end
function c98730013.dfilter(c)
    return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c98730013.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() and e:GetHandler():IsAbleToGraveAsCost()
        and Duel.IsExistingMatchingCard(c98730013.dfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c98730013.dfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
    g:AddCard(e:GetHandler())
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c98730013.desfilter(c)
    return c:IsDestructable()
end
function c98730013.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and c98730013.desfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c98730013.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c98730013.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98730013.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c98730013.thfilter(c)
    return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand()
end
function c98730013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c98730013.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98730013.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c98730013.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c98730013.cfilter(c)
    return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_FIRE)) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
        and c:IsAbleToRemoveAsCost()
end
function c98730013.pspcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c98730013.cfilter,tp,LOCATION_EXTRA,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c98730013.cfilter,tp,LOCATION_EXTRA,0,2,2,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c98730013.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98730013.pspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
        Duel.SendtoGrave(c,REASON_RULE)
    end
end
