--水灵术解放
function c98920865.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c98920865.condition1)
	e1:SetTarget(c98920865.target1)
	e1:SetOperation(c98920865.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	--act in hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920865,0))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetCondition(c98920865.handcon)
	c:RegisterEffect(e4)
	--SSet
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,98920865)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c98920865.setcon)
	e2:SetTarget(c98920865.settg)
	e2:SetOperation(c98920865.setop)
	c:RegisterEffect(e2)
end
function c98920865.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0xbf) or c:IsSetCard(0x10c0)) and c:IsType(TYPE_MONSTER)
end
function c98920865.condition1(e,tp,eg,ep,ev,re,r,rp)
	return aux.NegateSummonCondition() and Duel.IsExistingMatchingCard(c98920865.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98920865.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c98920865.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c98920865.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c98920865.handcon(e)
	return Duel.IsExistingMatchingCard(c98920865.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c98920865.setcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsActivated() and re:GetHandler():IsSetCard(0x514c) and not re:GetHandler():IsCode(98920865)
end
function c98920865.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c98920865.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end