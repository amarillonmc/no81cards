--因帕克危机
function c29065617.initial_effect(c)
	aux.AddCodeList(c,29065619)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c29065617.condition)
	e1:SetTarget(c29065617.target)
	e1:SetOperation(c29065617.activate)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCost(c29065617.drcost)
	e2:SetTarget(c29065617.drtg)
	e2:SetOperation(c29065617.drop)
	c:RegisterEffect(e2)
	--inactivatable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetValue(c29065617.effectfilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetRange(LOCATION_FZONE)
	e4:SetValue(c29065617.effectfilter)
	c:RegisterEffect(e4)
end
function c29065617.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_MAIN1
		and (not Duel.CheckPhaseActivity() or Duel.GetFlagEffect(tp,15248873)>0)
end
function c29065617.rmfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToRemove()
end
function c29065617.tdfilter(c)
	return c:IsCode(29065619) and (c:IsAbleToDeck() or c:IsLocation(LOCATION_DECK))
end
function c29065617.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065617.rmfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c29065617.tdfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c29065617.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c29065617.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()==0 or Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)==0 then return end
	local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c29065617.tdfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g2:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.HintSelection(g2)
		if tc:IsLocation(LOCATION_DECK) then
			Duel.MoveSequence(tc,0)
		else
			Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		end
		if tc:IsLocation(LOCATION_DECK) then
			Duel.ConfirmDecktop(tp,1)
		end
	end
end
function c29065617.cfilter(c)
	return (c:IsRace(RACE_FIEND) or aux.IsCodeListed(c,29065619)) and c:IsAbleToDeckAsCost()
		and c:IsFaceup()
end
function c29065617.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065617.cfilter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c29065617.cfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,0,REASON_COST)
	Duel.SortDecktop(tp,tp,3)
	for i=1,3 do
		local mg=Duel.GetDecktopGroup(tp,1)
		Duel.MoveSequence(mg:GetFirst(),1)
	end
end
function c29065617.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c29065617.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c29065617.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	return p==tp and tc:IsRace(RACE_FIEND) and bit.band(loc,LOCATION_REMOVED)~=0
end
