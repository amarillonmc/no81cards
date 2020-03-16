--ヴァルキュルスの影霊衣
function c125857246.initial_effect(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.ritlimit)
    c:RegisterEffect(e1)
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(125857246,0))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,125857246)
    e2:SetCondition(c125857246.atkcon)
    e2:SetCost(c125857246.atkcost)
    e2:SetOperation(c125857246.atkop)
    c:RegisterEffect(e2)
    --draw
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(125857246,1))
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,258572461)
    e3:SetTarget(c125857246.target)
    e3:SetOperation(c125857246.operation)
    c:RegisterEffect(e3)
    --special summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(125857246,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e4:SetCountLimit(1,125857246)
    e4:SetCost(c125857246.hspcost)
    e4:SetTarget(c125857246.hsptg)
    e4:SetOperation(c125857246.hspop)
    c:RegisterEffect(e4)
    --return
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(125857246,3))
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,125857246)
    e5:SetCode(EVENT_PHASE+PHASE_END)
    e5:SetCondition(c125857246.retcon)
    e5:SetTarget(c125857246.rettg)
    e5:SetOperation(c125857246.retop)
    c:RegisterEffect(e5)
    --search
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(125857246,4))
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_REMOVE)
    e6:SetCountLimit(1,125857246)
    e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e6:SetTarget(c125857246.thtg)
    e6:SetOperation(c125857246.thop)
    c:RegisterEffect(e6)
end
function c125857246.mat_filter(c)
    return c:GetLevel()~=8
end
function c125857246.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker():IsControler(1-tp)
end
function c125857246.cfilter(c)
    return c:IsSetCard(0xb4) and c:IsAbleToRemoveAsCost()
end
function c125857246.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable()
        and Duel.IsExistingMatchingCard(c125857246.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c125857246.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c125857246.atkop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateAttack() then
        Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
    end
end
function c125857246.filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end
function c125857246.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.CheckReleaseGroupEx(tp,c125857246.filter,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c125857246.operation(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsPlayerCanDraw(tp) then return end
    local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    if ct==0 then ct=1 end
    if ct>2 then ct=2 end
    local g=Duel.SelectReleaseGroupEx(tp,c125857246.filter,1,ct,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        local rct=Duel.Release(g,REASON_EFFECT)
        Duel.Draw(tp,rct,REASON_EFFECT)
    end
end

function c125857246.rfilter(c)
    return c:IsSetCard(0x10b4) and c:IsAbleToRemoveAsCost()
end
function c125857246.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c125857246.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c125857246.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c125857246.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c125857246.hspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
end
function c125857246.retcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
        and e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) and not e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c125857246.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c125857246.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end
function c125857246.thfilter(c)
    return c:IsSetCard(0x10b4) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c125857246.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c125857246.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c125857246.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c125857246.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end