--幻想乐章的华尔兹
function c60150551.initial_effect(c)
    c:SetUniqueOnField(1,0,60150551)
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
    e2:SetCondition(c60150551.e2con)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --cannot target
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetCondition(c60150551.e3con)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetCondition(c60150551.e4con)
    e4:SetValue(c60150551.e4filter)
    c:RegisterEffect(e4)
    --
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(60150551,0))
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(c60150551.e5tg)
    e5:SetOperation(c60150551.e5op)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(60150551,1))
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_SZONE)
    e6:SetCountLimit(1)
    e6:SetCost(c60150551.e6cost)
    e6:SetTarget(c60150551.e6tg)
    e6:SetOperation(c60150551.e6op)
    c:RegisterEffect(e6)
	
end
function c60150551.confilter(c)
    return c:IsFaceup() and c:IsSetCard(0xcb20) and c:IsType(TYPE_CONTINUOUS)
end
function c60150551.confilter2(c)
    return c:IsSetCard(0xcb20) and c:IsType(TYPE_XYZ)
end
function c60150551.e2con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c60150551.confilter,tp,LOCATION_SZONE,0,nil)
    return g:GetClassCount(Card.GetCode)>=2 and Duel.IsExistingMatchingCard(c60150551.confilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c60150551.e3con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c60150551.confilter,tp,LOCATION_SZONE,0,nil)
    return g:GetClassCount(Card.GetCode)>=3 and Duel.IsExistingMatchingCard(c60150551.confilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c60150551.e4con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c60150551.confilter,tp,LOCATION_SZONE,0,nil)
    return g:GetClassCount(Card.GetCode)>=4 and Duel.IsExistingMatchingCard(c60150551.confilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c60150551.e4filter(e,te)
    return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c60150551.e5tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
    local g0=Duel.GetMatchingGroup(c60150551.confilter,tp,LOCATION_SZONE,0,nil)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60150551.confilter2(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c60150551.confilter2,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c60150551.e5opfilter,tp,0,LOCATION_MZONE,1,nil) 
		and g0:GetClassCount(Card.GetCode)>=1 and Duel.IsExistingMatchingCard(c60150551.confilter2,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,c60150551.confilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c60150551.e5opfilter(c)
    return c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN)
end
function c60150551.e5op(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectMatchingCard(tp,c60150551.e5opfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if not g:GetFirst():IsImmuneToEffect(e) and g:GetFirst():IsLocation(LOCATION_MZONE) and tc:IsLocation(LOCATION_MZONE) then
        local og=g:GetFirst():GetOverlayGroup()
        if og:GetCount()>0 then
            Duel.SendtoGrave(og,REASON_RULE)
        end
        Duel.Overlay(tc,g)
    end
end
function c60150551.e6costfilter(c,tp)
    return c:IsSetCard(0xcb20) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0 and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function c60150551.e6cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandlerPlayer()
    local g=Duel.GetMatchingGroup(c60150551.e6costfilter,tp,LOCATION_MZONE,0,nil,tp)
    if chk==0 then return g:GetCount()>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local gc=Duel.SelectMatchingCard(tp,c60150551.e6costfilter,tp,LOCATION_MZONE,0,1,1,nil)
    gc:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60150551.e6tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
    local g0=Duel.GetMatchingGroup(c60150551.confilter,tp,LOCATION_SZONE,0,nil)
    if chk==0 then return Duel.IsExistingTarget(c60150551.confilter2,tp,LOCATION_MZONE,0,1,nil) 
		and g0:GetClassCount(Card.GetCode)==5 and Duel.IsExistingMatchingCard(c60150551.confilter2,tp,LOCATION_MZONE,0,1,nil) end
end
function c60150551.e6opfilter(c,tp)
	if c:IsLocation(LOCATION_MZONE) then
		if c:IsControler(1-tp) then
			return c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN)
		else
			return not c:IsType(TYPE_TOKEN)
		end
	else
		return true
	end
end
function c60150551.e6op(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150551,2))
    local g=Duel.SelectMatchingCard(tp,c60150551.confilter2,tp,LOCATION_MZONE,0,1,1,nil)
    local tc=g:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150551,3))
    local g2=Duel.SelectMatchingCard(tp,c60150551.e6opfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,tc,tp)
    local tc2=g2:GetFirst()
	if not tc2:IsImmuneToEffect(e) and tc:IsLocation(LOCATION_MZONE) then
        local og=tc2:GetOverlayGroup()
        if og:GetCount()>0 then
            Duel.SendtoGrave(og,REASON_RULE)
        end
        Duel.Overlay(tc,g2)
    end
end