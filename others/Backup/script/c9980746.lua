--盖亚记忆体-疾风-
function c9980746.initial_effect(c)
	c:SetUniqueOnField(1,0,9980746)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9980746)
	e1:SetTarget(c9980746.target)
	e1:SetOperation(c9980746.activate)
	c:RegisterEffect(e1)
	--recover conversion
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_REVERSE_RECOVER)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(c9980746.recon)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,99807460)
	e3:SetCondition(c9980746.spcon)
	e3:SetTarget(c9980746.sptg)
	e3:SetOperation(c9980746.spop)
	c:RegisterEffect(e3)
end
function c9980746.filter(c)
	return c:IsCode(9980747) and c:IsAbleToHand()
end
function c9980746.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980746.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c9980746.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9980746.filter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980746,0))
end
function c9980746.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3bc2)
end
function c9980746.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9980746.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9980746.cfilter2(c,tp)
	return c:IsSetCard(0x3bc2) and c:IsReason(REASON_DESTROY)
		and (c:IsReason(REASON_BATTLE) or c:GetReasonPlayer()==1-tp and c:IsReason(REASON_DESTROY))
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c9980746.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9980746.cfilter2,1,nil,tp)
end
function c9980746.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x3bc2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980746.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) and chkc:IsControler(tp) and c9980746.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9980746.spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9980746.spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9980746.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980746,0))
	end
end
