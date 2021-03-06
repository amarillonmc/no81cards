--忍鬼 白鹭
function c40006903.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,c40006903.lcheck)
	c:EnableReviveLimit()   
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40006903,0))
	e5:SetCategory(CATEGORY_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,40006903)
	e5:SetCondition(c40006903.spcon2)
	e5:SetTarget(c40006903.sptg2)
	e5:SetOperation(c40006903.spop2)
	c:RegisterEffect(e5)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40006903,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c40006903.reccon)
	e2:SetTarget(c40006903.thtg)
	e2:SetOperation(c40006903.thop)
	c:RegisterEffect(e2)
	local e1=e2:Clone()
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c40006903.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x2b)
end
function c40006903.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsSetCard(0x61)
end
function c40006903.spfilter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0x2b)  and c:IsSummonable(true,nil)
end
function c40006903.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40006903.spfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c40006903.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c40006903.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
function c40006903.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:IsSetCard(0x2b)
end
function c40006903.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40006903.cfilter,1,nil,tp)
end
function c40006903.thfilter(c)
	return ((c:IsSetCard(0x61) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or (c:IsSetCard(0x2b) and c:IsType(TYPE_MONSTER))) and c:IsAbleToHand()
end
function c40006903.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40006903.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function c40006903.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c40006903.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
