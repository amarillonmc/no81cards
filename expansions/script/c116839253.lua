function c116839253.initial_effect(c)
    c:EnableCounterPermit(0x4)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e2:SetCondition(c116839253.handcon)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(116839253,0))
    e3:SetCategory(CATEGORY_COUNTER)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_SZONE)
    e3:SetHintTiming(0,TIMING_END_PHASE)
    e3:SetCountLimit(1)
    e3:SetCost(c116839253.cost)
    e3:SetTarget(c116839253.target2)
    e3:SetOperation(c116839253.activate2)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(116839253,1))
    e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetHintTiming(0,TIMING_END_PHASE)
    e4:SetCountLimit(1)
    e4:SetCost(c116839253.cost2)
    e4:SetTarget(c116839253.shtg)
    e4:SetOperation(c116839253.shop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(116839253,2))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetHintTiming(0,TIMING_END_PHASE)
    e5:SetCountLimit(1)
    e5:SetCost(c116839253.cost2)
    e5:SetTarget(c116839253.sptg)
    e5:SetOperation(c116839253.spop)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(116839253,3))
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetRange(LOCATION_SZONE)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetHintTiming(0,TIMING_END_PHASE)
    e6:SetCost(c116839253.cost2)
    e6:SetCountLimit(1)
    e6:SetTarget(c116839253.tftg)
    e6:SetOperation(c116839253.tfop)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_TOHAND)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetRange(LOCATION_GRAVE)
    e7:SetCode(EVENT_FREE_CHAIN)
    e7:SetCondition(aux.exccon)
    e7:SetCost(c116839253.thcost)
    e7:SetTarget(c116839253.thtg)
    e7:SetOperation(c116839253.thop)
    c:RegisterEffect(e7)
end
function c116839253.cfilter(c)
    return c:IsSetCard(0xc1) and c:IsFaceup()
end
function c116839253.handcon(e)
    return Duel.IsExistingMatchingCard(c116839253.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c116839253.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,99,e:GetHandler())
    e:SetLabel(sg:GetCount())
    Duel.SendtoGrave(sg,REASON_COST)
end
function c116839253.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanAddCounter(tp,0x4,e:GetLabel(),e:GetHandler()) end
end
function c116839253.activate2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    c:AddCounter(0x4,e:GetLabel())
end
function c116839253.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x4,1,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x4,1,REASON_COST)
end
function c116839253.shfilter(c)
    return c:IsSetCard(0xc1) and not c:IsCode(116839253) and c:IsAbleToHand() and (c:IsFaceup() or c:IsLocation(LOCATION_DECK))
end
function c116839253.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c116839253.shfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c116839253.shop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c116839253.shfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c116839253.spfilter(c,e,tp)
    return c:IsSetCard(0xc1) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c116839253.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c116839253.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c116839253.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c116839253.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c116839253.tffilter(c,tp)
    return c:IsSetCard(0xc1) and (c:GetType()==0x20004 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or c:IsType(TYPE_FIELD)) and not c:IsCode(116839253) and c:GetActivateEffect():IsActivatable(tp)
end
function c116839253.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c116839253.tffilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c116839253.tfop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c116839253.tffilter,tp,LOCATION_DECK,0,nil,tp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then
        g=g:Filter(Card.IsType,nil,TYPE_FIELD)
    end
    if g:GetCount()==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local tc=g:Select(tp,1,1,nil):GetFirst()
    if tc:IsType(TYPE_FIELD) then
        local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
        if fc then
            Duel.SendtoGrave(fc,REASON_RULE)
            Duel.BreakEffect()
        end
    end
    local lc
    if tc:IsType(TYPE_FIELD) then lc=LOCATION_FZONE else lc=LOCATION_SZONE end
    Duel.MoveToField(tc,tp,tp,lc,POS_FACEUP,true)
    local te=tc:GetActivateEffect()
    local tep=tc:GetControler()
    local cost=te:GetCost()
    if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
    Duel.RaiseEvent(tc,116839253,te,0,tp,tp,Duel.GetCurrentChain())
end
function c116839253.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c116839253.thfilter(c)
    return c:IsSetCard(0xc1) and c:IsAbleToHand() and not c:IsCode(116839253)
end
function c116839253.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c116839253.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c116839253.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c116839253.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end