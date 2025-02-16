--PSYフレーム・アフターイメージャー
function c49811367.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c49811367.matfilter,1,1)
	--extra summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811367,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c49811367.spcon)
    e1:SetOperation(c49811367.spop)
    c:RegisterEffect(e1)
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811367,1))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c49811367.rmtg)
    e2:SetOperation(c49811367.rmop)
    c:RegisterEffect(e2)
    --to hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(49811367,2))
    e3:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetTarget(c49811367.thtg)
    e3:SetOperation(c49811367.thop)
    c:RegisterEffect(e3)
end
function c49811367.matfilter(c)
    return c:IsCode(49036338)
end
function c49811367.cfilter(c)
    return c:IsCode(49036338) and c:IsAbleToGraveAsCost()
end
function c49811367.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
        and Duel.IsExistingMatchingCard(c49811367.cfilter,tp,LOCATION_HAND,0,1,nil)
end
function c49811367.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c49811367.cfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c49811367.sumlimit)
    Duel.RegisterEffect(e1,tp)
end
function c49811367.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsSetCard(0xc1)
end
function c49811367.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemove() end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c49811367.rmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
        e1:SetCountLimit(1)
        e1:SetLabelObject(c)
        e1:SetCondition(c49811367.retcon)
        e1:SetOperation(c49811367.retop)
        e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
        Duel.RegisterEffect(e1,tp)
    end
end
function c49811367.retcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c49811367.retop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.ReturnToField(tc)
end
function c49811367.thfilter(c)
    return c:IsSetCard(0xc1) and c:IsAbleToHand()
end
function c49811367.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c49811367.thfilter(chkc) end
    if chk==0 then return e:GetHandler():IsAbleToExtra()
        and Duel.IsExistingTarget(c49811367.thfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c49811367.thfilter,tp,LOCATION_REMOVED,0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function c49811367.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0
        and c:IsLocation(LOCATION_EXTRA) and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end