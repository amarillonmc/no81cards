--不变的牵绊
function c75010021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75010021+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c75010021.target)
	e1:SetOperation(c75010021.activate)
	c:RegisterEffect(e1)
	--lv
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c75010021.lvtg)
	e2:SetOperation(c75010021.lvop)
	c:RegisterEffect(e2)
end
function c75010021.cfilter(c,op)
	return c:IsLevel(3) and c:IsRace(RACE_PYRO) and c:IsAttribute(ATTRIBUTE_FIRE)
		and (op~=2 and c:IsAbleToHand() or op~=1 and c:IsAbleToGrave())
end
function c75010021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c75010021.cfilter,tp,LOCATION_DECK,0,nil,3)
	if chk==0 then return g:CheckSubGroup(aux.gffcheck,2,2,c75010021.cfilter,1,c75010021.cfilter,2) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c75010021.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c75010021.cfilter,tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
	if not tc then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	tc=Duel.SelectMatchingCard(tp,c75010021.cfilter,tp,LOCATION_DECK,0,1,1,nil,2):GetFirst()
	if tc then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c75010021.lvfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_RITUAL) and not c:IsPublic()
end
function c75010021.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75010021.lvfilter,tp,LOCATION_HAND,0,1,nil) end
end
function c75010021.lvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75010021,0))
	local g=Duel.SelectMatchingCard(tp,c75010021.lvfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		g:GetFirst():RegisterEffect(e1)
	end
end
