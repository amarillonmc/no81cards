--整合运动·士兵
function c79020012.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9411399,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c79020012.cost)
	e1:SetTarget(c79020012.target)
	e1:SetOperation(c79020012.operation)
	c:RegisterEffect(e1)	
end
function c79020012.fil(c)
	return c:IsCode(79020012) and c:IsAbleToRemoveAsCost()
end
function c79020012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79020012.fil,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local tc=Duel.SelectMatchingCard(tp,c79020012.fil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
end
function c79020012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c79020012.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local sc=Duel.CreateToken(tp,79020012)
	local op=Duel.SelectOption(tp,aux.Stringid(79020012,0),aux.Stringid(79020012,1))
	if op==0 then 
	Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	else 
	Duel.SendtoHand(sc,nil,REASON_EFFECT)
	end
end