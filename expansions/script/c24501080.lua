--神威骑士堡中门炮（未解限）
function c24501080.initial_effect(c)
	-- Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    -- 特殊召唤
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(24501080,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1,24501080)
    e1:SetCondition(c24501080.con1)
    e1:SetTarget(c24501080.tg1)
    e1:SetOperation(c24501080.op1)
    c:RegisterEffect(e1)
    -- 选项破坏
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(24501080,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c24501080.con2)
    e2:SetTarget(c24501080.tg2)
    e2:SetOperation(c24501080.op2)
    c:RegisterEffect(e2)
end
-- 1
function c24501080.con1(e,tp)
    return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c24501080.filter1(c,e,tp)
    return c:IsFaceupEx() and c:IsSetCard(0x501) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24501080.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c24501080.filter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c24501080.op1(e,tp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c24501080.filter1),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
-- 2
function c24501080.filter2(c)
    return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x501)
end
function c24501080.con2(e,tp)
    return Duel.IsExistingMatchingCard(c24501080.filter2,tp,LOCATION_MZONE,0,1,nil)
end
function c24501080.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.GetFlagEffect(tp,24501082)==0 
        and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,2,nil)
    local b2=Duel.GetFlagEffect(tp,24501083)==0 
        and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
    if chk==0 then return b1 or b2 end
    local ops={}
    local opval={}
    if b1 then
        ops[#ops+1]=aux.Stringid(24501080,2)
        opval[#opval+1]=0
    end
    if b2 then
        ops[#ops+1]=aux.Stringid(24501080,3)
        opval[#opval+1]=1
    end
    local op=Duel.SelectOption(tp,table.unpack(ops))
    e:SetLabel(opval[op+1])
    local sel=e:GetLabel()
    if sel==0 then
        Duel.RegisterFlagEffect(tp,24501082,RESET_PHASE+PHASE_END,0,1)
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,1-tp,LOCATION_ONFIELD)
    else
        Duel.RegisterFlagEffect(tp,24501083,RESET_PHASE+PHASE_END,0,1)
        Duel.SetOperationInfo(0,CATEGORY_DISABLE+CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
    end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function c24501080.op2(e,tp)
    local op=e:GetLabel()
    local c=e:GetHandler()
    if op==0 then
        local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
        if #g>=2 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local sg=g:Select(tp,2,2,nil)
            Duel.Destroy(sg,REASON_EFFECT)
        end
    elseif op==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
        local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
        if tc then
            Duel.NegateRelatedChain(tc,RESET_TURN_SET)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
            Duel.Destroy(tc,REASON_EFFECT)
        end
    end
    Duel.BreakEffect()
    local selfg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
    if #selfg>0 then
        Duel.Destroy(selfg,REASON_EFFECT)
    end
end
