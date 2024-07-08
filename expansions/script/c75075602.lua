--噩梦的 史塔尔莲华
function c75075602.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75075602)
	e1:SetCondition(c75075602.spcon)
	e1:SetTarget(c75075602.sptg)
	e1:SetOperation(c75075602.spop)
	c:RegisterEffect(e1)	
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75075602,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,75075603)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c75075602.postg)
	e2:SetOperation(c75075602.posop)
	c:RegisterEffect(e2) 
	--activate cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetCost(c75075602.costchk)
	e3:SetCondition(c75075602.actcon)
	e3:SetOperation(c75075602.costop)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_FLIPSUMMON_COST)
	e5:SetCost(c75075602.costchk1)
	e5:SetOperation(c75075602.costop1)
	c:RegisterEffect(e5)
	--
	--activate cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetCost(c75075602.costchk)
	e3:SetCondition(c75075602.actcon1)
	e3:SetOperation(c75075602.costop)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_FLIPSUMMON_COST)
	e5:SetCost(c75075602.costchk1)
	e5:SetOperation(c75075602.costop1)
	c:RegisterEffect(e5)
	--accumulate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_FLAG_EFFECT+75075602)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	c:RegisterEffect(e4)
end
function c75075602.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c75075602.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c75075602.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c75075602.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanChangePosition() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c75075602.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
--
function c75075602.actcon(e)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil) and e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
function c75075602.actcon1(e)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
function c75075602.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,75075602)
	return Duel.CheckLPCost(tp,ct*400)
end
function c75075602.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,400)
end
function c75075602.costchk1(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,75075602)
	return Duel.CheckLPCost(tp,ct*1200)
end
function c75075602.costop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,1200)
end