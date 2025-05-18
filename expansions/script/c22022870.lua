--人理之星 阿尔托莉雅·卡斯特
function c22022870.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,3,c22022870.lcheck)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022870,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,22022870+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c22022870.thcon)
	e1:SetTarget(c22022870.sptg)
	e1:SetOperation(c22022870.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22022870,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22022871+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c22022870.cost)
	e2:SetTarget(c22022870.sptg1)
	e2:SetOperation(c22022870.spop1)
	c:RegisterEffect(e2)
	--spsummon ere
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22022870,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22022871+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c22022870.erecon)
	e3:SetCost(c22022870.erecost)
	e3:SetTarget(c22022870.sptg1)
	e3:SetOperation(c22022870.spop1)
	c:RegisterEffect(e3)
end
c22022870.effect_with_light=true
c22022870.effect_with_avalon=true
function c22022870.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_TUNER)
end
function c22022870.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c22022870.filter(c,e,tp)
	return c:IsCode(22020000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22022870.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22022870.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c22022870.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22022870.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22022870.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xfee,6,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xfee,6,REASON_COST)
end
function c22022870.espfilter(c,e,tp)
	return c:IsSetCard(0x6ff1) and c:IsType(TYPE_SYNCHRO) and c.effect_with_light and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c22022870.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22022870.espfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22022870.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22022870.espfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22022870.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22022870.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xfee,6,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xfee,6,REASON_COST)
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end