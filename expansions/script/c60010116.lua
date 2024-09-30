--引月
local cm,m,o=GetID()
function cm.initial_effect(c)
    aux.AddCodeList(c,60010111)
    --act in hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    e2:SetCondition(cm.con)
    c:RegisterEffect(e2)
    --activated
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,2))
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCondition(cm.con1)
    e1:SetCost(cm.cos1)
    e1:SetTarget(cm.tg1)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,3))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCost(cm.thcost)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
end
function cm.confil(c)
    return c:IsCode(60010111) and c:IsFaceup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.confil,tp,LOCATION_MZONE,0,1,nil)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,60010111)>=2
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x628,1,REASON_COST) end
    Duel.RemoveCounter(tp,1,0,0x628,1,REASON_COST)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.RegisterFlagEffect(tp,60010111,0,0,1)
    local op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
    if op==0 then
        local dg=Duel.GetMatchingGroup(Card.IsAttackBelow,tp,0,LOCATION_MZONE,nil,2000)
        Duel.Destroy(dg,REASON_EFFECT)
    elseif op==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local rg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil):Select(tp,1,1,nil)
        Duel.Remove(rg,POS_FACEUP,REASON_RULE)
    end
    if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsPreviousLocation(LOCATION_HAND) then
        Duel.BreakEffect()
        c:CancelToGrave()
        Duel.Remove(c,POS_FACEUP,REASON_RULE)
    end
    Duel.RaiseEvent(c,EVENT_CUSTOM+60010111,e,0,tp,tp,0)
end

function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c)
    return c:IsCode(60010111) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
            Duel.ConfirmCards(1-tp,g)
            if g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false) 
            and Duel.IsCanRemoveCounter(tp,1,0,0x628,1,REASON_EFFECT) then
                Duel.RemoveCounter(tp,1,0,0x628,1,REASON_EFFECT)
                Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
            end
        end
    end
end