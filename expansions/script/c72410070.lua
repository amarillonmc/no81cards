--冲破黑暗
function c72410070.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e0:SetHintTiming(0,TIMING_END_PHASE)
	e0:SetCondition(c72410070.con0)
	e0:SetCost(c72410070.cost)
	e0:SetTarget(c72410070.target)
	e0:SetOperation(c72410070.activate)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c72410070.con)
	e1:SetCost(c72410070.cost)
	e1:SetTarget(c72410070.target)
	e1:SetOperation(c72410070.activate)
	c:RegisterEffect(e1)
end
function c72410070.con0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(72410000)
end
function c72410070.con(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsEnvironment(72410000)
end
function c72410070.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c72410070.filter1(c,e,tp)
	return c:IsRace(RACE_DRAGON) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c72410070.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c72410070.filter2(c,e,tp,tcode)
	return c:IsSetCard(0xc727) and c.valorous_name==tcode and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c72410070.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c72410070.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c72410070.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c72410070.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c72410070.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel()):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP_ATTACK)>0 then
		tc:CompleteProcedure()
	end
end
