--#团结友爱六出花
function c28319011.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c28319011.condition)
	e0:SetDescription(aux.Stringid(28319011,4))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c28319011.target)
	e1:SetOperation(c28319011.activate)
	c:RegisterEffect(e1)
	--grave copy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28319011.tdcon)
	e2:SetTarget(c28319011.tdtg)
	e2:SetOperation(c28319011.tdop)
	c:RegisterEffect(e2)
end
function c28319011.condition(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c28319011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c28319011.cfilter(c,oc)
	return c:IsFaceup() and c:IsCode(oc:GetCode())
end
function c28319011.spfilter(c,e,tp)
	return c:IsSetCard(0x287) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(c28319011.cfilter,tp,LOCATION_ONFIELD,0,1,nil,c)
end
function c28319011.activate(e,tp,eg,ep,ev,re,r,rp,op)
	local b1=true
	local b2=Duel.IsExistingMatchingCard(c28319011.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(28319011,0)},
		{b2,aux.Stringid(28319011,1)})
	if op==1 then
		Duel.Recover(tp,1000,REASON_EFFECT)
		if Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(28319011,2)) then
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c28319011.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) and sc:IsSummonLocation(LOCATION_GRAVE) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(28319011,5))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetValue(LOCATION_DECKBOT)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			sc:RegisterEffect(e1)
			Duel.SpecialSummonComplete()
		end
		if true then
			local te=sc.recover_effect
			if not te then return end
			local tg=te:GetTarget()
			if tg and tg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(28319011,3)) then
				Duel.BreakEffect()
				local lp=Duel.GetLP(tp)
				Duel.SetLP(tp,lp-1500)
				local op=te:GetOperation()
				if op then op(e,tp,eg,ep,ev,re,r,rp) end
			end
		end
	end
end
function c28319011.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_ONFIELD)~=0 and rp==tp and rc and rc:IsSetCard(0x287)
end
function c28319011.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c28319011.tdop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp-1500)
	local te=e:GetHandler():CheckActivateEffect(false,true,false)
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsAbleToDeck() then
		Duel.BreakEffect()
		Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
