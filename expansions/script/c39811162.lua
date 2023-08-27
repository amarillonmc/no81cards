--しばしば接触するＧ
function c39811162.initial_effect(c)
    --change name
    aux.EnableChangeCode(c,25137581,LOCATION_GRAVE)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(39811162,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,39811162)
    e1:SetCondition(c39811162.descon)
    e1:SetTarget(c39811162.destg)
    e1:SetOperation(c39811162.desop)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(c39811162.regcon)
    e2:SetOperation(c39811162.regop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(39811162,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION+CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,39811163)
    e3:SetCondition(c39811162.spcon)
    e3:SetTarget(c39811162.sptg)
    e3:SetOperation(c39811162.spop)
    c:RegisterEffect(e3)
end
function c39811162.descon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function c39811162.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c39811162.desop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.Destroy(e:GetHandler(),REASON_EFFECT)
    end
end
function c39811162.regcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_EFFECT)
end
function c39811162.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    c:RegisterFlagEffect(39811162,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c39811162.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(39811162)>0
end
function c39811162.posfilter(c,e)
    return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end  
function c39811162.posfilter2(c,e)
    return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsAbleToRemove()
end   
function c39811162.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c39811162.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local sg=#g+1
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,sg,0,0)
end
function c39811162.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
            local g=Duel.GetMatchingGroup(c39811162.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
            if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)<1 then return end
            local tg=Duel.GetMatchingGroup(c39811162.posfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
            if #tg>0 then
                Duel.BreakEffect()
                --not fully implemented: https://github.com/Fluorohydride/ygopro/issues/2404
                Duel.Remove(tg,POS_FACEUP,REASON_RULE)
            end
        end
    end
end