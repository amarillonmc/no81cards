--神代丰
function c64800097.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64800097,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,64800097)
	e1:SetCost(c64800097.spcost1)
	e1:SetTarget(c64800097.sptg1)
	e1:SetOperation(c64800097.spop1)
	c:RegisterEffect(e1)
	--spsm from grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64800097,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c64800097.spcon)
	e2:SetTarget(c64800097.sptg2)
	e2:SetOperation(c64800097.spop2)
	c:RegisterEffect(e2)
end

--e1
function c64800097.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0 end
	Duel.Release(c,REASON_COST)
end
function c64800097.spfilter1(c,e,tp,ec)
	return c:IsSetCard(0x641a) and c:IsType(TYPE_LINK) and c:IsLinkBelow(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c64800097.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64800097.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c64800097.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c64800097.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--e2
function c64800097.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_SZONE)~=0
end
function c64800097.cfilter(c,tp)
	return c:IsSetCard(0x641a) and c:IsFaceup()
	  and ( 
			(c:IsType(TYPE_LINK) and Duel.GetFlagEffect(tp,64800097)==0) or
			(c:IsType(TYPE_FUSION) and Duel.GetFlagEffect(tp,64800098)==0) or
			(c:IsType(TYPE_XYZ) and Duel.GetFlagEffect(tp,64800099)==0) or
			(c:IsType(TYPE_SYNCHRO) and Duel.GetFlagEffect(tp,64800100)==0) or 
			(c:IsType(TYPE_TOKEN) and Duel.GetFlagEffect(tp,64800101)==0) or 
			(not c:IsType(TYPE_LINK) and not c:IsType(TYPE_FUSION) and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_SYNCHRO))
		  )
		and not c:IsCode(64800097)
end
function c64800097.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c64800097.cfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)   and Duel.IsExistingMatchingCard(c64800097.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c64800097.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_LINK) then e:SetValue(1) end
	if tc:IsType(TYPE_FUSION) then e:SetValue(2) end
	if tc:IsType(TYPE_XYZ) then e:SetValue(3) end
	if tc:IsType(TYPE_SYNCHRO) then e:SetValue(4) end
	if tc:IsType(TYPE_TOKEN) then e:SetValue(5) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c64800097.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	if e:GetValue()==1 then
	Duel.RegisterFlagEffect(tp,64800097,RESET_PHASE+PHASE_END,0,1)
	end 
	if e:GetValue()==2 then
	Duel.RegisterFlagEffect(tp,64800098,RESET_PHASE+PHASE_END,0,1)
	end 
	if e:GetValue()==3 then
	Duel.RegisterFlagEffect(tp,64800099,RESET_PHASE+PHASE_END,0,1)
	end 
	if e:GetValue()==4 then
	Duel.RegisterFlagEffect(tp,64800100,RESET_PHASE+PHASE_END,0,1)
	end 
	if e:GetValue()==5 then
	Duel.RegisterFlagEffect(tp,64800101,RESET_PHASE+PHASE_END,0,1)
	end 
end