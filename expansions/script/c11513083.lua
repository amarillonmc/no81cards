--征服斗魂 白金
function c11513083.initial_effect(c)
	--spsummon 
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(11513083,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,11513083)
	e1:SetCondition(c11513083.spcon)
	e1:SetTarget(c11513083.sptg)
	e1:SetOperation(c11513083.spop)
	c:RegisterEffect(e1)
	--show  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11513083,2)) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,29280201) 
	e2:SetCondition(aux.dscon)
	e2:SetCost(c11513083.swcost1)
	e2:SetTarget(c11513083.swtg1)
	e2:SetOperation(c11513083.swop1)
	c:RegisterEffect(e2)
end
function c11513083.xckfil(c) 
	return c:IsType(TYPE_MONSTER) and not c:IsPreviousLocation(LOCATION_DECK)
end 
function c11513083.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11513083.xckfil,1,nil) 
end
function c11513083.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFlagEffect(tp,11513083)==0  end
	Duel.RegisterFlagEffect(tp,11513083,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11513083.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11513083.swcfilter1(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and not c:IsPublic()
end
function c11513083.swcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11513083.swcfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c11513083.swcfilter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.RaiseEvent(g,EVENT_CUSTOM+9091064,e,REASON_COST,tp,tp,0)
	Duel.ShuffleHand(tp)
end
function c11513083.swtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,OCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(tp,11513083)==0 end
	Duel.RegisterFlagEffect(tp,11513083,RESET_CHAIN,0,1)
end
function c11513083.swop1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,nil,tp,OCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
	if tc then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1) 
	end 
end
function c11513083.swcfilter2(c)
	return c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_FIRE) and not c:IsPublic()
end
function c11513083.swcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c11513083.swcfilter2,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.gfcheck,2,2,Card.IsAttribute,ATTRIBUTE_DARK,ATTRIBUTE_FIRE) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsAttribute,ATTRIBUTE_DARK,ATTRIBUTE_FIRE)
	Duel.ConfirmCards(1-tp,sg)
	Duel.RaiseEvent(sg,EVENT_CUSTOM+9091064,e,REASON_COST,tp,tp,0)
	Duel.ShuffleHand(tp)
end
function c11513083.setfil(c,e,tp) 
	if not (c:IsSetCard(0x195) or c:IsCode(54562327)) then return false end 
	if c:IsType(TYPE_MONSTER) then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	else 
		return (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSSetable(true)
	end 
end 
function c11513083.swtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11513083.setfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,11513083)==0 end
	Duel.RegisterFlagEffect(tp,11513083,RESET_CHAIN,0,1)
end
function c11513083.swop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.SelectMatchingCard(tp,c11513083.setfil,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst() 
	if tc then 
		if tc:IsType(TYPE_MONSTER) then 
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,tc)
		else 
			Duel.SSet(tp,tc)
		end  
	end 
end 






