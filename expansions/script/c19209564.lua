--Undercover
function c19209564.initial_effect(c)
	aux.AddCodeList(c,19209511)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19209564)
	e1:SetTarget(c19209564.target)
	e1:SetOperation(c19209564.activate)
	c:RegisterEffect(e1)
	--kksk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,19209565)
	e2:SetCondition(c19209564.chkcon)
	e2:SetCost(c19209564.chkcost)
	e2:SetTarget(c19209564.chktg)
	e2:SetOperation(c19209564.chkop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(19209564,ACTIVITY_CHAIN,aux.FilterBoolFunction(aux.NOT(Effect.IsActiveType),TYPE_MONSTER))
end
function c19209564.thfilter(c)
	return c:IsSetCard(0x3b50) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c19209564.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209564.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c19209564.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c19209564.thfilter,tp,LOCATION_DECK,0,1,nil) then return end
	local g=Duel.GetMatchingGroup(c19209564.thfilter,tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local seq=-1
	local sc=nil
	for tc in aux.Next(g) do
		if tc:GetSequence()>seq then
			seq=tc:GetSequence()
			sc=tc
		end
	end
	if seq==-1 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	Duel.DisableShuffleCheck(true)
	Duel.SendtoHand(sc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sc)
	if sc:IsLocation(LOCATION_HAND) and Duel.GetCustomActivityCount(19209564,1-tp,ACTIVITY_CHAIN)~=0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(19209564,0)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c19209564.chkfilter(c)
	return c:IsCode(19209511) and c:IsFaceup()
end
function c19209564.chkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19209564.chkfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c19209564.chkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c19209564.chktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function c19209564.chkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if ct==0 then return end
	local ac=1
	if ct>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19209564,1))
		ac=Duel.AnnounceNumber(tp,1,2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,ac)
	Duel.ConfirmCards(tp,g)
end
