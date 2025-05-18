--#花散满地六出花
function c28319111.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c28319111.condition)
	e0:SetDescription(aux.Stringid(28319111,4))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c28319111.target)
	e1:SetOperation(c28319111.activate)
	c:RegisterEffect(e1)
	--grave copy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28319111.tdcon)
	e2:SetCost(c28319111.tdcost)
	e2:SetTarget(c28319111.tdtg)
	e2:SetOperation(c28319111.tdop)
	c:RegisterEffect(e2)
end
function c28319111.condition(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c28319111.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_DECK)
end
function c28319111.ccfilter(c)
	return bit.band(c:GetType(),0x7)
end
function c28319111.fselect(g)
	return g:GetClassCount(c28319111.ccfilter)==g:GetCount()
end
function c28319111.deckfilter(c)
	return c:IsSetCard(0x287) and c:IsAbleToGrave()
end
function c28319111.activate(e,tp,eg,ep,ev,re,r,rp,op)
	local g=Duel.GetMatchingGroup(c28319111.deckfilter,tp,LOCATION_DECK,0,nil)
	local b1=true
	local b2=g:CheckSubGroup(c28319111.fselect,1,1)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(28319111,0)},
		{b2,aux.Stringid(28319111,1)})
	if op==1 then
		Duel.Recover(tp,1000,REASON_EFFECT)
		if Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(28319111,2)) then
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:SelectSubGroup(tp,c28319111.fselect,false,1,3)
		if Duel.SendtoGrave(sg,REASON_EFFECT)==0 then return end
		Duel.BreakEffect()
		Duel.Recover(tp,500,REASON_EFFECT)
		if Duel.GetLP(tp)>=1500 then
			local tc=sg:Filter(Card.IsType,nil,TYPE_MONSTER):GetFirst()
			local te=tc.recover_effect
			if not te then return end
			local tg=te:GetTarget()
			if tg and tg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(28319111,3)) then
				Duel.BreakEffect()
				Duel.PayLPCost(tp,1500)
				local op=te:GetOperation()
				if op then op(e,tp,eg,ep,ev,re,r,rp) end
			end
		end
	end
end
function c28319111.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_ONFIELD)~=0 and rp==tp and rc and rc:IsSetCard(0x287)
end
function c28319111.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function c28319111.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c28319111.tdop(e,tp,eg,ep,ev,re,r,rp)
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
