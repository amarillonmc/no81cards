local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,74610710)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_CHAIN_NEGATED)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(s.thcon)
    e2:SetCost(s.thcost)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_CUSTOM+id)
    e3:SetCondition(s.thcon2)
    c:RegisterEffect(e3)
end
function s.counterfilter(c)
    return c:IsType(TYPE_RITUAL)
end
function s.splimit(e,c)
    return not c:IsType(TYPE_RITUAL)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAIN_NEGATED)
    e1:SetLabelObject(e)
    e1:SetOperation(s.negcheck)
    e1:SetReset(RESET_CHAIN)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetTargetRange(1,0)
    e2:SetTarget(s.splimit)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function s.negcheck(e,tp,eg,ep,ev,re,r,rp)
    local te=e:GetLabelObject()
    local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
    if rp==tp and de and dp==1-tp and re==te then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_CHAIN_END)
        e1:SetOperation(s.negevent)
        e1:SetLabelObject(te)
        Duel.RegisterEffect(e1,tp)
    end
end
function s.negevent(e,tp,eg,ep,ev,re,r,rp)
    local te=e:GetLabelObject()
    Duel.RaiseEvent(te:GetHandler(),EVENT_CUSTOM+id,te,0,tp,tp,0)
    e:Reset()
end
function s.matfilter(c)
    return c:IsType(TYPE_SPELL) and aux.IsCodeListed(c,74610710) and c:IsAbleToGrave()
end
function s.ritfilter(c,e,tp,mg)
    if not c:IsCode(74610710) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local lv=c:GetLevel()
    if lv<4 then return false end
    local ct=math.floor(lv/4)
    return mg:GetCount()>=ct
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local mg1=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_HAND,0,e:GetHandler())
    local mg2=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_DECK,0,nil)
    local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.ritfilter,tp,LOCATION_DECK,0,1,nil,e,tp,mg1)
    local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.ritfilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg2)
    if chk==0 then return b1 or b2 end
    local op=aux.SelectFromOptions(tp,
        {b1,aux.Stringid(id,0),1},
        {b2,aux.Stringid(id,1),2})
    e:SetLabel(op)
    if op==1 then
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
    elseif op==2 then
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
    end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local op=e:GetLabel()
    local loc_mon=0
    local loc_mat=0
    if op==1 then
        loc_mon=LOCATION_DECK
        loc_mat=LOCATION_HAND
    elseif op==2 then
        loc_mon=LOCATION_HAND
        loc_mat=LOCATION_DECK
    else return end
    local mg=Duel.GetMatchingGroup(s.matfilter,tp,loc_mat,0,e:GetHandler())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.ritfilter,tp,loc_mon,0,1,1,nil,e,tp,mg)
    local tc=g:GetFirst()
    if tc then
        local ct=math.floor(tc:GetLevel()/4)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local mat=mg:Select(tp,ct,ct,nil)
        if #mat==ct and Duel.SendtoGrave(mat,REASON_EFFECT)>0 then
            local og=Duel.GetOperatedGroup()
            if og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==ct then
                tc:SetMaterial(mat)
                Duel.BreakEffect()
                if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)>0 then
                    tc:CompleteProcedure()
                end
            end
        end
    end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
    return rp==tp and de and dp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
        and e:GetHandler()==re:GetHandler() and e:GetHandler():GetReasonEffect()==de
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end
function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c==re:GetHandler() and c:GetReasonEffect()==nil
end