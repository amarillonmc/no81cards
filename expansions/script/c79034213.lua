--哭泣鲨鱼
function c79034213.initial_effect(c)
	 --sp
	 local e1=Effect.CreateEffect(c)
	 e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	 e1:SetType(EFFECT_TYPE_IGNITION)
	 e1:SetRange(LOCATION_MZONE)
	 e1:SetCountLimit(1,79034213)
	 e1:SetCost(c79034213.spcost)
	 e1:SetTarget(c79034213.sptg)
	 e1:SetOperation(c79034213.spop)
	 c:RegisterEffect(e1)
	 local e2=Effect.CreateEffect(c)
	 e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	 e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	 e2:SetProperty(EFFECT_FLAG_DELAY)
	 e2:SetCode(EVENT_MOVE)
	 e2:SetCountLimit(1,013213)
	 e2:SetRange(LOCATION_MZONE)
	 e2:SetCondition(c79034213.ctcon1)
	 e2:SetTarget(c79034213.cttg1)
	 e2:SetOperation(c79034213.ctop1)
	 c:RegisterEffect(e2)
end
function c79034213.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	 local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	 Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c79034213.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c79034213.spfil(c,e,tp)
	 return c:IsLevelBelow(4) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79034213.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return e:GetHandler():GetSequence()==2 and Duel.IsExistingMatchingCard(c79034213.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	 local g=Duel.SelectMatchingCard(tp,c79034213.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	 Duel.SetTargetCard(g)
	 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c79034213.spop(e,tp,eg,ep,ev,re,r,rp)
	 local tc=Duel.GetFirstTarget()
	 Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function c79034213.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and not c:IsAttribute(ATTRIBUTE_WATER)
end
function c79034213.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xca12) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c79034213.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79034213.cfilter,1,e:GetHandler())
end
function c79034213.xxfil(c)
	return c:IsSetCard(0xca12) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c79034213.cttg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79034213.xxfil,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79034213.xxfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0)
end
function c79034213.ctop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.SSet(tp,tc)
	Duel.BreakEffect()
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end







	 







