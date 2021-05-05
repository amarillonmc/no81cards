--宿星辉士 南前朱雀
function c40008140.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x9c),3,3)
	c:EnableReviveLimit()
	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c40008140.condition)
	e1:SetOperation(c40008140.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c40008140.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--multi attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c40008140.condition)
	e3:SetOperation(c40008140.operation2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c40008140.valcheck2)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--Prevent Activation
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(0,1)
	e6:SetValue(c40008140.aclimit)
	c:RegisterEffect(e6)	 
end
function c40008140.spcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9c) and c:IsAbleToHandAsCost()
end
function c40008140.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008140.spcfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c40008140.spcfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c40008140.cfilter(c)
	return c:IsSetCard(0x9c) and c:IsType(TYPE_MONSTER)
end
function c40008140.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroup(c40008140.cfilter,tp,LOCATION_GRAVE,0,nil)
	return ct:GetClassCount(Card.GetCode)<7
end
function c40008140.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroup(c40008140.cfilter,tp,LOCATION_GRAVE,0,nil)
	return ct:GetClassCount(Card.GetCode)>=7
end
function c40008140.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c40008140.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c40008140.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_XYZ) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c40008140.valcheck2(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_LINK) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c40008140.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function c40008140.operation2(e,tp,eg,ep,ev,re,r,rp)
	local e8=Effect.CreateEffect(e:GetHandler())
	e8:SetCategory(CATEGORY_TODECK)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCost(c40008140.spcost)
	e8:SetCondition(c40008140.spcon1)
	e8:SetTarget(c40008140.sptg)
	e8:SetOperation(c40008140.spop)
	e:GetHandler():RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetCondition(c40008140.spcon2)
	e:GetHandler():RegisterEffect(e9)
end
function c40008140.operation(e,tp,eg,ep,ev,re,r,rp)
	local e7=Effect.CreateEffect(e:GetHandler())
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetOperation(c40008140.chainop)
	e7:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e7)
end
function c40008140.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x9c) and re:IsActiveType(TYPE_MONSTER) and ep==tp then
		Duel.SetChainLimit(c40008140.chainlm)
	end
end
function c40008140.chainlm(e,rp,tp)
	return tp==rp
end
function c40008140.aclimit(e,re,tp)
	return re:GetHandler():IsAttribute(ATTRIBUTE_DARK) and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end