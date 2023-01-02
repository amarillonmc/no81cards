--术结天缘 残影之鲁歇奴
function c67200437.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200437,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCountLimit(2,67200437)
	e3:SetCondition(c67200437.spcon)
	e3:SetTarget(c67200437.sptg)
	e3:SetOperation(c67200437.spop)
	c:RegisterEffect(e3)	
end
--
function c67200437.spfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsType(TYPE_PENDULUM) and c:IsPreviousSetCard(0x5671)
end
function c67200437.pfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x5671) and not c:IsForbidden() and c:IsCanHaveCounter(0x671) and Duel.IsCanAddCounter(tp,0x671,1,c) 
end
function c67200437.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200437.spfilter,1,nil,tp)
end
function c67200437.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(c67200437.pfilter,tp,LOCATION_HAND,0,1,nil,tp) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200437.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then	
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c67200437.pfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
		if g:GetCount()>0 then
			if Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)~=0 then
				if g:GetFirst():AddCounter(0x671,2)~=0 then
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
					e2:SetValue(LOCATION_HAND)
					c:RegisterEffect(e2,true)
				end
			end
		end
	end
end

