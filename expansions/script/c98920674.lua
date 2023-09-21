--念动力呼唤者
function c98920674.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920674,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98920674)
	e3:SetCondition(c98920674.spcon)
	e3:SetCost(c98920674.spcost)
	e3:SetTarget(c98920674.sptg)
	e3:SetOperation(c98920674.spop)
	c:RegisterEffect(e3)
	 --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920674,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCountLimit(1,98930674)
	e2:SetCondition(c98920674.rmcon)
	e2:SetTarget(c98920674.rmtg)
	e2:SetOperation(c98920674.rmop)
	c:RegisterEffect(e2)
end
function c98920674.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98920674.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98920674.ffilter(c,e,tp)
	return c:IsSetCard(0x104f) and Duel.IsExistingMatchingCard(c98920674.spfilter,tp,LOCATION_EXTRA,0,1,nil,c.assault_name,e,tp)
end
function c98920674.spfilter(c,tcode,e,tp)
	return c:IsCode(tcode) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c98920674.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920674.ffilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920674.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c98920674.ffilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c98920674.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc.assault_name,e,tp)
		if g:GetCount()>0 then
			local tc1=g:GetFirst()
			tc1:SetMaterial(nil)
			Duel.SpecialSummonStep(tc1,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(98920674,1))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc1:RegisterEffect(e1)
			tc1:CompleteProcedure()
			Duel.SpecialSummonComplete()
			Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
		end
	end
end
function c98920674.ccfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and (c:IsType(TYPE_SYNCHRO) or c:IsSetCard(0x104f))
end
function c98920674.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActivated() and not re:IsActiveType(TYPE_MONSTER) and r&REASON_COST~=0 and eg:IsExists(c98920674.ccfilter,1,nil,tp) and not eg:IsContains(e:GetHandler()) 
end
function c98920674.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920674.rmop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end