--救世之旅-？？？
function c16400114.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,458748+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(0)
	e1:SetCondition(c16400114.condition)
	e1:SetTarget(c16400114.target)
	e1:SetOperation(c16400114.activate)
	c:RegisterEffect(e1)
end
function c16400114.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xce3)
end
function c16400114.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c16400114.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c16400114.filter(c,e,tp)
	return c:IsSetCard(0xce3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16400114.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16400114.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c16400114.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16400114.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
