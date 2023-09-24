--幻魔之眼
function c98950003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,989500003+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c98950003.condition)
	e1:SetTarget(c98950003.target)
	e1:SetOperation(c98950003.activate)
	c:RegisterEffect(e1)
--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98950003,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98951003)
	e2:SetTarget(c98950003.sptg2)
	e2:SetOperation(c98950003.spop2)
	c:RegisterEffect(e2)
end
function c98950003.cfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(1)
end
function c98950003.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c98950003.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98950003.thfilter(c,tp)
	return c:IsCode(4779091,78371393,98950001,98950004) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98950003.tgfilter(c)
	return c:IsAttack(0) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_PLANT) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c98950003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98950003.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c98950003.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98950003.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)   
	local tg=Duel.SelectMatchingCard(tp,c98950003.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tgc=tg:GetFirst()
	if Duel.SendtoGrave(tgc,REASON_EFFECT)~=0 and tgc:IsLocation(LOCATION_GRAVE) then	   
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND) 
		 local g=Duel.SelectMatchingCard(tp,c98950003.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
		 local tc=g:GetFirst()	  
		 Duel.SendtoHand(tc,nil,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,tc)
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98950003.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98950003.splimit(e,c)
	return not (c:IsAttack(0) and c:IsDefense(0))
end
function c98950003.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(Card.IsLevelAbove,tp,LOCATION_MZONE,0,1,nil,10) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c98950003.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsLevelAbove,tp,LOCATION_MZONE,0,1,1,nil,10)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0
		and c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end