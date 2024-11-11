--融合之龙
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),s.fmfilter,false)
	--spsum condition
	aux.AddContactFusionProcedure(c,aux.FilterBoolFunction(Card.IsReleasable,REASON_SPSUMMON),LOCATION_MZONE,0,Duel.Release,REASON_SPSUMMON+REASON_MATERIAL)
	--splimit
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e00:SetCode(EFFECT_SPSUMMON_CONDITION)
	e00:SetValue(s.splimit)
	c:RegisterEffect(e00)
	--add attribute
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetCode(EFFECT_ADD_ATTRIBUTE)
	e01:SetRange(LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_MZONE+LOCATION_DECK+LOCATION_HAND)
	e01:SetValue(ATTRIBUTE_ALL)
	c:RegisterEffect(e01)
	--add race
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_SINGLE)
	e02:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e02:SetCode(EFFECT_ADD_RACE)
	e02:SetRange(LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_MZONE+LOCATION_DECK+LOCATION_HAND)
	e02:SetValue(RACE_ALL)
	c:RegisterEffect(e02)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--fusion spsummon ： attribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+10000)
	e2:SetTarget(s.sptg1)
	e2:SetOperation(s.spop1)
	c:RegisterEffect(e2)
	--fusion spsummon ： race
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+10000)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)

end
--fusion material
function s.fmfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsLocation(LOCATION_MZONE)
end
--splimit
function s.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
--to hand
function s.thfilter(c)
	return c:IsSetCard(0x46) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--fusion spsummon ： attribute
function s.cfilter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and not c:IsCode(id)
		and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetAttribute(),e:GetHandler())
end
function s.spfilter1(c,e,tp,att,ec)
	return c:IsAttribute(att) and c:IsType(TYPE_FUSION)
		and Duel.GetLocationCountFromEx(tp,tp,ec,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.cfilter1(chkc,e,tp) end
	if chk==0 then return e:GetHandler():IsAbleToExtra()
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingTarget(s.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and c:IsLocation(LOCATION_EXTRA)
		and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetAttribute(),nil):GetFirst()
		if sc then
			sc:SetMaterial(nil)
			if Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)>0 then
				sc:CompleteProcedure()
			end
		end
	end
end
--fusion spsummon ： race
function s.cfilter2(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and not c:IsCode(id)
		and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetRace(),e:GetHandler())
end
function s.spfilter2(c,e,tp,ra,ec)
	return c:IsRace(ra) and c:IsType(TYPE_FUSION)
		and Duel.GetLocationCountFromEx(tp,tp,ec,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.cfilter2(chkc,e,tp) end
	if chk==0 then return e:GetHandler():IsAbleToExtra()
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingTarget(s.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and c:IsLocation(LOCATION_EXTRA)
		and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetRace(),nil):GetFirst()
		if sc then
			sc:SetMaterial(nil)
			if Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)>0 then
				sc:CompleteProcedure()
			end
		end
	end
end


