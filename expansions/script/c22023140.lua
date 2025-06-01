--人理之基 玛丽·安宁
function c22023140.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023140,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22023140)
	e1:SetCondition(c22023140.spcon1)
	e1:SetTarget(c22023140.sptg1)
	e1:SetOperation(c22023140.spop1)
	c:RegisterEffect(e1)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023140,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22023141)
	e3:SetCost(c22023140.tdcost)
	e3:SetTarget(c22023140.tdtg)
	e3:SetOperation(c22023140.tdop)
	c:RegisterEffect(e3)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023140,3))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22023141)
	e2:SetCondition(c22023140.erescon)
	e2:SetCost(c22023140.tdcost1)
	e2:SetTarget(c22023140.tdtg)
	e2:SetOperation(c22023140.tdop)
	c:RegisterEffect(e2)
end
c22023140.effect_with_darkguda=true
function c22023140.erescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22023140.cfilter(c)
	return c:IsFaceup() and c:IsCode(22020000) and c:GetOriginalAttribute()==ATTRIBUTE_DARK 
end
function c22023140.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22023140.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22023140.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22023140.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c22023140.tdfilter(c)
	return c:IsAbleToDeckAsCost()
end
function c22023140.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023140.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local num=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)
	if num>6 then
		local num=6
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c22023140.tdfilter,tp,LOCATION_GRAVE,0,1,num,nil)
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
		local ct=g:GetCount()
		e:SetLabel(ct)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c22023140.tdfilter,tp,LOCATION_GRAVE,0,1,num,nil)
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
		local ct=g:GetCount()
		e:SetLabel(ct)
	end
end
function c22023140.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct end
	Duel.SelectOption(tp,aux.Stringid(22023140,4))
end
function c22023140.thfilter(c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c22023140.spfilter(c,e,tp)
	return c:IsSetCard(0xff1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22023140.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return end
	local g=Duel.GetDecktopGroup(tp,ct)
	Duel.ConfirmCards(tp,g)
	if g:IsExists(c22023140.thfilter,1,nil) and g:IsExists(c22023140.spfilter,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(22023140,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c22023140.thfilter,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g:FilterSelect(tp,c22023140.spfilter,1,1,sg,e,tp)
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.SortDecktop(tp,tp,ct-2)
		for i=1,ct-2 do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	else
		Duel.SortDecktop(tp,tp,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end
function c22023140.tdcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023140.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local num=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)
	if num>6 then
		local num=6
		Duel.Hint(HINT_CARD,0,22020980)
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c22023140.tdfilter,tp,LOCATION_GRAVE,0,1,num,nil)
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
		local ct=g:GetCount()
		e:SetLabel(ct)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c22023140.tdfilter,tp,LOCATION_GRAVE,0,1,num,nil)
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
		local ct=g:GetCount()
		e:SetLabel(ct)
	end
end