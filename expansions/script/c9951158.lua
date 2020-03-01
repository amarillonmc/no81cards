--宝具-天下布武光线
function c9951158.initial_effect(c)
   --activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c9951158.condition)
	e1:SetCost(c9951158.cost)
	e1:SetTarget(c9951158.target)
	e1:SetOperation(c9951158.activate)
	c:RegisterEffect(e1)
end
function c9951158.confilter(c,tp)
	return c:IsPreviousSetCard(0xba5) and c:GetPreviousControler()==tp
end
function c9951158.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9951158.confilter,1,nil,tp)
end
function c9951158.cfilter(c)
	return c:IsSetCard(0x3ba5) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD)) and c:IsAbleToGraveAsCost()
end
function c9951158.exfilter(c,tp)
	return Duel.GetLocationCountFromEx(tp,tp,c,TYPE_FUSION)>0
end
function c9951158.gselect(g,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g,TYPE_FUSION)>0
end
function c9951158.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9951158.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=3
		and (Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION)>0 or g:IsExists(c9951158.exfilter,1,nil,tp)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	aux.GCheckAdditional=aux.dncheck
	local rg=g:SelectSubGroup(tp,c9951158.gselect,false,3,3,tp)
	aux.GCheckAdditional=nil
	Duel.SendtoGrave(rg,REASON_COST)
end
function c9951158.filter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x3ba5) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial()
end
function c9951158.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(c9951158.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9951158.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION)<=0 or not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9951158.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end