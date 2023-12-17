--Kamipro 风天狱的加护
function c50213235.initial_effect(c)
	c:EnableCounterPermit(0xcbf)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c50213235.ctop)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCost(c50213235.smcost)
	e2:SetTarget(c50213235.smtg)
	e2:SetOperation(c50213235.smop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(10,50213235)
	e3:SetTarget(c50213235.desreptg)
	e3:SetOperation(c50213235.desrepop)
	c:RegisterEffect(e3)
end
function c50213235.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcbf)
end
function c50213235.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c50213235.ctfilter,1,nil) then
		e:GetHandler():AddCounter(0xcbf,1)
	end
end
function c50213235.smcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) and e:GetHandler():IsCanRemoveCounter(tp,0xcbf,1,REASON_COST) end
	Duel.PayLPCost(tp,500)
	e:GetHandler():RemoveCounter(tp,0xcbf,1,REASON_COST)
end
function c50213235.sfilter(c)
	return c:IsSummonable(true,nil) and c:IsSetCard(0xcbf)
end
function c50213235.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50213235.sfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c50213235.smop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c50213235.sfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c50213235.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE)
		and e:GetHandler():IsCanRemoveCounter(tp,0xcbf,2,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c50213235.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0xcbf,2,REASON_EFFECT)
end