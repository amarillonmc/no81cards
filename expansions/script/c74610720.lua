local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,74610710)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCondition(s.effcon)
    e2:SetOperation(s.effop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,id+1)
    e3:SetCondition(s.placecon)
    e3:SetTarget(s.placetg)
    e3:SetOperation(s.placeop)
    c:RegisterEffect(e3)
end
function s.thfilter(c)
    return c:IsAbleToHand() and not c:IsCode(id) and aux.IsCodeListed(c,74610710)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
    if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function s.effilter(c,tp)
    if c:IsFacedown() or c:GetFlagEffect(id+3)>0 then return false end
    local code=c:GetOriginalCode()
    for _,label in ipairs({Duel.GetFlagEffectLabel(tp,id)}) do
        if label==code then return false end
    end
    return true
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler()~=e:GetHandler() and Duel.GetFlagEffect(tp,id+2)<2
        and Duel.IsExistingMatchingCard(s.effilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,1)) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local tc=Duel.SelectMatchingCard(tp,s.effilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp):GetFirst()
    if tc then
        Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE+PHASE_END,0,1)
        Duel.HintSelection(Group.FromCards(tc))
        Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1,tc:GetOriginalCode())
        tc:RegisterFlagEffect(id+3,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
        local c=e:GetHandler()
        local e2=Effect.CreateEffect(c)
        e2:SetDescription(aux.Stringid(id,2))
        e2:SetCategory(CATEGORY_DESTROY)
        e2:SetType(EFFECT_TYPE_QUICK_F)
        e2:SetCode(EVENT_CHAINING)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCountLimit(1)
        e2:SetCondition(s.descon)
        e2:SetTarget(s.destg)
        e2:SetOperation(s.desop)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2)
        if not tc:IsAttribute(ATTRIBUTE_DARK) then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
            e1:SetValue(ATTRIBUTE_DARK)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
        end
    end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler()~=e:GetHandler()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    if #g>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
function s.cfilter(c,tp)
    return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.placecon(e,tp,eg,ep,ev,re,r,rp)
    return not eg:IsContains(e:GetHandler()) and eg:IsExists(s.cfilter,1,nil,tp)
end
function s.placetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function s.placeop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
    end
end