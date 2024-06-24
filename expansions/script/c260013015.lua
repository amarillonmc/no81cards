--天の聖杯 ホムラ
function c260013015.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,nil,2,2,c260013015.lcheck)
    
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,260013015)
    e1:SetTarget(c260013015.atktg)
    e1:SetOperation(c260013015.atkop)
    c:RegisterEffect(e1)
    
    --material
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c260013015.mattg)
    e2:SetOperation(c260013015.matop)
    c:RegisterEffect(e2)
    
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(260013015,2))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_XMATERIAL)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c260013015.descon)
    e3:SetCost(c260013015.descost)
    e3:SetTarget(c260013015.destg)
    e3:SetOperation(c260013015.desop)
    c:RegisterEffect(e3)
end


--【召喚ルール】
function c260013015.lcheck(g,lc)
    return g:IsExists(Card.IsLinkRace,1,nil,RACE_SPELLCASTER)
end

--【攻撃力上昇】
function c260013015.atkfilter(c)
    return c:IsFaceup()
end
function c260013015.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c260013015.atkfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c260013015.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c260013015.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,c)
end
function c260013015.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end

--【X素材補充】
function c260013015.matfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x944) and c:IsType(TYPE_XYZ)
end
function c260013015.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c260013015.matfilter(chkc) end
    if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
        and Duel.IsExistingTarget(c260013015.matfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c260013015.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c260013015.matop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        Duel.Overlay(tc,Group.FromCards(c))
    end
end

--【X効果】
function c260013015.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSetCard(0x943)
end
function c260013015.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c260013015.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c260013015.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.Destroy(g,REASON_EFFECT)
    end
end