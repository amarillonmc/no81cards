--破碎世界 不祥的开端
function c6160601.initial_effect(c)
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(6160601,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)  
	e1:SetCountLimit(1,6160601)  
	e1:SetTarget(c6160601.sptg)  
	e1:SetOperation(c6160601.spop)  
	c:RegisterEffect(e1)  
	--no damage  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCode(EVENT_FREE_CHAIN)	
	e2:SetCost(aux.bfgcost)  
	e2:SetOperation(c6160601.activate)  
	c:RegisterEffect(e2)  
end
function c6160601.desfilter(c,e,tp)  
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)  
		and Duel.IsExistingMatchingCard(c6160601.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c:GetCode())  
end  
function c6160601.spfilter(c,e,tp,code)  
	return c:IsSetCard(0x616) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function c6160601.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c6160601.desfilter(chkc,e,tp) end  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingTarget(c6160601.desfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,c6160601.desfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end  
function c6160601.spop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then  
		local code=tc:GetCode()  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local g=Duel.SelectMatchingCard(tp,c6160601.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,code)  
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then  
			Duel.Destroy(tc,REASON_EFFECT)  
		end 
	end
end  
function c6160601.activate(e,tp,eg,ep,ev,re,r,rp)  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e1:SetTargetRange(LOCATION_MZONE,0)  
	e1:SetTarget(c6160601.indtg)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	e1:SetValue(1)  
	Duel.RegisterEffect(e1,tp)  
end  
function c6160601.indtg(e,c)  
	return c:IsSetCard(0x616)  
end