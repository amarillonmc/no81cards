local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,74610710)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id+1)
    e2:SetCondition(s.thcon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.settg)
    e2:SetOperation(s.setop)
    c:RegisterEffect(e2)
end
function s.costfilter(c)
    return c:IsAbleToGraveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    if Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
        and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
        Duel.SendtoGrave(g,REASON_COST)
        e:SetLabel(1)
    else
        e:SetLabel(0)
    end
end
function s.thsetfilter(c,tp)
    return c:IsType(TYPE_SPELL) and aux.IsCodeListed(c,74610710)
        and (c:IsLocation(LOCATION_DECK) or c:IsFaceup())
        and (c:IsAbleToHand() or (c:IsSSetable() and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)))
end
function s.thtgfilter(c)
    return c:IsCode(74610710) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function s.revfilter(c,tp)
    if c:IsPublic() then return false end
    if c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) then
        return Duel.IsExistingMatchingCard(s.thsetfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,tp)
    elseif c:IsType(TYPE_SPELL) then
        return Duel.IsExistingMatchingCard(s.thtgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsPlayerCanDraw(tp,1)
    end
    return false
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.revfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),tp) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,s.revfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
    if #g==0 then return end
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
    local tc=g:GetFirst()
    if tc:IsType(TYPE_MONSTER) and tc:IsType(TYPE_RITUAL) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
        local sg=Duel.SelectMatchingCard(tp,s.thsetfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,tp)
        local sc=sg:GetFirst()
        if sc then
            local b1=sc:IsAbleToHand()
            local b2=sc:IsSSetable() and (sc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
            local op=aux.SelectFromOptions(tp,
                {b1,aux.Stringid(id,2),1},
                {b2,aux.Stringid(id,3),2})
            if op==1 then
                Duel.SendtoHand(sc,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,sc)
            elseif op==2 then
                Duel.SSet(tp,sc)
            end
        end
    elseif tc:IsType(TYPE_SPELL) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
        local sg=Duel.SelectMatchingCard(tp,s.thtgfilter,tp,LOCATION_DECK,0,1,1,nil)
        local sc=sg:GetFirst()
        if sc then
            local b1=sc:IsAbleToHand()
            local b2=sc:IsAbleToGrave()
            local op=aux.SelectFromOptions(tp,
                {b1,aux.Stringid(id,2),1},
                {b2,aux.Stringid(id,4),2})
            local res=0
            if op==1 then
                res=Duel.SendtoHand(sc,nil,REASON_EFFECT)
                if res>0 then Duel.ConfirmCards(1-tp,sc) end
            elseif op==2 then
                res=Duel.SendtoGrave(sc,REASON_EFFECT)
            end
            if res>0 then
                Duel.BreakEffect()
                Duel.Draw(tp,1,REASON_EFFECT)
            end
        end
    end
    if e:GetLabel()==1 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
        and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
        local cg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
        if #cg>0 then
            Duel.HintSelection(cg)
            local ctc=cg:GetFirst()
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
            e1:SetValue(ATTRIBUTE_DARK)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            ctc:RegisterEffect(e1)
        end
    end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function s.epsetfilter(c,tp)
    return c:IsType(TYPE_SPELL) and aux.IsCodeListed(c,74610710) and not c:IsCode(id)
        and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSSetable()
        and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.epsetfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,s.epsetfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SSet(tp,tc)
    end
end