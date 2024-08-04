--魔犀族童子军
function c49811238.initial_effect(c)
	--discard deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,49811238)
	e1:SetTarget(c49811238.distg)
	e1:SetOperation(c49811238.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,49811338)
	e3:SetTarget(c49811238.tgtg)
	e3:SetOperation(c49811238.tgop)
	c:RegisterEffect(e3)
end
function c49811238.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c49811238.disfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsLocation(LOCATION_GRAVE)
end
function c49811238.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c49811238.disfilter,nil)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if ct~=0 and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(49811238,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sdg=dg:Select(tp,1,1,nil)
		Duel.Destroy(sdg,REASON_EFFECT)
	elseif ct==0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c49811238.tgfilter(c)
	return c:IsRace(RACE_FIEND) and not c:IsCode(49811238) and c:IsAbleToGrave()
end
function c49811238.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811238.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c49811238.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c49811238.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end