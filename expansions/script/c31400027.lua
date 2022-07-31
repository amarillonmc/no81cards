local m=31400027
local cm=_G["c"..m]
cm.name="薰风的离人 薇茵"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,31400027)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x10) and not c:IsCode(31400027) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ft>=1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)		 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>=2 then
		local c=e:GetHandler()
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		local tc=sg:GetFirst()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TUNER) then
			local ec=Effect.CreateEffect(c)
			ec:SetType(EFFECT_TYPE_SINGLE)
			ec:SetCode(EFFECT_REMOVE_TYPE)
			ec:SetValue(TYPE_TUNER)
			ec:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(ec)
		end
		tc=sg:GetNext()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e3=Effect.Clone(e1)
		tc:RegisterEffect(e3)
		local e4=Effect.Clone(e2)
		tc:RegisterEffect(e4)
		if tc:IsType(TYPE_TUNER) then
			local ec=Effect.CreateEffect(c)
			ec:SetType(EFFECT_TYPE_SINGLE)
			ec:SetCode(EFFECT_REMOVE_TYPE)
			ec:SetValue(TYPE_TUNER)
			ec:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(ec)
		end
		Duel.SpecialSummonComplete()
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e5:SetTargetRange(1,0)
		e5:SetTarget(cm.splimit)
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
	end
end
function cm.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WIND)
end