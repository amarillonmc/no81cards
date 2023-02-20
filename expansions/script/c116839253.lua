--PSYフレーム・ブースター
function c116839253.initial_effect(c)
    c:EnableCounterPermit(0x4)
    --act in hand
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e0:SetCondition(c116839253.actcon)
    c:RegisterEffect(e0)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c116839253.target)
    c:RegisterEffect(e1)
    --counter
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(116839253,0))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMING_END_PHASE)
    e2:SetCountLimit(1)
    e2:SetCost(c116839253.countercost)
    e2:SetTarget(c116839253.countertg)
    e2:SetOperation(c116839253.counterop)
    c:RegisterEffect(e2)
    --search
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(116839253,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,TIMING_END_PHASE)
    e3:SetCountLimit(1)
    e3:SetCost(c116839253.efcost)
    e3:SetTarget(c116839253.thtg)
    e3:SetOperation(c116839253.thop)
    c:RegisterEffect(e3)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(116839253,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetHintTiming(0,TIMING_END_PHASE)
    e4:SetCountLimit(1)
    e4:SetCost(c116839253.efcost)
    e4:SetTarget(c116839253.sptg)
    e4:SetOperation(c116839253.spop)
    c:RegisterEffect(e4)
    --activate from deck
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(116839253,3))
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetHintTiming(0,TIMING_END_PHASE)
    e5:SetCountLimit(1)
    e5:SetCost(c116839253.efcost)
    e5:SetTarget(c116839253.actg)
    e5:SetOperation(c116839253.acop)
    c:RegisterEffect(e5)
    --to hand
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_TOHAND)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetRange(LOCATION_GRAVE)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetCondition(aux.exccon)
    e6:SetCost(c116839253.srcost)
    e6:SetTarget(c116839253.srtg)
    e6:SetOperation(c116839253.srop)
    c:RegisterEffect(e6)
end

function c116839253.actfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc1)
end
function c116839253.actcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c116839253.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function c116839253.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    if c116839253.countercost(e,tp,eg,ep,ev,re,r,rp,0) and c116839253.countertg(e,tp,eg,ep,ev,re,r,rp,0)
        and Duel.SelectYesNo(tp,94) then
        e:SetProperty(EFFECT_FLAG_CARD_TARGET)
        e:SetOperation(c116839253.counterop)
        c116839253.countercost(e,tp,eg,ep,ev,re,r,rp,1)
        c116839253.countertg(e,tp,eg,ep,ev,re,r,rp,1)
    else
        e:SetProperty(0)
        e:SetOperation(nil)
    end
end

function c116839253.cfilter(c)
    return c:IsAbleToGraveAsCost()
end
function c116839253.countercost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetFlagEffect(116839253)==0
        and Duel.IsExistingMatchingCard(c116839253.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    local g=Duel.GetMatchingGroup(c116839253.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local cg=g:Select(tp,1,g:GetCount(),nil)
    Duel.SendtoGrave(cg,REASON_COST)
    e:SetLabel(cg:GetCount())
    e:GetHandler():RegisterFlagEffect(116839253,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c116839253.countertg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function c116839253.counterop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    e:GetHandler():AddCounter(0x4,e:GetLabel())
end


function c116839253.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x4,1,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x4,1,REASON_COST)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end

function c116839253.thfilter(c)
    return c:IsSetCard(0xc1) and (c:IsLocation(LOCATION_DECK) or c:IsFaceup()) and c:IsAbleToHand()
end
function c116839253.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c116839253.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c116839253.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c116839253.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

function c116839253.spfilter(c,e,tp)
    return c:IsSetCard(0xc1) and not c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c116839253.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c116839253.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c116839253.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c116839253.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

function c116839253.acfilter(c,tp)
    return (((c:GetType()==0x20004 or c:GetType()==0x20002) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or c:IsType(TYPE_FIELD))
        and c:IsSetCard(0xc1) and c:GetActivateEffect():IsActivatable(tp)
end
function c116839253.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c116839253.acfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c116839253.acop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c116839253.acfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
    local tc=g:GetFirst()
    if tc then
        if tc:IsType(TYPE_FIELD) then
            Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
        else
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        end
        local te=tc:GetActivateEffect()
        local tep=tc:GetControler()
        local cost=te:GetCost()
        if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
        Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,tc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
    end
end

function c116839253.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c116839253.srfilter(c)
    return c:IsSetCard(0xc1) and c:IsAbleToHand()
end
function c116839253.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c116839253.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c116839253.srop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c116839253.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
