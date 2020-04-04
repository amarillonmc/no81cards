--极光之宣告者
local m=117960683
local cm=_G["c"..m]
function cm.isherald(c)
    return c:IsCode(1249315,17266660,21074344,27383110,44665365,48546368,79306385,79606837,94689635,m,121074344,92919429,46935289)
end
function cm.initial_effect(c)
    --negate(herald of the orange light)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.negcon1)
    e1:SetCost(cm.negcost)
    e1:SetTarget(cm.negtg)
    e1:SetOperation(cm.negop)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetRange(LOCATION_DECK)
    e2:SetTargetRange(LOCATION_HAND,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,17266660))
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)
    --negate(herald of the green light)
    local e3=e1:Clone()
    e3:SetCondition(cm.negcon2)
    local e4=e2:Clone()
    e4:SetTarget(aux.TargetBoolFunction(Card.IsCode,21074344))
    e4:SetLabelObject(e3)
    c:RegisterEffect(e4)
    --negate(herald of the purple light)
    local e5=e1:Clone()
    e5:SetCondition(cm.negcon3)
    local e6=e2:Clone()
    e6:SetTarget(aux.TargetBoolFunction(Card.IsCode,94689635))
    e6:SetLabelObject(e5)
    c:RegisterEffect(e6)
    --negate(herald of perfection,herald of ultimateness)
    local e7=e1:Clone()
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(cm.negcon4)
    e7:SetCost(cm.discost)
    local e8=e2:Clone()
    e8:SetTargetRange(LOCATION_MZONE,0)
    e8:SetTarget(aux.TargetBoolFunction(Card.IsCode,44665365,48546368))
    e8:SetLabelObject(e7)
    c:RegisterEffect(e8)
    --disable spsummon(herald of ultimateness)
    local e9=Effect.CreateEffect(c)
    e9:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
    e9:SetType(EFFECT_TYPE_QUICK_O)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EVENT_SPSUMMON)
    e9:SetCountLimit(1,m)
    e9:SetCondition(cm.discon)
    e9:SetCost(cm.discost)
    e9:SetTarget(cm.distg)
    e9:SetOperation(cm.disop)
    local e10=e2:Clone()
    e10:SetTargetRange(LOCATION_MZONE,0)
    e10:SetTarget(aux.TargetBoolFunction(Card.IsCode,48546368))
    e10:SetLabelObject(e9)
    c:RegisterEffect(e10)
    --to hand
    local e11=Effect.CreateEffect(c)
    e11:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e11:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e11:SetCode(EVENT_TO_GRAVE)
    e11:SetTarget(cm.thtg)
    e11:SetOperation(cm.thop)
    c:RegisterEffect(e11)
    --spsummon
    local e12=Effect.CreateEffect(c)
    e12:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e12:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e12:SetType(EFFECT_TYPE_QUICK_O)
    e12:SetCode(EVENT_FREE_CHAIN)
    e12:SetRange(LOCATION_GRAVE)
    e12:SetHintTiming(0,TIMING_END_PHASE)
    e12:SetCountLimit(1,m+1)
    e12:SetCost(cm.spcost)
    e12:SetTarget(cm.sptg)
    e12:SetOperation(cm.spop)
    c:RegisterEffect(e12)
    local e13=e1:Clone()
    e13:SetRange(LOCATION_MZONE)
    e13:SetCondition(cm.negcon5)
    e13:SetCost(cm.discost)
    local e14=e2:Clone()
    e14:SetTargetRange(LOCATION_MZONE,0)
    e14:SetTarget(aux.TargetBoolFunction(Card.IsCode,46935289))
    e14:SetLabelObject(e13)
    c:RegisterEffect(e14)
end
function cm.negcon1(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function cm.costfilter(c)
    return c:IsCode(m) and c:IsAbleToGraveAsCost()
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_DECK,0,1,nil) end
    local tc=Duel.GetFirstMatchingCard(cm.costfilter,tp,LOCATION_DECK,0,nil)
    Duel.SendtoGrave(Group.FromCards(c,tc),REASON_COST)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function cm.negcon2(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
        and Duel.IsChainNegatable(ev)
end
function cm.negcon3(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
        and Duel.IsChainNegatable(ev)
end
function cm.negcon4(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
    return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function cm.negcon5(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tc=Duel.GetFirstMatchingCard(cm.costfilter,tp,LOCATION_DECK,0,1,nil)
    Duel.SendtoGrave(tc,REASON_COST)
end
function cm.disfilter(c,tp)
    return c:GetSummonPlayer()==tp
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentChain()==0 and eg:IsExists(cm.disfilter,1,nil,1-tp)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=eg:Filter(cm.disfilter,nil,1-tp)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(cm.disfilter,nil,1-tp)
    Duel.NegateSummon(g)
    Duel.Destroy(g,REASON_EFFECT)
end
function cm.thfilter(c)
    return cm.isherald(c) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.spfilter(c,e,tp)
    return cm.isherald(c) and not c:IsCode(m,46935289) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler(),e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler(),e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,tp,LOCATION_GRAVE)
end
function cm.sxfilter(c,mg)
    return c:IsSynchroSummonable(nil,mg) or c:IsXyzSummonable(mg,2,2)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or g:GetCount()<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    local tc=g:GetFirst()
    while tc do
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2,true)
        tc=g:GetNext()
    end
    Duel.SpecialSummonComplete()
    local sxg=Duel.GetMatchingGroup(cm.sxfilter,tp,LOCATION_EXTRA,0,nil,g)
    if Duel.GetLocationCountFromEx(tp,tp,g,e:GetHandler())>0 and sxg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sxc=sxg:Select(tp,1,1,nil):GetFirst()
        if sxc:IsType(TYPE_SYNCHRO) then
            Duel.SynchroSummon(tp,sxc,nil,g)
        else
            Duel.XyzSummon(tp,sxc,g)
        end
    end
end
