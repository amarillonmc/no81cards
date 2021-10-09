--桃木剑
function c9950840.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c9950840.target)
	e1:SetOperation(c9950840.operation)
	c:RegisterEffect(e1)
 --Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c9950840.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9950840.discon)
	e3:SetOperation(c9950840.disop)
	c:RegisterEffect(e3)
end
function c9950840.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9950840.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c9950840.disable(e,c)
	return c:IsRace(RACE_FIEND+RACE_ZOMBIE)
end
function c9950840.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND+RACE_ZOMBIE) 
end
function c9950840.discon(e,tp,eg,ep,ev,re,r,rp)
	local race=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE)
	return Duel.GetMatchingGroupCount(c9950840.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)>1
		and re:IsActiveType(TYPE_MONSTER) and race&RACE_FIEND+RACE_ZOMBIE>0
end
function c9950840.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
