--勇者的奇袭
function c12057814.initial_effect(c)
	 --activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(11711438,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)   
	--r and d 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12057814,1))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,12057814)
	e1:SetCondition(c12057814.radcon)
	e1:SetTarget(c12057814.radtg)
	e1:SetOperation(c12057814.radop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12057814,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22057814)
	e2:SetCondition(c12057814.setcon)
	e2:SetTarget(c12057814.settg)
	e2:SetOperation(c12057814.setop)
	c:RegisterEffect(e2)
end
function c12057814.setfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsRace(RACE_WYRM) and c:IsType(TYPE_SYNCHRO+TYPE_XYZ+TYPE_FUSION+TYPE_PENDULUM+TYPE_LINK) 
end
function c12057814.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12057814.setfilter,1,nil,tp)
end
function c12057814.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c12057814.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	   Duel.SSet(tp,c) 
	end
end
function c12057814.radfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x145,0x16b)
end
function c12057814.radcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c12057814.radfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c12057814.radtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,1000)
end
function c12057814.radop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil) 
	if g:GetCount()<=0 then return end 
	local dg=g:Select(tp,1,2,nil)   
	if Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)~=0 then
	Duel.BreakEffect() 
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
	end
end








