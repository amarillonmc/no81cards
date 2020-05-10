--天空漫步者-回绝
function c9910246.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c9910246.condition)
	e1:SetTarget(c9910246.target)
	e1:SetOperation(c9910246.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
end
function c9910246.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c9910246.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c9910246.filter1(c,tp,id)
	return c:GetTurnID()==id and not c:IsReason(REASON_RETURN) and c:GetReasonPlayer()==tp and c:IsAbleToHand()
end
function c9910246.filter2(c,e,tp,id)
	return c:GetTurnID()==id and not c:IsReason(REASON_RETURN) and c:GetReasonPlayer()==1-tp
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910246.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	if Duel.Destroy(eg,REASON_EFFECT)==0 then return end
	local id=Duel.GetTurnCount()
	local g1=Duel.GetMatchingGroup(c9910246.filter1,tp,0,LOCATION_GRAVE,nil,tp,id)
	local g2=Duel.GetMatchingGroup(c9910246.filter2,tp,LOCATION_GRAVE,0,nil,e,tp,id)
	Duel.BreakEffect()
	local off=1
	local ops={}
	local opval={}
	if g1:GetCount()>0 then
		ops[off]=aux.Stringid(9910246,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g2:GetCount()>0 then
		ops[off]=aux.Stringid(9910246,1)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		if sg1:GetCount()>0 then
			Duel.HintSelection(sg1)
			Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		end
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g2:Select(tp,1,1,nil)
		if sg2:GetCount()>0 then
			Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
