--索菲之虫惑魔
local m=89389004
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_HAND+LOCATION_MZONE)
    e4:SetCountLimit(1,m)
    e4:SetCost(cm.thcost)
    e4:SetTarget(cm.thtg)
    e4:SetOperation(cm.thop)
    c:RegisterEffect(e4)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.filter(c)
    return c:GetType()==TYPE_TRAP and c:IsSetCard(0x4c,0x89) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
    Duel.BreakEffect()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e4=Effect.CreateEffect(c)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(0xff)
    e4:SetCode(EFFECT_ACTIVATE_COST)
    e4:SetTargetRange(1,0)
    e4:SetTarget(cm.actarget)
    e4:SetCost(cm.costchk)
    e4:SetOperation(cm.costop)
    e4:SetReset(RESET_PHASE+PHASE_END)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e3:SetTargetRange(0xff,0xff)
    e3:SetTarget(cm.eftg)
    e3:SetLabelObject(e4)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
    e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e2:SetValue(LOCATION_DECKBOT)
    e2:SetTarget(cm.rmtg)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function cm.actarget(e,te,tp)
    return te:GetHandler()==e:GetHandler()
end
function cm.costfilter(c)
    return (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x108a) or c:IsType(TYPE_TRAP)) and c:IsAbleToDeckOrExtraAsCost()
end
function cm.costchk(e,te_or_c,tp)
    return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler())
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler())
    if g:GetFirst():IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,g) end
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.eftg(e,c)
    return c:IsType(TYPE_TRAP)
end
function cm.rmtg(e,c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsLocation(LOCATION_OVERLAY)
end
