--静流葬
function c33700017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c33700017.con)
	e1:SetTarget(c33700017.target)
	e1:SetOperation(c33700017.activate)
	c:RegisterEffect(e1)
end
function c33700017.con(e,tp,eg,ep,ev,re,r,rp)
     return eg:IsExists(c33700017.filter,1,nil)
end
function c33700017.filter(c)
	return  bit.band(c:GetSummonLocation(),LOCATION_DECK)~=0  
end
function c33700017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c33700017.refilter(c,tp,ct)
	return  c:IsAbleToRemove() and c:IsLevelAbove(5) and Duel.IsExistingMatchingCard(c33700017.refilter2,tp,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,1,c,ct)
end
function c33700017.refilter2(c,ct)
	local g=0
	local tg=ct:GetFirst()
	while tg do
	if tg:GetCode()==c:GetCode() then
	g=g+1
	end
	tg=ct:GetNext()
end
	return  c:IsAbleToRemove() and g>0
end
function c33700017.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		if ct:GetCount()>0 and  Duel.IsExistingMatchingCard(c33700017.refilter,tp,LOCATION_HAND,0,1,nil,tp,ct)
	and Duel.SelectYesNo(tp,aux.Stringid(33700017,0)) then
			Duel.BreakEffect()
			local pt=Duel.SelectMatchingCard(tp,c33700017.refilter,tp,LOCATION_HAND,0,1,1,nil,tp,ct)
			if Duel.Remove(pt,POS_FACEUP,REASON_EFFECT)>0 then
			local d=Duel.GetMatchingGroup(c33700017.refilter2,tp,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil,ct)
			Duel.Remove(d,POS_FACEUP,REASON_EFFECTSON)
		end
	end
end
end