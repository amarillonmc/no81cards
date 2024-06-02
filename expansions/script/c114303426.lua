function c114303426.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,114303426+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c114303426.condition)
    e1:SetTarget(c114303426.target)
    e1:SetOperation(c114303426.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCondition(c114303426.sumcon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c114303426.target2)
    e2:SetOperation(c114303426.activate)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetRange(LOCATION_DECK)
    e3:SetCondition(c114303426.condition2)
    e3:SetOperation(c114303426.operation2)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_ACTIVATE_COST)
    e4:SetRange(LOCATION_DECK)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(1,0)
    e4:SetTarget(c114303426.actarget)
    e4:SetOperation(c114303426.costop)
    c:RegisterEffect(e4)
end
function c114303426.cfilter(c,tp)
    return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetPreviousControler()==tp and c:IsSetCard(0xaa)
end
function c114303426.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c114303426.cfilter,1,nil,tp)
end
function c114303426.thfilter(c)
    return c:IsSetCard(0xaa) and c:IsAbleToHand()
end
function c114303426.refilter(c)
    return c:IsSetCard(0xaa) and c:IsFaceup()
end
function c114303426.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c114303426.thfilter,tp,LOCATION_DECK,0,1,nil) end
    local ct=Duel.GetMatchingGroupCount(c114303426.refilter,tp,LOCATION_EXTRA,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*800)
end
function c114303426.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c114303426.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        local ct=Duel.GetMatchingGroupCount(c114303426.refilter,tp,LOCATION_EXTRA,0,nil)
        if ct>0 then
            Duel.BreakEffect()
            Duel.Recover(tp,ct*800,REASON_EFFECT)
        end
    end
end
function c114303426.sumcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c114303426.sumfilter(c)
    local a=c:GetTributeRequirement()
    if a==0 then a=1 end 
    if c:IsCode(27279764,40061558) then a=3 end 
    return c:IsSetCard(0xaa) and c:IsSummonable(true,nil,1) and Duel.CheckTribute(c,a)
end
function c114303426.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c114303426.sumfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c114303426.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,c114303426.sumfilter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.Summon(tp,tc,true,nil,1)
    end
end
function c114303426.actarget(e,te,tp)
    e:SetLabelObject(te)
    return te:GetHandler()==e:GetHandler()
end
function c114303426.costop(e,tp,eg,ep,ev,re,r,rp)
    local te=e:GetLabelObject()
    local c=e:GetHandler()
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
    c:CreateEffectRelation(te)
    local ev0=Duel.GetCurrentChain()+1
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EVENT_CHAIN_SOLVED)
    e1:SetCountLimit(1)
    e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
    e1:SetOperation(c114303426.rsop)
    e1:SetReset(RESET_CHAIN)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EVENT_CHAIN_NEGATED)
    Duel.RegisterEffect(e2,tp)
end
function c114303426.rsop(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
        rc:SetStatus(STATUS_EFFECT_ENABLED,true)
    end
    if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
        rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
    end
end
function c114303426.condition2(e,tp,eg,ep,ev,re,r,rp)
    return c114303426.condition(e,tp,eg,ep,ev,re,r,rp) and not Duel.IsExistingMatchingCard(aux.NOT(Card.IsSetCard),tp,LOCATION_EXTRA,0,1,nil,0xaa)
end
function c114303426.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_EXTRA,0))
    c114303426.operation(e,tp,eg,ep,ev,re,r,rp)
end

local re=Duel.RegisterEffect
Duel.RegisterEffect=function(e,tp)
    if e:GetOwner():IsOriginalCodeRule(51194046) and e:GetCode()==EFFECT_MATERIAL_CHECK 
    then
        e:SetTargetRange(LOCATION_HAND+LOCATION_DECK,LOCATION_HAND+LOCATION_DECK)
    end
    return re(e,tp)
end
