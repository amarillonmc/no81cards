-- 术式顺转-苍
local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,65823000)
    --发动
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SSET+CATEGORY_DISABLE+CATEGORY_TOHAND)
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
    e2:SetCondition(s.handcon)
    c:RegisterEffect(e2)
end
function s.handcon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(s.gojofilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.gojofilter1(c)
    return c:IsFaceup() and c:IsCode(65823000)
end
function s.gojofilter(c)
    return c:IsFaceup() and c:IsOriginalCodeRule(65823000) and not c:IsDisabled() and c:GetFlagEffect(65823000)==0
end
function s.setfilter(c)
    return c:IsType(TYPE_SPELL) and aux.IsCodeListed(c,65823000)
        and c:IsFaceupEx() and c:IsSSetable() and not c:IsForbidden()
end
function s.negfilter(c)
    return c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
    local b2=Duel.IsExistingMatchingCard(s.negfilter,tp,0,LOCATION_ONFIELD,1,nil)
    if chk==0 then return b1 or b2 end
    if b1 then Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED) end
    if b2 then Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local b1=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
    local b2=Duel.IsExistingMatchingCard(s.negfilter,tp,0,LOCATION_ONFIELD,1,nil)
    local both=false
    if Duel.IsExistingMatchingCard(s.gojofilter,tp,LOCATION_MZONE,0,1,nil) then
        both=true
    end
    local off=1
    local ops={}
    local opval={}
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
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
        local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
        if #g>0 then
            Duel.SSet(tp,g:GetFirst())
        end
    end
    if sel==2 or sel==3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
        local g=Duel.SelectMatchingCard(tp,s.negfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
        if #g>0 then
            Duel.HintSelection(g)
            Duel.SendtoHand(g,nil,REASON_EFFECT)
        end
    end
end