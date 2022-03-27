--洞察的欧妮塞瑞
function c9910875.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910875)
	e1:SetCondition(c9910875.spcon)
	e1:SetTarget(c9910875.sptg)
	e1:SetOperation(c9910875.spop)
	c:RegisterEffect(e1)
	--turn set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910876)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9910875.poscon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910875.postg)
	e2:SetOperation(c9910875.posop)
	c:RegisterEffect(e2)
end
function c9910875.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local sg=g:Filter(Card.IsFaceup,nil)
	return sg and sg:GetClassCount(Card.GetRace)>=2
end
function c9910875.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910875.thfilter(c,e,tp)
	return aux.IsCodeListed(c,9910871) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910875.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g=Duel.GetMatchingGroup(c9910875.thfilter,tp,LOCATION_DECK,0,nil)
	if Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910875,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c9910875.cfilter2(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsRace(RACE_WINDBEAST)
end
function c9910875.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
		and Duel.IsExistingMatchingCard(c9910875.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c9910875.posfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsFaceup() and c:IsCanTurnSet()
end
function c9910875.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(c9910875.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c9910875.posfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c9910875.posop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil,REASON_EFFECT)==0 then return end
	local g=Duel.GetMatchingGroup(c9910875.posfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
