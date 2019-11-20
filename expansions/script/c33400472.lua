--希望的开端
function c33400472.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,33400472+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c33400472.spcon)
	e1:SetTarget(c33400472.sptg)
	e1:SetOperation(c33400472.spop)
	c:RegisterEffect(e1)
end
function c33400472.cfilter2(c,tp,re)
	return c:IsType(TYPE_MONSTER) and  c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) 
		and re:GetOwner():IsSetCard(0x341)
end
function c33400472.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33400472.cfilter2,1,nil,tp,re)
end
function c33400472.spfilter(c,e,tp)
	return c:IsSetCard(0xc342) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400472.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400472.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c33400472.spop(e,tp,eg,ep,ev,re,r,rp)
if not Duel.IsExistingMatchingCard(c33400472.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) or 
Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c33400472.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	local n1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g2=Duel.GetMatchingGroup(c33400472.cnfilter1,tp,LOCATION_GRAVE,0,nil)
	local pg2=Duel.GetMatchingGroupCount(c33400472.cnfilter1,tp,LOCATION_GRAVE,0,nil)
	local g3=Duel.GetMatchingGroup(c33400472.cnfilter2,tp,LOCATION_GRAVE,0,nil,e,tp)
	local pg3=Duel.GetMatchingGroupCount(c33400472.cnfilter2,tp,LOCATION_GRAVE,0,nil,e,tp)
	local op
	if pg2>0 or pg3>0 then 
		if Duel.SelectYesNo(tp,aux.Stringid(33400472,0))then 
			if n1>0 and pg2>0 and pg3>0 then 
				op=Duel.SelectOption(tp,aux.Stringid(33400472,1),aux.Stringid(33400472,2))
			end
			if n1==0 or  g3==0 then op=0 end 
			if n1>0 and  g2==0 and g3>0 then op=1 end
				if op==0 then 
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
						local g6=g2:Select(tp,1,1,nil)
						Duel.SendtoHand(g6,tp,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,g6)
				else	
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						local g7=g3:Select(tp,1,1,nil)
						Duel.SpecialSummon(g7,0,tp,tp,false,false,POS_FACEUP)
				end
		end
	end 
   local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,0)
		e3:SetTarget(c33400472.splimit)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
end
function c33400472.cnfilter1(c)
	return c:IsSetCard(0x5342)  and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33400472.cnfilter2(c,e,tp)
	return c:IsSetCard(0x5342)  and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400472.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x341)
end