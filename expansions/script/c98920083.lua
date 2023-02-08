--宝玉兽 黄晶虎
function c98920083.initial_effect(c)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c98920083.discon)
	e1:SetTarget(c98920083.distg)
	e1:SetOperation(c98920083.disop)
	c:RegisterEffect(e1)
--send replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c98920083.repcon)
	e1:SetOperation(c98920083.repop)
	c:RegisterEffect(e1)
--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c98920083.atkcon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1034,0x2034))
	e2:SetValue(400)
	c:RegisterEffect(e2)
end
function c98920083.disfilter(c)
	return c:IsSetCard(0x1034) or c:IsSetCard(0x2034) and c:IsFaceup()
end
function c98920083.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c98920083.disfilter,tp,LOCATION_MZONE,0,1,nil)
		and rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) and not c:IsPublic()
end
function c98920083.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c98920083.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateEffect(ev) then   
	   if not c:IsRelateToEffect(e) then return end
	   if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		   local e1=Effect.CreateEffect(c)
		   e1:SetCode(EFFECT_CHANGE_TYPE)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		   e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		   c:RegisterEffect(e1)
	   end
	end 
end
function c98920083.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c98920083.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
end
function c98920083.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end