--失控磁盘游击
function c95101245.initial_effect(c)
	--Activate(effect)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_POSITION)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetTarget(c95101245.target)
	e0:SetOperation(c95101245.activate)
	c:RegisterEffect(e0)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(aux.NegateSummonCondition)
	e1:SetTarget(c95101245.target2)
	e1:SetOperation(c95101245.activate2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
end
function c95101245.cfilter(c,pos)
	return c:IsSetCard(0x6bb0) and c:IsPosition(pos) and c:IsCanChangePosition()
end
function c95101245.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c95101245.cfilter,tp,LOCATION_MZONE,0,nil,POS_FACEUP_DEFENSE)
	if chk==0 then return aux.nbtg(e,tp,eg,ep,ev,re,r,rp,0) and #g>0 end
	aux.nbtg(e,tp,eg,ep,ev,re,r,rp,1)
end
function c95101245.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c95101245.cfilter,tp,LOCATION_MZONE,0,nil,POS_FACEUP_DEFENSE)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)~=0 and #g~=0 then
		Duel.BreakEffect()
		Duel.ChangePosition(g,POS_FACEUP_ATTACK)
	end
end
function c95101245.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanRemove(tp) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c95101245.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	local g=Duel.GetMatchingGroup(c95101245.cfilter,tp,LOCATION_MZONE,0,nil,POS_FACEUP_ATTACK)
	if Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)==0 or #g==0 then return end
	Duel.BreakEffect()
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
end
