--孤独星球
--罐子
function c60000055.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2)
	c:EnableReviveLimit()  
	--open
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(2,60000055)
	e1:SetOperation(c60000055.operation)
	c:RegisterEffect(e1)
end
c60000055.toss_dice=true
function c60000055.operation(e,tp,eg,ep,ev,re,r,rp)
	local d1,d2=Duel.TossDice(tp,2)
	if d1==1 or d2==1 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_REMOVED,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
	if d1==2 or d2==2 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_REMOVED,0,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
	if d1==3 or d2==3 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
	if d1==4 or d2==4 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
	if d1==5 or d2==5 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_GRAVE,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
	if d1==6 or d2==6 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,0,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
