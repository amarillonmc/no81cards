--真樱修正者 神威
function c67200977.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pzone spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(67200977,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,67200978)
	e0:SetCondition(c67200977.pspcon)
	e0:SetTarget(c67200977.psptg)
	e0:SetOperation(c67200977.pspop)
	c:RegisterEffect(e0)
	--hand to pzone 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200977,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c67200977.pspcon)
	e1:SetTarget(c67200977.pstg)
	e1:SetOperation(c67200977.psop)
	c:RegisterEffect(e1)  
	--Activate MoveToPzone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200977,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,67200977)
	e2:SetTarget(c67200977.target)
	e2:SetOperation(c67200977.activate)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3) 
end
function c67200977.pspcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x67a) and rc:IsControler(tp)
end
function c67200977.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200977.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end
end
--
function c67200977.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c67200977.psop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--
function c67200977.penfilter(c)
	return c:IsSetCard(0x567a) and c:IsType(TYPE_PENDULUM)
		and not c:IsForbidden()
end
function c67200977.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c67200977.penfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c67200977.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c67200977.penfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end