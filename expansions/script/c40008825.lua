--阴阳超合
function c40008825.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40008825+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c40008825.cost)
	e1:SetTarget(c40008825.target)
	e1:SetOperation(c40008825.operation)
	c:RegisterEffect(e1)   
	Duel.AddCustomActivityCounter(40008825,ACTIVITY_SPSUMMON,c40008825.counterfilter) 
end
function c40008825.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA or c:IsType(TYPE_SYNCHRO)
end
function c40008825.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(40008825,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c40008825.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c40008825.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_SYNCHRO)
end
function c40008825.spfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:GetOriginalLevel()>=8 and (c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_LIGHT)) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsCanBeEffectTarget(e) and Duel.IsExistingMatchingCard(c40008825.spfilter2,tp,LOCATION_GRAVE,0,1,c,e,tp,c:GetLevel(),c:GetAttribute())
end
function c40008825.spfilter2(c,e,tp,lv,att)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv) and not c:IsAttribute(att)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and (c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_LIGHT)) and c:GetOriginalLevel()>=8
end
function c40008825.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c40008825.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c40008825.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c40008825.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g1:GetCount()>0 then
		local tc=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c40008825.spfilter2),tp,LOCATION_GRAVE,0,1,1,tc,e,tp,tc:GetLevel(),tc:GetAttribute())
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	local dc=Duel.GetOperatedGroup()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40008825,0))
		local sg=dc:Select(tp,1,1,nil)
		local pc=sg:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetLabelObject(pc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		dc:GetFirst():RegisterEffect(e1)
	Duel.SpecialSummonComplete()
	end
end
