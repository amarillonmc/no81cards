--混合咖啡的友爱调制
function c9910579.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910579+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9910579.cost)
	e1:SetTarget(c9910579.target)
	e1:SetOperation(c9910579.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9910579,ACTIVITY_CHAIN,c9910579.chainfilter)
end
function c9910579.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not (re:IsActiveType(TYPE_MONSTER) and not rc:IsLocation(LOCATION_MZONE)
		and not rc:IsSummonableCard())
end
function c9910579.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(9910579,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(c9910579.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910579.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsLocation(LOCATION_MZONE)
		and not rc:IsSummonableCard()
end
function c9910579.chfilter(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function c9910579.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g1+#g2>0 end
	local s=0
	if #g1>0 and #g2==0 then
		s=Duel.SelectOption(tp,aux.Stringid(9910579,0))
	end
	if #g1==0 and #g2>0 then
		s=Duel.SelectOption(tp,aux.Stringid(9910579,1))+1
	end
	if #g1>0 and #g2>0 then
		s=Duel.SelectOption(tp,aux.Stringid(9910579,0),aux.Stringid(9910579,1))
	end
	e:SetLabel(s)
	if s==0 then
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g1,g1:GetCount(),0,0)
		local tep=nil
		if Duel.GetCurrentChain()>1 then tep=Duel.GetChainInfo(Duel.GetCurrentChain()-1,CHAININFO_TRIGGERING_PLAYER) end
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and tep and tep==1-tp then
			e:SetCategory(CATEGORY_POSITION+CATEGORY_TOHAND)
		end
	else
		e:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g2,g2:GetCount(),0,0)
	end
end
function c9910579.thfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FLIP) and c:IsAbleToHand()
end
function c9910579.spfilter(c,e,tp)
	return c:IsSetCard(0xc951) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9910579.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,0,nil)
	if e:GetLabel()==0 and #g1>0 and Duel.ChangePosition(g1,POS_FACEUP_DEFENSE)>0 then
		local ct=Duel.GetCurrentChain()
		if ct<2 then return end
		local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tep==1-tp and Duel.IsExistingMatchingCard(c9910579.thfilter,tep,0,LOCATION_MZONE,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(9910579,2)) then
			Duel.BreakEffect()
			local g=Group.CreateGroup()
			Duel.ChangeTargetCard(ct-1,g)
			Duel.ChangeChainOperation(ct-1,c9910579.repop)
		end
	end
	if e:GetLabel()==1 and #g2>0 and Duel.ChangePosition(g2,POS_FACEDOWN_DEFENSE)>0
		and Duel.IsExistingMatchingCard(c9910579.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(9910579,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910579.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9910579.repop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,c9910579.thfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
