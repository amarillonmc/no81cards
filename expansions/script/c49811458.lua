-- 废铁解构机
function c49811458.initial_effect(c) 
    c:EnableCounterPermit(0x492,LOCATION_SZONE)
    c:SetCounterLimit(0x492,6)

    -- Activation limit
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetCountLimit(1,49811458+EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e0)

    -- Place Scrap Counters
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_COUNTER)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(c49811458.ctcon)
    e1:SetOperation(c49811458.ctop)
    c:RegisterEffect(e1)

    -- Replacement for destruction
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTarget(c49811458.reptg)
    e2:SetCountLimit(1)
    e2:SetValue(c49811458.repval)
    e2:SetOperation(c49811458.repop)
    c:RegisterEffect(e2)

    -- Remove counters and destroy a monster
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTarget(c49811458.sptg)
    e3:SetOperation(c49811458.spop)
    c:RegisterEffect(e3)
end
function c49811458.ctfilter(c,tp,re,e)
    return c:IsSetCard(0x24) 
        and c:GetPreviousControler()==tp 
        and (not re or re:GetHandler()~=e:GetHandler()) -- 确保效果来源不是这张卡
end

function c49811458.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c49811458.ctfilter,1,nil,tp,re,e) -- 将 e 传递给 ctfilter
end

function c49811458.ctop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():AddCounter(0x492,2)
end


-- Effect 2: Replacement for destruction
function c49811458.repfilter(c,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() and not c:IsReason(REASON_REPLACE) and c:GetPreviousControler()==tp
end
function c49811458.replacementfilter(c)
    return c:IsSetCard(0x24) and c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c49811458.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c49811458.repfilter,1,nil,tp)
        and Duel.IsExistingMatchingCard(c49811458.replacementfilter,tp,LOCATION_HAND,0,1,nil) end
    if Duel.SelectYesNo(tp,aux.Stringid(49811458,0)) then
        return true
    else
        return false
    end
end
function c49811458.repval(e,c)
    return c49811458.repfilter(c,e:GetHandlerPlayer())
end
function c49811458.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,c49811458.replacementfilter,tp,LOCATION_HAND,0,1,1,nil)
    if #g>0 then
        Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
    end
end


-- Effect 3: Remove any number of counters and destroy a monster

function c49811458.filter(c,cc,e,tp)
	return c:IsSetCard(0x24) and c:IsType(TYPE_MONSTER) and c:IsDestructable()
		and c:GetLevel()>0 and cc:IsCanRemoveCounter(tp,0x492,c:GetLevel(),REASON_COST)
end

function c49811458.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811458.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler(),e,tp) end
    local g=Duel.GetMatchingGroup(c49811458.filter,tp,LOCATION_DECK,0,nil,e:GetHandler(),e,tp)
    local lvt={}
    local tc=g:GetFirst()
    while tc do
        local tlv=tc:GetLevel()
        lvt[tlv]=tlv
        tc=g:GetNext()
    end
    local pc=1
    for i=1,12 do
        if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
    end
    lvt[pc]=nil
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(49811458,1))
    local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
    e:GetHandler():RemoveCounter(tp,0x492,lv,REASON_COST)
    e:SetLabel(lv)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
end

function c49811458.sfilter(c,lv)
    return c:IsSetCard(0x24) and c:IsType(TYPE_MONSTER) and c:IsLevel(lv) and c:IsDestructable()
end

function c49811458.spop(e,tp,eg,ep,ev,re,r,rp)
    local lv=e:GetLabel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811458.sfilter),tp,LOCATION_DECK,0,1,1,nil,lv)
    if #g>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
