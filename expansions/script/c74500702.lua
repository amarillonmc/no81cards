--旁观者
function c74500702.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,74500702+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCondition(c74500702.condition1)
	e1:SetCost(c74500702.cost1)
	e1:SetTarget(c74500702.target)
	e1:SetOperation(c74500702.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(c74500702.condition2)
	e2:SetCost(c74500702.cost2)
	c:RegisterEffect(e2)
end
function c74500702.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,74590055)
end
function c74500702.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c74500702.condition2(e,tp,eg,ep,ev,re,r,rp)
	return aux.dscon() and Duel.IsPlayerAffectedByEffect(tp,74590055)
end
function c74500702.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Recover(tp,1000,REASON_COST)
end
function c74500702.dfilter(c)
	return c:IsReleasableByEffect() and c:IsSetCard(0x745) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_DUAL)
end
function c74500702.rfilter(c)
	return c:IsReleasableByEffect() and c:IsSetCard(0x745) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL)
end
function c74500702.exfilter(c)
	return c:IsReleasableByEffect() and c:IsSetCard(0x745) and c:IsType(TYPE_MONSTER) and c:IsSummonLocation(LOCATION_EXTRA)
end
function c74500702.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c74500702.dfilter,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c74500702.rfilter,tp,LOCATION_MZONE,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c74500702.exfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 or b3 end
end
function c74500702.operation(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c74500702.dfilter,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c74500702.rfilter,tp,LOCATION_MZONE,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c74500702.exfilter,tp,LOCATION_MZONE,0,1,nil)
	if not (b1 or b2 or b3) then return end
	local d=0
	local r=0
	local ex=0
	--release
	local sg=Group.CreateGroup()
	repeat
		if b1 and Duel.SelectYesNo(tp,aux.Stringid(74500702,0)) then
			local dsg=Duel.SelectReleaseGroup(tp,c74500702.dfilter,1,1,nil,tp)
			sg:Merge(dsg)
			d=1
		end
		if b2 and Duel.SelectYesNo(tp,aux.Stringid(74500702,1)) then
			local rsg=Duel.SelectReleaseGroup(tp,c74500702.rfilter,1,1,nil,tp)
			sg:Merge(rsg)
			r=1
		end
		if b3 and Duel.SelectYesNo(tp,aux.Stringid(74500702,2)) then
			local esg=Duel.SelectReleaseGroup(tp,c74500702.exfilter,1,1,nil,tp)
			sg:Merge(esg)
			ex=1
		end
	until sg:GetCount()>0
		Duel.Release(sg,REASON_EFFECT)
		Duel.BreakEffect()
	--dual
	if d==1 then
		local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
		for tc in aux.Next(g) do
			if tc:IsType(TYPE_MONSTER) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1:SetCode(EFFECT_UNRELEASABLE_NONSUM)
				e1:SetRange(LOCATION_MZONE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e1:SetValue(1)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
				e2:SetValue(c74500702.fuslimit)
				tc:RegisterEffect(e2)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
				tc:RegisterEffect(e3)
				local e4=e1:Clone()
				e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
				tc:RegisterEffect(e4)
				local e5=e1:Clone()
				e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				tc:RegisterEffect(e5)
			end
		end
	end
	--ritual
	if r==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil,tp)
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
	--extra
	if ex==1 then
		local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end
function c74500702.fuslimit(e,c,st)
	return st==SUMMON_TYPE_FUSION
end
