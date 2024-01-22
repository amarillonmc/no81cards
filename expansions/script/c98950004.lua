--不朽绝望蔷薇
function c98950004.initial_effect(c)
	aux.AddCodeList(c,78371393)
--same effect send this card to grave and spsummon another card check
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	--search
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(98950004,1))
	e10:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_HAND)  
	e10:SetCountLimit(1,98950004)
	e10:SetCondition(c98950004.spcon)
	e10:SetCost(c98950004.cost)
	e10:SetTarget(c98950004.target)
	e10:SetOperation(c98950004.operation)
	c:RegisterEffect(e10)
 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98950004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetLabelObject(e0)
	e1:SetCountLimit(1,98951004)
	e1:SetCost(c98950004.drcost)
	e1:SetCondition(c98950004.spcon1)
	e1:SetTarget(c98950004.sptg)
	e1:SetOperation(c98950004.spop)
	c:RegisterEffect(e1)
end
function c98950004.cfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(1)
end
function c98950004.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c98950004.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98950004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c98950004.thfilter(c)
	return c:IsAttack(0) and c:IsDefense(0) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND+RACE_PLANT) and c:IsAbleToHand()
end
function c98950004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98950004.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98950004.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c98950004.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c98950004.filter(c,tp)
	return c:IsType(TYPE_EFFECT) and c:IsAttack(0)
end
function c98950004.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c98950004.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98950004.filter,1,e:GetHandler())
end
function c98950004.spfilter(c,e,tp)
	return c:IsCode(78371393) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c98950004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and e:GetHandler():IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c98950004.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c98950004.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98950004.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)~=0 then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98950004.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98950004.splimit(e,c)
	return not (c:IsAttack(0) and c:IsDefense(0))
end