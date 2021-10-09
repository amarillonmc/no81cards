--风神录-乌鸦天狗
function c9980094.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980094,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9980094)
	e1:SetCondition(c9980094.spcon)
	e1:SetTarget(c9980094.sptg)
	e1:SetOperation(c9980094.spop)
	c:RegisterEffect(e1)
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980094,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,99800940)
	e1:SetTarget(c9980094.sptg2)
	e1:SetOperation(c9980094.spop2)
	c:RegisterEffect(e1)
end
function c9980094.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3bc6)
end
function c9980094.spcon(e)
	return  Duel.IsExistingMatchingCard(c9980094.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c9980094.desfilter(c)
	return c:IsFaceup()
end
function c9980094.spfilter(c,e,tp)
	return (c:IsRace(RACE_WINDBEAST) or c:IsSetCard(0x3bc6)) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980094.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(e:GetLabel()) and chkc:IsControler(tp) and c9980094.desfilter(chkc) end
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<-1 then return false end
		local loc=LOCATION_ONFIELD
		if ft==0 then loc=LOCATION_MZONE end
		e:SetLabel(loc)
		return Duel.IsExistingTarget(c9980094.desfilter,tp,loc,loc,1,nil)
			and Duel.IsExistingMatchingCard(c9980094.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c9980094.desfilter,tp,e:GetLabel(),e:GetLabel(),1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9980094.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9980094.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9980094.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9980094.splimit(e,c)
	return not (c:IsRace(RACE_WINDBEAST) or c:IsSetCard(0xbc6)) and c:IsLocation(LOCATION_EXTRA)
end
function c9980094.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9980094.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end