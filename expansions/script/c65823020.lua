-- 反转术式-修复
local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,65823000)
    --发动
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    --对方回合手发
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,3))
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    c:RegisterEffect(e2)
end

function s.gojofilter(c)
    return c:IsFaceup() and c:IsOriginalCodeRule(65823000) and not c:IsDisabled() and c:GetFlagEffect(65823000)==0
end

--特殊召唤过滤：墓地·除外的五条悟
function s.spfilter(c,e,tp)
    return c:IsCode(65823000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED))
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
    local b2=true --回复4000总是可用
    if chk==0 then return b1 or b2 end
    if b1 then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED) end
    if b2 then Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,4000) end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
    local b2=true
    local both=Duel.IsExistingMatchingCard(s.gojofilter,tp,LOCATION_MZONE,0,1,nil)

    local ops={}
    local opval={}
    local off=1
    if b1 then
        ops[off]=aux.Stringid(id,0)
        opval[off-1]=1
        off=off+1
    end
    if b2 then
        ops[off]=aux.Stringid(id,1)
        opval[off-1]=2
        off=off+1
    end
    if both and b1 and b2 then
        ops[off]=aux.Stringid(id,2)
        opval[off-1]=3
        off=off+1
    end
    if off==1 then return end
    local op=Duel.SelectOption(tp,table.unpack(ops))
    local sel=opval[op]

    if sel==3 then
        Duel.Hint(24,0,aux.Stringid(id,4))
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
        local tc=Duel.SelectMatchingCard(tp,s.gojofilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
        if tc then
            Duel.HintSelection(Group.FromCards(tc))
            tc:RegisterFlagEffect(65823000,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65823000,1))
        end
    end

    if sel==1 or sel==3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
        if #g>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end

    if sel==2 or sel==3 then
        Duel.Recover(tp,4000,REASON_EFFECT)
    end
end