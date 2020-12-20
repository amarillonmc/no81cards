--影依の再誕 リバース
function c84610034.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c84610034.matfilter,1,1)
    c:EnableReviveLimit()
    --not act
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_CANNOT_ACTIVATE)
    e0:SetRange(LOCATION_MZONE)
    e0:SetTargetRange(0,1)
    e0:SetCondition(c84610034.econ)
    e0:SetValue(c84610034.actval)
    c:RegisterEffect(e0)
    --to grave and todeck or spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c84610034.target)
    e1:SetOperation(c84610034.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_MATERIAL_CHECK)
    e2:SetValue(c84610034.valcheck)
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)
    --change pos
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(84610034,0))
    e3:SetCategory(CATEGORY_POSITION)
    e3:SetType(EFFECT_TYPE_QUICK_O) 
    e3:SetCode(EVENT_FREE_CHAIN)    
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1) 
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e3:SetTarget(c84610034.chtg)
    e3:SetOperation(c84610034.chop)
    c:RegisterEffect(e3)
    --set
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(84610034,1))
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,84610034)
    e4:SetTarget(c84610034.settg)
    e4:SetOperation(c84610034.setop)
    c:RegisterEffect(e4)
end
function c84610034.matfilter(c)
    return c:IsLinkSetCard(0x9d) and not c:IsLinkType(TYPE_LINK)
end
function c84610034.efilter(c)
    return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0x9d)
end
function c84610034.econ(e)
    return Duel.IsExistingMatchingCard(c84610034.efilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,3,nil)
end
function c84610034.actval(e,re,rp)
    local g=Duel.GetMatchingGroup(c84610034.efilter,tp,LOCATION_MZONE,0,nil)
    if g:GetCount()>3 then return end
    local tc=g:GetFirst()
    local c=re:GetHandler()
    if tc then
        tc1=g:GetNext()
        tc2=g:GetNext()
    end
    return re:IsActiveType(TYPE_MONSTER) and (c:IsAttribute(tc:GetAttribute())
        or c:IsAttribute(tc1:GetAttribute()) or c:IsAttribute(tc2:GetAttribute()))
end
function c84610034.gfilter(c)
    return c:IsSetCard(0x9d) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c84610034.tfilter(c)
    return c:IsSetCard(0x9d) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c84610034.spfilter(c,e,tp)
    return c:IsSetCard(0x9d) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84610034.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610034.gfilter,tp,LOCATION_DECK,0,1,nil)
        and (Duel.IsExistingMatchingCard(c84610034.tfilter,tp,LOCATION_GRAVE,0,1,nil)
        or (e:GetLabel()==1 and Duel.IsExistingMatchingCard(c84610034.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp))) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c84610034.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c84610034.gfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        ct=Duel.SendtoGrave(g,REASON_EFFECT)
    end
    s=0
    if ct>0 and e:GetLabel()==1 and Duel.GetFlagEffect(tp,84610034)==0
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.SelectYesNo(tp,aux.Stringid(84610034,2)) then
        local tg=Duel.GetMatchingGroup(c84610034.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,false,false)
        if tg:GetCount()>0 then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sg=tg:Select(tp,1,1,nil)
            s=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
            Duel.RegisterFlagEffect(tp,84610034,RESET_PHASE+PHASE_END,0,1)
        end
    end
    if ct>0 and s~=1 then
        local tg=Duel.GetMatchingGroup(c84610034.tfilter,tp,LOCATION_GRAVE,0,nil,e,tp,false,false)
        if tg:GetCount()>0 then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
            local sg=tg:Select(tp,1,1,nil)
            Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
        end
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetValue(c84610034.limval)
    Duel.RegisterEffect(e1,tp)
end
function c84610034.limval(e,re,rp)
    local rc=re:GetHandler()
    return re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE
        and not rc:IsSetCard(0x9d) and not rc:IsImmuneToEffect(e)
end
function c84610034.mfilter(c)
    return c:IsType(TYPE_FUSION)
end
function c84610034.valcheck(e,c)
    local g=c:GetMaterial()
    if g:IsExists(c84610034.mfilter,1,nil) then
        e:GetLabelObject():SetLabel(1)
    else
        e:GetLabelObject():SetLabel(0)
    end
end
function c84610034.cmfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x9d)
end
function c84610034.chfilter(c)
    return (not c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()) or c:IsCanTurnSet()
end
function c84610034.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610034.cmfilter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingMatchingCard(c84610034.chfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c84610034.chfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c84610034.chop(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetMatchingGroup(c84610034.cmfilter,tp,LOCATION_MZONE,0,nil)
    local g2=Duel.GetMatchingGroup(c84610034.chfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local ct=5
    ct=math.min(ct,g1:GetCount())
    if ct>0 and g2:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
        local tg=g2:Select(tp,1,ct,nil)
        local tc=tg:GetFirst()
        while tc do
            if tc:IsAttackPos() then
                local pos=0
                if tc:IsCanTurnSet() then
                    pos=Duel.SelectPosition(tp,tc,POS_DEFENSE)
                else
                    pos=Duel.SelectPosition(tp,tc,POS_FACEUP_DEFENSE)
                end
                Duel.ChangePosition(tc,pos)
            else
                Duel.ChangePosition(tc,0,0,POS_FACEDOWN_DEFENSE,POS_FACEUP_DEFENSE)
            end
            tc=tg:GetNext()
        end
    end
end
function c84610034.setfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x9d) and c:IsSSetable() 
end
function c84610034.setcheck(g)
    return g:GetClassCount(Card.GetCode)==#g
end
function c84610034.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c84610034.efilter,tp,LOCATION_MZONE,0,nil)
    if chk==0 then return g:GetCount()>1
        and Duel.IsExistingMatchingCard(c84610034.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c84610034.setop(e,tp,eg,ep,ev,re,r,rp)
    local cg=Duel.GetMatchingGroup(c84610034.efilter,tp,LOCATION_MZONE,0,nil)
    local ct=cg:GetClassCount(Card.GetCode)
    if ct==0 then return end
    local g=Duel.GetMatchingGroup(c84610034.setfilter,tp,LOCATION_GRAVE,0,nil)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
        local sg=g:SelectSubGroup(tp,c84610034.setcheck,false,1,ct)
        local tc=sg:GetFirst()
        while tc do
            Duel.SSet(tp,tc)
            tc=sg:GetNext()
        end
    end
end
