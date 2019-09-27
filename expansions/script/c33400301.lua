--夜刀神十香 花前月下
function c33400301.initial_effect(c)
	 c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400301,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,33400301)
	e1:SetCondition(c33400301.spcon)
	e1:SetTarget(c33400301.sptg)
	e1:SetOperation(c33400301.spop)
	c:RegisterEffect(e1)
	--send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400301,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,33400301+10000)
	e2:SetTarget(c33400301.tgtg)
	e2:SetOperation(c33400301.tgop)
	c:RegisterEffect(e2)
end
function c33400301.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c33400301.spfilter(c,e,tp)
	return c:IsSetCard(0x341) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and  c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400301.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:GetControler()==tp and c33400301.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33400301.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
end
function c33400301.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingTarget(c33400301.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33400301.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)   
	Duel.SpecialSummonComplete()
end
function c33400301.tgfilter(c)
	return  c:IsSetCard(0x341) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c33400301.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400301.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c33400301.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c33400301.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
