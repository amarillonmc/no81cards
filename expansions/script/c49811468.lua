--熔岩爆破手
function c49811468.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,49811468)
	e1:SetCost(c49811468.tgcost)
	e1:SetTarget(c49811468.tgtg)
	e1:SetOperation(c49811468.tgop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,49811469)
	e2:SetCondition(c49811468.discon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c49811468.distg)
	e2:SetOperation(c49811468.disop)
	c:RegisterEffect(e2)
end
function c49811468.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c49811468.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
		and Duel.GetDecktopGroup(tp,5):FilterCount(Card.IsAbleToGrave,nil)>0 end
end
function c49811468.tgfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToGrave()
end
function c49811468.thfilter(c)
	return c:IsSetCard(0x39) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c49811468.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local tg=g:Filter(c49811468.tgfilter,nil)
	if tg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=tg:Select(tp,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) and tc:IsSetCard(0x39) and Duel.IsExistingMatchingCard(c49811468.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(49811468,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c49811468.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c49811468.discon(e,tp,eg,ep,ev,re,r,rp)
	if ev<2 or not Duel.IsChainDisablable(ev) then return false end
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0x39) and te:IsActiveType(TYPE_SYNCHRO) and p==tp and rp==1-tp
end
function c49811468.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c49811468.sfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c49811468.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c49811468.sfilter),tp,LOCATION_GRAVE,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(49811468,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g:Select(tp,1,1,nil)
			Duel.SSet(tp,sg)
		end
	end
end
