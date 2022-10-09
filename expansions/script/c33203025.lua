--缝合僵尸 凤梨食虫谷精游走鲸
function c33203025.initial_effect(c)
	--Fusion Material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x332b),2,true)
	--To Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33203025,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,33203025)
	e1:SetCondition(c33203025.thcon)
	e1:SetTarget(c33203025.thtg)
	e1:SetOperation(c33203025.thop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33203025,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,33213025)
	e2:SetTarget(c33203025.sptg)
	e2:SetOperation(c33203025.spop)
	c:RegisterEffect(e2)
end
function c33203025.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c33203025.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x332b) and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA))
end
function c33203025.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33203025.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c33203025.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33203025.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c33203025.relfilter(c,tp)
	return c:IsReleasableByEffect() and (c:GetCounter(0x132b)>0 or c:IsControler(tp)) and Duel.GetMZoneCount(tp,c)>0
end
function c33203025.spfilter(c,e,tp)
	return c:IsSetCard(0x332b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33203025.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c33203025.relfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33203025.relfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
		and Duel.IsExistingMatchingCard(c33203025.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,c33203025.relfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c33203025.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e)
		and Duel.Release(tc,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c33203025.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

