--珊海环的眷主 阿尔维德
function c67200520.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200520,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c67200520.eqtg)
	e1:SetOperation(c67200520.eqop)
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--spsummon and to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200520,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,67200520)
	e3:SetCondition(c67200520.spcon)
	e3:SetTarget(c67200520.sptg)
	e3:SetOperation(c67200520.spop)
	c:RegisterEffect(e3)	
end
--
function c67200520.filter(c,ec)
	return c:IsCode(67200521) and c:CheckEquipTarget(ec)
end
function c67200520.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c67200520.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c67200520.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67200520.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,c)
	if g:GetCount()>0 then
		Duel.Equip(tp,g:GetFirst(),c)
	end
end
--
function c67200520.spfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSetCard(0x675) and c:IsType(TYPE_MONSTER) 
end
function c67200520.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200520.spfilter,1,nil,tp)
end
function c67200520.tgfilter(c)
	return c:IsSetCard(0x675) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c67200520.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(c67200520.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200520.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67200520.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tgc=g:GetFirst()
	if tgc and Duel.SendtoGrave(tgc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end