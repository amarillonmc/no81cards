--钢战-永远的孤独
function c82557938.initial_effect(c)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCountLimit(1,82558038)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c82557938.condition2)
	e4:SetTarget(c82557938.target2)
	e4:SetOperation(c82557938.activate2)
	c:RegisterEffect(e4)
	--rank up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,82557938+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c82557938.rktg)
	e2:SetOperation(c82557938.rkop)
	c:RegisterEffect(e2)
end
function c82557938.confilter(c)
	return c:IsSetCard(0x829) and c:IsType(TYPE_XYZ)
end
function c82557938.condition2(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c82557938.confilter,tp,LOCATION_MZONE,0,1,nil) and ep~=tp 
end
function c82557938.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c82557938.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c82557938.rkfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x829) and c:IsType(TYPE_XYZ)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c82557938.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank())
end
function c82557938.spfilter(c,e,tp,mc,rank)
	return c:IsRank(rank+1) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c82557938.rktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c82557938.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c82557938.rkfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c82557938.rkfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82557938.rkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL)
		or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82557938.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
