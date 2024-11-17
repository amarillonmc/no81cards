--人理之基 兰斯洛特
function c22021040.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xff1),1)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22021040,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,22021040)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c22021040.discon)
	e1:SetTarget(c22021040.distg)
	e1:SetOperation(c22021040.disop)
	c:RegisterEffect(e1)
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetCondition(c22021040.descon)
	e2:SetValue(c22021040.val)
	c:RegisterEffect(e2)
end
c22021040.effect_with_light=true
function c22021040.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c22021040.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsLocation(LOCATION_MZONE) and rc:IsControler(1-tp) and rc:IsAbleToChangeControler() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
	end
end
function c22021040.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=re:GetHandler()
	if Duel.NegateEffect(ev) and c:IsRelateToEffect(e) and tc:IsRelateToEffect(re) then
		Duel.Equip(tp,tc,c,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c22021040.eqlimit)
		e1:SetLabelObject(c)
		tc:RegisterEffect(e1)
		--atkup
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(800)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function c22021040.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c22021040.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c22021040.val(e,c)
	return c:GetEquipCount()
end