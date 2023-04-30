--真神使者 狻猊
local m=91020017
local cm=c91020017
function c91020017.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,m*3)
    e1:SetCondition(cm.con1)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_FLIP)
    e2:SetProperty(EFFECT_FLAG_DELAY) 
    e2:SetTarget(cm.tg2)
    e2:SetCountLimit(1,m)
    e2:SetOperation(cm.op2)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCategory(CATEGORY_RELEASE)
    e3:SetCode(EVENT_RELEASE)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_FLIP)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetOperation(cm.flipop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetCategory(CATEGORY_SEARCH)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,m*2)
    e5:SetCondition(cm.condition)
    e5:SetTarget(cm.tg5)
    e5:SetOperation(cm.op5)
    c:RegisterEffect(e5)
    Duel.AddCustomActivityCounter(91020017,ACTIVITY_SPSUMMON,cm.counterfilter)
end
--e4
function cm.counterfilter(c)
    return  c:IsSetCard(0x9d0) or  c:IsSetCard(0x9d1)
end
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(91020017,RESET_EVENT+RESETS_STANDARD,0,1)
end
--e1
function cm.tag(e,c)
return not (c:IsSetCard(0x9d0) or  c:IsSetCard(0x9d1))
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
    return  Duel.GetCurrentChain()<1 and Duel.GetTurnPlayer()==tp and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 and Duel.GetCustomActivityCount(91020017,tp,ACTIVITY_SPSUMMON)==0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.tag)
    Duel.RegisterEffect(e1,tp)   
    local c=e:GetHandler()
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)    
    Duel.ConfirmCards(1-tp,c)
end
--e2
function cm.fit(c,e,tp)
    return c:IsSetCard(0x9d1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.fit,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.fit,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
    end
end
--e5
function cm.fit2(c,e,tp)
    return c:IsSetCard(0x9d0) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
 return c:IsFaceup() and c:GetFlagEffect(91020017)>0 and  not c:IsDisabled()
end
function cm.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(cm.fit2,tp,LOCATION_DECK,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
local g=Duel.GetMatchingGroup(cm.fit2,tp,LOCATION_DECK,0,nil,e,tp)
    if g:GetCount()>0 then
    local sg=g:RandomSelect(tp,1)
      Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
     local tc=sg:GetFirst()
    tc:RegisterFlagEffect(91000001,RESET_EVENT+RESETS_STANDARD,0,1)
    local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE+PHASE_END)
        e2:SetCountLimit(1)
        e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetLabelObject(tc)
        e2:SetCondition(cm.descon)
        e2:SetOperation(cm.desop)
        Duel.RegisterEffect(e2,tp)
 end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:GetFlagEffect(9100001)~=0 then
        return true
    else
        e:Reset()
        return false
    end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.SendtoHand(tc,tp,REASON_EFFECT)
end