--喀兰贸易·先锋干员-讯使
function c79029067.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c79029067.matfilter,2,2)
	c:EnableReviveLimit() 
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029067)
	e1:SetCondition(c79029067.spcon)
	e1:SetTarget(c79029067.sptg)
	e1:SetOperation(c79029067.spop)
	c:RegisterEffect(e1)  
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,7902906799999999999)
	e2:SetCondition(c79029067.thcon2)
	e2:SetTarget(c79029067.thtg2)
	e2:SetOperation(c79029067.thop2)
	c:RegisterEffect(e2) 
end
function c79029067.matfilter(c)
	return c:IsLinkSetCard(0xa900)
end
function c79029067.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c79029067.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c79029067.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79029067.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c79029067.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029067.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function c79029067.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c79029067.thfilter2(c,tp)
	return c:IsSetCard(0xc90f) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c79029067.thfilter3,tp,LOCATION_DECK,0,1,c)
end
function c79029067.thfilter3(c)
	return c:IsSetCard(0x1906) and c:IsAbleToHand()
end
function c79029067.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029067.thfilter2,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029067.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c79029067.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c79029067.thfilter3,tp,LOCATION_DECK,0,1,1,g1:GetFirst())
		g1:Merge(g2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
