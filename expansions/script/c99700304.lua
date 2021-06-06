--灵界指路人
function c99700304.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99700304,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,99700304)
	e1:SetCost(c99700304.tgcost)
	e1:SetTarget(c99700304.tgtg)
	e1:SetOperation(c99700304.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--extra material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99700304,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,99700305)
	e3:SetCondition(c99700304.fusioncon)
	e3:SetOperation(c99700304.fusionop)
	e3:SetValue(SUMMON_TYPE_FUSION)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTargetRange(LOCATION_EXTRA,0)
	e4:SetTarget(c99700304.mattg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c99700304.tgilter(c)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c99700304.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99700304.tgilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99700304.tgilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c99700304.spfilter(c,e,tp)
	return c:IsSetCard(0xfd03) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99700304.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99700304.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99700304.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99700304.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
   end
end
function c99700304.fusfilter(c)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER)
end
function c99700304.lmfilter(c,lc,tp,og,lmat)
	return c:IsCanBeFusionMaterial(lc) and c:IsRace(lc:GetRace()) and c:IsFusionSetCard(0xfd03) and Duel.IsExistingMatchingCard(c99700304.fusfilter,tp,LOCATION_GRAVE,0,3,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_FMATERIAL)
		and (not og or og:IsContains(c)) and (not lmat or lmat==c)
end
function c99700304.fusioncon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c99700304.lmfilter,tp,LOCATION_GRAVE,0,1,nil,c,tp,og,lmat)
end
function c99700304.fusionop(e,tp,eg,ep,ev,re,r,rp,c,sc,og,lmat,min,max)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.SelectMatchingCard(tp,c99700304.lmfilter,tp,LOCATION_GRAVE,0,1,1,nil,c,tp,og,lmat)
	c:SetMaterial(mg)
	Duel.Hint(HINT_CARD,0,99700304)
	Duel.Remove(mg,POS_FACEUP,REASON_MATERIAL+REASON_FUSION)
end
function c99700304.mattg(e,c)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_FUSION)
end