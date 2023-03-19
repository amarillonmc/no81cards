--蔓延的灾祸
local m=89389006
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(cm.spcost)
    e1:SetTarget(cm.sptg)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e2:SetCondition(cm.handcon)
    c:RegisterEffect(e2)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetCost(cm.cost)
    e5:SetTarget(cm.target)
    e5:SetOperation(cm.operation)
    c:RegisterEffect(e5)
    Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
    return not c:IsSummonLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE) or c:IsSetCard(0x108a)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetLabelObject(e)
    e1:SetTarget(cm.splimit)
    Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE) and not c:IsSetCard(0x108a)
end
function cm.thfilter(c)
    return (c:GetType()==TYPE_TRAP and c:IsSetCard(0x4c,0x89) and not c:IsCode(m) or c:IsType(TYPE_MONSTER) and c:IsSetCard(0x108a)) and c:IsAbleToHand()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,0,0,0)
end
function cm.sumfilter(c)
    return c:IsSetCard(0x108a) and c:IsSummonable(true,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g2=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g2:GetCount()>0 then
        Duel.SendtoHand(g2,tp,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g2)
        if Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
            and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
            Duel.BreakEffect()
            Duel.ShuffleHand(tp)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
            local sg=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
            Duel.Summon(tp,sg:GetFirst(),true,nil)
        end
    end
end
function cm.hcfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x108a)
end
function cm.handcon(e)
    return Duel.IsExistingMatchingCard(cm.hcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(1)
    return true
end
function cm.filter(c)
    return c:GetType()==TYPE_TRAP and c:IsSetCard(0x4c,0x89) and c:IsAbleToDeckAsCost() and c:CheckActivateEffect(false,true,false)~=nil
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        if e:GetLabel()==0 then return false end
        e:SetLabel(0)
        return c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c)
    end
    e:SetLabel(0)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local gc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,c):GetFirst()
    local te,ceg,cep,cev,cre,cr,crp=gc:CheckActivateEffect(false,true,true)
    if gc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,gc) end
    Duel.Hint(HINT_CARD,0,gc:GetOriginalCode())
    local sg=Group.FromCards(c,gc)
    Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_COST)
    e:SetProperty(te:GetProperty())
    local tg=te:GetTarget()
    if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
    te:SetLabelObject(e:GetLabelObject())
    e:SetLabelObject(te)
    Duel.ClearOperationInfo(0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local te=e:GetLabelObject()
    if not te then return end
    e:SetLabelObject(te:GetLabelObject())
    local op=te:GetOperation()
    if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
