--人理之基 武则天
function c22025030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22025030,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22025030)
	e1:SetCost(c22025030.discost)
	e1:SetTarget(c22025030.target)
	e1:SetOperation(c22025030.operation)
	c:RegisterEffect(e1)
end
function c22025030.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c22025030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	e:SetLabel(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c22025030.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac1=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	e:GetHandler():SetHint(CHINT_CARD,ac1)
	local ac=e:GetLabel()
	--forbidden
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c22025030.aclimit)
	e1:SetLabel(ac)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetLabel(ac)
	e2:SetCondition(c22025030.drcon1)
	e2:SetOperation(c22025030.drop1)
	Duel.RegisterEffect(e2,tp)
end
function c22025030.aclimit(e,re,tp)
	return re:GetHandler():GetOriginalCode()==e:GetLabel() and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function c22025030.drcon1(e,tp,eg,ep,ev,re,r,rp)
	local fcode=e:GetLabel()
	return rp==1-tp and re:GetHandler():IsCode(fcode)
end
function c22025030.drop1(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(1-tp)
	Duel.Hint(HINT_CARD,0,22025030)
	Duel.SetLP(1-tp,lp-950)
end