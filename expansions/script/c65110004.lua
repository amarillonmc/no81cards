--坎特伯雷 波比
function c65110004.initial_effect(c)
	aux.AddCodeList(c,65110005)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65110004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c65110004.spcon)
	e1:SetTarget(c65110004.sptg)
	e1:SetOperation(c65110004.spop)
	c:RegisterEffect(e1)
end
function c65110004.cfilter(c)
	return c:IsFaceup() and c:IsCode(65110005)
end
function c65110004.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c65110004.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c65110004.filter(c,e,tp)
	return c:IsCode(65110005) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65110004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65110004.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c65110004.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65110004.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

