--狂暴化
function c9951618.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c9951618.target)
	e1:SetOperation(c9951618.activate)
	c:RegisterEffect(e1)
end
function c9951618.tfilter(c,lv,e,tp,tc)
	return c:IsSetCard(0xba5) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelBelow(lv)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c9951618.filter(c,lv,e,tp)
	 local lv=c:GetLevel()
	return c:IsFaceup() and c:IsSetCard(0xba5) and c:IsLevelBelow(lv) and c:IsAttribute(ATTRIBUTE_DARK) and lv>0
		and Duel.IsExistingMatchingCard(c9951618.tfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetLevel(),e,tp,c)
end
function c9951618.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9951618.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9951618.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c9951618.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9951618.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local lv=tc:GetLevel()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c9951618.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,lv,e,tp,nil)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		local atk=sg:GetAttack()
		if Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(math.ceil(atk*2))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sg:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetOperation(c9951618.desop)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetCountLimit(1)
			sg:RegisterEffect(e2,true)
		end
		sg:GetFirst():CompleteProcedure()
	end
end
function c9951618.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
