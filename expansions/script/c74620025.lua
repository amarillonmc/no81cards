local s,id,o=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.plcon1)
    e1:SetTarget(s.pltg1)
    e1:SetOperation(s.plop1)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id+1)
    e2:SetCondition(s.plcon2)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.pltg2)
    e2:SetOperation(s.plop2)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1,id+2)
    e3:SetValue(s.matval)
    c:RegisterEffect(e3)
end
function s.plcon1(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return Duel.GetTurnPlayer()==tp or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function s.thfilter(c)
    return c:IsSetCard(0x3e7a) and c:IsAbleToHand()
end
function s.pltg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.splimit(e,c)
    return c:IsType(TYPE_LINK) and c:IsLinkAbove(5)
end
function s.plop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
        if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
            local e1=Effect.CreateEffect(c)
            e1:SetCode(EFFECT_CHANGE_TYPE)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
            e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
            c:RegisterEffect(e1)
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
            if #g>0 then
                Duel.SendtoHand(g,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,g)
            end
        end
    end
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetTargetRange(1,0)
    e2:SetTarget(s.splimit)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function s.desfilter(c,tp)
    return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
        and c:GetOriginalType()&TYPE_MONSTER~=0 and c:GetOriginalRace()&RACE_CYBERSE~=0
end
function s.plcon2(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.desfilter,1,nil,tp)
end
function s.tgfilter2(c)
    return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_MONSTER)
end
function s.pltg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(s.tgfilter2,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
end
function s.plop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tgfilter2),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
    if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
        tc:RegisterEffect(e1)
    end
end
function s.exmfilter(c)
    return c:IsLocation(LOCATION_SZONE) and c:IsCode(id)
end
function s.matval(e,lc,mg,c,tp)
    if not lc then return false,nil end
    if not (lc:IsRace(RACE_CYBERSE)) then return false,nil end
    if e:GetHandler():GetType()&(TYPE_TRAP+TYPE_CONTINUOUS)~=(TYPE_TRAP+TYPE_CONTINUOUS) then return false,nil end
    return true,not mg or not mg:IsExists(s.exmfilter,1,nil)
end