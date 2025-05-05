--可怕过去之梦
function c75075614.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    -- 迈向死亡的效果伤害
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c75075614.con11)
    e3:SetOperation(c75075614.op11)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetCondition(c75075614.con1)
    e2:SetTarget(c75075614.tg1)
    e2:SetLabelObject(e3)
    c:RegisterEffect(e2)
    -- 攻击下降
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_LEAVE_FIELD)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(c75075614.con2)
    e5:SetOperation(c75075614.op2)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e4:SetRange(LOCATION_FZONE)
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e4:SetCondition(c75075614.con1)
    e4:SetTarget(c75075614.tg1)
    e4:SetLabelObject(e5)
    c:RegisterEffect(e4)
    -- 遗言解场
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(75075614,1))
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_TO_GRAVE)
    e8:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e8:SetTarget(c75075614.tg3)
    e8:SetOperation(c75075614.op3)
    c:RegisterEffect(e8)
end
-- 1
function c75075614.tg1(e,c)
    return c:IsFaceup() and Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,0x5754) and not c:IsSetCard(0x5754)
end
function c75075614.con1(e)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,0x5754)
end
function c75075614.con11(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler()==e:GetHandler()
end
function c75075614.op11(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(tp,400,REASON_EFFECT)
end
-- 2
function c75075614.filter2(c)
	return c:IsPreviousLocation(LOCATION_MZONE)
end
function c75075614.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75075614.filter2,1,nil)
end
function c75075614.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(-800)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e1)
end
-- 3
function c75075614.filter3(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c75075614.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c75075614.filter3(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c75075614.filter3,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c75075614.filter3,tp,0,LOCATION_MZONE,1,1,nil)
end
function c75075614.op3(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_TRIGGER)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end