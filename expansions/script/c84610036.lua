--全土滅殺　転生波
function c84610036.initial_effect(c)
    aux.AddCodeList(c,6007213,32491822,69890967)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(84610036,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,84610036+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c84610036.target)
    e1:SetOperation(c84610036.activate)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetRange(LOCATION_DECK)
    e2:SetCondition(c84610036.deckcon)
    e2:SetTarget(c84610036.decktarget)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(84610036,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_ACTIVATE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1,846100361+EFFECT_COUNT_CODE_OATH)
    e3:SetTarget(c84610036.sptg)
    e3:SetOperation(c84610036.spop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetRange(LOCATION_DECK)
    e4:SetCondition(c84610036.deckcon)
    e4:SetTarget(c84610036.decksptg)
    c:RegisterEffect(e4)
    --armityle
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCountLimit(1,84610036)
    e5:SetCondition(c84610036.armcon)
    e5:SetCost(aux.bfgcost)
    e5:SetTarget(c84610036.armtg)
    e5:SetOperation(c84610036.armop)
    c:RegisterEffect(e5)
    --immune
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_GRAVE)
    e6:SetCost(aux.bfgcost)
    e6:SetCondition(c84610036.imcon)
    e6:SetTarget(c84610036.imtg)
    e6:SetOperation(c84610036.imop)
    c:RegisterEffect(e6)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_ACTIVATE_COST)
    e4:SetRange(LOCATION_DECK)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(1,0)
    e4:SetTarget(c84610036.actarget)
    e4:SetOperation(c84610036.costop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_SPSUMMON_PROC_G)
    e5:SetRange(LOCATION_DECK)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e5)
end
function c84610036.deckfilter(c)
    return c:IsOriginalCodeRule(6007213,32491822,69890967) and c:IsFaceup()
end
function c84610036.deckcon(e)
    local tp=e:GetHandlerPlayer()
    local g=Duel.GetMatchingGroup(c84610036.deckfilter,tp,LOCATION_MZONE,0,nil)
    return g:GetClassCount(Card.GetCode)>=1
end
function c84610036.filter(c)
    return (c:IsCode(6007213,32491822,69890967) or ((aux.IsCodeListed(c,6007213) or aux.IsCodeListed(c,32491822) or aux.IsCodeListed(c,69890967)))
        and not c:IsCode(84610036)) and c:IsAbleToHand()
end
function c84610036.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610036.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c84610036.decktarget(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c84610036.filter,tp,LOCATION_DECK,0,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c84610036.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c84610036.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetTargetRange(LOCATION_ONFIELD,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,6007213,32491822,69890967,43378048))
    e1:SetValue(c84610036.ifilter)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c84610036.cfilter(c,code)
    return c:IsFaceup() and c:IsCode(code)
end
function c84610036.spfilter(c,e,tp)
    return c:IsCode(6007213,32491822,69890967) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
        and not Duel.IsExistingMatchingCard(c84610036.cfilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function c84610036.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c84610036.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c84610036.decksptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c84610036.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c84610036.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c84610036.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetTargetRange(LOCATION_ONFIELD,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,6007213,32491822,69890967,43378048))
    e1:SetValue(c84610036.ifilter)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c84610036.ifilter(e,re)
    return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c84610036.confilter(c)
    return c:IsOriginalCodeRule(43378048) and c:IsFaceup()
end
function c84610036.armcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c84610036.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c84610036.mfilter(c)
    return c:IsType(TYPE_MONSTER)
end
function c84610036.armtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610036.mfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c84610036.armop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(84610036,2))
    local g=Duel.SelectMatchingCard(tp,c84610036.mfilter,tp,0,LOCATION_MZONE,1,1,nil)
    local sc=g:GetFirst()
    if sc:IsImmuneToEffect(e) then return false end
    if sc:IsAttackPos() then
        local atk=sc:GetAttack()
        if atk<10001 then
            local dmg=10000-atk
            Duel.Damage(1-tp,dmg,REASON_BATTLE)
            Duel.Destroy(sc,REASON_RULE)
        end
    else
        if sc:IsFacedown() then
            Duel.ChangePosition(sc,0,0,POS_FACEUP_DEFENSE)
        end
        local def=sc:GetDefense()
        if def<10000 then
            Duel.Destroy(sc,REASON_RULE)
        end
    end
end
function c84610036.imcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==1-tp
end
function c84610036.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function c84610036.imop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetTargetRange(LOCATION_ONFIELD,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,6007213,32491822,69890967,43378048))
    e1:SetValue(c84610036.imfilter)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c84610036.imfilter(e,re)
    return re:GetOwner()~=e:GetOwner()
end
function c84610036.actarget(e,te,tp)
    return te:GetHandler()==e:GetHandler()
end
function c84610036.costop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
