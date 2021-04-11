--幻惑的奇术师
function c72411310.initial_effect(c)
		aux.AddCodeList(c,72411270)
	--search def
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72411310,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(c72411310.target1)
	e1:SetOperation(c72411310.operation1)
	c:RegisterEffect(e1)
end
function c72411310.filter1(c,tp)
	return c:IsCode(72411270) and c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0
end
function c72411310.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c72411310.filter1,tp,LOCATION_ONFIELD,0,1,nil,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c72411310.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c72411310.filter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end