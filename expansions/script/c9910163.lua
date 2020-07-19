--战车道豕突猛进
function c9910163.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910163)
	e1:SetTarget(c9910163.target)
	e1:SetOperation(c9910163.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,9910163)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910163.sptg)
	e2:SetOperation(c9910163.spop)
	c:RegisterEffect(e2)
end
function c9910163.filter(c,e,tp,zone)
	return c:IsFaceup() and c:IsSetCard(0x952) and c:GetSequence()<5
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c9910163.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local zone=0
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and c9910163.filter(chkc,e,tp,zone) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9910163.filter,tp,LOCATION_SZONE,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,c9910163.filter,tp,LOCATION_SZONE,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c9910163.gyfilter(c,g)
	return g:IsContains(c)
end
function c9910163.activate(e,tp,eg,ep,ev,re,r,rp)
	local sc=Duel.GetFirstTarget()
	if not sc:IsRelateToEffect(e) then return end
	local lg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local zone=0
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP,zone)==0 then return end
	local tg=Duel.GetMatchingGroup(c9910163.gyfilter,tp,0,LOCATION_ONFIELD,nil,sc:GetColumnGroup())
	if tg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c9910163.filter1(c,e,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE)
		and Duel.IsExistingMatchingCard(c9910163.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetLevel())
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c9910163.filter2(c,e,tp,mc,lv)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x952) and c:IsRank(lv) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9910163.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9910163.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9910163.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9910163.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9910163.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910163.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetLevel())
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
