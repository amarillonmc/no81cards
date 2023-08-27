--A・O・J プロト·アームズ
function c49811182.initial_effect(c)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811182,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
    e1:SetCountLimit(1,49811182)
    e1:SetCondition(c49811182.thcon1)
    e1:SetCost(c49811182.thcost)
    e1:SetTarget(c49811182.thtg)
    e1:SetOperation(c49811182.thop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e2:SetCondition(c49811182.thcon2)
    c:RegisterEffect(e2)
    --to hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(49811182,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,49811182)
    e3:SetCost(c49811182.gthcost)
    e3:SetCondition(c49811182.gthcon)
    e3:SetTarget(c49811182.gthtg)
    e3:SetOperation(c49811182.gthop)
    c:RegisterEffect(e3)
end
function c49811182.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c49811182.filter(c)
    return c:IsSetCard(0x1) and c:IsAbleToHand() and c:IsLevelBelow(10) and c:IsType(TYPE_MONSTER)
end
function c49811182.gselect(g)
    return g:GetSum(Card.GetLevel)<=10 and g:GetClassCount(Card.GetCode)==#g
end
function c49811182.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811182.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c49811182.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)
    if tg:GetCount()>0 then
        local tc=tg:GetFirst()
        if Duel.SendtoGrave(tg,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_GRAVE) then
            return 
        end    
    end
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c49811182.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
    if g:GetCount()==0 then
        return
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=g:SelectSubGroup(tp,c49811182.gselect,false,1,3)
    if sg:GetCount()>0 then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function c49811182.thcon1(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,1,nil)
end
function c49811182.thcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,1,nil)
end
function c49811182.gthfilter1(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsFaceup()
end
function c49811182.gthfilter2(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c49811182.gthcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c49811182.gthfilter1,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil) or Duel.IsExistingMatchingCard(c49811182.gthfilter2,e:GetHandlerPlayer(),0,LOCATION_GRAVE,1,nil)
end
function c49811182.rfilter(c,e)
    return c:IsLevelAbove(1) and c:IsSetCard(0x1) and c:IsAbleToRemoveAsCost()
end
function c49811182.fselect(g,tp)
    Duel.SetSelectedCard(g)
    return g:CheckWithSumGreater(Card.GetLevel,10)
end
function c49811182.gcheck(g)
    if g:GetSum(Card.GetLevel)<=10 then return true end
    Duel.SetSelectedCard(g)
    return g:CheckWithSumGreater(Card.GetLevel,10)
end
function c49811182.gthcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c49811182.rfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
    if chk==0 then
        local res=g:CheckSubGroup(c49811182.fselect,1,g:GetCount(),tp)
        aux.GCheckAdditional=nil
        return res
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local rg=g:SelectSubGroup(tp,c49811182.fselect,false,1,g:GetCount(),tp)
    aux.GCheckAdditional=nil
    Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c49811182.gthtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c49811182.sfilter(c,e,tp)
    return c:IsSetCard(0x1) and c:IsSummonable(true,nil)
end
function c49811182.gthop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND)
        and Duel.IsExistingMatchingCard(c49811182.sfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
        and Duel.SelectYesNo(tp,aux.Stringid(49811182,2)) then
        Duel.ShuffleHand(tp)
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
        local sg=Duel.SelectMatchingCard(tp,c49811182.sfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
        if sg:GetCount()>0 then
            Duel.Summon(tp,sg:GetFirst(),true,nil)
        end
    end
end