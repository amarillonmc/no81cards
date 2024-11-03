--#成为主角六出花
function c28318460.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c28318460.condition)
	e0:SetDescription(aux.Stringid(28318460,4))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c28318460.target)
	e1:SetOperation(c28318460.activate)
	c:RegisterEffect(e1)
	--grave copy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28318460.tdcon)
	e2:SetTarget(c28318460.tdtg)
	e2:SetOperation(c28318460.tdop)
	c:RegisterEffect(e2)
end
function c28318460.condition(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c28318460.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28318460.thfilter(c)
	return c:IsSetCard(0x287) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28318460.activate(e,tp,eg,ep,ev,re,r,rp,op)
	local b1=true
	local b2=Duel.IsExistingMatchingCard(c28318460.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(28318460,0)},
		{b2,aux.Stringid(28318460,1)})
	if op==1 then
		Duel.Recover(tp,1000,REASON_EFFECT)
		if Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(28318460,2)) then
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28318460.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
		if tc then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			if tc:IsPreviousLocation(LOCATION_DECK) then
				Duel.ShuffleDeck(tp)
			end
			if not tc:IsLocation(LOCATION_HAND) or Duel.GetLP(tp)<10000 then return end
			local te=tc.recover_effect
			if not te then return end
			local tg=te:GetTarget()
			if tg and tg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(28318460,3)) then
				Duel.BreakEffect()
				local lp=Duel.GetLP(tp)
				Duel.SetLP(tp,lp-1000)
				local op=te:GetOperation()
				if op then op(e,tp,eg,ep,ev,re,r,rp) end
			end
		end
	end
end
function c28318460.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_ONFIELD)~=0 and rp==tp and rc and rc:IsSetCard(0x287)
end
function c28318460.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c28318460.tdop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp-1500)
	local te,ceg,cep,cev,cre,cr,crp=e:GetHandler():CheckActivateEffect(false,true,true)
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsAbleToDeck() then
		Duel.BreakEffect()
		Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
