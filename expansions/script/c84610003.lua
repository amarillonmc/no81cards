--リチュアの巫女　エリアル
function c84610003.initial_effect(c)
    --inactivatable
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_INACTIVATE)
    e1:SetRange(LOCATION_ONFIELD)
    e1:SetValue(c84610003.effectfilter)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)   
    e2:SetCode(EFFECT_CANNOT_DISEFFECT)
    e2:SetRange(LOCATION_ONFIELD)
    e2:SetValue(c84610003.effectfilter)
    c:RegisterEffect(e2)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_CHAIN_NEGATED)
    e1:SetRange(LOCATION_DECK)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(c84610003.spcon)
    e1:SetCost(c84610003.spcost)
    e1:SetTarget(c84610003.sptg)
    e1:SetOperation(c84610003.spop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_CHAIN_DISABLED)        
    c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_ONFIELD)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --copy active
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e4:SetCountLimit(2)
    e4:SetCost(c84610003.cocost)
    e4:SetTarget(c84610003.cotarget)
    e4:SetOperation(c84610003.cooperation)
    c:RegisterEffect(e4)
    --search
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_HAND)
    e6:SetCost(c84610003.cost)
    e6:SetTarget(c84610003.target)
    e6:SetOperation(c84610003.operation)
    c:RegisterEffect(e6)        
end
function c84610003.effectfilter(e,ct)
    local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
    local tc=te:GetHandler()
    return tc:IsSetCard(0x3a)
end
function c84610003.spcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsHasType(EFFECT_TYPE_ACTIONS)    
end
function c84610003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.ConfirmCards(1-tp,e:GetHandler())
end
function c84610003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c84610003.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c84610003.cocost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(1)
    if chk==0 then return e:GetHandler():GetFlagEffect(84610003)<3 end
    e:GetHandler():RegisterFlagEffect(84610003,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c84610003.filter1(c)
    return c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSetCard(0x3a) and c:IsAbleToGraveAsCost()
        and c:CheckActivateEffect(false,true,false)~=nil
end
function c84610003.cotarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if e:GetLabel()==0 then return false end
        e:SetLabel(0)
        return Duel.IsExistingMatchingCard(c84610003.filter1,tp,LOCATION_HAND,0,1,nil)
    end
    e:SetLabel(0)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c84610003.filter1,tp,LOCATION_HAND,0,1,1,nil)
    local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
    Duel.SendtoGrave(g,REASON_COST)
    e:SetCategory(te:GetCategory())
    e:SetProperty(te:GetProperty())
    local tg=te:GetTarget()
    if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
    te:SetLabelObject(e:GetLabelObject())
    e:SetLabelObject(te)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c84610003.cooperation(e,tp,eg,ep,ev,re,r,rp)
    local te=e:GetLabelObject()
    if not te then return end
    e:SetLabelObject(te:GetLabelObject())
    local op=te:GetOperation()
    if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c84610003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c84610003.filter(c)
    return c:IsSetCard(0x3a) and c:IsAbleToHand()
end
function c84610003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610003.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c84610003.operation(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c84610003.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
