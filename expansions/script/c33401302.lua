--D.A.L Ratatoskr 辅助形态
function c33401302.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	 --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33401302,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,33401302)
	e2:SetCondition(c33401302.spcon)
	e2:SetTarget(c33401302.sptg)
	e2:SetOperation(c33401302.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(33401302,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c33401302.sptg2)
	e6:SetOperation(c33401302.spop2)
	c:RegisterEffect(e6)
   --to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33401302,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,33401302+20000)
	e4:SetCondition(c33401302.thcon)
	e4:SetTarget(c33401302.thtg)
	e4:SetOperation(c33401302.thop)
	c:RegisterEffect(e4)
end
function c33401302.cfilter(c,tp)
	return c:IsFaceup() and c:GetControler()==1-tp and c:IsSetCard(0x341)
end
function c33401302.spcon(e,tp,eg,ep,ev,re,r,rp)
	return  eg:IsExists(c33401302.cfilter,1,nil,tp)
end
function c33401302.spfilter(c,e,tp)
	return c:IsSetCard(0xc342) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c33401302.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33401302.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c33401302.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not  e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33401302.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c33401302.spfilter2(c,e,tp)
	return c:IsSetCard(0x341,0x5344)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33401302.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33401302.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c33401302.spop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33401302.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c33401302.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c33401302.thfilter(c)
	return c:IsSetCard(0x341) and c:IsType(TYPE_FIELD) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and not c:IsCode(33401302)
end
function c33401302.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33401302.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33401302.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33401302.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
