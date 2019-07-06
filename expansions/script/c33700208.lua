--Heavenly Maid : Secret Whisper
function c33700208.initial_effect(c)
	--Return 3 "Heavenly Maid" cards from your GY to your deck, if you do, Draw 1 card. And if it's a "Heavenly Maid" monster, you can Special Summon it. If this card is activated in your opponent's turn, you can draw 1 more card. You can only activate 1 "Heavenly Maid : Secret Whisper" per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33700208)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetTarget(c33700208.tg)
	e1:SetOperation(c33700208.op)
	c:RegisterEffect(e1)
end
function c33700208.filter(c)
	return c:IsSetCard(0x444) and c:IsAbleToDeck()
end
function c33700208.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700208.filter,tp,LOCATION_GRAVE,0,3,nil)
		and Duel.IsPlayerCanDraw(tp,1) end
	local g=Duel.GetMatchingGroup(c33700208.filter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33700208.spfilter(c,e,tp)
	return c:IsSetCard(0x444) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700208.op(e,tp,eg,ep,ev,re,r,rp)
	--Return 3 "Heavenly Maid" cards from your GY to your deck,
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c33700208.filter,tp,LOCATION_GRAVE,0,3,3,nil)
	if g:GetCount()==3 then
		Duel.HintSelection(g)
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)<3 or g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)<3 then return end
		--if you do, Draw 1 card. If this card is activated in your opponent's turn, you can draw 1 more card.
		local d=1
		if Duel.GetTurnPlayer()==1-tp then d=d+1 end
		Duel.Draw(tp,d,REASON_EFFECT)
		local dg=Duel.GetOperatedGroup():Filter(Card.IsLocation,tp,LOCATION_HAND)
		--And if it's a "Heavenly Maid" monster, you can Special Summon it.
		local sg=dg:Filter(c33700208.spfilter,nil,e,tp)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,2) then
			if sg:GetCount()>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				sg=sg:Select(tp,1,1,nil)
			end
			Duel.ConfirmCards(1-tp,sg)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
