local s,id,o=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_CHAIN_SOLVED)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.spcon)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,id+1)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)
    local e2b=e2:Clone()
    e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2b)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_SZONE)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e3:SetCountLimit(1)
    e3:SetCondition(s.descon)
    e3:SetTarget(s.destg)
    e3:SetOperation(s.desop)
    c:RegisterEffect(e3)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    local ty=re:GetActiveType()
    return ty&TYPE_QUICKPLAY~=0 or (ty&TYPE_TRAP~=0 and ty&TYPE_CONTINUOUS~=0)
end
function s.revfilter(c)
    return c:IsSetCard(0x3e7a) and not c:IsCode(74620020) and not c:IsPublic()
end
function s.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x3e7a)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.IsExistingMatchingCard(s.revfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
    local b2=Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
    if chk==0 then return b1 or b2 end
    if b1 then
        if b2 and not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local g=Duel.SelectMatchingCard(tp,s.revfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
        Duel.ConfirmCards(1-tp,g)
        Duel.ShuffleHand(tp)
    end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
function s.thfilter(c,tp)
    if not (c:IsSetCard(0x3e7a) and c:IsType(TYPE_MONSTER)) then return false end
    return c:IsAbleToHand() or Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
    local tc=g:GetFirst()
    if tc then
        local b1=tc:IsAbleToHand()
        local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        local op=0
        if b1 and b2 then
            op=Duel.SelectOption(tp,1190,aux.Stringid(id,1))
        elseif b1 then
            op=Duel.SelectOption(tp,1190)
        else
            op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
        end
        if op==0 then
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        else
            if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetCode(EFFECT_CHANGE_TYPE)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
                e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
                tc:RegisterEffect(e1)
            end
        end
    end
    local c=e:GetHandler()
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetTargetRange(1,0)
    e2:SetTarget(s.splimit)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function s.splimit(e,c)
    return c:IsType(TYPE_LINK) and c:IsLinkAbove(5)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ph=Duel.GetCurrentPhase()
    return c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g1=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
    if #g1>0 and Duel.Destroy(g1,REASON_EFFECT)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
        if #g2>0 then
            Duel.BreakEffect()
            Duel.Destroy(g2,REASON_EFFECT)
        end
    end
end