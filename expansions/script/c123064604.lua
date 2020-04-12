function c123064604.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,123064604+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c123064604.target)
    e1:SetOperation(c123064604.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_NEGATE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCountLimit(1)
    e2:SetCondition(c123064604.discon)
    e2:SetTarget(c123064604.distg)
    e2:SetOperation(c123064604.disop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_MSET)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(0,1)
    e3:SetCondition(c123064604.setcon)
    e3:SetTarget(aux.TRUE)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_CANNOT_SSET)
    c:RegisterEffect(e4)
    local e5=e3:Clone()
    e5:SetCode(EFFECT_CANNOT_TURN_SET)
    c:RegisterEffect(e5)
    local e6=e3:Clone()
    e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e6:SetTarget(c123064604.sumlimit)
    c:RegisterEffect(e6)
end
function c123064604.filter1(c,e,tp)
    return c:GetAttack()==800 and c:GetDefense()==1000 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c123064604.filter2(c)
    return c:GetAttack()==2800 and c:GetDefense()==1000 and c:IsAbleToHand()
end
function c123064604.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=(Duel.IsExistingMatchingCard(c123064604.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
    local b2=Duel.IsExistingMatchingCard(c123064604.filter2,tp,LOCATION_DECK,0,1,nil)
    if chk==0 then return b1 or b2 end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c123064604.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local b1=(Duel.IsExistingMatchingCard(c123064604.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
    local b2=Duel.IsExistingMatchingCard(c123064604.filter2,tp,LOCATION_DECK,0,1,nil)
    local op=0
    if b1 and b2 then
        op=Duel.SelectOption(tp,aux.Stringid(123064604,0),aux.Stringid(123064604,1))
    elseif b1 then
        op=Duel.SelectOption(tp,aux.Stringid(123064604,0))
    else
        op=Duel.SelectOption(tp,aux.Stringid(123064604,1))+1
    end
    if op==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c123064604.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c123064604.filter2,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
function c123064604.discon(e,tp,eg,ep,ev,re,r,rp)
    return rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c123064604.sumfilter(c,lv)
    return c:GetLevel()>=lv and c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1) and not c:IsPublic()
end
function c123064604.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ec=eg:GetFirst()
    local lv=99
    if ec:IsType(TYPE_XYZ) then
        lv=ec:GetOriginalRank()
    elseif not ec:IsType(TYPE_LINK) then
        lv=ec:GetOriginalLevel()
    end
    if chk==0 then return Duel.IsExistingMatchingCard(c123064604.sumfilter,tp,LOCATION_HAND,0,1,nil,lv) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,c123064604.sumfilter,tp,LOCATION_HAND,0,1,1,nil,lv)
    if g:GetCount()>0 then
        Duel.ConfirmCards(1-tp,g)
        Duel.ShuffleHand(tp)
        Duel.SetTargetCard(g)
    end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c123064604.disop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc then
        local s1=tc:IsSummonable(true,nil,1)
        local s2=tc:IsMSetable(true,nil,1)
        if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
            Duel.Summon(tp,tc,true,nil,1)
            Duel.NegateActivation(ev)
        else
            Duel.MSet(tp,tc,true,nil,1)
            Duel.NegateActivation(ev)
        end
    end
end
function c123064604.cfilter(c)
    return bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function c123064604.setcon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
        and Duel.IsExistingMatchingCard(c123064604.cfilter,tp,LOCATION_MZONE,0,1,nil)
        and not Duel.IsExistingMatchingCard(c123064604.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c123064604.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return bit.band(sumpos,POS_FACEDOWN)>0
end