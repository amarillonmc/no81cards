--镜碎扩张
function c189003.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcEqual2(c,c189003.rifilter,nil,c189003.rifilter2,c189003.rifilter3)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,189003)
	e1:SetTarget(c189003.target)
	e1:SetOperation(c189003.operation)
	c:RegisterEffect(e1)
end
c189003.Dakexiaer=true
function c189003.rifilter(c)
	return c.Dakexiaer
end
function c189003.rifilter2(c)
	return c:IsLevel(10) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c189003.rifilter3(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c189003.filter(c,e,tp)
	return c:IsFaceup() and c.Dakexiaer and c:IsType(TYPE_RITUAL)
		and Duel.IsExistingMatchingCard(c189003.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode())
end
function c189003.spfilter(c,e,tp,code)
	return c.Dakexiaer and c:IsLevel(10) and c:IsType(TYPE_RITUAL) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false)
end
function c189003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c189003.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c189003.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c189003.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c189003.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c189003.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetCode())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
	end
end
