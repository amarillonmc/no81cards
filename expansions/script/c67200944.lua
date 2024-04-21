--天垣修正者 玄机
function c67200944.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pzone spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(67200944,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,67200945)
	e0:SetCondition(c67200944.pspcon)
	e0:SetTarget(c67200944.psptg)
	e0:SetOperation(c67200944.pspop)
	c:RegisterEffect(e0)
	--hand to pzone 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200944,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c67200944.pspcon)
	e1:SetTarget(c67200944.pstg)
	e1:SetOperation(c67200944.psop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,67200944)
	e2:SetCondition(c67200944.stcon)
	e2:SetTarget(c67200944.target)
	e2:SetOperation(c67200944.activate)
	c:RegisterEffect(e2)
end
function c67200944.pspcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x67a) and rc:IsControler(tp)
end
function c67200944.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200944.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end
end
--
function c67200944.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c67200944.psop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--
function c67200944.pfilter(c)
	return c:IsSetCard(0x567a)
end
function c67200944.stcon(e)
	return Duel.GetFlagEffect(tp,67200944)==0 and e:GetHandler():IsFaceup() and Duel.IsExistingMatchingCard(c67200944.pfilter,tp,LOCATION_PZONE,0,2,nil)
end
function c67200944.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 end
	Duel.RegisterFlagEffect(tp,67200944,RESET_PHASE+PHASE_END,0,2)
end
function c67200944.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end
end
