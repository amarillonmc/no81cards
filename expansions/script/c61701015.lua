--巨目
function c61701015.initial_effect(c)
	aux.AddCodeList(c,61701001)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(61701015,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c61701015.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,61701015)
	e1:SetTarget(c61701015.target)
	e1:SetOperation(c61701015.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,61701016)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c61701015.tdtg)
	e2:SetOperation(c61701015.tdop)
	c:RegisterEffect(e2)
	--public
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PUBLIC)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c61701015.limcon)
	e3:SetTargetRange(0,LOCATION_HAND)
	c:RegisterEffect(e3)
	--summon limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c61701015.limcon)
	e4:SetTarget(c61701015.splimit)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetValue(c61701015.elimit)
	c:RegisterEffect(e6)
end
function c61701015.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
function c61701015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
		and Duel.GetDecktopGroup(tp,5):IsExists(Card.IsAbleToHand,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c61701015.thfilter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c61701015.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if #g>0 and g:IsExists(c61701015.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(61701015,1)) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		g:Sub(sg)
	end
	if g:GetCount()>0 then
		Duel.SortDecktop(tp,tp,g:GetCount())
		for i=1,g:GetCount() do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end
function c61701015.tdfilter(c)
	return not c:IsCode(61701015) and c:IsAbleToDeck()
end
function c61701015.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c61701015.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,5,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c61701015.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c61701015.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,5,nil)
	if #g~=5 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	if og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)==5 then Duel.Draw(tp,1,REASON_EFFECT) end
end
function c61701015.limcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsCode(61701001) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c61701015.splimit(e,c)
	local g=Duel.GetMatchingGroup(Card.IsAttackAbove,e:GetHandlerPlayer(),0,LOCATION_HAND,nil,0)
	if g:GetCount()==0 then return false end
	return g:GetMaxGroup(Card.GetAttack):IsContains(c)
end
function c61701015.elimit(e,re,tp)
	if not re:IsActiveType(TYPE_MONSTER) then return false end
	local g=Duel.GetMatchingGroup(Card.IsAttackAbove,e:GetHandlerPlayer(),0,LOCATION_HAND,nil,0)
	if g:GetCount()==0 then return false end
	return g:GetMaxGroup(Card.GetAttack):IsContains(re:GetHandler())
end
