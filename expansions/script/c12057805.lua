--裁决的指引
function c12057805.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(12057805,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12057805,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,12057805)
	e1:SetCondition(c12057805.condition)
	e1:SetTarget(c12057805.target)
	e1:SetOperation(c12057805.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12057805,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22057805)
	e2:SetCondition(c12057805.setcon)
	e2:SetTarget(c12057805.settg)
	e2:SetOperation(c12057805.setop)
	c:RegisterEffect(e2)
end
function c12057805.ckfil(c) 
	return c:IsSetCard(0x145,0x16b) and c:IsFaceup()
end
function c12057805.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsExistingMatchingCard(c12057805.ckfil,tp,LOCATION_MZONE,0,1,nil)
end
function c12057805.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
end
function c12057805.operation(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c12057805.setfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsRace(RACE_WYRM) and c:IsType(TYPE_SYNCHRO+TYPE_XYZ+TYPE_FUSION+TYPE_PENDULUM+TYPE_LINK) 
end
function c12057805.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12057805.setfilter,1,nil,tp)
end
function c12057805.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c12057805.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	   Duel.SSet(tp,c) 
	end
end


