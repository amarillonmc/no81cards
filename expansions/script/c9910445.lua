--女武神永不止步
function c9910445.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910445+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910445.target)
	e1:SetOperation(c9910445.activate)
	c:RegisterEffect(e1)
	c9910445.act_effect=e1
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,9910446)
	e2:SetTarget(c9910445.reptg)
	e2:SetValue(c9910445.repval)
	e2:SetOperation(c9910445.repop)
	c:RegisterEffect(e2)
end
function c9910445.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,e:GetHandler())
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=g:GetCount()
		and g:IsExists(Card.IsAbleToDeck,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9910445.thfilter(g)
	local g1=g:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
	local g2=g:Filter(Card.IsType,nil,TYPE_MONSTER)
	return g1:GetCount()<=1 and (g2:GetCount()==0 or g2:GetClassCount(Card.GetLevel)==g2:GetCount())
end
function c9910445.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk~=9910445 and not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	if Duel.SendtoDeck(g,nil,0,REASON_EFFECT)==0 then return end
	local og=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
	if og:IsExists(Card.IsControler,1,nil,tp) then Duel.ShuffleDeck(tp) end
	if og:IsExists(Card.IsControler,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
	local ct=og:GetCount()
	if ct<=0 or not Duel.IsPlayerCanDiscardDeck(tp,2*ct) then return end
	Duel.ConfirmDecktop(tp,2*ct)
	local dg=Duel.GetDecktopGroup(tp,2*ct)
	if dg:GetCount()==0 then return end
	Duel.DisableShuffleCheck()
	local tg=dg:Filter(Card.IsAbleToHand,nil)
	local thct=0
	local flag=true
	local g1=Group.CreateGroup()
	while tg:GetCount()>10 do
		if not Duel.SelectYesNo(tp,aux.Stringid(9910445,0)) then
			flag=false
			break
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		g1:AddCard(tc)
		local sg=Group.CreateGroup()
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) then sg=tg:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP) end
		if tc:IsType(TYPE_MONSTER) then sg=tg:Filter(Card.IsLevel,nil,tc:GetLevel()) end
		tg:Sub(sg)
	end
	if flag and tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910445,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=tg:SelectSubGroup(tp,c9910445.thfilter,false,1,tg:GetCount())
		g1:Merge(sg)
	end
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleHand(tp)
		thct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_HAND)
	end
	local g2=dg:Filter(Card.IsLocation,nil,LOCATION_DECK)
	Duel.Remove(g2,POS_FACEDOWN,REASON_EFFECT)
	if thct>=ct and Duel.GetTurnPlayer()==tp then
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910445.repfilter(c)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup()
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c9910445.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c9910445.repfilter,1,c)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c9910445.repval(e,c)
	return c9910445.repfilter(c)
end
function c9910445.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910445)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
	local te=c9910445.act_effect
	local op=te:GetOperation()
	if op and Duel.SelectYesNo(tp,aux.Stringid(9910445,1)) then
		op(e,tp,eg,ep,ev,re,r,rp,9910445)
	end
end
