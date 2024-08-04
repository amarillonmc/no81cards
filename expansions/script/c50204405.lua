--毛绒动物·虎
function c50204405.initial_effect(c)
	--spsummon1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50204405,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,50204405)
	e1:SetCondition(c50204405.sscon)
	e1:SetTarget(c50204405.sstg)
	e1:SetOperation(c50204405.ssop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50204405,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,50204405+1)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c50204405.thtg)
	e2:SetOperation(c50204405.thop)
	c:RegisterEffect(e2)
	local e22=e2:Clone()
	e22:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e22)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50204405,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,50204405+2)
	e3:SetCondition(c50204405.spcon)
	e3:SetTarget(c50204405.sptg)
	e3:SetOperation(c50204405.spop)
	c:RegisterEffect(e3)
end
function c50204405.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa9)
end
function c50204405.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c50204405.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c50204405.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c50204405.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c50204405.thfilter(c)
	return c:IsSetCard(0xc3,0xa9,0xad) and c:IsAbleToHand()
end
function c50204405.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50204405.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50204405.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c50204405.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c50204405.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_FUSION and c:GetReasonCard():IsSetCard(0xad)
end
function c50204405.spfilter(c,e,tp)
	return c:IsSetCard(0xc3,0xa9) and not c:IsCode(50204405) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50204405.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c50204405.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c50204405.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c50204405.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c50204405.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end