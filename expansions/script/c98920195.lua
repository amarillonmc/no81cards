--真海皇 安凯奥斯
function c98920195.initial_effect(c)
		--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920195,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920195)
	e1:SetCost(c98920195.spcost1)
	e1:SetTarget(c98920195.sptg1)
	e1:SetOperation(c98920195.spop1)
	c:RegisterEffect(e1)  
  --boost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920195,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c98920195.tdcon)
	e2:SetOperation(c98920195.tdop)
	c:RegisterEffect(e2)
end
function c98920195.cfilter(c,tp)
	return c:IsSetCard(0x77) and c:IsType(TYPE_MONSTER) and not c:IsCode(98920195) and not c:IsCode(47826112) and c:IsAbleToGraveAsCost()
end
function c98920195.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c98920195.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c98920195.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	tg:AddCard(c)
	Duel.SendtoGrave(tg,REASON_COST)
end
function c98920195.spfilter1(c,e,tp)
	return c:IsCode(47826112) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920195.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920195.spfilter1,tp,LOCATION_DECK,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920195.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920195.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98920195.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsAttribute(ATTRIBUTE_WATER) and not re:GetHandler():IsCode(98920195)
end
function c98920195.atkfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c98920195.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c98920195.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(200)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
