local s, id = GetID()
function s.initial_effect(c)
 
    -- 效果①：加入手卡时检索幻兽魔陷
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_TO_HAND)
 	e1:SetCountLimit(1,id)
    e1:SetCondition(s.thcon)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
    
    -- 效果②：在墓地时增加抽卡数量
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EFFECT_DRAW_COUNT)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    e2:SetCondition(s.drawcon)
    e2:SetValue(2) -- 抽卡数量变为2
    c:RegisterEffect(e2)
end

-- 效果①：加入手卡时检索幻兽魔陷
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    return (c:IsPreviousLocation(LOCATION_DECK) or c:IsPreviousLocation(LOCATION_GRAVE))
        and re and re:GetHandler():IsSetCard(0x1b)
end

function s.thfilter(c)
    return c:IsSetCard(0x1b) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

-- 效果②条件：墓地存在此卡且场上有幻兽怪兽
function s.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x1b)
end

function s.drawcon(e)
    return Duel.IsExistingMatchingCard(s.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end