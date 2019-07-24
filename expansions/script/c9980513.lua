--风之流法—神砂岚
function c9980513.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c9980513.condition)
	e1:SetTarget(c9980513.target)
	e1:SetOperation(c9980513.activate)
	c:RegisterEffect(e1)
end
function c9980513.cfilter(c)
	return c:IsFaceup() and c:IsCode(9980501)
end
function c9980513.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9980513.cfilter,tp,LOCATION_PZONE+LOCATION_MZONE,0,1,nil)
end
function c9980513.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c9980513.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980513.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c9980513.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c9980513.chainlm)
end
function c9980513.chainlm(e,rp,tp)
	return tp==rp
end
function c9980513.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9980513.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
