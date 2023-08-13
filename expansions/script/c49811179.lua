--A・O・J サウザンド·レイザー
function c49811179.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --self destroy
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e0:SetCode(EFFECT_SELF_DESTROY)
    e0:SetRange(LOCATION_PZONE)
    e0:SetCondition(c49811179.sdcon)
    c:RegisterEffect(e0)
    --change attribute
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e1:SetCondition(c49811179.imcon)
    e1:SetValue(ATTRIBUTE_LIGHT)
    c:RegisterEffect(e1)
    local e1g=e1:Clone()
    e1g:SetTargetRange(0,LOCATION_GRAVE)
    e1g:SetCondition(c49811179.gravecon)
    c:RegisterEffect(e1g)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811179,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,49811179)
    e2:SetTarget(c49811179.thtg)
    e2:SetOperation(c49811179.thop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(49811179,1))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetCondition(c49811179.fdcon)
    e4:SetTarget(c49811179.fdtg)
    e4:SetOperation(c49811179.fdop)
    c:RegisterEffect(e4)
end
function c49811179.sdcon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_END
        and not Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,1,nil)
end
function c49811179.imfilter(c)
    return c:IsSetCard(1) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c49811179.imcon(e)
    return Duel.IsExistingMatchingCard(c49811179.imfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c49811179.gravecon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(c49811179.imfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_NECRO_VALLEY)
end
function c49811179.filter(c)
    return c:IsSetCard(1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c49811179.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.IsExistingMatchingCard(c49811179.filter,tp,LOCATION_DECK,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c49811179.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c49811179.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        Duel.BreakEffect()
        local c=e:GetHandler()
        if c:IsRelateToEffect(e) then
            Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
        end
    end
end
function c49811179.fdcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c49811179.fdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c49811179.fdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.ChangePosition(g:GetFirst(),POS_FACEDOWN_DEFENSE)
    end
end