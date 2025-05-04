--魅惑淫靡之梦
function c75075618.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	-- 攻宣禁止
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetCondition(c75075618.atkcon)
	e3:SetRange(LOCATION_MZONE)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetCondition(c75075618.con1)
    e2:SetTarget(c75075618.tg1)
    e2:SetLabelObject(e3)
    c:RegisterEffect(e2)
	-- 发动禁止
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_TRIGGER)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c75075618.atkcon)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e4:SetRange(LOCATION_FZONE)
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e4:SetCondition(c75075618.con1)
    e4:SetTarget(c75075618.tg1)
    e4:SetLabelObject(e5)
    c:RegisterEffect(e4)
    -- 伤害与回复
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(75075618,0))
    e7:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e7:SetCode(EVENT_MOVE)
    e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCountLimit(1)
    e7:SetCondition(c75075618.con2)
    e7:SetTarget(c75075618.tg2)
    e7:SetOperation(c75075618.op2)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e6:SetRange(LOCATION_FZONE)
    e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e6:SetTarget(c75075618.tg1)
    e6:SetLabelObject(e7)
    c:RegisterEffect(e6)
    -- 遗言检索
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(75075618,1))
    e8:SetCategory(CATEGORY_DRAW)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_TO_GRAVE)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetTarget(c75075618.tg3)
    e8:SetOperation(c75075618.op3)
    c:RegisterEffect(e8)
end
-- 1
function c75075618.con1(e)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,0x5754)
end
function c75075618.tg1(e,c)
    return c:IsFaceup() and Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,0x5754) and not c:IsSetCard(0x5754)
end
function c75075618.val1(e,re,rp)
	return rp==1-e:GetHandlerPlayer()
end
function c75075618.atkcon(e)
    return e:GetHandler():GetAttack()==0
end
-- 2
function c75075618.filter2(c,tp)
    return (c:GetPreviousLocation()==LOCATION_DECK or c:GetPreviousLocation()==LOCATION_EXTRA)
        and c:GetOwner()==tp
end
function c75075618.con2(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c75075618.filter2,1,nil,tp) 
        or eg:IsExists(c75075618.filter2,1,nil,1-tp)
end
function c75075618.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,400)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,400)
end
function c75075618.op2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(tp,400,REASON_EFFECT)
    Duel.Recover(1-tp,400,REASON_EFFECT)
end
-- 3
function c75075618.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c75075618.op3(e,tp,eg,ep,ev,re,r,rp)
    if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
        if #sg>0 then
            Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        end
    end
end
