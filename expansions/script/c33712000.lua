local m=33712000
local cm=_G["c"..m]
cm.name="赛扬娜拉"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message(Duel.GetTurnCount())
	return Duel.GetTurnCount()>=3
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local check1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
	local check2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) or e:GetHandler():IsLocation(LOCATION_HAND)
	local check3=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	local check4=Duel.GetDecktopGroup(tp,15):FilterCount(Card.IsAbleToRemove,nil)==15 and Duel.GetDecktopGroup(1-tp,15):FilterCount(Card.IsAbleToRemove,nil)==15
	if chk==0 then return (check1 or check2 or check3 or check4) and Duel.GetLP(tp)>=4000 end
	Duel.SetChainLimit(aux.FALSE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local g4=Duel.GetDecktopGroup(tp,15)
	g4:Merge(Duel.GetDecktopGroup(1-tp,15))
	g4=g4:Filter(Card.IsAbleToRemove,nil)
	local sel=0
	if g1 and #g1>0 and Duel.GetLP(tp)>=4000 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.SetLP(tp,Duel.GetLP(tp)-4000)
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
		sel=sel+1
	end
	if g2 and #g2>0 and Duel.GetLP(tp)>=4000 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.SetLP(tp,Duel.GetLP(tp)-4000)
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
		sel=sel+1
	end
	if g3 and #g3>0 and Duel.GetLP(tp)>=4000 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.SetLP(tp,Duel.GetLP(tp)-4000)
		Duel.Remove(g3,POS_FACEUP,REASON_EFFECT)
		sel=sel+1
	end
	if g4 and #g4==30 and Duel.GetLP(tp)>=4000 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.SetLP(tp,Duel.GetLP(tp)-4000)
		Duel.DisableShuffleCheck()
		Duel.Remove(g4,POS_FACEUP,REASON_EFFECT)
		sel=sel+1
	end
	if sel==4 and Duel.CheckLPCost(tp,8000) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.BreakEffect()
		Duel.PayLPCost(tp,8000)
		Duel.Damage(1-tp,Duel.GetLP(1-tp),REASON_EFFECT)
	end
end