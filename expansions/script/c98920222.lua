--毛绒动物·狐狸
function c98920222.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920222,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DAMAGE+CATEGORY_RECOVER+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920222)
	e1:SetCost(c98920222.cost)
	e1:SetTarget(c98920222.target)
	e1:SetOperation(c98920222.operation)
	c:RegisterEffect(e1)
end
function c98920222.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c98920222.filter(c)
	return c:IsCode(24094653) and c:IsAbleToHand()
end
function c98920222.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920222.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920222.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c98920222.filter,tp,LOCATION_DECK,0,nil)
	local c=e:GetHandler()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if Duel.IsExistingMatchingCard(c98920222.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
		if Duel.IsExistingMatchingCard(c98920222.cfilter2,tp,LOCATION_MZONE,0,1,nil) then
			Duel.Damage(1-tp,800,REASON_EFFECT)
		end
		if Duel.IsExistingMatchingCard(c98920222.cfilter3,tp,LOCATION_MZONE,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
		if Duel.IsExistingMatchingCard(c98920222.cfilter4,tp,LOCATION_SZONE,0,1,nil) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c98920222.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa9)
end
function c98920222.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xc3)
end
function c98920222.cfilter3(c)
	return c:IsFaceup() and c:IsSetCard(0xad) and c:IsType(TYPE_FUSION)
end
function c98920222.cfilter4(c)
	return c:IsFaceup() and c:IsCode(70245411)
end