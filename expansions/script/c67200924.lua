--废都虹翼·轮回
function c67200924.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200924,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,67200925)
	e1:SetCondition(c67200924.spcon)
	e1:SetTarget(c67200924.sptg)
	e1:SetOperation(c67200924.spop)
	c:RegisterEffect(e1) 
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200924,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,67200924)
	e3:SetTarget(c67200924.thtg)
	e3:SetOperation(c67200924.thop)
	c:RegisterEffect(e3)
	local e2=e3:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
c67200924.SetCard_Counter_current=true 
--
function c67200924.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsSetCard(0x67a) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c67200924.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c67200924.cfilter,1,c,tp)
end
function c67200924.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67200924.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c67200924.thfilter(c)
	return c.SetCard_Counter_current and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c67200924.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200924.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67200924.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200924.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

