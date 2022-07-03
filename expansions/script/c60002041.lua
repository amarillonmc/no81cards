--Re:SURGUM 往昔的残骸
local m=60002041
local cm=_G["c"..m]
cm.name="Re:SURGUM 往昔的残骸"
function cm.initial_effect(c)
	--sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_DECK)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
end
function cm.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsPlayerCanDiscardDeck(tp,10)
		and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,10)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_GRAVE)
			and Duel.IsPlayerCanDiscardDeck(tp,1) then
			Duel.BreakEffect()
			Duel.DiscardDeck(tp,10,REASON_EFFECT)
		end
	end
end