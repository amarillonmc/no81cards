--光天使の怒り
function c116472626.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,116472626)
    e1:SetCondition(c116472626.condition)
    e1:SetTarget(c116472626.target)
    e1:SetOperation(c116472626.activate)
    c:RegisterEffect(e1)
    --Damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(c116472626.dmcon)
    e2:SetCost(c116472626.dmcost)
    e2:SetTarget(c116472626.dmtg)
    e2:SetOperation(c116472626.dmop)
    c:RegisterEffect(e2)
end

function c116472626.condition(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c116472626.ssfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c116472626.filter(c)
    return c:IsSetCard(0x86) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c116472626.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c116472626.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c116472626.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c116472626.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

function c116472626.cfilter(c,tp)
    return c:GetPreviousControler()==1-tp and c:IsType(TYPE_MONSTER)
end
function c116472626.ssfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x86)
end
function c116472626.dmcon(e,tp,eg,ep,ev,re,r,rp)
    return aux.exccon(e) and eg:IsExists(c116472626.cfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c116472626.ssfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c116472626.dmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c116472626.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c116472626.dmop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
