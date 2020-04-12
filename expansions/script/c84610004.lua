--妖精伝姫－ケール
function c84610004.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --activate limit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e1:SetCode(EVENT_CHAINING)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_ONFIELD)
    e1:SetOperation(c84610004.aclimit1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_CHAIN_NEGATED)
    e2:SetOperation(c84610004.aclimit2)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetRange(LOCATION_ONFIELD)
    e3:SetCondition(c84610004.econ)
    e3:SetTargetRange(0,1)
    e3:SetValue(aux.TRUE)
    c:RegisterEffect(e3)            
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_LEAVE_FIELD)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCondition(c84610004.spcon1)
    e1:SetTarget(c84610004.sptg1)
    e1:SetOperation(c84610004.spop1)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1)     
    e2:SetTarget(c84610004.target)
    e2:SetOperation(c84610004.activate)
    c:RegisterEffect(e2)
    --spsummon  
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_HAND)
    e1:SetOperation(c84610004.sp1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_CHAIN_NEGATED)
    e2:SetOperation(c84610004.sp2)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_HAND)
    e3:SetCode(EVENT_CHAINING)
    e3:SetCondition(c84610004.spcon)       
    e3:SetTarget(c84610004.sptg)
    e3:SetOperation(c84610004.spop)
    c:RegisterEffect(e3)        
    --summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(84610004,0))
    e4:SetCategory(CATEGORY_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O) 
    e4:SetCode(EVENT_FREE_CHAIN)    
    e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1) 
    e4:SetCost(c84610004.cost1)
    e4:SetTarget(c84610004.target1)
    e4:SetOperation(c84610004.activate1)
    c:RegisterEffect(e4)
    --spsummon
    local e5=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(84610004,1))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_LEAVE_FIELD)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(2)     
    e5:SetCost(c84610004.cost) 
    e5:SetCondition(c84610004.spcon2)  
    e5:SetTarget(c84610004.sptarget)
    e5:SetOperation(c84610004.spactivate)
    c:RegisterEffect(e5)    
end
function c84610004.aclimit1(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp then return end
    e:GetHandler():RegisterFlagEffect(84610004,RESET_PHASE+PHASE_END,0,1)
end
function c84610004.aclimit2(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp then return end
    e:GetHandler():ResetFlagEffect(84610004)
end
function c84610004.econ(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(84610004)>1
end
function c84610004.cfilter(c,tp)
    return c:IsAttack(1850) and c:IsRace(RACE_SPELLCASTER) 
        and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
end
function c84610004.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c84610004.cfilter,1,nil,tp)
end
function c84610004.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c84610004.spop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c84610004.filter(c,e,tp)
    if not c:IsFaceup() or not c:IsRace(RACE_SPELLCASTER)then return false end
    local g=Duel.GetMatchingGroup(c84610004.filter2,tp,LOCATION_DECK,0,nil,e,tp,c)
    return g:GetClassCount(Card.GetCode)>1
end
function c84610004.filter2(c,e,tp,tc)
    return c:IsLevel(tc:GetLevel()) and c:IsAttack(1850)and c:IsRace(tc:GetRace()) and c:IsAttribute(tc:GetAttribute())
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84610004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c84610004.filter(chkc,e,tp) end
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsExistingTarget(c84610004.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c84610004.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c84610004.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.GetMatchingGroup(c84610004.filter2,tp,LOCATION_DECK,0,nil,e,tp,tc)
    if not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and ft>1 and g:GetClassCount(Card.GetCode)>1 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g1=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g2=g:Select(tp,1,1,nil)
        g1:Merge(g2)
        Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c84610004.sp1(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp then return end
    e:GetHandler():RegisterFlagEffect(84610004,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c84610004.sp2(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp then return end
    e:GetHandler():ResetFlagEffect(84610004)
end
function c84610004.spcon(e)
    return e:GetHandler():GetFlagEffect(84610004)>1
end
function c84610004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and rp==1-tp and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c84610004.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c84610004.filter1(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsAttack(1850) and c:IsSummonable(true,nil)
end
function c84610004.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
function c84610004.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610004.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) 
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c84610004.activate1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c84610004.filter1),tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.Summon(tp,tc,true,nil)
    end
end
function c84610004.cofilter(c,tp)
    return c:IsRace(RACE_SPELLCASTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
end
function c84610004.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c84610004.cofilter,1,nil,tp)
end
function c84610004.cosfilter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToGraveAsCost()
end
function c84610004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610004.cosfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c84610004.cosfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_COST)
    end
end
function c84610004.co2filter(c,e,tp)
    return c:IsAttack(1850) and c:IsRace(RACE_SPELLCASTER) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c84610004.spfilter(c,e,tp)
    return c:IsAttack(1850) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84610004.sptarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c84610004.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c84610004.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c84610004.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c84610004.spactivate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetValue(0)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_SET_DEFENSE)
        tc:RegisterEffect(e2)
        Duel.SpecialSummonComplete()        
    end
end
