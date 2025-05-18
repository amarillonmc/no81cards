--我不会……再依靠任何人
function c60151031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60151031+EFFECT_COUNT_CODE_OATH)
	--e1:SetCondition(c60151031.condition)
	e1:SetTarget(c60151031.target)
	e1:SetOperation(c60151031.activate)
	c:RegisterEffect(e1)
end
function c60151031.confilter(c)
	return c:IsSetCard(0x5b23) and c:IsRace(RACE_SPELLCASTER) and c:IsFaceup()
end
function c60151031.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c60151031.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60151031.filter(c,e,tp)
	return c:IsSetCard(0x5b23) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151031.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c60151031.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c60151031.dfilter(c)
	return not (c:IsSetCard(0x5b23) and c:IsRace(RACE_SPELLCASTER) and c:IsFaceup())
end
function c60151031.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60151031.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(60151031,1))
			e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			e3:SetValue(c60151031.efilter)
			tc:RegisterEffect(e3,true)
			Duel.SpecialSummonComplete()
			local dg=Duel.GetMatchingGroup(c60151031.dfilter,tp,LOCATION_MZONE,0,nil)
			if dg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoHand(dg,nil,REASON_EFFECT)
			end
		end
	end
end
function c60151031.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end