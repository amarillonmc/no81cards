--毅飞冲天啦啦队
function c75038097.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75038097,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75038097)
	e1:SetCondition(c75038097.spcon1)
	e1:SetTarget(c75038097.sptg)
	e1:SetOperation(c75038097.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c75038097.spcon2)
	c:RegisterEffect(e2)
end
function c75038097.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c75038097.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c75038097.spfilter(c,e,tp,res)
	return c:IsSetCard(0x107f) and (res or c:IsCode(84013237)) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)-- and e:GetHandler():IsCanBeXyzMaterial(c)
end
function c75038097.ovfilter(c,chk)
	return c:IsSetCard(0x54,0x59,0x82,0x8f) and c:IsLevelAbove(1) and c:IsCanOverlay() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c75038097.gcheck(g,ec)
	local f=aux.CreateChecks(Card.IsSetCard,{0x54,0x59,0x82,0x8f})
	return aux.dlvcheck(g) and g:IsContains(ec) and g:CheckSubGroupEach(f)
end
function c75038097.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=Duel.IsExistingMatchingCard(Card.IsSummonLocation,tp,0,LOCATION_MZONE,1,nil,LOCATION_EXTRA)
	local g=Duel.GetMatchingGroup(c75038097.ovfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,0)
	if chk==0 then return aux.MustMaterialCheck(e:GetHandler(),tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c75038097.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,res)
		and g:CheckSubGroup(c75038097.gcheck,4,4,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c75038097.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	local res=Duel.IsExistingMatchingCard(Card.IsSummonLocation,tp,0,LOCATION_MZONE,1,nil,LOCATION_EXTRA)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c75038097.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,res):GetFirst()
	if not sc or Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)==0 then return end
	sc:CompleteProcedure()
	--
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c75038097.ovfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,1)
	if not c:IsRelateToChain() or not g:CheckSubGroup(c75038097.gcheck,4,4,c) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=g:SelectSubGroup(tp,c75038097.gcheck,false,4,4,c)
	Duel.Overlay(sc,sg)
end
