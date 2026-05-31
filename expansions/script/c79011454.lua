--星爆天穹寂灭斩
function c79011454.initial_effect(c) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,79011454+EFFECT_COUNT_CODE_OATH) 
	e1:SetCost(c79011454.cost)
	e1:SetTarget(c79011454.target)
	e1:SetOperation(c79011454.activate)
	c:RegisterEffect(e1)
end 
c79011454.SetCard_Pain_PBLK_Skill=true  
function c79011454.cost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(function(c) return c:IsAbleToDeckAsCost() and c.SetCard_Pain_PBLK_Skill end,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.dncheck,6,6) end 
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,6,6)
	Duel.SendtoDeck(sg,nil,2,REASON_COST) 
end 
function c79011454.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end 
function c79011454.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 then  
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
		Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79011454,1))
		Duel.Hint(HINT_MESSAGE,1,aux.Stringid(79011454,1))
	end  
end









