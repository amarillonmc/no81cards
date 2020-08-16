--一个世界的纪录 ～残留的记忆～
function c33701331.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c33701331.cost)
	c:RegisterEffect(e1) 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c33701331.con1)
	e1:SetValue(aux.TRUE)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c33701331.con2)
	e1:SetValue(aux.TRUE)
	c:RegisterEffect(e1)
end
function c33701331.cofil1(c)
	return c:IsAbleToRemoveAsCost() and c:IsCode(33700902)
end
function c33701331.cofil2(c)
	return c:IsAbleToRemoveAsCost() and c:IsCode(33700903)
end
function c33701331.cofil3(c)
	return c:IsAbleToRemoveAsCost() and c:IsCode(33700904)
end
function c33701331.cofil4(c)
	return c:IsAbleToRemoveAsCost() and c:IsCode(33700905)
end
function c33701331.cofil5(c)
	return c:IsAbleToRemoveAsCost() and c:IsCode(11113135)
end
function c33701331.cofil6(c)
	return c:IsAbleToRemoveAsCost() and c:IsCode(33700906)
end
function c33701331.xcofil1(c)
	return c:IsCode(33700902)
end
function c33701331.xcofil2(c)
	return c:IsCode(33700903)
end
function c33701331.xcofil3(c)
	return c:IsCode(33700904)
end
function c33701331.xcofil4(c)
	return c:IsCode(33700905)
end
function c33701331.xcofil5(c)
	return c:IsCode(11113135)
end
function c33701331.xcofil6(c)
	return c:IsCode(33700906)
end
function c33701331.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
	Duel.IsExistingMatchingCard(c33701331.cofil1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and
	Duel.IsExistingMatchingCard(c33701331.cofil2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and
	Duel.IsExistingMatchingCard(c33701331.cofil3,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and
	Duel.IsExistingMatchingCard(c33701331.cofil4,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and
	Duel.IsExistingMatchingCard(c33701331.cofil5,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and
	Duel.IsExistingMatchingCard(c33701331.cofil6,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	local g1=Duel.SelectMatchingCard(tp,c33701331.cofil1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c33701331.cofil2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	local g3=Duel.SelectMatchingCard(tp,c33701331.cofil3,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	local g4=Duel.SelectMatchingCard(tp,c33701331.cofil4,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	local g5=Duel.SelectMatchingCard(tp,c33701331.cofil5,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	local g6=Duel.SelectMatchingCard(tp,c33701331.cofil6,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	g1:Merge(g5)
	g1:Merge(g6)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c33701331.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)~=0 and
	Duel.IsExistingMatchingCard(c33701331.xcofil1,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and
	Duel.IsExistingMatchingCard(c33701331.xcofil2,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and
	Duel.IsExistingMatchingCard(c33701331.xcofil3,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and
	Duel.IsExistingMatchingCard(c33701331.xcofil4,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and
	Duel.IsExistingMatchingCard(c33701331.xcofil5,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and
	Duel.IsExistingMatchingCard(c33701331.xcofil6,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) 
end
function c33701331.con2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return  Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)~=0 and
	Duel.IsExistingMatchingCard(c33701331.xcofil1,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and
	Duel.IsExistingMatchingCard(c33701331.xcofil2,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and
	Duel.IsExistingMatchingCard(c33701331.xcofil3,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and
	Duel.IsExistingMatchingCard(c33701331.xcofil4,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and
	Duel.IsExistingMatchingCard(c33701331.xcofil5,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and
	Duel.IsExistingMatchingCard(c33701331.xcofil6,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) 
end









