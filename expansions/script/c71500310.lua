-- c71500300.lua
-- 原初之七彩 珀尔
local s,id=GetID()
function s.initial_effect(c)
    -- 召唤限制：不能通常召唤
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_CANNOT_SUMMON)
    c:RegisterEffect(e0)
    local e0a=e0:Clone()
    e0a:SetCode(EFFECT_CANNOT_MSET)
    c:RegisterEffect(e0a)

    -- ①：手卡·墓地特殊召唤 + 检索/回收 神石镇压
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)

    -- ②：魔陷区域保护
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e2:SetTarget(aux.TRUE) -- 影响魔陷区所有卡
    e2:SetValue(s.efilter)
    c:RegisterEffect(e2)

    -- ③：每次反击陷阱发动后盖放
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_CHAIN_SOLVED) -- 改为连锁处理后触发，解决速攻/反击陷阱速度问题
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCondition(s.setcon)
    e3:SetCost(s.setcost)
    e3:SetTarget(s.settg)
    e3:SetOperation(s.setop)
    c:RegisterEffect(e3)
end

s.listed_names={71500305}

-- e1 效果逻辑
function s.cfilter(c)
    return c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.cfilter,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.thfilter(c)
    return c:IsCode(71500305) and c:IsAbleToHand()
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
        local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
        if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local sg=g:Select(tp,1,1,nil)
            if #sg>0 then
                Duel.SendtoHand(sg,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,sg)
            end
        end
    end
end

-- e2 抗性逻辑：不受此卡以外的效果影响
function s.efilter(e,re)
    return re:GetHandler()~=e:GetHandler()
end

-- e3 盖放逻辑
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
    -- 检查刚刚处理完的效果是否为自己发动的反击陷阱
    return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_TRAP) and re:GetHandler():IsType(TYPE_COUNTER)
end
function s.costfilter(c)
    return c:IsRace(RACE_FAIRY) and c:IsAbleToGraveAsCost()
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function s.setfilter(c)
    return c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SSet(tp,g:GetFirst())
    end
end