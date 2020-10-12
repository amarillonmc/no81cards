--罗德岛·部署-奇袭突击
function c79029321.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetTarget(c79029321.target)
	e2:SetOperation(c79029321.activate)
	c:RegisterEffect(e2)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c79029321.actop)
	e1:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,79029321)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c79029321.target1)
	e1:SetOperation(c79029321.activate1)
	c:RegisterEffect(e1)	
end
function c79029321.filter(c,e,tp,re)
	return c:GetPreviousControler()==tp and c:IsReason(REASON_COST) and c==re:GetHandler() 
end
function c79029321.thfil(c)
	return c:IsSetCard(0xa904) and c:IsAbleToHand()
end
function c79029321.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return eg:IsExists(c79029321.filter,1,nil,e,tp,re)
		and Duel.IsExistingMatchingCard(c79029321.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	tg=Duel.SelectMatchingCard(tp,c79029321.thfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,1,0,0)
end
function c79029321.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	end
end
function c79029321.actop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and  re:GetHandler():IsSetCard(0xa904) then
		Duel.SetChainLimit(c79029321.chainlm)
	end
end
function c79029321.chainlm(e,rp,tp)
	return tp==rp
end
function c79029321.txfil(c)
	return (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToDeck() and c:IsSetCard(0xa904)) or (c:IsLocation(LOCATION_DECK) and c:IsSetCard(0xa904))
end
function c79029321.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsPlayerCanDraw(tp,1) then return false end
		local g=Duel.GetMatchingGroup(c79029321.txfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		return g:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,0)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c79029321.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029321.txfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
		Duel.ConfirmCards(1-tp,sg)
		Duel.SendtoDeck(sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE),tp,2,REASON_EFFECT)
		if Duel.ShuffleDeck(tp)~=0 then
			for i=1,3 do
				local tc
				if i<3 then
					tc=sg:RandomSelect(tp,1):GetFirst()
				else
					tc=sg:GetFirst()
				end
				Duel.MoveSequence(tc,0)
				sg:RemoveCard(tc)
			end
		end
		Duel.Draw(tp,1,REASON_EFFECT)
end
end





