--风神录-神灵之谷
function c9980099.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980099,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9980099.condition)
	e2:SetTarget(c9980099.target)
	e2:SetOperation(c9980099.operation)
	c:RegisterEffect(e2)
 --recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c9980099.reccon)
	e2:SetOperation(c9980099.recop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
 --set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980099,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9980099)
	e2:SetCost(c9980099.setcost)
	e2:SetTarget(c9980099.settg)
	e2:SetOperation(c9980099.setop)
	c:RegisterEffect(e2)
end
function c9980099.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and bit.band(c:GetPreviousAttributeOnField(),ATTRIBUTE_WIND+ATTRIBUTE_WATER)~=0
		and c:IsPreviousPosition(POS_FACEUP)
end
function c9980099.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9980099.cfilter,1,nil,tp)
end
function c9980099.filter(c,e,tp)
	return c:IsSetCard(0x3bc6) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980099.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.IsExistingMatchingCard(c9980099.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9980099.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9980099.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9980099.cfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c9980099.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9980099.cfilter,1,nil,1-tp)
end
function c9980099.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9980099)
	Duel.Recover(tp,1000,REASON_EFFECT)
end
function c9980099.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND+ATTRIBUTE_WATER) and c:IsDiscardable()
end
function c9980099.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980099.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9980099.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c9980099.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c9980099.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end