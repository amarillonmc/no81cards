--企鹅物流·行动-分头行动
function c79029057.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029057)
	e1:SetTarget(c79029057.target)
	e1:SetOperation(c79029057.operation)
	c:RegisterEffect(e1) 
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(73594093,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,09029057)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79029057.settg)
	e2:SetOperation(c79029057.setop)
	c:RegisterEffect(e2)   
end
function c79029057.costfilter(c)
	local lk=c:GetLink()
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:IsReleasable() and c:IsAbleToRemove() and c:IsType(TYPE_LINK) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil)
end
function c79029057.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029057.costfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c79029057.operation(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,c79029057.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local lk=sg:GetFirst():GetLink()
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	local x=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_EXTRA,nil)
	local g=x:RandomSelect(tp,lk)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function c79029057.setfilter(c)
	return c:IsSetCard(0xc90e) and c:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c79029057.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029057.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c79029057.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c79029057.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
