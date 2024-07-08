--混沌
function c121082832.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c121082832.actcost)
    e1:SetTarget(c121082832.target)
    c:RegisterEffect(e1)
    --duel start
    local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_TO_HAND)
    e2:SetRange(LOCATION_DECK+LOCATION_HAND)
    e2:SetCountLimit(1,121082832+EFFECT_COUNT_CODE_DUEL)
    e2:SetCondition(c121082832.chcon)
    e2:SetOperation(c121082832.chop)
    c:RegisterEffect(e2)
end

function c121082832.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,121082832)==0 end
    Duel.RegisterFlagEffect(tp,121082832,0,0,0)
end
function c121082832.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetRange(LOCATION_FZONE)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetLabel(0)
    e1:SetCountLimit(1)
    e1:SetCondition(c121082832.tgcon)
    e1:SetOperation(c121082832.tgop)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
    e:GetHandler():RegisterEffect(e1)
end
function c121082832.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function c121082832.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=e:GetLabel()
    ct=ct+1
    e:SetLabel(ct)
    if ct<=3 then e:GetHandler():SetTurnCounter(ct) end
    if ct==3 then
        --search & destroy
        local e1=Effect.CreateEffect(c)
        e1:SetCategory(CATEGORY_DESTROY)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetRange(LOCATION_FZONE)
        e1:SetCountLimit(1)
        e1:SetTarget(c121082832.destg)
        e1:SetOperation(c121082832.desop)
        e1:SetReset(RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end

function c121082832.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c121082832.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    if Duel.Destroy(c,REASON_EFFECT)==0 then return end
    Duel.SetLP(tp,4000)
    local dc=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    if Duel.GetLP(tp)<Duel.GetLP(1-tp) and dc>1 and Duel.SelectYesNo(tp,aux.Stringid(121082832,2)) then
        local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.ShuffleDeck(tp)
            Duel.MoveSequence(tc,0)
            Duel.ConfirmDecktop(tp,1)
        end
    end
end


function c121082832.chcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()==0
end
function c121082832.chop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tp=c:GetOwner()
    if not c:IsLocation(LOCATION_DECK+LOCATION_HAND) then return end
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
    if g:GetCount()>0 then Duel.SendtoDeck(g,nil,2,REASON_RULE) end
    if c:GetActivateEffect():IsActivatable(tp) then  
        Duel.SSet(tp,c)
        c:RegisterFlagEffect(121082832,RESET_EVENT+0x1fe0000,0,1)
        --cannot activate
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_ACTIVATE)
        e1:SetRange(LOCATION_FZONE)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_SET_AVAILABLE)
        e1:SetTargetRange(1,0)
        e1:SetCondition(c121082832.negcon)
        e1:SetValue(c121082832.actlimit)
        Duel.RegisterEffect(e1,tp)
        --cannot set
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_CANNOT_SSET)
        e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e2:SetRange(LOCATION_SZONE)
        e2:SetTargetRange(1,0)
        e2:SetCondition(c121082832.negcon)
        e2:SetTarget(c121082832.setlimit)
        e2:SetValue(c121082832.actlimit)
        Duel.RegisterEffect(e2,tp)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_FIELD)
        e3:SetCode(EFFECT_CANNOT_ACTIVATE)
        e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e3:SetRange(LOCATION_SZONE)
        e3:SetTargetRange(1,1)
        e3:SetCondition(c121082832.negcon)
        e3:SetValue(c121082832.nofilter)
        Duel.RegisterEffect(e3,tp)
        --indes
        local e4=Effect.CreateEffect(c)
        e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
        e4:SetType(EFFECT_TYPE_FIELD)
        e4:SetTargetRange(LOCATION_SZONE,0)
        e4:SetTarget(c121082832.indtg)
        e4:SetCondition(c121082832.negcon)
        e4:SetCode(EFFECT_INDESTRUCTABLE)
        e4:SetValue(1)
        Duel.RegisterEffect(e4,tp)
        local e5=e4:Clone()
        e5:SetCode(EFFECT_CANNOT_REMOVE)
        Duel.RegisterEffect(e5,tp)
        local e6=e4:Clone()
        e6:SetCode(EFFECT_CANNOT_TO_DECK)
        Duel.RegisterEffect(e6,tp)
        local e7=e4:Clone()
        e7:SetCode(EFFECT_CANNOT_TO_HAND)
        Duel.RegisterEffect(e7,tp)
        local e8=e4:Clone()
        e8:SetCode(EFFECT_UNRELEASABLE_SUM)
        Duel.RegisterEffect(e8,tp)
        local e9=e4:Clone()
        e9:SetCode(EFFECT_UNRELEASABLE_NONSUM)
        Duel.RegisterEffect(e9,tp)
        local e10=e4:Clone()
        e10:SetCode(EFFECT_CANNOT_TO_GRAVE)
        Duel.RegisterEffect(e10,tp)
        --chage name
        local e1=Effect.CreateEffect(c)
        e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY+EFFECT_FLAG_SET_AVAILABLE)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CHANGE_CODE)
        e1:SetRange(LOCATION_FZONE)
        e1:SetTargetRange(0xff,0xff)
        e1:SetValue(121082832)
        c:RegisterEffect(e1)
    end
    Duel.BreakEffect()
    Duel.ShuffleDeck(tp)
    Duel.Draw(Duel.GetTurnPlayer(),5,REASON_RULE)
end
function c121082832.negcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsFacedown()
end
function c121082832.indtg(e,c)
    return c:IsCode(121082832) and c:IsFacedown() and c:IsType(TYPE_FIELD) and c:GetFlagEffect(121082832)~=0
end
function c121082832.actlimit(e,re,tp)
    return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and not re:GetHandler():IsCode(121082832)
end
function c121082832.setlimit(e,c,tp)
    return c:IsType(TYPE_FIELD)
end
function c121082832.nofilter(e,re,tp)
    return re:GetHandler():IsCode(73468603)
end

local st=Effect.SetTarget
Effect.SetTarget=function(e,tg)
    if e:GetOwner():IsOriginalCodeRule(92746535) and e:GetCategory()==CATEGORY_TOHAND+CATEGORY_SEARCH then
        return st(e,c121082832.thtg)
    else
        return st(e,tg)
    end
end
local so=Effect.SetOperation
Effect.SetOperation=function(e,op)
    if e:GetOwner():IsOriginalCodeRule(92746535) and e:GetCategory()==CATEGORY_TOHAND+CATEGORY_SEARCH then
        return so(e,c121082832.thop)
    else
        return so(e,op)
    end
end

function c121082832.thfilter(c,code)
    return c:IsCode(code) and c:IsAbleToHand()
end
function c121082832.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler())
    if chk==0 then return Duel.IsExistingMatchingCard(c121082832.thfilter,tp,LOCATION_DECK,0,1,nil,sc:GetCode()) end
    Duel.SetTargetCard(sc)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sc,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c121082832.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c121082832.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
