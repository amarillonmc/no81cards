--魔女工艺·狂欢
function c84350001.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,84350001)
    e1:SetTarget(c84350001.target)
    e1:SetOperation(c84350001.activate)
    c:RegisterEffect(e1)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(84350001,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetCountLimit(1,84350001)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(c84350001.thcon)
    e2:SetTarget(c84350001.thtg)
    e2:SetOperation(c84350001.thop)
    c:RegisterEffect(e2)
end
function c84350001.filter(c)
    return (((c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0x128))
        or (c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_SPELLCASTER)))
        and not c:IsCode(84350001) and c:IsAbleToGrave()
end
function c84350001.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
        and Duel.IsExistingMatchingCard(c84350001.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c84350001.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c84350001.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
    local tc=g:GetFirst()
    if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
        Duel.Draw(tp,2,REASON_EFFECT)
    end
end
function c84350001.rccfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x128)
end
function c84350001.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
        and Duel.IsExistingMatchingCard(c84350001.rccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c84350001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c84350001.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end