--解脱
function c29010208.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c29010208.cost)
	c:RegisterEffect(e1)
end
function c29010208.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function c29010208.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c29010208.rfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c29010208.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end