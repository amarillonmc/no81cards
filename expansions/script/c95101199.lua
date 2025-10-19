--暗黑能乐面具 愉悦之突然
function c95101199.initial_effect(c)
	--union
	aux.EnableUnionAttribute(c,c95101199.unfilter)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95101199,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	--e1:SetCountLimit(1,95101199)
	e1:SetCondition(c95101199.spcon)
	e1:SetTarget(c95101199.sptg)
	e1:SetOperation(c95101199.spop)
	c:RegisterEffect(e1)
	--effect indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
c95101199.has_text_type=TYPE_UNION
function c95101199.unfilter(c)
	return c:IsSetCard(0xbbb0) or c:IsCode(95101209)
end
function c95101199.cfilter(c)
	return c:IsType(TYPE_UNION) and c:IsFaceup()
end
function c95101199.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c95101199.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c95101199.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c95101199.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
