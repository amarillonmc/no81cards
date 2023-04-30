--方舟骑士-凯尔希·残余
c29038040.named_with_Arknight=1
function c29038040.initial_effect(c)
	aux.AddCodeList(c,29065500,29065502)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(423585,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,29038040)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c29038040.sptg)
	e3:SetOperation(c29038040.spop)
	c:RegisterEffect(e3)
end
function c29038040.filter(c,e,tp)
	return (c:IsCode(c,29065500,29065502) or aux.IsCodeListed(c,29065500) or aux.IsCodeListed(c,29065502)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29038040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29038040.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c29038040.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29038040.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end