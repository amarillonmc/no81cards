--世纪末-錆瞑
local m=114620011
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE+CATEGORY_HANDES)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(cm.condition)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCost(cm.spcost)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTargetRange(0xff,0)
    e4:SetCode(m)
    e4:SetTarget(cm.rmtg)
    c:RegisterEffect(e4)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e0:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
    c:RegisterEffect(e0)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetCurrentChain()~=0 then return false end
    if Duel.GetTurnPlayer()==tp then
        if c:IsHasEffect(114620005) then return true end
        return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
    else
        if c:IsHasEffect(114620005) then return c:IsLocation(LOCATION_HAND) end
        return false
    end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,6) end
end
function cm.filter(c)
    return c:IsSetCard(0xe6f) and c:IsType(TYPE_MONSTER)
end
function cm.rfilter(c)
    return cm.filter(c) and c:IsAbleToRemove()
end
function cm.thfilter(c)
    return c:IsSetCard(0xe6f) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or not Duel.IsPlayerCanDiscardDeck(tp,6) then return end
    Duel.ConfirmDecktop(tp,6)
    local g=Duel.GetDecktopGroup(tp,6)
    local sg=g:Filter(cm.filter,nil)
    if sg:GetCount()>0 then
        if Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)==0 then return end
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local mg=Duel.SelectMatchingCard(tp,cm.rfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,99,nil)
    if not mg then return end
    local n=mg:GetCount()
    Duel.Remove(mg,POS_FACEUP,REASON_EFFECT)
    local o1=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
    if n>=1 and o1:GetCount()>0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local s1=o1:Select(tp,1,1,nil)
        if s1:GetCount()>0 then
            Duel.SendtoHand(s1,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,s1)
        end
    end
    if n>=3 then
        Duel.BreakEffect()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_ACTIVATE)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(0,1)
        e1:SetValue(cm.actlimit)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
    local o2=Duel.GetFieldGroup(tp,0,LOCATION_SZONE)
    local o2c=o2:GetCount()
    if n>=6 and o2c>0 and o2:FilterCount(Card.IsAbleToRemove,nil)==o2c then
        Duel.BreakEffect()
        Duel.Remove(o2,POS_FACEUP,REASON_EFFECT)
    end
    local o3=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    local o3c=o3:GetCount()
    if n>=10 and o3c>0 and o3:FilterCount(Card.IsAbleToRemove,nil)==o3c then
        Duel.BreakEffect()
        Duel.Remove(o3,POS_FACEUP,REASON_EFFECT)
    end
end
function cm.actlimit(e,re,tp)
    return re:IsActiveType(TYPE_MONSTER)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToGraveAsCost() end
    Duel.SendtoGrave(c,REASON_COST)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(tp,m)~=0 then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetValue(cm.val)
    e1:SetReset(RESET_PHASE+PHASE_END,1)
    Duel.RegisterEffect(e1,tp)
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.val(e,re,dam,r,rp,rc)
    if bit.band(r,REASON_BATTLE)~=0 then
        return dam*2
    else return dam end
end
function cm.rmtg(e,c)
    return c:IsSetCard(0xe6f)
end
