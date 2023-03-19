--ルドラの多元魔導書
function c123314220.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,123314220+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c123314220.target)
    e1:SetOperation(c123314220.activate)
    c:RegisterEffect(e1)
    --act in hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    c:RegisterEffect(e2)
    --cannot set
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_SSET)
    c:RegisterEffect(e3)
    --remove type
    local e4=Effect.CreateEffect(c)
    e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_REMOVE_TYPE)
    e4:SetValue(TYPE_QUICKPLAY)
    c:RegisterEffect(e4)
end

function c123314220.filter(c)
    return (((c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0x306e))
        or (c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_SPELLCASTER)))
        and not c:IsCode(123314220) and c:IsAbleToGrave()
end
function c123314220.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
        and Duel.IsExistingMatchingCard(c123314220.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c123314220.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c123314220.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
    local tc=g:GetFirst()
    if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
        Duel.Draw(tp,2,REASON_EFFECT)
    end
end
