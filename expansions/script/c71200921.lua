--绝音魔兽·守墓之狼
function c71200921.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,71200921)
	e1:SetTarget(c71200921.sptg)
	e1:SetOperation(c71200921.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)	
	--des
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,71200877)
	e2:SetTarget(c71200921.destg)
	e2:SetOperation(c71200921.desop)
	c:RegisterEffect(e2) 
	local e3=e2:Clone() 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e3:SetCondition(c71200921.xdescon) 
	e3:SetCost(c71200921.xdescost) 
	c:RegisterEffect(e3) 
end
function c71200921.spfilter(c,e,tp)
	return c:IsSetCard(0x895) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c71200921.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c71200921.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c71200921.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c71200921.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if tc then
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetTargetRange(1,0)
			e1:SetTarget(function(e,c)
			return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA) end)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true) 
			Duel.SpecialSummonComplete()
		end
	end 
end 
function c71200921.xdckfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x895) 
end 
function c71200921.xdescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and Duel.IsExistingMatchingCard(c71200921.xdckfil,tp,LOCATION_MZONE,0,1,nil) 
end 
function c71200921.xdescost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.CheckLPCost(tp,700) end
	Duel.PayLPCost(tp,700) 
end 
function c71200921.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end 
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end 
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c71200921.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then  
		Duel.Destroy(tc,REASON_EFFECT) 
	end 
end 



