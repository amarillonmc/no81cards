--奇术师 愚人节荷官
function c10700276.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10700276)
	e1:SetCondition(c10700276.spcon)
	e1:SetTarget(c10700276.sptg)
	e1:SetOperation(c10700276.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700276,1))
	e2:SetCategory(CATEGORY_COIN+CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_NEGATE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10700276.drcon)
	e2:SetTarget(c10700276.drtg)
	e2:SetOperation(c10700276.drop)
	c:RegisterEffect(e2)	  
end
c10700276.toss_coin=true
function c10700276.spfilter(c)
	return c:IsFaceup() and c:IsDisabled()
end
function c10700276.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10700276.spfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c10700276.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10700276.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	  if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		  Duel.BreakEffect()
		  if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
		  local tc=Duel.GetOperatedGroup():GetFirst()
		  Duel.ConfirmCards(1-tp,tc)
		  if tc.toss_coin then
			 Duel.BreakEffect()
			 Duel.Draw(tp,1,REASON_EFFECT)
		  else
			 Duel.BreakEffect()
			 Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)
		  end
	  end
	  Duel.ShuffleHand(tp)
end
function c10700276.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and not c:IsStatus(STATUS_CHAINING) and Duel.IsChainNegatable(ev)
end
function c10700276.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return (Duel.IsPlayerCanDraw(tp) or h1==0)
		and (Duel.IsPlayerCanDraw(1-tp) or h2==0)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c10700276.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	local res=Duel.TossCoin(tp,1)
	if res==1 then 
	   if Duel.SendtoDeck(g,nil,0,REASON_EFFECT)~=0 then
		local og=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if og:IsExists(Card.IsControler,1,nil,tp) then Duel.ShuffleDeck(tp) end
		if og:IsExists(Card.IsControler,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
		Duel.BreakEffect()
		local ct1=og:FilterCount(aux.FilterEqualFunction(Card.GetPreviousControler,tp),nil)
		local ct2=og:FilterCount(aux.FilterEqualFunction(Card.GetPreviousControler,1-tp),nil)
		Duel.Draw(tp,ct1,REASON_EFFECT)
		Duel.Draw(1-tp,ct2,REASON_EFFECT)
	   end
	else 
		Duel.Damage(tp,500,REASON_EFFECT)
		Duel.NegateRelatedChain(e:GetOwner(),RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetOwner())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetOwner():RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetOwner())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetOwner():RegisterEffect(e2)
	end
end