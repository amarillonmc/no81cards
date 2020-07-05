--整合运动·宿主重装士兵
function c79020030.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2,nil,nil,99)
	c:EnableReviveLimit()  
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c79020030.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)  
	--defense
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,79020030)
	e3:SetTarget(c79020030.contg)
	e3:SetOperation(c79020030.conop)
	c:RegisterEffect(e3) 
	--overlay
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c79020030.cost)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetTarget(c79020030.postg)
	e4:SetOperation(c79020030.posop)
	c:RegisterEffect(e4)	
end
function c79020030.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3900) and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE+LOCATION_EXTRA,0,1,nil,79020034)
end
function c79020030.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c79020030.contg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)~=0 end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),tp,0)
end
function c79020030.conop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local tc=g:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetValue(0)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	tc=g:GetNext()
end
end
function c79020030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79020030.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,0x3904) end
	Duel.SetChainLimit(c79020030.chlimit)
end
function c79020030.chlimit(e,ep,tp)
	return tp==ep
end
function c79020030.posop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil,0x3904)
	Duel.Overlay(c,g)   
end






