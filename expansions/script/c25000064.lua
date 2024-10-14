--太空墓场
function c25000064.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c25000064.target)
	c:RegisterEffect(e1)
	--select target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabelObject(e1)
	e2:SetCondition(c25000064.slcon)
	e2:SetOperation(c25000064.slop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c25000064.disop)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SELF_TOGRAVE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetLabelObject(e1)
	e4:SetCondition(c25000064.condition)
	c:RegisterEffect(e4)
end
function c25000064.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g:GetFirst())
end
function c25000064.slcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c25000064.slop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):GetFirst()
	if c:IsRelateToEffect(re) and tc:IsFaceup() and tc:IsRelateToEffect(re) then
		c:SetCardTarget(tc)
	end
end
function c25000064.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	local rc=re:GetHandler()
	if not (re:GetActivateLocation()==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and rc:IsLevelAbove(1))or rc==tc then return end
	if (rc:IsLocation(LOCATION_MZONE) and rc:IsRelateToEffect(re)) then
		Duel.SendtoGrave(rc,REASON_EFFECT)
	elseif (not rc:IsLocation(LOCATION_MZONE) and Duel.IsChainDisablable(ev)) then
		Duel.Hint(HINT_CARD,0,25000064)
		Duel.NegateEffect(ev)
	end
end
function c25000064.chkfilter(c)
	return not c:IsLevelAbove(1) and c:IsFaceup()
end
function c25000064.condition(e,tp,eg,ep,ev,re,r,rp)
	return (not e:GetLabelObject():GetLabelObject() or Duel.IsExistingMatchingCard(c25000064.chkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetLabelObject():GetLabelObject()))
end
