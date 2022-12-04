--混沌二气
local m=30005205
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e12:SetCondition(cm.handcon)
	c:RegisterEffect(e12)
	--Effect 2  
	local e32=Effect.CreateEffect(c)
	e32:SetDescription(aux.Stringid(m,0))
	e32:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e32:SetType(EFFECT_TYPE_QUICK_O)
	e32:SetCode(EVENT_FREE_CHAIN)
	e32:SetRange(LOCATION_GRAVE)
	e32:SetTarget(cm.tg)
	e32:SetOperation(cm.op)
	c:RegisterEffect(e32)
end
--Effect 1
function cm.at(c,attr)
	return c:IsFaceup() and c:IsAttribute(attr)
end
function cm.handcon(e)
	local tp=e:GetHandlerPlayer()
	local g1=Duel.GetMatchingGroup(cm.at,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ATTRIBUTE_LIGHT)
	local g2=Duel.GetMatchingGroup(cm.at,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ATTRIBUTE_DARK)
	return #g1>0 and #g2>0
end
function cm.f(c)
	return c:IsAbleToDeck() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) 
end
function cm.f1(c,e,tp,g)
	local b1=c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)
	local b2=c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
	local b3=c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	return #g>0 and Duel.GetMZoneCount(tp,g)>0 and b1 and b2 and b3
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(cm.f,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(cm.f,tp,0,LOCATION_MZONE,nil)
	local g3=Duel.GetMatchingGroup(cm.f1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,g1)
	local g4=Duel.GetMatchingGroup(cm.f1,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil,e,1-tp,g2)
	local b1=#g3>0 and #g2==0
	local b2=#g4>0 and #g1==0
	local b3=#g3>0 and #g4>0
	if chk==0 then return b1 or b2 or b3 end
	if b1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	end
	if b2 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_GRAVE+LOCATION_REMOVED)
	end
	Group.Merge(g1,g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,#g1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(cm.f,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(cm.f,tp,0,LOCATION_MZONE,nil)
	local g3=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.f1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,g1)
	local g4=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.f1),tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil,e,1-tp,g2)
	local b1=#g3>0 and #g2==0
	local b2=#g4>0 and #g1==0
	local b3=#g3>0 and #g4>0
	if b1 or b2 or b3 then
		local g3=g1+g2
		--Debug.Message(#g3)
		if Duel.SendtoDeck(g3,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return false end
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if #og==0 then return end
		local tg1=og:Filter(Card.IsControler,nil,tp)
		local tg2=og:Filter(Card.IsControler,nil,1-tp)
		local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		if #tg1>0 then
			local ct=#tg1
			if #tg1>=ft1 then ct=ft1 end
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.f1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ct,nil,e,tp,tg1)
			if #sg==0 then return end
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
		if #tg2>0 then
			local ct=#tg2
			if #tg2>=ft2 then ct=ft2 end
			if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ct=1 end
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(1-tp,aux.NecroValleyFilter(cm.f1),tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,ct,nil,e,1-tp,tg2)
			if #sg==0 then return end
			Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end
--Effect 2
function cm.tf(c)
	return c:IsAbleToHand() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	local g1=Duel.GetMatchingGroup(cm.tf,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(cm.tf,tp,0,LOCATION_GRAVE,nil)
	local b1=ec:GetFlagEffect(m)==0 and ec:IsAbleToDeck()
	local b2=#g1>0 and #g2>0
	if chk==0 then return b1 and b2 end
	ec:RegisterFlagEffect(m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,ec,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0) 
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.tf),tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.tf),tp,0,LOCATION_GRAVE,nil)
	if #g1==0 or #g2==0 or not c:IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) and c:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g1:Select(tp,1,1,nil):GetFirst()
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)==0 then return end
		Duel.ConfirmCards(1-tp,tc)
		if tc and tc:IsLocation(LOCATION_HAND) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
			local tcc=g2:Select(1-tp,1,1,nil):GetFirst()
			if Duel.SendtoHand(tcc,nil,REASON_EFFECT)==0 then return end
			Duel.ConfirmCards(tp,tcc)
		end
	end
end