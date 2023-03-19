--星夜茶会的韶光
function c9910469.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910469.target)
	e1:SetOperation(c9910469.activate)
	c:RegisterEffect(e1)
end
function c9910469.spfilter(c,e,tp)
	return c:IsSetCard(0x9950) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910469.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910469.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9910469.ctfilter(c)
	return c:GetSequence()<5 and c:IsCanAddCounter(0x1950,1)
end
function c9910469.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910469.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if not sc or Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)==0
		or sc:GetLocation()~=LOCATION_MZONE then return end
	local cg=Group.FromCards(sc)
	local g1=sc:GetColumnGroup():Filter(Card.IsCanAddCounter,aux.ExceptThisCard(e),0x1950,1)
	cg:Merge(g1)
	local g2=Duel.GetMatchingGroup(c9910469.ctfilter,tp,LOCATION_MZONE,0,nil)
	cg:Merge(g2)
	local tc=cg:GetFirst()
	while tc do
		tc:AddCounter(0x1950,1)
		tc=cg:GetNext()
	end
	if Duel.GetCounter(tp,1,1,0x1950)<5 then return end
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9910469,0))
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_SZONE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetCountLimit(1)
		e1:SetCondition(c9910469.chcon)
		e1:SetCost(c9910469.chcost)
		e1:SetTarget(c9910469.chtg)
		e1:SetOperation(c9910469.chop)
		c:RegisterEffect(e1)
	end
end
function c9910469.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c9910469.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c9910469.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(rp,1,1,0x1950,1,REASON_EFFECT)
		and Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
end
function c9910469.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c9910469.repop)
end
function c9910469.repop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.RemoveCounter(tp,1,1,0x1950,1,REASON_EFFECT) then return end
	local ct1=Duel.GetCounter(tp,1,0,0x1950)
	local ct2=Duel.GetCounter(tp,0,1,0x1950)
	if ct1>ct2 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif ct1<ct2 then
		Duel.BreakEffect()
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
