--睡鼠山眠
function c95101097.initial_effect(c)
	aux.AddCodeList(c,95101001)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c95101097.mfilter1,c95101097.mfilter2,true)
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_POSITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
	e1:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e1)
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetDescription(aux.Stringid(95101097,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95101097)
	e2:SetCost(c95101097.poscost)
	e2:SetTarget(c95101097.postg)
	e2:SetOperation(c95101097.posop)
	c:RegisterEffect(e2)
	--pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,95101097+1)
	e3:SetTarget(c95101097.pentg)
	e3:SetOperation(c95101097.penop)
	c:RegisterEffect(e3)
	--gr:pendulum spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(1152)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,95101097+2)
	e4:SetCondition(c95101097.pspcon)
	e4:SetTarget(c95101097.psptg)
	e4:SetOperation(c95101097.pspop)
	c:RegisterEffect(e4)
end
function c95101097.mfilter1(c,fc)
	return aux.IsCodeListed(c,95101001) and c:IsType(TYPE_PENDULUM)
end
function c95101097.mfilter2(c,fc)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_PENDULUM)
end
function c95101097.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c95101097.posfilter(c)
	return c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanTurnSet()
end
function c95101097.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101097.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c95101097.posfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c95101097.posop(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetMatchingGroup(c95101097.posfilter,tp,0,LOCATION_MZONE,nil)
	if g2:GetCount()>0 then Duel.ChangePosition(g2,POS_FACEDOWN_DEFENSE) end
end
function c95101097.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c95101097.penop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c95101097.chkfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_PZONE)
end
function c95101097.pspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95101097.chkfilter,1,nil,tp)
end
function c95101097.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c95101097.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
