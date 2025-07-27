--归回净灵 亚里亚
function c19209670.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,19209670)
	e1:SetTarget(c19209670.sptg)
	e1:SetOperation(c19209670.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209670,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,19209670)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c19209670.thtg)
	e2:SetOperation(c19209670.thop)
	c:RegisterEffect(e2)
end
function c19209670.spfilter(c,e,tp)
	return c:IsCode(19209669) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19209670.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable(REASON_EFFECT) and Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c19209670.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c19209670.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD)==0 or Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c19209670.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c19209670.thfilter(c)
	return c:IsSetCard(0x3b52) and c:IsFaceup() and c:IsAbleToHand()
end
function c19209670.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c19209670.thfilter(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c19209670.thfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c19209670.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c19209670.sphfilter(c,e,tp,code)
	return c:IsSetCard(0x3b52) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19209670.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) and Duel.IsExistingMatchingCard(c19209670.sphfilter,tp,LOCATION_HAND,0,1,nil,e,tp,code) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(19209670,2)) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c19209670.sphfilter,tp,LOCATION_HAND,0,nil,e,tp,code)
		local sc=g:GetFirst()
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sc=g:Select(tp,1,1,nil):GetFirst()
		end
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end

