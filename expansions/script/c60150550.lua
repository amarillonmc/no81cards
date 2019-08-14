--幻想乐章的崩析
function c60150550.initial_effect(c)
    c:SetUniqueOnField(1,0,60150550)
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
    e2:SetCondition(c60150550.e2con)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --cannot target
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetCondition(c60150550.e3con)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetCondition(c60150550.e4con)
    e4:SetValue(c60150550.e4filter)
    c:RegisterEffect(e4)
    --disable and destroy
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCode(EVENT_CHAIN_SOLVING)
    e5:SetOperation(c60150550.e5op)
    c:RegisterEffect(e5)
end
function c60150550.confilter(c)
    return c:IsFaceup() and c:IsSetCard(0xcb20) and c:IsType(TYPE_CONTINUOUS)
end
function c60150550.confilter2(c)
    return c:IsSetCard(0xcb20) and c:IsType(TYPE_XYZ)
end
function c60150550.e2con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c60150550.confilter,tp,LOCATION_SZONE,0,nil)
    return g:GetClassCount(Card.GetCode)>=2 and Duel.IsExistingMatchingCard(c60150550.confilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c60150550.e3con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c60150550.confilter,tp,LOCATION_SZONE,0,nil)
    return g:GetClassCount(Card.GetCode)>=3 and Duel.IsExistingMatchingCard(c60150550.confilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c60150550.e4con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c60150550.confilter,tp,LOCATION_SZONE,0,nil)
    return g:GetClassCount(Card.GetCode)>=4 and Duel.IsExistingMatchingCard(c60150550.confilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c60150550.e4filter(e,te)
    return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c60150550.e5opfilter(c,tp)
    return c:IsOnField() and c:IsControler(1-tp)
end
function c60150550.e5opfilter2(c,tp)
    return c:IsLocation(LOCATION_GRAVE) and c:IsControler(1-tp)
end
function c60150550.e5op(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c60150550.confilter,tp,LOCATION_SZONE,0,nil)
    if ep==tp then return false end
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
    local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if (g:GetClassCount(Card.GetCode)>=1 and Duel.IsExistingMatchingCard(c60150550.confilter2,tp,LOCATION_MZONE,0,1,nil)) 
		and tg:IsExists(c60150550.e5opfilter,1,nil,tp) then
        Duel.NegateEffect(ev)
    elseif (g:GetClassCount(Card.GetCode)==5 and Duel.IsExistingMatchingCard(c60150550.confilter2,tp,LOCATION_MZONE,0,1,nil)) 
		and tg:IsExists(c60150550.e5opfilter2,1,nil,tp) then
        Duel.NegateEffect(ev)
    end
end