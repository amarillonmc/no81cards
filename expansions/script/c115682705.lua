--遗式巫女 艾莉娅儿
function c115682705.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCost(c115682705.cost)
    e1:SetTarget(c115682705.target)
    e1:SetOperation(c115682705.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetValue(c115682705.efilter)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(115682705,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetRange(LOCATION_DECK)
    e3:SetCode(EVENT_CHAIN_NEGATED)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCost(c115682705.spcost)
    e3:SetTarget(c115682705.sptg)
    e3:SetOperation(c115682705.spop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_INACTIVATE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(c115682705.effectfilter)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_DISEFFECT)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetCountLimit(2)
    e6:SetCost(c115682705.cpcost)
    e6:SetTarget(c115682705.cptg)
    e6:SetOperation(c115682705.cpop)
    c:RegisterEffect(e6)
end
function c115682705.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c115682705.filter(c)
    return c:IsSetCard(0x3a) and not c:IsCode(115682705) and c:IsAbleToHand()
end
function c115682705.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c115682705.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c115682705.operation(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c115682705.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c115682705.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c115682705.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(115682705)==0 end
    Duel.ConfirmCards(1-tp,c)
    c:RegisterFlagEffect(115682705,RESET_CHAIN,0,1)
end
function c115682705.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c115682705.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c115682705.effectfilter(e,ct)
    local p=e:GetHandler():GetControler()
    local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
    return p==tp and te:GetHandler():IsSetCard(0x3a)
end
function c115682705.cfilter(c)
    return c:IsSetCard(0x3a) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost() and c:CheckActivateEffect(true,true,false)~=nil
end
function c115682705.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c115682705.cfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c115682705.cfilter,tp,LOCATION_HAND,0,1,1,nil)
    local te=g:GetFirst():CheckActivateEffect(false,false,true)
    c115682705[Duel.GetCurrentChain()]=te
    Duel.SendtoGrave(g,REASON_COST)
end
function c115682705.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local te=c115682705[Duel.GetCurrentChain()]
    if chkc then
        local tg=te:GetTarget()
        return tg(e,tp,eg,ep,ev,re,r,rp,0,true)
    end
    if chk==0 then return true end
    if not te then return end
    e:SetCategory(te:GetCategory())
    e:SetProperty(te:GetProperty())
    local tg=te:GetTarget()
    if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c115682705.cpop(e,tp,eg,ep,ev,re,r,rp)
    local te=c115682705[Duel.GetCurrentChain()]
    if not te then return end
    local op=te:GetOperation()
    if op then op(e,tp,eg,ep,ev,re,r,rp) end
end