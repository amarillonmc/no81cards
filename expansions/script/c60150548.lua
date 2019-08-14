--幻想乐章的舞步
function c60150548.initial_effect(c)
    c:SetUniqueOnField(1,0,60150548)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    --Destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c60150548.e2con)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --cannot target
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetCondition(c60150548.e3con)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetCondition(c60150548.e4con)
    e4:SetValue(c60150548.e4filter)
    c:RegisterEffect(e4)
    --move
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(22198672,0))
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(c60150548.e5tg)
    e5:SetOperation(c60150548.e5op)
    c:RegisterEffect(e5)
	
end
function c60150548.confilter(c)
    return c:IsFaceup() and c:IsSetCard(0xcb20) and c:IsType(TYPE_CONTINUOUS)
end
function c60150548.confilter2(c)
    return c:IsSetCard(0xcb20) and c:IsType(TYPE_XYZ)
end
function c60150548.e2con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c60150548.confilter,tp,LOCATION_SZONE,0,nil)
    return g:GetClassCount(Card.GetCode)>=2 and Duel.IsExistingMatchingCard(c60150548.confilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c60150548.e3con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c60150548.confilter,tp,LOCATION_SZONE,0,nil)
    return g:GetClassCount(Card.GetCode)>=3 and Duel.IsExistingMatchingCard(c60150548.confilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c60150548.e4con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c60150548.confilter,tp,LOCATION_SZONE,0,nil)
    return g:GetClassCount(Card.GetCode)>=4 and Duel.IsExistingMatchingCard(c60150548.confilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c60150548.e4filter(e,te)
    return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c60150548.e5tgfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xcb20) and c:IsType(TYPE_XYZ)
end
function c60150548.e5tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c60150548.confilter,tp,LOCATION_SZONE,0,nil)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60150548.e5tgfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c60150548.e5tgfilter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 and g:GetClassCount(Card.GetCode)>=1 and Duel.IsExistingMatchingCard(c60150548.confilter2,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22198672,2))
    Duel.SelectTarget(tp,c60150548.e5tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c60150548.e5op(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c60150548.confilter,tp,LOCATION_SZONE,0,nil)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
    local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
    local nseq=math.log(s,2)
    if Duel.MoveSequence(tc,nseq)~=0 and g:GetClassCount(Card.GetCode)==5 and Duel.IsExistingMatchingCard(c60150548.confilter2,tp,LOCATION_MZONE,0,1,nil) then
		local e5=Effect.CreateEffect(e:GetHandler())
        e5:SetType(EFFECT_TYPE_SINGLE)
        e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e5:SetRange(LOCATION_MZONE)
        e5:SetCode(EFFECT_IMMUNE_EFFECT)
        e5:SetValue(c60150548.e4filter)
        e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_CHAIN)
        tc:RegisterEffect(e5)
	end
end
