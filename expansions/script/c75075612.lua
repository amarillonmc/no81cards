--亲爱温柔之梦
function c75075612.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    -- 效破抗性
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(aux.indoval)
    e3:SetValue(1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetCondition(c75075612.con1)
    e2:SetTarget(c75075612.tg1)
    e2:SetLabelObject(e3)
    c:RegisterEffect(e2)
    -- 除外抗性
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_CANNOT_REMOVE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(c75075612.val1)
    e5:SetValue(1)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e4:SetRange(LOCATION_FZONE)
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e4:SetCondition(c75075612.con1)
    e4:SetTarget(c75075612.tg1)
    e4:SetLabelObject(e5)
    c:RegisterEffect(e4)
    -- 诱发抽卡
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(75075612,0))
    e7:SetCategory(CATEGORY_DRAW)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_LEAVE_FIELD)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1)
    e7:SetCondition(c75075612.con2)
    e7:SetTarget(c75075612.tg2)
    e7:SetOperation(c75075612.op2)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e6:SetRange(LOCATION_FZONE)
    e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e6:SetTarget(c75075612.tg1)
    e6:SetLabelObject(e7)
    c:RegisterEffect(e6)
    -- 遗言检索
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(75075612,1))
    e8:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_TO_GRAVE)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetTarget(c75075612.tg3)
    e8:SetOperation(c75075612.op3)
    c:RegisterEffect(e8)
end
-- 1
function c75075612.con1(e)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,0x5754)
end
function c75075612.tg1(e,c)
    return c:IsSetCard(0x5754) and c:IsFaceup()
        and Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,0x5754)
end
function c75075612.val1(e,re,rp)
	return rp==1-e:GetHandlerPlayer()
end
-- 2
function c75075612.filter2(c,tp)
	return  c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetReasonPlayer()==1-tp
end
function c75075612.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75075612.filter2,1,nil,tp)
end
function c75075612.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c75075612.op2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end
-- 3
function c75075612.filter3(c)
    return c:IsSetCard(0x5754) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c75075612.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c75075612.filter3,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75075612.op3(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c75075612.filter3,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        Duel.ShuffleHand(tp)
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
        if #sg>0 then
            Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        end
    end
end
