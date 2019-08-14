--青龙的化身 木莉
function c60159903.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,60159903)
    e1:SetTarget(c60159903.target)
    e1:SetOperation(c60159903.operation)
    c:RegisterEffect(e1)
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60159901,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetTarget(c60159903.target2)
    e2:SetOperation(c60159903.operation2)
    c:RegisterEffect(e2)
    --multiatk
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60159903,2))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c60159903.atkcon)
    e3:SetCost(c60159903.atkcost)
    e3:SetTarget(c60159903.atktg)
    e3:SetOperation(c60159903.atkop)
    c:RegisterEffect(e3)
end
function c60159903.sfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60159903.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummon(tp) 
        and Duel.IsExistingMatchingCard(c60159903.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c60159903.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if (tc:IsAttribute(ATTRIBUTE_EARTH) or tc:IsAttribute(ATTRIBUTE_FIRE) or tc:IsAttribute(ATTRIBUTE_WATER))
    and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
        if Duel.SelectYesNo(tp,aux.Stringid(60159901,1)) then
            Duel.DisableShuffleCheck()
            Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
            Duel.SpecialSummonComplete()
            Duel.ShuffleDeck(tp)
        else
            Duel.ShuffleDeck(tp)
        end
    else
        Duel.ShuffleDeck(tp)
    end
end
function c60159903.filter(c)
    return ((c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_AQUA)) 
        or (c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WINDBEAST)) 
        or (c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_BEAST)))
        and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c60159903.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159903.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60159903.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60159903.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c60159903.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsAbleToEnterBP()
end
function c60159903.cfilter(c)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_DRAGON) and c:IsAbleToRemoveAsCost()
end
function c60159903.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159903.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    local g=Duel.SelectMatchingCard(tp,c60159903.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c60159903.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c60159903.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end