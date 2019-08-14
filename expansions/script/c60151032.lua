--消散的回忆
function c60151032.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(c60151032.afilter))
    e2:SetValue(300)
    c:RegisterEffect(e2)
    --extra summon
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetRange(LOCATION_SZONE)
    e12:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
    e12:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e12:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5b23))
    c:RegisterEffect(e12)
    --search
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151032,0))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetRange(LOCATION_SZONE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,60151032)
    e3:SetCode(EVENT_TO_HAND)
    e3:SetCondition(c60151032.condition)
    e3:SetTarget(c60151032.target)
    e3:SetOperation(c60151032.operation)
    c:RegisterEffect(e3)
    --SendtoGrave
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(60151032,0))
    e4:SetCategory(CATEGORY_REMOVE)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetRange(LOCATION_SZONE)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetCountLimit(1,6011032)
    e4:SetCondition(c60151032.drcon)
    e4:SetTarget(c60151032.drtar)
    e4:SetOperation(c60151032.drop)
    c:RegisterEffect(e4)
end
function c60151032.afilter(c)
    return c:IsRace(RACE_FIEND) or c:IsRace(RACE_SPELLCASTER)
end
function c60151032.cfilter(c,tp)
    return c:IsControler(tp) and c:GetPreviousControler()==tp
        and c:IsPreviousLocation(LOCATION_ONFIELD)
        and c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x5b23)
end
function c60151032.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c60151032.cfilter,1,nil,tp)
end
function c60151032.filter(c)
    return c:IsAbleToHand()
end
function c60151032.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151032.filter,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(c60151032.filter,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c60151032.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60151032.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end
function c60151032.drcon(e,tp,eg,ep,ev,re,r,rp)
    local tg=eg:GetFirst()
    return tg:IsSetCard(0x5b23) and tg:IsRace(RACE_FIEND)
end
function c60151032.drfilter(c)
    return c:IsAbleToGrave()
end
function c60151032.drtar(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151032.drfilter,tp,0,LOCATION_EXTRA,1,nil) end
    local g=Duel.GetMatchingGroup(c60151032.drfilter,tp,0,LOCATION_EXTRA,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c60151032.drop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
    Duel.ConfirmCards(tp,tg)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60151032.drfilter,tp,0,LOCATION_EXTRA,1,1,nil)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
    end
end
function c60151032.drcon2(e,tp,eg,ep,ev,re,r,rp)
    local tg=eg:GetFirst()
    return eg:GetCount()==1 and tg~=e:GetHandler() and tg:IsSetCard(0x5b23) and tg:IsType(TYPE_FUSION)
end
function c60151032.filter2(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c60151032.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c60151032.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
    local sg=Duel.GetMatchingGroup(c60151032.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c60151032.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local sg=Duel.GetMatchingGroup(c60151032.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
    Duel.Destroy(sg,REASON_EFFECT)
end