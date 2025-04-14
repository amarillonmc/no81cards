--天启录B
function c21170003.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c21170003.tg)
	e1:SetOperation(c21170003.op)
	c:RegisterEffect(e1)
	c21170003.copy = e1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(c21170003.con2)
	e2:SetValue(c21170003.val2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c21170003.con3)
	e3:SetOperation(c21170003.op3)
	c:RegisterEffect(e3)
end
function c21170003.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c21170003.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,0,REASON_EFFECT)
end
function c21170003.con2(e)
	return e:GetHandler():IsSetCard(0x6917)
end
function c21170003.val2(e,te)
	return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c21170003.con3(e,tp,eg,ep,ev,re,r,rp)
	return r&(REASON_LINK|REASON_FUSION|REASON_SYNCHRO)>0
end
function c21170003.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not rc:IsSetCard(0x6917) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21170003,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c21170003.val2)
	--e1:SetOwnerPlayer(ep)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end