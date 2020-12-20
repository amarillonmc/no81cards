--妖精伝姫－ストーリー
function c84610015.initial_effect(c)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_QUICK_O) 
    e1:SetCode(EVENT_FREE_CHAIN)    
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCost(c84610015.cost)
    e1:SetTarget(c84610015.target)
    e1:SetOperation(c84610015.operation)
    c:RegisterEffect(e1)
    --position
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_POSITION)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetOperation(c84610015.posop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --cannot be target
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e4:SetTarget(c84610015.tglimit)
    e4:SetValue(c84610015.tgval)
    c:RegisterEffect(e4)
    --change effect
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e5:SetCode(EVENT_CHAINING)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCost(c84610015.chcost)
    e5:SetCondition(c84610015.chcon)
    e5:SetTarget(c84610015.chtg)
    e5:SetOperation(c84610015.chop)
    c:RegisterEffect(e5)
end
function c84610015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c84610015.filter(c)
    return c:IsAttack(1850) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand() and not c:IsCode(84610015)
end
function c84610015.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610015.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c84610015.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c84610015.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c84610015.posfilter(c)
    return (c:IsFaceup() and c:IsCanTurnSet()) or c:IsDefensePos() or c:IsFacedown()
end
function c84610015.posop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c84610015.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(84610015,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
        local pcg=Duel.SelectMatchingCard(tp,c84610015.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
        local tg=pcg:GetFirst()
        if tg:IsAttackPos() then
            Duel.ChangePosition(tg,POS_FACEDOWN_DEFENSE)
            e:GetHandler():RegisterFlagEffect(84610015,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
        end
        if e:GetHandler():GetFlagEffect(84610015)==0 and (tg:IsDefensePos() or tg:IsFacedown()) then
            Duel.ChangePosition(tg,POS_FACEUP_ATTACK)
        end
    end
end
function c84610015.tglimit(e,c)
    return c~=e:GetHandler()
end
function c84610015.tgval(e,re,rp)
    return re:IsActiveType(TYPE_MONSTER)
end
function c84610015.chcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c84610015.cfilter(c)
    return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c84610015.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c84610015.cfilter,1,e:GetHandler()) end
    local g=Duel.SelectReleaseGroup(tp,c84610015.cfilter,1,1,e:GetHandler())
    Duel.Release(g,REASON_COST)
end
function c84610015.chfilter(c)
    return c:IsFaceup() and c:IsCanTurnSet()
end
function c84610015.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610015.chfilter,rp,0,LOCATION_MZONE,1,nil) end
end
function c84610015.chop(e,tp,eg,ep,ev,re,r,rp)
    local g=Group.CreateGroup()
    Duel.ChangeTargetCard(ev,g)
    Duel.ChangeChainOperation(ev,c84610015.repop)
end
function c84610015.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectMatchingCard(tp,c84610015.filter2,tp,0,LOCATION_MZONE,1,1,nil)
    if g:GetCount()>0 then
        Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
    end
end
