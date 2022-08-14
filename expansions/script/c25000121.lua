local m=25000121
local cm=_G["c"..m]
cm.name="来自光之星的使者 佐菲"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetCondition(aux.TRUE)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,e,tp)
	return c:GetOwner()==tp and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,cm.zone(c))
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,0,LOCATION_MZONE,1,nil,e,tp)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.spfilter(c,e,tp,z)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,tp,z)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,0,LOCATION_MZONE,nil,e,tp)
	if #g==0 then return end
	local zone=0
	for tc in aux.Next(g) do zone=zone|cm.zone(tc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
	if #g>0 then Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP,zone) end
end
function cm.tdfilter(c,tp)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tdfilter(chkc,tp) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) and c:IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp)
	sg:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local sg=Group.FromCards(c,tc)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct==0 then return end
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function cm.zone(c)
	local seq,z=c:GetSequence(),0
	if seq<5 then z=1<<(4-seq) elseif seq==5 then z=0x8 elseif seq==6 then z=0x2 end
	return z
end
