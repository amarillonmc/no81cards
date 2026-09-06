--数理罪论 莫里亚蒂·自由射手
function c88887002.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,88887002)
	e2:SetTarget(c88887002.thtg)
	e2:SetOperation(c88887002.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,18887002)
	e3:SetCondition(c88887002.spcon)
	e3:SetTarget(c88887002.sptg)
	e3:SetOperation(c88887002.spop)
	c:RegisterEffect(e3)
end
function c88887002.thfilter(c,check)
	return c:IsFaceup() and c:IsAbleToHand() and ((check) or c:IsSetCard(0x881))
end
function c88887002.checkfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsLevel(12)
end
function c88887002.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local check=Duel.IsExistingMatchingCard(c88887002.checkfilter,tp,LOCATION_MZONE,0,1,nil)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c88887002.thfilter(chkc,check) end
	if chk==0 then return Duel.IsExistingTarget(c88887002.thfilter,tp,LOCATION_REMOVED,0,1,nil,check) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c88887002.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c88887002.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c88887002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE+LOCATION_ONFIELD)
end
function c88887002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c88887002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end