--废都洗礼者
function c67200933.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pzone spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(67200933,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,67200933)
	e0:SetCondition(c67200933.pspcon)
	e0:SetTarget(c67200933.psptg)
	e0:SetOperation(c67200933.pspop)
	c:RegisterEffect(e0)
	--hand to pzone 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200933,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c67200933.pspcon)
	e1:SetTarget(c67200933.pstg)
	e1:SetOperation(c67200933.psop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,67200938)
	e2:SetCost(c67200933.cost)
	e2:SetCondition(c67200933.stcon)
	e2:SetTarget(c67200933.target)
	e2:SetOperation(c67200933.activate)
	c:RegisterEffect(e2)
end
function c67200933.pspcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x67a) and rc:IsControler(tp)
end
function c67200933.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200933.atkfilter(c)
	return c:IsSetCard(0x67a) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()
end
function c67200933.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local atk=Duel.GetMatchingGroup(c67200933.atkfilter,tp,LOCATION_MZONE,0,c):GetSum(Card.GetAttack)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function c67200933.val(e,c)
	return c:IsSetCard(0x67a) and c:IsAttribute(ATTRIBUTE_WATER)
end
--
function c67200933.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c67200933.psop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--
function c67200933.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x67a) 
end
function c67200933.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c67200933.stcon(e)
	return Duel.GetFlagEffect(tp,67200933)==0
end
function c67200933.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c67200933.cfilter,tp,LOCATION_ONFIELD,0,1,c,c,tp) and dg:GetCount()>0 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200933.cfilter,tp,LOCATION_ONFIELD,0,1,dg:GetCount(),c)
	Duel.SendtoHand(g,nil,REASON_COST)
	e:SetLabel(0,g:GetCount())
	Duel.RegisterFlagEffect(tp,67200933,RESET_PHASE+PHASE_END,0,2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,dg,g:GetCount(),0,0)
end
function c67200933.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local label,count=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200933.filter,tp,0,LOCATION_MZONE,count,count,nil)
	if g:GetCount()==count then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end 
end
