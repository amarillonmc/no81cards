-- 虚式-茈
local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,65823005,65823010,65823000)
    --发动
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_REMOVE)
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

--手发条件：五条悟在自己场上表侧表示存在
function s.handcon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(s.gojofilter_normal,tp,LOCATION_MZONE,0,1,nil)
end

--五条悟基础过滤（手发用）
function s.gojofilter_normal(c)
    return c:IsFaceup() and c:IsCode(65823000)
end

--五条悟②效果可用过滤（两方适用用）
function s.gojofilter(c)
    return c:IsFaceup() and c:IsOriginalCodeRule(65823000) and not c:IsDisabled() and c:GetFlagEffect(65823000)==0
end

--选项1过滤
function s.thfilter(c)
    return (c:IsCode(65823005) or c:IsCode(65823010)) and c:IsAbleToHand()
end

--选项2过滤：苍
function s.aofilter(c)
    return c:IsCode(65823005) and c:IsFaceupEx() and c:IsAbleToDeck()
end

--选项2过滤：赫
function s.akafilter(c)
    return c:IsCode(65823010) and c:IsFaceupEx() and c:IsAbleToDeck()
end


function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
    local b2=Duel.IsExistingMatchingCard(s.aofilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
        and Duel.IsExistingMatchingCard(s.akafilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
				and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
    if chk==0 then return b1 or b2 end
    if b1 then Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE) end
    if b2 then
        Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
        Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
    end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
    local b2=Duel.IsExistingMatchingCard(s.aofilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
        and Duel.IsExistingMatchingCard(s.akafilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
				and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
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
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
        if #g>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end

    if sel==2 or sel==3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local g1=Duel.SelectMatchingCard(tp,s.aofilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local g2=Duel.SelectMatchingCard(tp,s.akafilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
        if #g1>0 and #g2>0 then
            g1:Merge(g2)
			Duel.ConfirmCards(1-tp,g1)
            Duel.HintSelection(g1)
            local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
            if Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and #rg>0 then
                Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
            end
        end
    end
end