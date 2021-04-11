--素晴的惠惠的好友
function c60152811.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60152811,0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,60152811+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c60152811.e1tg)
    e1:SetOperation(c60152811.e1op)
    c:RegisterEffect(e1)
    --salvage
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetDescription(aux.Stringid(60152811,3))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(c60152811.e2cost)
    e2:SetTarget(c60152811.e2tg)
    e2:SetOperation(c60152811.e2op)
    c:RegisterEffect(e2)
end
function c60152811.e1tgfilter(c)
	local tp=c:GetControler()
    return c:IsFaceup() and c:IsSetCard(0xab27) and c:IsType(TYPE_FUSION) and Duel.IsExistingMatchingCard(c60152811.e1tgfilter2,tp,LOCATION_EXTRA,0,1,nil,c:GetCode())
end
function c60152811.e1tgfilter2(c,code)
    return c:IsType(TYPE_FUSION) and c:IsSetCard(0xab27) and not c:IsCode(code) 
end
function c60152811.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60152811.e1tgfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c60152811.e1tgfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c60152811.e1tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c60152811.e1op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152811,2))
		local g=Duel.SelectMatchingCard(tp,c60152811.e1tgfilter2,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetCode())
		if g:GetCount()==0 then return end
		Duel.ConfirmCards(1-tp,g)
		local tc2=g:GetFirst()
        local code=tc2:GetOriginalCodeRule()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_CHANGE_CODE)
        e1:SetValue(code)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        if not tc2:IsType(TYPE_TRAPMONSTER) then
            local cid=tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
        end
        local e3=Effect.CreateEffect(c)
        e3:SetDescription(aux.Stringid(60152811,1))
        e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e3:SetCode(EVENT_PHASE+PHASE_END)
        e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e3:SetCountLimit(1)
        e3:SetRange(LOCATION_MZONE)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e3:SetLabelObject(e1)
        e3:SetLabel(cid)
        e3:SetOperation(c60152811.e1oprstop)
        tc:RegisterEffect(e3)
    end
end
function c60152811.e1oprstop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local cid=e:GetLabel()
    if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
    local e1=e:GetLabelObject()
    e1:Reset()
    Duel.HintSelection(Group.FromCards(c))
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60152811.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c60152811.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c60152811.e2op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end