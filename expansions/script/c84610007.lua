--水晶機巧－シンクロン
function c84610007.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCost(c84610007.spcost)   
    e1:SetTarget(c84610007.sptg)
    e1:SetOperation(c84610007.spop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e3:SetCondition(c84610007.sccon)
    e3:SetTarget(c84610007.sctg)
    e3:SetOperation(c84610007.scop)
    c:RegisterEffect(e3)
    --level
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(c84610007.lvtg)
    e4:SetOperation(c84610007.lvop)
    c:RegisterEffect(e4)
    --set
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_REMOVE)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCountLimit(1,84610007)
    e5:SetHintTiming(0,TIMING_END_PHASE)
    e5:SetCost(aux.bfgcost)
    e5:SetCondition(c84610007.setcon)  
    e5:SetOperation(c84610007.setop)
    c:RegisterEffect(e5)
end
function c84610007.gfilter(c)
    return c:IsSetCard(0xea)    
end
function c84610007.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610007.gfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c84610007.gfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_COST)
    end
end
function c84610007.spfilter(c,e,tp)
    return c:IsSetCard(0xea) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(84610007)
end
function c84610007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c84610007.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c84610007.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c84610007.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function c84610007.sccon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return Duel.GetTurnPlayer()~=tp and e:GetHandler():GetFlagEffect(84610007)<1
end
function c84610007.scfilter1(c,e,tp,mc)
    local mg=Group.FromCards(c,mc)
    return not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingMatchingCard(c84610007.scfilter2,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function c84610007.scfilter2(c,mg)
    return c:IsSynchroSummonable(nil,mg)
end
function c84610007.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c84610007.scfilter1(chkc,e,tp,e:GetHandler()) end
    if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c84610007.scfilter1,tp,LOCATION_DECK,0,1,nil,e,tp,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    e:GetHandler():RegisterFlagEffect(84610007,RESET_CHAIN,0,1)
end
function c84610007.scop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    local g=Duel.SelectMatchingCard(tp,c84610007.scfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetHandler())
    local tc=g:GetFirst()
    if not tc or not Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    tc:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    tc:RegisterEffect(e2)
    Duel.SpecialSummonComplete()
    if not c:IsRelateToEffect(e) then return end
    local mg=Group.FromCards(c,tc)
    local g=Duel.GetMatchingGroup(c84610007.scfilter2,tp,LOCATION_EXTRA,0,nil,mg)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,1,1,nil)
        Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
    end
end
function c84610007.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
    local lv=Duel.AnnounceLevel(tp,1,3)
    e:SetLabel(lv)
end
function c84610007.lvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local fid=0
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetValue(e:GetLabel())
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        c:RegisterEffect(e1)
        fid=c:GetRealFieldID()
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
        e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetTargetRange(0xff,0xff)
        e2:SetValue(1)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        Duel.RegisterEffect(e2,true)
    end
end
function c84610007.setcon(c,tp)
    return Duel.IsExistingMatchingCard(c84610007.setfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,c)
end
function c84610007.setfilter(c)
    return c:IsType(TYPE_TRAP) and c:IsSetCard(0xea) and c:IsSSetable()
end
function c84610007.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,c84610007.setfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.SSet(tp,tc)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
        e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
    end
end
