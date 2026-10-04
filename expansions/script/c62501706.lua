--蚀痕无命 谢珐莉娅
function c62501706.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)--TIMING_END_PHASE
	e1:SetDescription(aux.Stringid(62501706,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,62501706)
	e1:SetCost(c62501706.thcost)
	e1:SetTarget(c62501706.thtg)
	e1:SetOperation(c62501706.thop)
	c:RegisterEffect(e1)
	--remove&spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)--TIMING_END_PHASE
	e2:SetDescription(aux.Stringid(62501706,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,62501706+1)
	e2:SetTarget(c62501706.sptg)
	e2:SetOperation(c62501706.spop)
	c:RegisterEffect(e2)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,62501706+2)
	e4:SetTarget(c62501706.rmtg)
	e4:SetOperation(c62501706.rmop)
	c:RegisterEffect(e4)
	c62501706.remove_event_effect=e4
end
function c62501706.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 or Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	if #g==3 then
		Duel.DisableShuffleCheck()
	end
	g:Merge(sg)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c62501706.thfilter(c,chk)
	return c:IsSetCard(0xea4) and c:IsAbleToHand() and (c:IsFacedown() or not c:IsLocation(LOCATION_REMOVED))
end
function c62501706.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501706.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c62501706.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c62501706.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,1):GetFirst()
	if not tc then return end
	--Duel.HintSelection(Group.FromCards(tc))
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or not c:IsAbleToRemove(tp,POS_FACEDOWN) then return end
	if not tc:IsLocation(LOCATION_HAND) or not Duel.SelectYesNo(tp,aux.Stringid(62501706,0)) then return end
	Duel.BreakEffect()
	Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
end
function c62501706.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	g:AddCard(e:GetHandler())
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==#g end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,tp,0)
end
function c62501706.spfilter(c,e,tp,chk)
	return c:IsSetCard(0xea4) and not c:IsCode(62501706) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFacedown()
end
function c62501706.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,3)
	local c=e:GetHandler()
	if not g or #g==0 or not c:IsRelateToChain() or not c:IsAbleToRemove(tp,POS_FACEDOWN) then return end
	g:AddCard(c)
	if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)==0 then return end
	if Duel.IsExistingMatchingCard(c62501706.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(62501706,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c62501706.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c62501706.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==#g end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,tp,0)
end
function c62501706.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,3)
	local c=e:GetHandler()
	if not g or #g==0 or Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)==0 then return end
	if Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(62501706,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
