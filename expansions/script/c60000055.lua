--孤独星球
local m=60000055
local cm=_G["c"..m]
cm.name="孤独星球"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),1,1)
	c:EnableReviveLimit()  
	--open
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
cm.toss_dice=true
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local d1,d2=Duel.TossDice(tp,2)
	if d1==1 or d2==1 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_REMOVED,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
	if d1==2 or d2==2 then
		if Duel.GetFlagEffect(tp,60001228)==0 then 
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_REMOVED,0,nil)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		else
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
	if d1==3 or d2==3 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
	if d1==4 or d2==4 then
		if Duel.GetFlagEffect(tp,60001229)==0 then 
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		else
			Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
		end
	end
	if d1==5 or d2==5 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_GRAVE,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
	if d1==6 or d2==6 then
		if Duel.GetFlagEffect(tp,60001230)==0 then 
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,0,nil)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		else
			local g=Duel.GetMatchingGroup(cm.ttkfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
function cm.ttkfilter(c)
	return c:IsCode(60000055)
end
