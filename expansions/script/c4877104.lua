function c4877104.initial_effect(c)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(4877104,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetTarget(c4877104.thtg)
    e2:SetOperation(c4877104.thop)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4877104,1))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetTarget(c4877104.reptg)
    e3:SetValue(c4877104.repval)
    c:RegisterEffect(e3)
end
function c4877104.repfilter(c,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_RITUAL) and c:IsControler(tp)
        and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c4877104.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c4877104.repfilter,1,nil,tp) end
    if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
        Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
        return true
    else return false end
end
function c4877104.repval(e,c)
    return c4877104.repfilter(c,e:GetHandlerPlayer())
end
function c4877104.thfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c4877104.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c4877104.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c4877104.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c4877104.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end