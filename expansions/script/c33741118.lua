--Howling Warcry 2
function c33741118.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c33741118.condition)
	e1:SetTarget(c33741118.target)
	e1:SetOperation(c33741118.activate)
	c:RegisterEffect(e1)
end
function c33741118.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c33741118.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.gfcheck,2,2,Card.IsLocation,LOCATION_DECK,LOCATION_EXTRA) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,3000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c33741118.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(tp,3000,REASON_EFFECT)==0 then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsLocation,LOCATION_DECK,LOCATION_EXTRA)
	if #tg==0 or Duel.SendtoGrave(tg,REASON_EFFECT)==0 or Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==0 then return end
	if Duel.Damage(1-tp,1000,REASON_EFFECT)==0 then return end
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
