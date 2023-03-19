--导引的翠玉碑使
function c67200791.initial_effect(c)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200791,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,67200791)
	e1:SetCondition(c67200791.chcon)
	e1:SetTarget(c67200791.chtg)
	e1:SetOperation(c67200791.chop)
	c:RegisterEffect(e1)
	--xue shou
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200791,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,67200792)
	e2:SetCost(c67200791.kkskcost)
	e2:SetTarget(c67200791.kksktg)
	e2:SetOperation(c67200791.kkskop)
	c:RegisterEffect(e2)	
end
function c67200791.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_SEARCH) or re:IsHasCategory(CATEGORY_DRAW) 
end
function c67200791.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsPlayerCanDraw(1-tp,1) end
end
function c67200791.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c67200791.repop)
end
function c67200791.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
--
function c67200791.spfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x67c) and c:IsReleasable()
end
function c67200791.kkskcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c67200791.spfilter1,tp,LOCATION_ONFIELD,0,1,c) end
	local g=Duel.SelectMatchingCard(tp,c67200791.spfilter1,tp,LOCATION_ONFIELD,0,1,1,c)
	g:AddCard(c)
	Duel.Release(g,REASON_COST)
end
function c67200791.kksktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c67200791.kkskop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local g1=Duel.GetOperatedGroup()
		if g1:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(1-tp) end
		local ct=g1:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct==1 then
			Duel.BreakEffect()
			Duel.Draw(1-tp,1,REASON_EFFECT)
			Duel.ShuffleHand(1-tp)
		end
	end
end

