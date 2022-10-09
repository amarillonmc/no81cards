--缝合僵尸黑旋风
local m=4865027
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(cm.target)
    e2:SetOperation(cm.operation)
    c:RegisterEffect(e2)
end
function cm.filter(c,val)
    local atk=c:GetAttack()
    return atk>=0 and atk<val and c:IsSetCard(0x332b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=eg:GetFirst()
    if chk==0 then return tc:IsSetCard(0x332b) and tc:GetControler()==tp
        and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,tc:GetAttack()) end
    tc:CreateEffectRelation(e)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    if not e:GetHandler():IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,tc:GetAttack())
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

