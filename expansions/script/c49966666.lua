--孤注一掷
function c49966666.initial_effect(c)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c49966666.condition)
	e1:SetTarget(c49966666.target)
	e1:SetOperation(c49966666.activate)
	c:RegisterEffect(e1)
end
function c49966666.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function c49966666.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) and ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct and Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function c49966666.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  if  Duel.Draw(p,d,REASON_EFFECT) and ct>0 then 
	 Duel.DiscardDeck(tp,ct,REASON_EFFECT)
end
 end


