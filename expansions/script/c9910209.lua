--天空漫步者 日向晶也
function c9910209.initial_effect(c)
	--spsummon & draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c9910209.sptg)
	e1:SetOperation(c9910209.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,9910209)
	e2:SetCondition(c9910209.thcon)
	e2:SetCost(c9910209.thcost)
	e2:SetTarget(c9910209.thtg)
	e2:SetOperation(c9910209.thop)
	c:RegisterEffect(e2)
end
function c9910209.filter(c,e,tp)
	return c:IsRace(RACE_PSYCHO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910209.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsLinkState,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local num=math.floor(ct/2)
	if chk==0 then return (Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c9910209.filter,tp,LOCATION_HAND,0,1,nil,e,tp))
		or (num>0 and Duel.IsPlayerCanDraw(tp,num)) end
end
function c9910209.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(Card.IsLinkState,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local num1=math.floor(ct1/2)
	local b1=Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c9910209.filter,tp,LOCATION_HAND,0,1,nil,e,tp)
	local b2=num1>0 and Duel.IsPlayerCanDraw(tp,num1)
	local res=false
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(9910209,0))) then
		res=true
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910209.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local ct2=Duel.GetMatchingGroupCount(Card.IsLinkState,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local num2=math.floor(ct2/2)
	if num2>0 and Duel.IsPlayerCanDraw(tp,num2) and (not res or Duel.SelectYesNo(tp,aux.Stringid(9910209,1))) then
		if res then Duel.BreakEffect() end
		Duel.Draw(tp,num2,REASON_EFFECT)
	end
end
function c9910209.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(c)
end
function c9910209.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.HintSelection(Group.FromCards(c))
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c9910209.thfilter(c)
	return c:IsSetCard(0x6956) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9910209.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910209.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910209.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910209.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
