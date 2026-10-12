--象征世界的裁判者
function c43990949.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,43990949)
	e1:SetCondition(c43990949.sumcon)
	e1:SetCost(c43990949.tdcost)
	e1:SetTarget(c43990949.tdtg)
	e1:SetOperation(c43990949.tdop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c43990949.effcon)
	c:RegisterEffect(e3)
	--salvage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,43990949+1000)
	e4:SetOperation(c43990949.regop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
end
function c43990949.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (#eg==1 and not eg:IsContains(c)) and (c:IsOnField() or Duel.IsPlayerAffectedByEffect(tp,43990948)~=nil and c:IsOriginalSetCard(0x7a10) and c:IsSummonableCard())
end
function c43990949.effcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:GetHandler()~=c and (c:IsOnField() or Duel.IsPlayerAffectedByEffect(tp,43990948)~=nil and c:IsOriginalSetCard(0x7a10) and c:IsSummonableCard())
end
function c43990949.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c43990949.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (e:GetCode()~=EVENT_CHAINING or eg:GetFirst():IsRelateToEffect(re)) and eg:GetFirst():IsAbleToDeck() end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
end
function c43990949.thfilter(c,chk)
	return c:IsSetCard(0x7a10) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))-- and c:IsFaceupEx() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c43990949.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToChain() or Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	local og=Duel.GetOperatedGroup()
	if og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)==0 or og:FilterCount(Card.IsControler,nil,tp)==0 then return end
	if Duel.IsExistingMatchingCard(c43990949.thfilter,tp,LOCATION_DECK,0,1,nil,0) and Duel.SelectYesNo(tp,aux.Stringid(43990949,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c43990949.thfilter,tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c43990949.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c43990949.spcon)
	e1:SetOperation(c43990949.spop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,tp)
end
function c43990949.spfilter(c,e,tp)
	return c:IsCode(43990949) and (c:IsAbleToHand() or Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) and aux.NecroValleyFilter()(c) and c:IsFaceupEx()
end
function c43990949.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c43990949.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,43990949)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c43990949.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	if not sc then return end
	if sc:IsAbleToHand() and (not sc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetMZoneCount(tp)<=0 or Duel.SelectOption(tp,1190,1152)==0) then
		Duel.SendtoHand(sc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sc)
	else
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
