--暴噬星皇神帝·吉咖罗斯
local m=89386004
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    c:SetUniqueOnField(1,0,m,LOCATION_MZONE)
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetCondition(cm.thcon)
    e3:SetCost(cm.thcost)
    e3:SetTarget(cm.thtg)
    e3:SetOperation(cm.thop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_CUSTOM+m)
    e4:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
    e4:SetTarget(cm.sptg)
    e4:SetOperation(cm.spop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_REMOVE)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetTarget(cm.destg)
    e5:SetOperation(cm.desop)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetProperty(EFFECT_FLAG_DELAY)
    e6:SetCode(EVENT_DESTROYED)
    e6:SetCondition(cm.thcon2)
    e6:SetTarget(cm.thtg2)
    e6:SetOperation(cm.thop2)
    c:RegisterEffect(e6)
    Duel.AddCustomActivityCounter(m,ACTIVITY_SUMMON,cm.counterfilter)
    Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
    if not cm.global_check then
        cm.global_check=true
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_CHAIN_NEGATED)
        e2:SetCondition(cm.regcon)
        e2:SetOperation(cm.regop2)
        Duel.RegisterEffect(e2,0)
        Duel.RegisterFlagEffect(0,m,0,0,0,0)
        Duel.RegisterFlagEffect(1,m,0,0,0,0)
    end
end
function cm.counterfilter(c)
    return c:IsSetCard(0xcc30)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler()==e:GetHandler()
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetFlagEffectLabel(ep,m,Duel.GetFlagEffectLabel(ep,m)-1)
end
function cm.ctfilter(c)
    return c:IsFaceup() and c:IsCode(m)
end
function cm.ctvalue(e)
    return Duel.IsExistingMatchingCard(cm.ctfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SUMMON)==0 and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 and c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.splimit)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_SUMMON)
    Duel.RegisterEffect(e2,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsSetCard(0xcc30)
end
function cm.thfilter(c)
    return c:IsFaceup() and c:IsCode(m)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    Duel.SetFlagEffectLabel(tp,m,Duel.GetFlagEffectLabel(tp,m)+1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
    Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+m,re,r,rp,ep,ev)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if Duel.GetFlagEffectLabel(tp,m)>=4 then
        if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
        e:SetCategory(CATEGORY_SPECIAL_SUMMON)
    else
        if chk==0 then return c:IsAbleToDeck() end
        Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
        e:SetCategory(CATEGORY_TODECK)
    end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local n=Duel.GetFlagEffectLabel(tp,m)
    if n>=4 then
        Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
    else
        c:SetTurnCounter(n)
        Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
    end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
    return tp==ep
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsAbleToRemove() end
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
    end
end
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp)
end
function cm.thfilter2(c)
    return c:IsSetCard(0xcc30) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
