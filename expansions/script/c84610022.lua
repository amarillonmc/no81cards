--妖精伝姫－禁断の書
function c84610022.initial_effect(c)
    --autoaction
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e0:SetCode(EVENT_PREDRAW)
    e0:SetRange(LOCATION_DECK)
    e0:SetCountLimit(1,84610022+EFFECT_COUNT_CODE_DUEL)
    e0:SetOperation(c84610022.autoop)
    c:RegisterEffect(e0)
    --inactivatable
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_INACTIVATE)
    e1:SetRange(LOCATION_ONFIELD)
    e1:SetValue(c84610022.effectfilter)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)   
    e2:SetCode(EFFECT_CANNOT_DISEFFECT)
    e2:SetRange(LOCATION_ONFIELD)
    e2:SetValue(c84610022.effectfilter)
    c:RegisterEffect(e2)
    --tohand+search
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(c84610022.activate)
    c:RegisterEffect(e1)
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_ONFIELD,0)
    e2:SetTarget(c84610022.indestg)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
    --Action
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(84610022,2))
    e4:SetCategory(CATEGORY_TODECK)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_FZONE)
    e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e4:SetTarget(c84610022.tdtg)
    e4:SetOperation(c84610022.tdop)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetDescription(aux.Stringid(84610022,3))
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetTarget(c84610022.target)
    e5:SetOperation(c84610022.operation)
    c:RegisterEffect(e5)
    local e6=e4:Clone()
    e6:SetDescription(aux.Stringid(84610022,4))
    e6:SetCategory(CATEGORY_POSITION)
    e6:SetTarget(c84610022.target2)
    e6:SetOperation(c84610022.activate2)
    c:RegisterEffect(e6)
    local e7=e4:Clone()
    e7:SetDescription(aux.Stringid(84610022,6))
    e7:SetCategory(CATEGORY_REMOVE)
    e7:SetTarget(c84610022.remtg)
    e7:SetOperation(c84610022.remop)
    c:RegisterEffect(e7)
end
function c84610022.rfilter(c)
    return c:IsCode(84610022)
end
function c84610022.spfilter(c,e,tp)
    return c:IsAttack(1850) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84610022.autoop(e,tp,eg,ep,ev,re,r,rp,chk)
    local dc=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
    Duel.ShuffleDeck(tp)
    --local ht1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
    --if ht1<5 then
        --Duel.Draw(tp,5-ht1,REASON_RULE)
    --end
    --local ht1=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
    --if ht1<5 then
        --Duel.Draw(1-tp,5-ht1,REASON_RULE)
    --end
    local fg=Duel.GetMatchingGroup(c84610022.spfilter,tp,LOCATION_DECK,0,nil,e,tp,false,false)
    if fg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(84610022,0)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=fg:Select(tp,1,1,nil)
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c84610022.effectfilter(e,ct)
    local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
    local tc=te:GetHandler()
    return tc:IsRace(RACE_SPELLCASTER)
end
function c84610022.thfilter(c)
    return c:IsAttack(1850) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c84610022.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c84610022.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(84610022,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function c84610022.indestg(e,c)
    return c:IsRace(RACE_SPELLCASTER)
end
function c84610022.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return e:GetHandler():GetFlagEffect(84610022)==0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_REMOVED)
    c:RegisterFlagEffect(84610022,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c84610022.tdop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,LOCATION_REMOVED)
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c84610022.filter(c)
    return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c84610022.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return e:GetHandler():GetFlagEffect(84610022)==0 and Duel.IsExistingMatchingCard(c84610022.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    c:RegisterFlagEffect(84610022,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c84610022.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c84610022.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        local tc=g:GetFirst()
        if tc:IsLocation(LOCATION_HAND) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e1:SetCode(EFFECT_CANNOT_ACTIVATE)
            e1:SetTargetRange(1,0)
            e1:SetValue(c84610022.aclimit)
            e1:SetLabelObject(tc)
            e1:SetReset(RESET_PHASE+PHASE_END)
            Duel.RegisterEffect(e1,tp)
        end
    end
end
function c84610022.aclimit(e,re,tp)
    local tc=e:GetLabelObject()
    return re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
function c84610022.filter2(c)
    return c:IsFaceup() and c:IsCanTurnSet()
end
function c84610022.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return e:GetHandler():GetFlagEffect(84610022)==0 and Duel.IsExistingMatchingCard(c84610022.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c84610022.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
    c:RegisterFlagEffect(84610022,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c84610022.filter3(c)
    return not c:IsPosition(POS_FACEUP_ATTACK)
end
function c84610022.activate2(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g=Duel.SelectMatchingCard(tp,c84610022.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.HintSelection(g)
        if tc:IsPosition(POS_FACEUP) then
            pc=Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
        end
    end
    if pc>0 then
        local fg=Duel.GetMatchingGroup(c84610022.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
        if fg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(84610022,5)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
            local g=Duel.SelectMatchingCard(tp,c84610022.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
            local tc=g:GetFirst()
            if tc then
                Duel.HintSelection(g)
                if tc:IsPosition(POS_FACEUP_DEFENSE+POS_FACEDOWN_DEFENSE) then
                    Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
                end
            end
        end
    end
end
function c84610022.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return e:GetHandler():GetFlagEffect(84610022)==0
        and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_IRON_WALL)
        and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK+LOCATION_EXTRA)
    c:RegisterFlagEffect(84610022,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c84610022.remop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
    if sg:GetCount()>0 then
        local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK+LOCATION_EXTRA)
        Duel.ConfirmCards(tp,g)
        local tg=g:Filter(Card.IsCode,nil,sg:GetFirst():GetCode())
        if tg:GetCount()>0 then
            Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
        end
    end
end
