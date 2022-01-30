--原生种·骨
local m=89390000
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
    e2:SetCondition(cm.thcon)
    e2:SetCost(cm.thcost)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_REMOVE)
    e1:SetTarget(cm.srettg)
    e1:SetOperation(cm.sretop)
    c:RegisterEffect(e1)
    if not cm.global_check then
        cm.global_check=true
        cm[0]={}
        cm[1]={}
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_CHAINING)
        ge1:SetOperation(cm.checkop)
        Duel.RegisterEffect(ge1,0)
        local ge2=ge1:Clone()
        ge2:SetCode(EVENT_CHAIN_NEGATED)
        ge2:SetOperation(cm.regop2)
        Duel.RegisterEffect(ge2,0)
        local ge4=Effect.CreateEffect(c)
        ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
        ge4:SetOperation(cm.clearop)
        Duel.RegisterEffect(ge4,0)
    end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.thfilter(c)
    return c:IsRace(RACE_PSYCHO) and not c:IsCode(m) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetChainLimit(aux.FALSE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
    if tg:GetCount()>0 then
        local tc=tg:GetFirst()
        if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_REMOVED) then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
function cm.srettg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToDeck() end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
    Duel.SetChainLimit(aux.FALSE)
end
function cm.sretop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,1,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(tp,m)==0 then
        local copyt=cm[tp]
        local exg=Group.CreateGroup()
        for k,v in pairs(copyt) do
            if k and v then exg:AddCard(k) end
        end
        if exg:GetClassCount(Card.GetOriginalCode)>=3 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
            local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
            if g:GetCount()==1 then
                Duel.HintSelection(g)
                Duel.SendtoHand(g,nil,REASON_EFFECT)
                Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
            end
        end
    end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if re:IsActiveType(TYPE_MONSTER) and rc:IsRace(RACE_PSYCHO) then
        cm[rp][rc]=1
    end
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
    cm[rp][re:GetHandler()]=nil
end
function cm.clearop(e,tp,eg,ep,ev,re,r,rp)
    cm[0]={}
    cm[1]={}
end
