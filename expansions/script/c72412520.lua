--混沌的觉醒
function c72412520.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c72412520.target)
	e1:SetOperation(c72412520.activate)
	c:RegisterEffect(e1)
end
function c72412520.cfilter(c)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_DARK)
end
function c72412520.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c72412520.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c72412520.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c72412520.cfilter(c)
	return c:IsSetCard(0x6727) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c72412520.filter2(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c72412520.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(ATTRIBUTE_DARK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
			if tc:IsSetCard(0x6727) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetValue(c72412520.efilter)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e3:SetOwnerPlayer(tp)
			tc:RegisterEffect(e3)
			end
			Duel.BreakEffect()
			local n=Duel.GetMatchingGroupCount(c72412520.cfilter,tp,LOCATION_MZONE,0,nil)
			if n>=2  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c72412520.cfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g2=Duel.SelectMatchingCard(tp,c72412520.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
				if g2:GetCount()>0 then
				Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
				end
			end
			if n>=4 then
			--disable
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_FIELD)
				e4:SetCode(EFFECT_DISABLE)
				e4:SetTargetRange(0,LOCATION_MZONE)
				e4:SetTarget(c72412520.distg)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e4,tp)
			end
	end
end
function c72412520.distg(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c72412520.efilter(e,re)
	return not (re:GetHandler():IsType(TYPE_MONSTER) and not re:GetHandler():IsAttribute(ATTRIBUTE_DARK)) and  e:GetOwnerPlayer()~=re:GetOwnerPlayer()  
end