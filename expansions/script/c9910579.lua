--混合咖啡的友爱调制
function c9910579.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
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
	if chk==0 then return Duel.IsExistingMatchingCard(c9910579.chfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c9910579.chfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c9910579.setfilter(c,e,tp)
	if c:IsType(TYPE_MONSTER) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	else return c:IsSSetable() end
end
function c9910579.gselect(g,ct,ft1,ft2,flag)
	local mct=g:FilterCount(Card.IsType,nil,TYPE_MONSTER)
	local fct=g:FilterCount(Card.IsType,nil,TYPE_FIELD)
	local sct=g:FilterCount(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)-fct
	local b1=mct<=ft1 and fct<=1 and sct<=ft2 and #g==ct
	local b2=mct==ft1 and sct==ft2
	if flag then b2=b2 and fct==1 end
	return b1 or b2
end
function c9910579.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910579.chfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
		local og=Duel.GetOperatedGroup():Filter(Card.IsPosition,nil,POS_FACEUP_DEFENSE)
		local g2=Duel.GetMatchingGroup(c9910579.setfilter,1-tp,LOCATION_HAND,0,nil,e,1-tp)
		local ct=math.min(#og,#g2)
		if ct<=0 then return end
		local ft1=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		if ft1>1 and Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ft1=1 end
		local ft2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
		local flag=g2:IsExists(Card.IsType,1,nil,TYPE_FIELD)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
		local sg=g2:SelectSubGroup(1-tp,c9910579.gselect,false,1,#g2,ct,ft1,ft2,flag)
		local sg1=sg:Filter(Card.IsType,nil,TYPE_MONSTER)
		if #sg1>0 then Duel.SpecialSummon(sg1,0,1-tp,1-tp,false,false,POS_FACEDOWN_DEFENSE) end
		local sg2=sg:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
		if #sg2>0 then Duel.SSet(1-tp,sg2,1-tp) end
		local tg=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
		if #tg<=0 then return end
		Duel.BreakEffect()
		Duel.ConfirmCards(tp,tg)
		local dct=Group.__band(sg,tg):GetCount()
		if dct>0 then
			Duel.Draw(tp,dct,REASON_EFFECT)
			Duel.Draw(1-tp,dct,REASON_EFFECT)
		end
	end
end
