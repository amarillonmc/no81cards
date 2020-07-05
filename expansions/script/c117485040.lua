function c117485040.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,117485040+EFFECT_COUNT_CODE_OATH)
    e1:SetOperation(c117485040.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER))
    e2:SetValue(c117485040.evalue)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1,117485040)
    e3:SetCondition(c117485040.pencon)
    e3:SetOperation(c117485040.penop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EVENT_CHAINING)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e4:SetTarget(c117485040.target2)
    e4:SetOperation(c117485040.activate2)
    c:RegisterEffect(e4)
end
function c117485040.filter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c117485040.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c117485040.filter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(117485040,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function c117485040.evalue(e,re,rp)
    return re:IsActiveType(TYPE_MONSTER) and rp~=e:GetHandlerPlayer()
end
function c117485040.sumfilter(c)
    return c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x98)
end
function c117485040.pencon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c117485040.sumfilter,1,nil)
end
function c117485040.penop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(117485040,1))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    e2:SetValue(aux.TRUE)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function c117485040.filter2(c)
    return c:IsSetCard(0x98) and c:IsDestructable()
end
function c117485040.filter3(c,e,tp,code)
    return c:IsCode(code) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c117485040.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_PZONE) and c117485040.filter2(chkc) end
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingTarget(c117485040.filter2,tp,LOCATION_PZONE,0,1,nil) and c:GetFlagEffect(117485040)==0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,c117485040.filter2,tp,LOCATION_PZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    c:RegisterFlagEffect(117485040,RESET_CHAIN,0,1)
end
function c117485040.activate2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Destroy(tc,REASON_EFFECT)
        local g=Duel.GetMatchingGroup(c117485040.filter3,tp,LOCATION_DECK,0,nil,e,tp,tc:GetCode())
        local b1=g:GetCount()>0
        local b2=Duel.IsChainNegatable(ev) and c:IsDestructable()
        local op=0
        if b1 and b2 then
            op=Duel.SelectOption(tp,aux.Stringid(117485040,2),aux.Stringid(117485040,3))
        elseif b1 then
            op=Duel.SelectOption(tp,aux.Stringid(117485040,2))
        elseif b2 then
            op=Duel.SelectOption(tp,aux.Stringid(117485040,3))+1
        else return end
        if op==0 then
            Duel.SpecialSummon(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
        else
            Duel.NegateActivation(ev)
            Duel.Destroy(c,REASON_EFFECT)
        end
    end
end