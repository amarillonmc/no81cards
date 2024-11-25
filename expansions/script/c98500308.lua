--三幻神之力2
function c98500308.initial_effect(c)
	aux.AddCodeList(c,10000000)
	aux.AddCodeList(c,10000010)
	aux.AddCodeList(c,10000020)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Trap activate in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetCountLimit(1,98500308)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98500308,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,98510309)
	e3:SetTarget(c98500308.target)
	e3:SetOperation(c98500308.activate)
	c:RegisterEffect(e3)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98500308,1))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,98510319)
	e4:SetTarget(c98500308.tdtg)
	e4:SetOperation(c98500308.tdop)
	c:RegisterEffect(e4)
end
function c98500308.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function c98500308.filter(c)
	return (aux.IsCodeListed(c,10000000) or aux.IsCodeListed(c,10000010) or aux.IsCodeListed(c,10000020) or c:IsCode(5253985,7373632,59094601,39913299,79339613,42469671,85758066,85182315,79868386,32247099,269012,10000000,10000010,10000020)) and c:IsAbleToHand()
end
function c98500308.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DIVINE) and c:IsAbleToGrave()
end
function c98500308.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<4 then return end
	local g=Duel.GetDecktopGroup(tp,4)
	Duel.ConfirmCards(tp,g)
	if g:IsExists(c98500308.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(98500308,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c98500308.filter,1,1,nil)
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.SortDecktop(tp,tp,3)
	else Duel.SortDecktop(tp,tp,4) end
	Duel.BreakEffect()
	local op=0
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	if #g>=1 and Duel.IsExistingMatchingCard(c98500308.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		op=Duel.SelectOption(tp,aux.Stringid(98500308,3),aux.Stringid(98500308,4))
	elseif #g>=1 then
		op=Duel.SelectOption(tp,aux.Stringid(98500308,3))
	else
		op=Duel.SelectOption(tp,aux.Stringid(98500308,4))+1
	end 
	if op==0 then
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,c98500308.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		if #sg>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
function c98500308.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c98500308.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c98500308.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c98500308.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c98500308.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<1 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) and Duel.CheckReleaseGroup(tp,Card.IsRace,1,nil,RACE_DIVINE) and Duel.SelectYesNo(tp,aux.Stringid(98500308,5)) then 
		Duel.BreakEffect()
		local rg=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,nil,RACE_DIVINE)
		Duel.Release(rg,REASON_COST)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
