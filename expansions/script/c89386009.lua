--研究机构-神帝暴噬星皇
local m=89386009
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableCounterPermit(0xce0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_INACTIVATE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetValue(cm.effectfilter)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_DISEFFECT)
    e3:SetRange(LOCATION_FZONE)
    e3:SetValue(cm.effectfilter)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_SZONE)
    e4:SetOperation(aux.chainreg)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e5:SetCode(EVENT_CHAIN_SOLVED)
    e5:SetRange(LOCATION_SZONE)
    e5:SetOperation(cm.acop)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_FZONE)
    e6:SetCountLimit(1,m)
    e6:SetCost(cm.thcost)
    e6:SetTarget(cm.thtg)
    e6:SetOperation(cm.thop)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
    e7:SetRange(LOCATION_SZONE)
    e7:SetCondition(cm.skcon)
    e7:SetTarget(cm.sktg)
    e7:SetOperation(cm.skop)
    c:RegisterEffect(e7)
end
function cm.effectfilter(e,ct)
    local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
    local tc=te:GetHandler()
    return tc:IsSetCard(0xce0) and tc:IsLevelAbove(7)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
    local te,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_LOCATION)
    local c=e:GetHandler()
    local tc=te:GetHandler()
    if re:IsActiveType(TYPE_MONSTER) and tc:IsSetCard(0xce0) and loc==LOCATION_HAND and c:GetFlagEffect(1)>0 then
        c:AddCounter(0xce0,1)
    end
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xce0,3,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0xce0,3,REASON_COST)
end
function cm.thfilter(c)
    return c:IsSetCard(0xce0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.skcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==1-tp and e:GetHandler():GetCounter(0xce0)>0
end
function cm.sktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeck() end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.skop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>0 then
        Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
    end
end
