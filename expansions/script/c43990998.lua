--默墟天使 ·时光
function c43990998.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)--CATEGORY_DAMAGE
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,43990998)
	e1:SetCost(c43990998.thcost)
	e1:SetTarget(c43990998.thtg)
	e1:SetOperation(c43990998.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetDescription(aux.Stringid(43990998,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCondition(c43990998.sccon)
	e2:SetTarget(c43990998.sctg)
	e2:SetOperation(c43990998.scop)
	c:RegisterEffect(e2)
end
function c43990998.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c43990998.thfilter(c,chk)
	return c:IsSetCard(0x9510) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c43990998.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990998.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c43990998.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c43990998.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,1):GetFirst()
	if not tc then return end
	--Duel.HintSelection(Group.FromCards(tc))
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	if not tc:IsLocation(LOCATION_HAND) then return end
	local ct=Duel.GetCurrentChain()
	if ct<=1 then return end
	local c=e:GetHandler()
	local code=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_CODE)
	if code==43990995 and Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(43990998,2)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c43990998.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c43990998.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c43990998.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	end
end
