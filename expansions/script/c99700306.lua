--灵界丽人 小提琴家
function c99700306.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99700306,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,99700306)
	e1:SetCondition(c99700306.tgcon)
	e1:SetCost(c99700306.tgcost)
	e1:SetTarget(c99700306.tgtg)
	e1:SetOperation(c99700306.tgop)
	c:RegisterEffect(e1)
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99700306,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,99700307)
	e2:SetCondition(c99700306.Synchrocon)
	e2:SetOperation(c99700306.Synchroop)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetTarget(c99700306.mattg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c99700306.tgfilter(c)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and not c:IsCode(99700306)
end
function c99700306.spfilter(c)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER)
end
function c99700306.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99700306.spfilter,tp,LOCATION_GRAVE,0,2,nil)
end
function c99700306.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99700306.tgfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99700306.tgfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c99700306.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99700306.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c99700306.synfilter(c)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER)
end
function c99700306.lmfilter(c,lc,tp,og,lmat)
	return c:IsCanBeSynchroMaterial(lc) and c:IsAttribute(lc:GetAttribute()) and c:IsSetCard(0xfd03) and Duel.IsExistingMatchingCard(c99700306.synfilter,tp,LOCATION_GRAVE,0,3,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_SMATERIAL)
		and (not og or og:IsContains(c)) and (not lmat or lmat==c)
end
function c99700306.Synchrocon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c99700306.lmfilter,tp,LOCATION_GRAVE,0,1,nil,c,tp,og,lmat)
end
function c99700306.Synchroop(e,tp,eg,ep,ev,re,r,rp,c,sc,og,lmat,min,max)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.SelectMatchingCard(tp,c99700306.lmfilter,tp,LOCATION_GRAVE,0,1,1,nil,c,tp,og,lmat)
	c:SetMaterial(mg)
	Duel.Hint(HINT_CARD,0,99700306)
	Duel.Remove(mg,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
end
function c99700306.mattg(e,c)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_SYNCHRO)
end