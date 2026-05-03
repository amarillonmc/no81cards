--饥献传道士 帕拉达
function c19209943.initial_effect(c)
	--antica spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,19209943)
	e1:SetCondition(c19209943.spcon)
	e1:SetTarget(c19209943.sptg)
	e1:SetOperation(c19209943.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)--TIMING_END_PHASE
	e2:SetDescription(aux.Stringid(19209943,0))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19209943+1)
	e2:SetCondition(c19209943.drcon)
	e2:SetCost(c19209943.drcost)
	e2:SetTarget(c19209943.drtg)
	e2:SetOperation(c19209943.drop)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19209943,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,19209943+2)
	e3:SetCondition(c19209943.tdcon)
	e3:SetTarget(c19209943.tdtg)
	e3:SetOperation(c19209943.tdop)
	c:RegisterEffect(e3)
end
function c19209943.cfilter(c)
	return c:IsSetCard(0xb54) and c:IsLevelAbove(6) and c:IsFaceup()
end
function c19209943.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19209943.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c19209943.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c19209943.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,0,LOCATION_MZONE,nil)
	if #g and Duel.SelectYesNo(tp,aux.Stringid(19209936,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Release(sg,REASON_EFFECT)
	end
end
function c19209943.drcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2--Duel.IsMainPhase()
end
function c19209943.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	local ct=Duel.DiscardHand(tp,Card.IsDiscardable,1,3,REASON_COST+REASON_DISCARD)
	e:SetLabel(ct)
end
function c19209943.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.IsPlayerCanDraw(0) and Duel.IsPlayerCanDraw(1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c19209943.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #g==0 then return end
	local val=#g
	if ct>=#g then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	else
		val=Duel.DiscardHand(1-tp,Card.IsDiscardable,ct,ct,REASON_EFFECT+REASON_DISCARD)
	end
	Duel.BreakEffect()
	if Duel.GetTurnPlayer()==tp then Duel.Draw(tp,ct,REASON_EFFECT) end
	Duel.Draw(1-tp,val,REASON_EFFECT)
	if Duel.GetTurnPlayer()~=tp then Duel.Draw(tp,ct,REASON_EFFECT) end
end
function c19209943.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=7
end
function c19209943.seqfilter(c)
	return c:GetSequence()<5
end
function c19209943.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end--Duel.IsPlayerCanSendtoDeck(1-tp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local ct=7-Duel.GetMatchingGroupCount(c19209943.seqfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,math.max(0,#g-ct),1-tp,LOCATION_HAND)
end
function c19209943.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local ct=7-Duel.GetMatchingGroupCount(c19209943.seqfilter,tp,0,LOCATION_MZONE,nil)
	if #g>ct then
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:RandomSelect(1-tp,#g-ct)--:Select(tp,#g-6,#g-6,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
