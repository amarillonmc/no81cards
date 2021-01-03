--真帝机 骑将
if not pcall(function() require("expansions/script/c98704001") end) then require("script/c98704001") end
local m=98704014
local cm=_G["c"..m]
cm.mqt=true
function cm.initial_effect(c)
    mqt.SummonWithExtraTributeEffect(c)
    --summon with opponent's monster
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_MAIN_END)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(cm.con)
    e1:SetCost(cm.cost)
    e1:SetOperation(cm.op)
    c:RegisterEffect(e1)
    --destroy&remove
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(cm.target)
    e2:SetOperation(cm.operation)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --indestructable
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e4:SetTarget(cm.tgtg)
    e4:SetValue(aux.indoval)
    c:RegisterEffect(e4)
    --tohand
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,2))
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetCountLimit(1)
    e5:SetCost(cm.thcost)
    e5:SetTarget(cm.thtg)
    e5:SetOperation(cm.thop)
    c:RegisterEffect(e5)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,m)==0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.splimit)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_EXTRA_RELEASE_SUM)
    e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e2:SetCountLimit(1)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
    if Duel.GetFlagEffect(tp,m)~=0 then Duel.ResetFlagEffect(tp,m) end
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsSummonableCard()
end
function cm.filter(c)
    return c:IsLocation(LOCATION_ONFIELD) or c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() or (chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove()) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,2,nil)
    local dg=g:Filter(Card.IsOnField,nil)
    local rg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
    if #dg>0 then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
    end
    if #rg>0 then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,rg,#rg,0,0)
    end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local dg=tg:Filter(Card.IsOnField,nil)
    local rg=tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
    if dg and #dg>0 then
        Duel.Destroy(dg,REASON_EFFECT)
        dg=Duel.GetOperatedGroup()
    end
    if rg and #rg>0 then
        Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
    end
    local d1=0
    local d2=0
    local tc=dg:GetFirst()
    while tc do
        if tc:GetPreviousControler()==tp then d1=d1+1 else d2=d2+1 end
        tc=dg:GetNext()
    end
    if d1>0 and Duel.IsPlayerCanDraw(tp,d1) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then Duel.Draw(tp,d1,REASON_EFFECT) end
    if d2>0 and Duel.IsPlayerCanDraw(1-tp,d2) and Duel.SelectYesNo(1-tp,aux.Stringid(m,4)) then Duel.Draw(1-tp,d2,REASON_EFFECT) end
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
end
function cm.tgtg(e,c)
    return mqt.ismqt(c) and c~=e:GetHandler()
end
function cm.cfilter(c,tp)
    return mqt.ismqt(c) and c:IsDiscardable() and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function cm.thfilter(c,code)
    return c:GetCode()~=code and ((c:IsLevelAbove(5) and c:IsSummonableCard()) or (mqt.ismqt(c) and c:IsType(TYPE_SPELL+TYPE_TRAP))) and c:IsAbleToHand()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil,tp) end
    local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
    e:SetLabel(g:GetFirst():GetCode())
    Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local code=e:GetLabel()
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc,code) end
    if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil,code) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,code)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end
