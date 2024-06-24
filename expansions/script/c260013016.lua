--天の聖杯 ヒカリ
function c260013016.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,nil,2,2,c260013016.lcheck)
    
    --disable
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,260013016)
    e1:SetTarget(c260013016.distg)
    e1:SetOperation(c260013016.disop)
    c:RegisterEffect(e1)
    
    --material
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c260013016.mattg)
    e2:SetOperation(c260013016.matop)
    c:RegisterEffect(e2)
    
    --atk
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_XMATERIAL)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetCondition(c260013016.atkcon)
    e3:SetValue(1500)
    c:RegisterEffect(e3)
end


--【召喚ルール】
function c260013016.lcheck(g,lc)
    return g:IsExists(Card.IsLinkRace,1,nil,RACE_SPELLCASTER)
end

--【効果無効】
function c260013016.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and aux.disfilter1(chkc) end
    if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c260013016.disfilter(c,e)
    return aux.disfilter1(c) and c:IsRelateToEffect(e)
end
function c260013016.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c260013016.disfilter,nil,e)
    local tc=g:GetFirst()
    while tc do
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        if tc:IsType(TYPE_TRAPMONSTER) then
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e3)
        end
        tc=g:GetNext()
    end
end


--【X素材補充】
function c260013016.matfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x944) and c:IsType(TYPE_XYZ)
end
function c260013016.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c260013016.matfilter(chkc) end
    if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
        and Duel.IsExistingTarget(c260013016.matfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c260013016.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c260013016.matop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        Duel.Overlay(tc,Group.FromCards(c))
    end
end

--【X効果】
function c260013016.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSetCard(0x943)
end

local re=Card.IsSetCard
Card.IsSetCard=function(c,name)
    if name==0x943 and c:IsCode(66976526,42737833,11682713,75539614,39507162) then return true end
    return re(c,name)
end
