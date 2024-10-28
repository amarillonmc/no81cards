--101号校车
function c98930409.initial_effect(c)
	aux.AddCodeList(c,98930409)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98930409,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98930409)
	e1:SetCost(c98930409.spcost)
	e1:SetTarget(c98930409.sptg)
	e1:SetOperation(c98930409.spop)
	c:RegisterEffect(e1)	
end
function c98930409.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98930409.stfilter(c,e,tp)
	return c:IsCode(98930403) and not c:IsForbidden()
end
function c98930409.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98930409.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c98930409.drtgfilter(c)
	return c:IsAbleToDeck() and (c:IsCode(98930401) or (aux.IsCodeListed(c,98930401) and c:IsType(TYPE_TRAP)))
end
function c98930409.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c98930409.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		if Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) and Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c98930409.drtgfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(98930409,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,c98930409.drtgfilter,tp,LOCATION_HAND,0,1,1,nil)
			local tc=g:GetFirst()
			if tc then
			   Duel.ConfirmCards(1-tp,tc)
			   if Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
				   Duel.Draw(tp,1,REASON_EFFECT)
			   end
			end
		end
	end
end