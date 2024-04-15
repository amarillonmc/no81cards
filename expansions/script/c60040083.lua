--真实的斩击
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60040005)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	c:RegisterEffect(e1)
end
function cm.tgfilter(c)
	return aux.IsCodeListed(c,60040005) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter1,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.tgfilter1,tp,LOCATION_DECK,0,nil):Select(tp,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end