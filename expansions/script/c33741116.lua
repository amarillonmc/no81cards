--\"Karmasprung\"
function c33741116.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33741116,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCost(c33741116.rmcost)
	e1:SetTarget(c33741116.rmtg)
	e1:SetOperation(c33741116.rmop)
	c:RegisterEffect(e1)
end
function c33741116.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c33741116.rmfilter(c,p,t)
	return (c:IsExtraDeckMonster() or (c:GetType()&0x81)==0x81) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(p) and c:GetReasonPlayer()~=p and c:IsReason(REASON_DESTROY) and c:IsAbleToRemove() and c:GetTurnID()==t
end
function c33741116.sfilter(c)
	return c:IsCode(33741116) and c:IsAbleToRemove()
end
function c33741116.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetTurnCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c33741116.rmfilter,tp,LOCATION_GRAVE,0,1,nil,tp,t) and Duel.IsExistingMatchingCard(c33741116.sfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c33741116.rmfilter,tp,LOCATION_GRAVE,0,nil,tp,t)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c33741116.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c33741116.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp,Duel.GetTurnCount()):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	e:GetHandler():SetCardTarget(tc)
	--to deck
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(33741116,1))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCost(c33741116.rmcost)
	e1:SetTarget(c33741116.tdtg)
	e1:SetOperation(c33741116.tdop)
	--e1:SetLabelObject(tc)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,3)
	e:GetHandler():RegisterEffect(e1)
end
function c33741116.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetCardTarget()--,e:GetLabelObject()
	if chk==0 then return g:IsExists(Card.IsAbleToDeck,1,nil) end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetSum(Card.GetAttack)+g:GetSum(Card.GetDefense))
end
function c33741116.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCardTarget()
	if #g==0 or Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	local og=Duel.GetOperatedGroup()
	Duel.Damage(1-tp,og:GetSum(Card.GetAttack)+og:GetSum(Card.GetDefense),REASON_EFFECT)
end
