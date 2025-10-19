--化龙真言
function c95101218.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,95101218+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c95101218.target)
	e1:SetOperation(c95101218.activate)
	c:RegisterEffect(e1)
end
function c95101218.tfilter(c,e,tp)
	return c:IsSetCard(0x5bb0) and c:IsFaceup() and c:IsAbleToGrave() and c:GetEquipCount()~=0
		and Duel.IsExistingMatchingCard(c95101218.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c95101218.spfilter(c,e,tp,tc)
	return c:IsSetCard(0x5bb0) and c:IsType(TYPE_SYNCHRO) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c:IsAttribute(tc:GetAttribute())
end
function c95101218.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c95101218.tfilter(chkc,e,tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	--if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=ft-1 end
	if chk==0 then return Duel.IsExistingTarget(c95101218.tfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c95101218.tfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c95101218.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c95101218.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst()
	if not sc or Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)==0 then return end
	sc:CompleteProcedure()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_GRAVE) then return end
	if sc:IsAttribute(ATTRIBUTE_WIND) and Duel.SelectYesNo(tp,aux.Stringid(95101218,2)) then
		Duel.BreakEffect()
		Duel.Damage(1-tp,1200,REASON_EFFECT)
	end
end
