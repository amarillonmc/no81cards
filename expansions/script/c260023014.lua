--大いなる蠅のベルゼブブ
function c260023014.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,nil,2,3,c260023014.lcheck)
    c:EnableReviveLimit()
    
    --control
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_CONTROL)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,260023014)
    e1:SetCondition(c260023014.ctcon)
    e1:SetTarget(c260023014.cttg)
    e1:SetOperation(c260023014.ctop)
    c:RegisterEffect(e1)
    
    --spsummon
    local e2=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(260023014,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,260024014)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c260023014.sptg)
    e2:SetOperation(c260023014.spop)
    c:RegisterEffect(e2)
    
    --effect gain
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
    e3:SetCondition(c260023014.effcon)
    e3:SetOperation(c260023014.effop)
    c:RegisterEffect(e3)
end
    

--【召喚条件】
function c260023014.lcheck(g)
    return g:IsExists(Card.IsLinkSetCard,1,nil,0x2045)
end


--【コントロール奪取】
function c260023014.ctcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsSummonType(SUMMON_TYPE_LINK)
end
function c260023014.ctfilter(c)
    return c:IsControlerCanBeChanged()
end
function c260023014.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c260023014.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c260023014.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,c260023014.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c260023014.ctop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.GetControl(tc,tp,PHASE_END,1)
    end
end


--【特殊召喚】
function c260023014.spfilter(c,e,tp)
    return c:IsCode(260023001) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c260023014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c260023014.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c260023014.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c260023014.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

--【攻撃アップ】
function c260023014.effcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_LINK and e:GetHandler():GetReasonCard():IsRace(RACE_FIEND)
end
function c260023014.effop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(260023014,2))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetValue(c260023014.indval)
    e1:SetOwnerPlayer(ep)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e1,true)
end
function c260023014.indval(e,re,rp)
    return rp==1-e:GetOwnerPlayer()
end
