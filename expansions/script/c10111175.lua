-- 卡号：10111175
local s,id=GetID()

function s.initial_effect(c)
	aux.AddCodeList(c,10111169)
    -- 卡名一回合只能发动一张
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e0)

    -- ①：双方墓地的怪兽的种族变成机械族
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_RACE)
    e1:SetRange(LOCATION_SZONE)
    e1:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
    e1:SetValue(RACE_MACHINE)
    c:RegisterEffect(e1)

   -- ②：攻击力/守备力变化效果（分拆为两个独立效果）
    -- 己方机械族上升
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_MZONE,0) -- 仅影响己方怪兽
    e2:SetTarget(s.uptg)
    e2:SetValue(s.upval)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)

    -- 对方机械族下降
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTargetRange(0,LOCATION_MZONE) -- 仅影响对方怪兽
    e4:SetTarget(s.downtg)
    e4:SetValue(s.downval)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e5)

    -- ③：从墓地除外并检索
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,0))
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_GRAVE)
    e6:SetCountLimit(1,id+1)
   	e6:SetCost(aux.bfgcost)
    e6:SetTarget(s.thtg)
    e6:SetOperation(s.thop)
    c:RegisterEffect(e6)
end

-- ②：己方机械族上升的过滤器和数值
function s.uptg(e,c)
    return c:IsRace(RACE_MACHINE)
end
function s.upval(e,c)
    local tp=e:GetHandlerPlayer()
    local ct=Duel.GetMatchingGroupCount(Card.IsRace,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,RACE_MACHINE)
    return ct*100
end

-- ②：对方机械族下降的过滤器和数值
function s.downtg(e,c)
    return c:IsRace(RACE_MACHINE)
end
function s.downval(e,c)
    local tp=e:GetHandlerPlayer()
    local ct=Duel.GetMatchingGroupCount(Card.IsRace,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,RACE_MACHINE)
    return ct*-100
end

-- ③：检索目标
function s.thfilter(c)
    return aux.IsCodeOrListed(c,10111169) and c:IsAbleToHand()
end

-- ③：检索目标设置
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

-- ③：检索操作
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end