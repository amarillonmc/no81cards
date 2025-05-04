--吹拂的翼弓 芙罗莉娜
function c75000829.initial_effect(c)
	aux.AddCodeList(c,75000812) 
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75000829)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(c75000829.spcon)
	e1:SetTarget(c75000829.sptg)
	e1:SetOperation(c75000829.spop)
	c:RegisterEffect(e1)   
	 --special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75000829,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_LEAVE_DECK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,75000829)
	e3:SetCondition(c75000829.tgcon)
	e3:SetTarget(c75000829.tgtg)
	e3:SetOperation(c75000829.tgop)
	c:RegisterEffect(e3)
end
function c75000829.spcfilter(c)
	return (c:IsCode(75000812) or aux.IsCodeListed(c,75000812)) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c75000829.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c75000829.spcfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c75000829.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c75000829.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
--
function c75000829.tgfilter1(c,tp)
	return c:IsPreviousLocation(LOCATION_EXTRA) and c:IsPreviousControler(tp) and c:IsSetCard(0xa751) and c:IsType(TYPE_SYNCHRO)
end
function c75000829.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75000829.tgfilter1,1,nil,tp)
end
function c75000829.tgfilter(c)
	return (c:IsCode(75000812) or aux.IsCodeListed(c,75000812)) and c:IsAbleToGrave()
end
function c75000829.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75000829.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c75000829.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75000829.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

