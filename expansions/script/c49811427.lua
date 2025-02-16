--リチュア・プロフェット
function c49811427.initial_effect(c)
	--ritual level
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_RITUAL_LEVEL)
	e0:SetValue(c49811427.rlevel)
	c:RegisterEffect(e0)
	--announce
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72403299,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c49811427.cost)
	e1:SetTarget(c49811427.target)
	e1:SetOperation(c49811427.operation)
	c:RegisterEffect(e1)
end
function c49811427.rlevel(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	if c:IsAttribute(ATTRIBUTE_WATER) then
		local clv=c:GetLevel()
		return (lv<<16)+clv
	else return lv end
end
function c49811427.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKBOTTOM,REASON_COST)
end
function c49811427.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c49811427.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3a) and c:IsAbleToHand()
end
function c49811427.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc:IsCode(ac) and tc:IsAbleToGrave() then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(tc,nil,REASON_EFFECT) 
		if tc:GetLocation()==LOCATION_GRAVE and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c49811427.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(49811427,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local dc=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
			if Duel.SendtoDeck(dc,tp,SEQ_DECKSHUFFLE,REASON_EFFECT) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local thc=Duel.SelectMatchingCard(tp,c49811427.thfilter,tp,LOCATION_DECK,0,1,1,nil)
				if Duel.SendtoHand(thc,tp,REASON_EFFECT) then
					Duel.ConfirmCards(1-tp,thc)
					Duel.ShuffleHand(tp)
				end
			end
		end
	else
		Duel.MoveSequence(tc,SEQ_DECKBOTTOM)	
	end
end