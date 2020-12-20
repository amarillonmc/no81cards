--妖精伝姫－ケール
function c84610004.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --activate limit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_PZONE+LOCATION_MZONE)
    e1:SetOperation(c84610004.actlimit1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_CHAIN_NEGATED)
    e2:SetOperation(c84610004.actlimit2)
    c:RegisterEffect(e2)
    if not c84610004.global_check then
        c84610004.global_check=true
        local e3=e1:Clone()
        e3:SetRange(0xff)
        e3:SetOperation(c84610004.checkop1)
        c:RegisterEffect(e3)
        local e4=e1:Clone()
        e4:SetCode(EVENT_CHAIN_NEGATED)
        e4:SetRange(0xff)
        e4:SetOperation(c84610004.checkop2)
        c:RegisterEffect(e4)
    end
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e5:SetCode(EFFECT_CANNOT_ACTIVATE)
    e5:SetRange(LOCATION_PZONE+LOCATION_MZONE)
    e5:SetTargetRange(0,1)
    e5:SetCondition(c84610004.condition)
    e5:SetValue(aux.TRUE)
    c:RegisterEffect(e5)            
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_LEAVE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCondition(c84610004.pspcon)
    e1:SetTarget(c84610004.psptg1)
    e1:SetOperation(c84610004.pspop1)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1)     
    e2:SetTarget(c84610004.psptg2)
    e2:SetOperation(c84610004.pspop2)
    c:RegisterEffect(e2)
    --spsummon  
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_HAND)
    e1:SetTarget(c84610004.sptg1)
    e1:SetOperation(c84610004.spop1)
    c:RegisterEffect(e1)        
    --summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(84610004,0))
    e2:SetCategory(CATEGORY_SUMMON+CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_QUICK_O) 
    e2:SetCode(EVENT_FREE_CHAIN)    
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1) 
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e2:SetTarget(c84610004.sumtg)
    e2:SetOperation(c84610004.sumop)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(84610004,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)     
    e3:SetCost(c84610004.spcost)   
    e3:SetCondition(c84610004.pspcon)  
    e3:SetTarget(c84610004.sptg2)
    e3:SetOperation(c84610004.spop2)
    c:RegisterEffect(e3)    
end
function c84610004.actlimit1(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp then return end
    e:GetHandler():RegisterFlagEffect(84610004,RESET_EVENT+0x27e0000+RESET_PHASE+PHASE_END,0,1)
end
function c84610004.actlimit2(e,tp,eg,ep,ev,re,r,rp)
    if ep==1-tp then
        if e:GetHandler():GetFlagEffect(84610004)==1 then
            e:GetHandler():ResetFlagEffect(84610004)
        end
        if e:GetHandler():GetFlagEffect(84610004)>1 then
            e:GetHandler():ResetFlagEffect(84610004)
            e:GetHandler():RegisterFlagEffect(84610004,RESET_EVENT+0x27e0000+RESET_PHASE+PHASE_END,0,1)
        end
    end
end
function c84610004.checkop1(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp then
        Duel.RegisterFlagEffect(1-tp,1,RESET_PHASE+PHASE_END,0,1)
    else
        Duel.RegisterFlagEffect(tp,1,RESET_PHASE+PHASE_END,0,1)
    end
end
function c84610004.checkop2(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp then
        if Duel.GetFlagEffect(1-tp,84610004)==1 then
            Duel.ResetFlagEffect(1-tp,84610004)
        end
        if Duel.GetFlagEffect(1-tp,84610004)>1 then
            Duel.ResetFlagEffect(1-tp,84610004)
            Duel.RegisterFlagEffect(1-tp,84610004,RESET_PHASE+PHASE_END,0,1)
        end
    end
    if ep==1-tp then
        if Duel.GetFlagEffect(tp,84610004)==1 then
            Duel.ResetFlagEffect(tp,84610004)
        end
        if Duel.GetFlagEffect(tp,84610004)>1 then
            Duel.ResetFlagEffect(tp,84610004)
            Duel.RegisterFlagEffect(tp,84610004,RESET_PHASE+PHASE_END,0,1)
        end
    end
end
function c84610004.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(84610004)>1
end
function c84610004.cfilter(c,tp)
    return c:IsRace(RACE_SPELLCASTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
end
function c84610004.pspcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c84610004.cfilter,1,nil,tp)
end
function c84610004.psptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c84610004.pspop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c84610004.pfilter1(c,e,tp)
    if not c:IsFaceup() or not c:IsRace(RACE_SPELLCASTER)then return false end
    local g=Duel.GetMatchingGroup(c84610004.pfilter2,tp,LOCATION_DECK,0,nil,e,tp,c)
    return g:GetClassCount(Card.GetCode)>1
end
function c84610004.pfilter2(c,e,tp,tc)
    return c:IsLevel(tc:GetLevel()) and c:IsAttack(1850)and c:IsRace(tc:GetRace()) and c:IsAttribute(tc:GetAttribute())
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84610004.psptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c84610004.pfilter1(chkc,e,tp) end
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsExistingTarget(c84610004.pfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c84610004.pfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,2000)
end
function c84610004.pspop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.GetMatchingGroup(c84610004.pfilter2,tp,LOCATION_DECK,0,nil,e,tp,tc)
    if not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and ft>1 and g:GetClassCount(Card.GetCode)>1 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g1=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g2=g:Select(tp,1,1,nil)
        g1:Merge(g2)
        Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
        Duel.Damage(tp,2000,REASON_EFFECT)
    end
end
function c84610004.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,1)>1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and rp==1-tp and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c84610004.spop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c84610004.sumfilter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsAttack(1850) and c:IsSummonable(true,nil)
end
function c84610004.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610004.sumfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) 
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function c84610004.sumop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,c84610004.sumfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.Summon(tp,tc,true,nil)
        Duel.Damage(tp,1000,REASON_EFFECT)
    end
end
function c84610004.gfilter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToGraveAsCost()
end
function c84610004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610004.gfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c84610004.gfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_COST)
    end
end
function c84610004.spfilter(c,e,tp)
    return c:IsAttack(1850) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84610004.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c84610004.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c84610004.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c84610004.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c84610004.spop2(e,tp,eg,ep,ev,re,r,rp)
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
