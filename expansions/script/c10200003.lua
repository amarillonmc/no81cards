--渊灵-暗潮鮟鱇
function c10200003.initial_effect(c)
    aux.EnablePendulumAttribute(c)
	-- 自爆回收
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(10200003,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,10200003)
    e1:SetTarget(c10200003.tg1)
    e1:SetOperation(c10200003.op1)
    c:RegisterEffect(e1)
    --双召盖放
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200003,1))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,10200004)
	e2:SetTarget(c10200003.tg2)
	e2:SetOperation(c10200003.op2)
	c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --遗言回收
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(10200003,2))
    e4:SetCategory(CATEGORY_TODECK)
    e4:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetCountLimit(1,10200005)
    e4:SetTarget(c10200003.tg3)
    e4:SetOperation(c10200003.op3)
    c:RegisterEffect(e4)
end
-- 1
function c10200003.filter1(c)
    return c:IsFaceup() and c:IsSetCard(0xe21) and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10200003.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c10200003.filter1,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c10200003.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c10200003.filter1,tp,LOCATION_EXTRA,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
-- 2
function c10200003.filter2(c)
	return c:IsSetCard(0xe21) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c10200003.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10200003.filter2,tp,LOCATION_DECK,0,1,nil) end
end
function c10200003.op2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,c10200003.filter2,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if tc and Duel.SSet(tp,tc)~=0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetDescription(aux.Stringid(10200003,2))
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
        e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetDescription(aux.Stringid(10200003,3))
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
        e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2)
    end
end
--3
function c10200003.filter3(c)
    return c:IsSetCard(0xe21) and c:IsAbleToDeck()
end

function c10200003.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c10200003.filter3,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end

function c10200003.op3(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c10200003.filter3,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
        Duel.ShuffleDeck(tp)
    end
end
