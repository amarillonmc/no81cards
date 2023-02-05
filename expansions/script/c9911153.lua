--溯雪恋戏·和泉千晶
function c9911153.initial_effect(c)
	--special summon (hand/grave)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911153,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9911153)
	e1:SetCondition(c9911153.condition1)
	e1:SetCost(c9911153.cost1)
	e1:SetTarget(c9911153.sptg)
	e1:SetOperation(c9911153.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9911153.condition2)
	c:RegisterEffect(e2)
	--Special Summon (deck)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9911153,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCountLimit(1,9911153)
	e3:SetCondition(c9911153.condition1)
	e3:SetCost(c9911153.cost2)
	e3:SetTarget(c9911153.sptg2)
	e3:SetOperation(c9911153.spop2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(c9911153.condition2)
	c:RegisterEffect(e4)
	--xyz effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9911153,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_MOVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,9911154)
	e5:SetCondition(c9911153.xyzcon)
	e5:SetTarget(c9911153.xyztg)
	e5:SetOperation(c9911153.xyzop)
	c:RegisterEffect(e5)
end
function c9911153.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9911165)
end
function c9911153.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9911165)
end
function c9911153.costfilter1(c,tp,b)
	return c:IsAbleToGraveAsCost() and (not c:IsSetCard(0x3958) or (b and Duel.GetMZoneCount(tp,c)>0))
end
function c9911153.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	local g=Duel.GetMatchingGroup(c9911153.costfilter1,tp,LOCATION_ONFIELD,0,nil,tp,b)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local costg=g:Select(tp,1,1,nil)
	local label=0
	if costg:IsExists(Card.IsSetCard,1,nil,0x3958) then label=1 end
	e:SetLabel(label)
	Duel.SendtoGrave(costg,REASON_COST)
end
function c9911153.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if e:GetLabel()==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end
end
function c9911153.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)==0 then return end
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):RandomSelect(tp,1)
	local tc=g:GetFirst()
	Duel.ConfirmCards(tp,tc)
	Duel.ShuffleHand(1-tp)
	if e:GetLabel()==1 and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9911153.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local costg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(costg,REASON_COST)
end
function c9911153.spfilter(c,e,tp)
	return c:IsSetCard(0x3958) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c9911153.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9911153.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c9911153.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911153.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 and c:IsRelateToEffect(e) then
		Duel.ShuffleDeck(tp)
		Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end
function c9911153.colfilter(c,col)
	return col==aux.GetColumn(c)
end
function c9911153.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local col=aux.GetColumn(e:GetHandler())
	return col and eg:IsExists(c9911153.colfilter,1,e:GetHandler(),col)
end
function c9911153.xyzfilter(c)
	return c:IsSetCard(0x3958) and c:IsXyzSummonable(nil)
end
function c9911153.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911153.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9911153.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911153.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end
