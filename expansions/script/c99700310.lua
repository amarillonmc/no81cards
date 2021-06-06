--灵界 箫灵之音
function c99700310.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99700310,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99700310)
	e1:SetCost(c99700310.spcost)
	e1:SetCondition(c99700310.spcon)
	e1:SetTarget(c99700310.sptg)
	e1:SetOperation(c99700310.spop)
	c:RegisterEffect(e1)
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99700310,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,99700311)
	e2:SetCondition(c99700310.Linkcon)
	e2:SetOperation(c99700310.Linkop)
	e2:SetValue(SUMMON_TYPE_LINK)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetTarget(c99700310.mattg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c99700310.spcon(e,c)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c99700310.tgilter(c)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c99700310.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99700310.tgilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99700310.tgilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c99700310.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99700310.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c99700310.Linkfilter(c)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER)
end
function c99700310.lmfilter(c,lc,tp,og,lmat)
	return c:IsCanBeLinkMaterial(lc) and c:IsAttack(lc:GetAttack()) and c:IsLinkSetCard(0xfd03) and Duel.IsExistingMatchingCard(c99700310.Linkfilter,tp,LOCATION_GRAVE,0,3,nil)
		and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL)
		and (not og or og:IsContains(c)) and (not lmat or lmat==c)
end
function c99700310.Linkcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c99700310.lmfilter,tp,LOCATION_GRAVE,0,1,nil,c,tp,og,lmat)
end
function c99700310.Linkop(e,tp,eg,ep,ev,re,r,rp,c,sc,og,lmat,min,max)
	if Duel.GetLocationCountFromEx(tp,tp,c,lc)<=0 then return end
	local mg=Duel.SelectMatchingCard(tp,c99700310.lmfilter,tp,LOCATION_GRAVE,0,1,1,nil,c,tp,og,lmat)
	c:SetMaterial(mg)
	Duel.Hint(HINT_CARD,0,99700310)
	Duel.Remove(mg,POS_FACEUP,REASON_MATERIAL+REASON_LINK)
end
function c99700310.mattg(e,c)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_LINK)
end