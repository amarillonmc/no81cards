--反则苏生
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return not c:IsAttack(0) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
		and not c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,PLAYER_ALL,LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_GRAVE,1,nil)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(1-tp,s.filter,tp,0,LOCATION_GRAVE,1,1,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.SendtoDeck(g1,1-tp,0,REASON_EFFECT)
		Duel.SendtoDeck(g2,tp,0,REASON_EFFECT)
		local rec=g1:GetFirst():GetAttack()+g2:GetFirst():GetAttack()
		Duel.Recover(tp,rec,REASON_EFFECT,true)
		Duel.Recover(1-tp,rec,REASON_EFFECT,true)
		Duel.RDComplete()
	end
end