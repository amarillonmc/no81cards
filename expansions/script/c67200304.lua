--神杀的封缄英杰 赛利卡·希露菲尔
function c67200304.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon(pendelum)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200304,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200304)
	e1:SetCost(c67200304.spcost)
	e1:SetTarget(c67200304.sptg)
	e1:SetOperation(c67200304.spop)
	c:RegisterEffect(e1)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c67200304.val)
	c:RegisterEffect(e3)  
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(67200304,0))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c67200304.negcon)
	e5:SetCost(c67200304.negcost)
	e5:SetTarget(c67200304.negtg)
	e5:SetOperation(c67200304.negop)
	c:RegisterEffect(e5)	 
end
function c67200304.spfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x3674) and c:IsReleasable()
end
function c67200304.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc=LOCATION_ONFIELD
	if ft==0 then loc=LOCATION_MZONE end
	if chk==0 then return Duel.IsExistingMatchingCard(c67200304.spfilter1,tp,loc,0,2,e:GetHandler(),e,tp) end
	local g=Duel.SelectMatchingCard(tp,c67200304.spfilter1,tp,loc,0,2,2,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c67200304.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200304.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--
function c67200304.atkfilter(c)
	return c:IsSetCard(0x3674) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c67200304.val(e,c)
	return Duel.GetMatchingGroupCount(c67200304.atkfilter,c:GetControler(),LOCATION_EXTRA,0,nil)*800
end
--
function c67200304.cfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3674) and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeckAsCost() 
end
function c67200304.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c67200304.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200304.cfilter1,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c67200304.cfilter1,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c67200304.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c67200304.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
--
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_ATTACK_ALL)
		e4:SetValue(1)
		e:GetHandler():RegisterEffect(e4)
	end
end
