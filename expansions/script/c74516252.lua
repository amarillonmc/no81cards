--人偶·艾妮斯
function c74516252.initial_effect(c)
	aux.EnableDualAttribute(c)
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74516252,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(aux.IsDualState)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_SUMMON+TIMING_SPSUMMON+TIMING_END_PHASE)
	e1:SetCountLimit(1)
	e1:SetCost(c74516252.cost)
	e1:SetTarget(c74516252.target)
	e1:SetOperation(c74516252.activate)
	c:RegisterEffect(e1)
end
function c74516252.cfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToRemoveAsCost()
end
function c74516252.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74516252.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c74516252.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c74516252.filter(c,check)
	return c:IsControlerCanBeChanged(check)
end
function c74516252.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local check=e:GetLabel()==100
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c74516252.filter,tp,0,LOCATION_MZONE,1,nil,check)
	end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c74516252.filter2(c)
	return c:IsControlerCanBeChanged()
end
function c74516252.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c74516252.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end
